# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**swarm-cheatsheets** produces printable, single-source reference cards for building on
[Ethereum Swarm](https://ethswarm.org). A cheatsheet is a dense A4 quick-reference (the
format that worked well at hackathons) that lives in two forms from **one source**:

1. A **printable PDF** (A4, double-sided where needed) handed out at events. **This is the
   primary product.**
2. A **thin web page**, hosted on Swarm, that displays the card and always offers the PDF
   download — not a guide engine.

**The cheatsheet's job is to orient and route, not to re-explain.** Depth lives in the
official docs; cards send people to `docs.ethswarm.org` (deep-linked, QR-coded) rather than
duplicating content. Build a bespoke guide **only** where the docs have a real gap and the
topic is high-traffic — `justdeploy` ("publish a website") is the one proven exception, used
sparingly, not the template for every topic.

It is one of three complementary DevRel surfaces that cross-reference each other:

| Surface | Repo | Role |
|---|---|---|
| **Cheatsheets** (this repo) | `swarm-cheatsheets` | Print-first quick reference. The "what/why + map." **Hero.** |
| **Official docs** | [`docs.ethswarm.org`](https://docs.ethswarm.org) | The depth. Cards route here instead of re-explaining. |
| **Interactive skills** | [`swarm-quickstart-skills`](https://github.com/ethersphere/swarm-quickstart-skills) | Claude Code skills that *do* the task with you. |
| **Web guide (sparingly)** | [`justdeploy`](https://github.com/GasperX93/justdeploy) | Bespoke walkthrough only where docs fall short. |

The v1 reference artifact is `dist/swarm-overview-cheatsheet-v1.pdf` (the original
hand-designed "Swarm Cheatsheet"). Treat it as the **content + visual benchmark** to match,
not as something to edit directly.

## Architecture (proposed — see docs/PLAN.md)

**Single source → both outputs.** Author each cheatsheet as HTML + a print stylesheet, so
the same file renders on the web and prints to an identical A4 PDF (via headless Chrome /
Paged.js). This is the central decision that keeps web and print from drifting. No framework,
no build runtime — mirror justdeploy's no-build, static, Swarm-hosted approach.

```
swarm-cheatsheets/
├── src/cheatsheets/<topic>/   # one folder per cheatsheet (index.html + content)
├── assets/                    # brand assets, QR codes, fonts
├── dist/                      # generated PDFs (+ the v1 reference)
├── docs/PLAN.md               # the build plan and content roadmap
└── CLAUDE.md
```

## Conventions

- **Brand:** reuse justdeploy's design tokens — accent orange `#f5a623`, Swarm logo, the
  same typographic feel. Print CSS forces a high-contrast, ink-economical light layout.
- **Version accuracy is the whole point.** Cheatsheets must track the current toolchain:
  **Bee 2.8.x · bee-js 12.x · swarm-cli 3.x** (the same correctness wave as
  swarm-quickstart-skills). Put a "verified against" version line on every card.
- **Skill commands use the `swarm-` prefix** (`/swarm-host-website`, `/swarm-stamps`, …)
  to match swarm-quickstart-skills after its namespacing PR. Entry point stays bare `/swarm`.
- **QR codes link to canonical online URLs** (docs deep-links, app pages) so a printed card
  keeps working as the targets update.
- **American English. Short. Every line earns its space** — a cheatsheet is ruthless about density.
- **Don't overpromise.** Future work is "goal/plan," not fact. Keep the "What Swarm is NOT"
  and "Limitations & gotchas" framing — it is the strongest, most-trusted part of v1.

## Running / generating

No build step to view: open `src/cheatsheets/<topic>/index.html` in a browser, or
`python3 -m http.server 8080`.

**Generate the PDFs** (HTML → A4 PDF via headless Chrome): `./scripts-pdf.sh`
regenerates every card into `dist/`. To export one card by hand: open it in Chrome →
`⌘P` → Save as PDF → A4 → margins **None** → Background graphics **ON**.
QR codes render client-side (qrcodejs via CDN); the script waits for them.

## Related

- v1 content benchmark: `dist/swarm-overview-cheatsheet-v1.pdf`
- Web-guide prototype + design tokens: `../justdeploy`
- Skills + the bee-js version-accuracy guard (`scripts/verify-beejs.mjs`): `swarm-quickstart-skills`
