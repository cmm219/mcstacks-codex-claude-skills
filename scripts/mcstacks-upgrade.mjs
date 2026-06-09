import { createInterface } from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import { execFileSync } from "node:child_process";
import {
  cp,
  mkdir,
  readFile,
  readdir,
  rm,
  stat,
  writeFile,
} from "node:fs/promises";
import { existsSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = dirname(dirname(fileURLToPath(import.meta.url)));
const args = parseArgs(process.argv.slice(2));
const codexHome = args.codexHome || process.env.CODEX_HOME || defaultCodexHome();
const skillsDir = join(codexHome, "skills");
const manifestDir = join(skillsDir, ".mcstacks");
const manifestPath = join(manifestDir, "manifest.json");

async function main() {
  const existingManifestRaw = await readTextIfExists(manifestPath);
  const existingManifest = await readJsonIfExists(manifestPath);
  const source = resolve(args.source || existingManifest?.sourcePath || repoRoot);
  await assertSource(source);

  if (!args.allowDirty) {
    assertCleanGitSource(source);
  }

  const sourceSkills = await listSkillDirs(source);
  if (!sourceSkills.length) {
    throw new Error(`No root-level skill directories found in source: ${source}`);
  }

  const version = await readVersion(source);
  const sourceHead = readGitHead(source);
  const installedNames = new Set((existingManifest?.skills || []).map((skill) => skill.name));
  const sourceNames = new Set(sourceSkills.map((skill) => skill.name));
  const allInstalledPresent = sourceSkills.every((skill) => existsSync(join(skillsDir, skill.name, "SKILL.md")));

  if (
    existingManifest &&
    existingManifest.sourceHead === sourceHead &&
    existingManifest.version === version &&
    allInstalledPresent
  ) {
    console.log(`McStacks is already up to date (${version}, ${sourceHead.slice(0, 12)}).`);
    return;
  }

  console.log(`McStacks upgrade source: ${source}`);
  console.log(`Target skills directory: ${skillsDir}`);
  console.log(`Version: ${existingManifest?.version || "unknown"} -> ${version}`);
  console.log(`Source: ${existingManifest?.sourceHead || "unknown"} -> ${sourceHead}`);

  if (!args.yes) {
    const rl = createInterface({ input, output });
    const answer = await rl.question("Upgrade installed McStacks skills now? [y/N] ");
    rl.close();
    if (!/^y(es)?$/i.test(answer.trim())) {
      console.log("Upgrade cancelled.");
      return;
    }
  }

  await mkdir(manifestDir, { recursive: true });
  const backupDir = join(manifestDir, "backups", timestamp());
  await mkdir(backupDir, { recursive: true });

  const allowlistNames = new Set([...installedNames, ...sourceNames]);
  const newlyCreatedTargets = [];

  try {
    for (const name of allowlistNames) {
      const installedPath = join(skillsDir, name);
      if (existsSync(installedPath)) {
        await cp(installedPath, join(backupDir, name), { recursive: true });
      }
    }

    for (const skill of sourceSkills) {
      const target = join(skillsDir, skill.name);
      if (!existsSync(target)) {
        newlyCreatedTargets.push(target);
      }
      await rm(target, { recursive: true, force: true });
      await cp(skill.path, target, { recursive: true });
      console.log(`Updated ${skill.name}`);
    }

    for (const name of installedNames) {
      if (!sourceNames.has(name)) {
        await rm(join(skillsDir, name), { recursive: true, force: true });
        console.log(`Removed retired McStacks skill ${name}`);
      }
    }

    await writeManifest({
      source,
      sourceHead,
      version,
      sourceSkills,
    });

    runPreflight(source);
    await showChangelog(source, version);
    console.log(`Backup saved at: ${backupDir}`);
  } catch (error) {
    console.error(`Upgrade failed: ${error.message}`);
    console.error(`Restoring backup from: ${backupDir}`);
    for (const target of newlyCreatedTargets) {
      await rm(target, { recursive: true, force: true });
    }
    for (const entry of await readdir(backupDir).catch(() => [])) {
      const target = join(skillsDir, entry);
      await rm(target, { recursive: true, force: true });
      await cp(join(backupDir, entry), target, { recursive: true });
    }
    if (existingManifestRaw) {
      await writeFile(manifestPath, existingManifestRaw, "utf8");
    } else {
      await rm(manifestPath, { force: true });
    }
    throw error;
  }
}

function parseArgs(argv) {
  const parsed = {
    source: null,
    codexHome: null,
    yes: false,
    allowDirty: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg === "--source") {
      parsed.source = argv[++index];
    } else if (arg === "--codex-home") {
      parsed.codexHome = argv[++index];
    } else if (arg === "--yes") {
      parsed.yes = true;
    } else if (arg === "--allow-dirty") {
      parsed.allowDirty = true;
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }

  return parsed;
}

function defaultCodexHome() {
  if (process.platform === "win32") {
    return join(process.env.USERPROFILE || process.env.HOME, ".codex");
  }
  return join(process.env.HOME, ".codex");
}

async function readJsonIfExists(path) {
  try {
    return JSON.parse(await readFile(path, "utf8"));
  } catch (error) {
    if (error.code === "ENOENT") return null;
    throw error;
  }
}

async function readTextIfExists(path) {
  try {
    return await readFile(path, "utf8");
  } catch (error) {
    if (error.code === "ENOENT") return null;
    throw error;
  }
}

async function assertSource(source) {
  if (!existsSync(source)) {
    throw new Error(`Source path does not exist: ${source}`);
  }
  const info = await stat(source);
  if (!info.isDirectory()) {
    throw new Error(`Source path is not a directory: ${source}`);
  }
}

function assertCleanGitSource(source) {
  if (!existsSync(join(source, ".git"))) return;
  const status = execFileSync("git", ["-C", source, "status", "--porcelain"], { encoding: "utf8" }).trim();
  if (status) {
    throw new Error("Source checkout has uncommitted changes. Commit/stash them or rerun with --allow-dirty.");
  }
}

function readGitHead(source) {
  try {
    return execFileSync("git", ["-C", source, "rev-parse", "HEAD"], { encoding: "utf8" }).trim();
  } catch {
    return "unknown";
  }
}

// Claude-driver skills live in this repo for visibility but install into the
// Claude Code skills directory, not the Codex skills directory.
const claudeDriverSkills = new Set(["codex-readonly-review"]);

async function listSkillDirs(source) {
  const entries = await readdir(source);
  const skills = [];
  for (const entry of entries) {
    if (claudeDriverSkills.has(entry)) continue;
    const path = join(source, entry);
    let info;
    try {
      info = await stat(path);
    } catch {
      continue;
    }
    if (!info.isDirectory()) continue;
    if (!existsSync(join(path, "SKILL.md"))) continue;
    skills.push({ name: entry, path });
  }
  return skills.sort((left, right) => left.name.localeCompare(right.name));
}

async function readVersion(source) {
  const changelogPath = join(source, "CHANGELOG.md");
  try {
    const changelog = await readFile(changelogPath, "utf8");
    const match = changelog.match(/^##\s+([0-9]+\.[0-9]+\.[0-9]+)/m);
    return match?.[1] || "unknown";
  } catch {
    return "unknown";
  }
}

async function writeManifest({ source, sourceHead, version, sourceSkills }) {
  const manifest = {
    schemaVersion: 1,
    name: "mcstacks",
    version,
    installedAtUtc: new Date().toISOString(),
    installType: "repo-root",
    sourcePath: source,
    sourceRemote: readGitRemote(source),
    sourceHead,
    destination: skillsDir,
    skills: sourceSkills.map((skill) => ({
      name: skill.name,
      installedPath: join(skillsDir, skill.name),
    })),
  };
  await mkdir(manifestDir, { recursive: true });
  await writeFile(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`, "utf8");
}

function readGitRemote(source) {
  try {
    return execFileSync("git", ["-C", source, "remote", "get-url", "origin"], { encoding: "utf8" }).trim();
  } catch {
    return "https://github.com/cmm219/mcstacks-codex-claude-skills.git";
  }
}

function runPreflight(source) {
  const env = { ...process.env, CODEX_HOME: codexHome };
  if (process.platform === "win32") {
    const shell = findWindowsPowerShell();
    execFileSync(
      shell,
      ["-ExecutionPolicy", "Bypass", "-File", join(source, "scripts", "preflight.ps1")],
      { stdio: "inherit", env },
    );
    return;
  }
  execFileSync("bash", [join(source, "scripts", "preflight.sh")], { stdio: "inherit", env });
}

function findWindowsPowerShell() {
  try {
    execFileSync("where.exe", ["pwsh"], { stdio: "ignore" });
    return "pwsh";
  } catch {
    return "powershell";
  }
}

async function showChangelog(source, version) {
  try {
    const changelog = await readFile(join(source, "CHANGELOG.md"), "utf8");
    const lines = changelog.split(/\r?\n/);
    const start = lines.findIndex((line) => line.startsWith(`## ${version}`));
    if (start === -1) return;
    const end = lines.findIndex((line, index) => index > start && line.startsWith("## "));
    const section = lines.slice(start, end === -1 ? undefined : end).join("\n").trim();
    if (section) {
      console.log("");
      console.log(section);
    }
  } catch {}
}

function timestamp() {
  return new Date().toISOString().replace(/[:.]/g, "-");
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
