# Brain Privacy

Before adding anything to the public McStacks brain, classify it.

## Safe To Publish

- General workflow patterns.
- Small synthetic examples.
- Public repo-relative paths.
- Public docs links.
- Generic failure modes and remediation steps.
- Templates that users fill in themselves.

## Needs Scrubbing

- Private project names.
- Customer, employer, or client details.
- Local absolute paths.
- Stack traces containing usernames, hosts, URLs, or IDs.
- Transcripts or logs.
- Screenshots.
- Review packets and model responses.

## Do Not Publish

- `.env*` contents.
- API keys, OAuth tokens, session cookies, or CLI auth files.
- Production credentials or account IDs.
- Private notes copied verbatim.
- Live incident details that identify a private system.
- Anything the user has not authorized for public release.

## Scrubbing Checklist

1. Replace private identifiers with generic names.
2. Convert exact logs into short summaries.
3. Remove local absolute paths.
4. Remove private URLs, hostnames, and account IDs.
5. Run a secret and private-path scan.
6. Read the final text as if it were public on GitHub.
