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

## Scope (refined): PDF-first, lean on docs

The **PDF cheatsheet is the product.** Everything else is thin:

```
   PDF cheatsheet ──▶ docs.ethswarm.org   (the depth — already written, maintained by others)
        │
        ├──▶ /swarm-* skills              (interactive path)
        └──▶ justdeploy-style guide       (ONLY where docs have a real gap)
```

- The card's job is to **orient and route**, not to re-explain what docs already cover.
- The **web page stays thin**: it displays the cards and always offers the printable PDF.
  It is not a guide CMS.
- **Send people to `docs.ethswarm.org`** for detail (v1's back page already does this with
  QR'd doc deep-links — keep that instinct).
- **Bespoke guides only where docs genuinely fall short** and traffic is high. justdeploy
  ("publish a website") is the one proven exception — used sparingly, not the template for
  every topic. This removes most of the per-topic "web guide" work.

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

→ **DECIDED: Option A** (HTML → print-to-PDF). PDF is the primary product and must stay
version-accurate across toolchain bumps; one HTML source keeps the PDF correct and gives the
thin web/download page for free. Print CSS is tuned toward v1's density; a single "hero" card
can still be polished in a design tool later without changing the system.

## Content roadmap — one card per core task

Each cheatsheet maps to a skill and routes to docs. A bespoke guide is the exception, not the rule:

| Cheatsheet | Skill | Routes to (depth) | Bespoke guide? | Status |
|---|---|---|---|---|
| **Swarm Overview** (general) | `/swarm` | docs `/develop/resources` | — | v1 done |
| **Publish a website** | `/swarm-host-website` | docs `/develop/host-your-website` | **justdeploy (exists)** | next |
| **Postage stamps** | `/swarm-stamps` | docs `/develop/.../buy-a-stamp-batch` | no | next |
| **Run a Bee node** | `/swarm-setup-bee` | docs `/bee/installation` | no | later |
| **Build with bee-js** | `/swarm-build-app` | bee-js.ethswarm.org | no | later |
| **Feeds & dynamic content** | `/swarm-feed` | docs `/develop/.../feeds` | no | later |
| **Access control (ACT)** | `/swarm-act` | docs `/develop/act` | no | later |
| **Messaging (PSS/GSOC)** | `/swarm-messaging` | docs `/develop/.../pss` + `/gsoc` | no | later |

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
- **Phase 1 — Pipeline:** ✅ DONE. v1 Overview card rebuilt as a self-contained HTML card
  (`src/cheatsheets/overview/cheatsheet.html`) with print CSS + live QR codes; generates a 2-page
  A4 PDF via `./scripts/pdf.sh` (headless Chrome). Version-corrected (swarm-prefixed skill
  commands, "Verified: Bee 2.8.1 · bee-js 12.x · swarm-cli 3.x"). Output:
  `dist/swarm-overview-cheatsheet.pdf`. The card is the single source: an external app extracts
  `cheatsheet.html` verbatim, and the hosted `index.html` is generated from it via
  `./scripts/build-web.sh` (splices in the page chrome), so web and print never drift.
  **Remaining tuning:** increase density to fill more of the page (currently ~60% height) to
  match v1; minor QR/typography polish.
- **Phase 2 — Web hub:** cheatsheets index page (Swarm-hosted, justdeploy design tokens) with
  per-card PDF download. Pick an ENS/bzz.link name.
- **Phase 3 — First topical card:** "Publish a website," reusing justdeploy content as the
  deep guide it links to.
- **Phase 4 — Fill the set:** stamps, bee node, bee-js, feeds, ACT, messaging — each card
  routes to its docs page + skill (no new guides).
- **Phase 5 — Maintenance:** tie version accuracy to the skills' `verify-beejs.mjs` so a
  toolchain bump flags which cards need a refresh.

## Open questions

- Architecture Option A vs B vs C (recommend A).
- Hosting name (e.g. `cheatsheets.swarm…` / a bzz.link) — or fold into justdeploy?
- Does the cheatsheet repo live under `ethersphere` (like the skills) from the start?
- Keep design-tool source for the *general* card's polish while topical cards go HTML-first?
