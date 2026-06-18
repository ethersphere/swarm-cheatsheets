# Swarm Cheatsheets — Plan

## Goal

Turn the v1 hackathon cheatsheet into a maintainable **set** of Swarm reference cards that
exist as both printable PDFs and Swarm-hosted web pages, wired into the wider DevRel
onboarding stack (web guides + interactive skills).

## Where we are

- **v1 exists:** `dist/swarm-overview-cheatsheet-v1.pdf` — a hand-designed A4 front/back
  ("what Swarm is / isn't," limitations, Claude Code quickstart, curated LEARN/EXAMPLES/TOOLS
  links with QR codes). It tested well at a hackathon.
- **Two siblings already live:** `justdeploy` (web guide prototype) and
  `swarm-quickstart-skills` (interactive skills). The v1 card already links to both.

## The three surfaces (and why this matters)

```
   PRINT                 WEB                    INTERACTIVE
   cheatsheet  ◄────►  justdeploy guide  ◄────►  /swarm-* skill
   (glanceable)        (step-by-step)           (does it with you)
```

A developer should be able to enter from any one and find the other two. The cheatsheet is
the "map"; the guide is the "route"; the skill is the "autopilot."

## Key architectural decision — DECISION NEEDED

**Single source → both outputs (recommended).** Author cheatsheets as HTML + a print
stylesheet; the same file serves the web page and prints to A4 PDF via headless Chrome /
[Paged.js](https://pagedjs.org). One source, web and print never drift, fully diffable in git,
no design-tool round-trips.

| Option | Pros | Cons |
|---|---|---|
| **A. HTML → print-to-PDF** (recommended) | One source; web + PDF in sync; version-controllable; reuses justdeploy stack; Swarm-hostable | Print fidelity needs CSS `@page` tuning to match v1's density |
| **B. Keep design-tool PDF** (Figma/InDesign) | Highest visual polish | Not diffable; web + print drift; manual re-export on every toolchain bump; slow to maintain |
| **C. Hybrid** | v1-quality print, simple web | Two sources to keep in sync — the exact problem we're trying to avoid |

→ Recommend **A**. Confirm before Phase 1.

## Content roadmap — one card per core task

Each cheatsheet maps 1:1 to a skill and (where it exists) a web guide:

| Cheatsheet | Skill | Web guide | Status |
|---|---|---|---|
| **Swarm Overview** (general) | `/swarm` | justdeploy hub | v1 done |
| **Publish a website** | `/swarm-host-website` | **justdeploy (exists)** | next |
| **Postage stamps** | `/swarm-stamps` | stamp calculator | next |
| **Run a Bee node** | `/swarm-setup-bee` | guide | later |
| **Build with bee-js** | `/swarm-build-app` | guide | later |
| **Feeds & dynamic content** | `/swarm-feed` | guide | later |
| **Access control (ACT)** | `/swarm-act` | guide | later |
| **Messaging (PSS/GSOC)** | `/swarm-messaging` | guide | later |

## Content optimizations (the "can we improve the content?" answer)

1. **Version-correct everything** to Bee 2.8.x / bee-js 12.x / swarm-cli 3.x — the same
   correctness wave as the skills. Add a "verified against" footer line to each card.
2. **Fix stale skill commands.** v1 shows `/setup-bee-interactive`, `/stamps`, etc. After the
   skills' namespacing PR these become `/swarm-setup-bee-interactive`, `/swarm-stamps`, …
   The cheatsheet's "Developer Journey" must update in lockstep.
3. **Keep the strongest framing.** "What Swarm is NOT" + "Limitations & gotchas" is the most
   valuable, most-trusted block — keep it on the general card and add a focused gotchas box to
   each topical card.
4. **Topical cards = single A4.** The general card earns its dense front/back; topical cards
   should be one page, one task, ruthless density.
5. **Links stay online.** QR/short-links point to canonical URLs so printed cards keep working.

## Phases

- **Phase 0 — Foundation (this issue):** repo init, CLAUDE.md, this plan, GitHub repo under
  `ethersphere`. Confirm the architecture decision above.
- **Phase 1 — Pipeline:** reproduce the v1 Overview card as HTML + print CSS; generate a PDF
  that matches v1 density/quality. Validates Option A.
- **Phase 2 — Web hub:** cheatsheets index page (Swarm-hosted, justdeploy design tokens) with
  per-card PDF download. Pick an ENS/bzz.link name.
- **Phase 3 — First topical card:** "Publish a website," reusing justdeploy content as the
  deep guide it links to.
- **Phase 4 — Fill the set:** stamps, bee node, bee-js, feeds, ACT, messaging — each card +
  guide + skill cross-linked.
- **Phase 5 — Maintenance:** tie version accuracy to the skills' `verify-beejs.mjs` so a
  toolchain bump flags which cards need a refresh.

## Open questions

- Architecture Option A vs B vs C (recommend A).
- Hosting name (e.g. `cheatsheets.swarm…` / a bzz.link) — or fold into justdeploy?
- Does the cheatsheet repo live under `ethersphere` (like the skills) from the start?
- Keep design-tool source for the *general* card's polish while topical cards go HTML-first?
