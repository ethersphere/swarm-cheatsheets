# Swarm Cheatsheets

> **Maintained by:** devrel team

Printable, single-source reference cards for building on [Ethereum Swarm](https://ethswarm.org).

Each cheatsheet is a dense A4 quick-reference that exists in two forms from one source:
a **printable PDF** for events, and a **web page** (hosted on Swarm) you can download the PDF from.

Part of the Swarm developer-onboarding stack:

- **[Cheatsheets](https://swarm-devrel.bzz.link/)** (this repo) — print-first quick reference
- **[justdeploy](https://github.com/GasperX93/justdeploy)** — deeper web guides
- **[swarm-quickstart-skills](https://github.com/ethersphere/swarm-quickstart-skills)** — interactive Claude Code skills

## Status

v1 (the original hand-designed "Swarm Overview" card) is in `dist/swarm-overview-cheatsheet-v1.pdf`.
The plan to turn it into a maintainable set is in [`docs/PLAN.md`](docs/PLAN.md).

## Layout

```
src/cheatsheets/<topic>/   one folder per cheatsheet
assets/                    vendored fonts + QR library
dist/                      generated PDFs (+ v1 reference)
scripts/                   pdf.sh, check-links.sh
docs/PLAN.md               build plan & content roadmap
```

No build step to preview: open an `index.html` in a browser, or `python3 -m http.server 8080`.
Regenerate the PDFs with `./scripts/pdf.sh`; verify all card links with `./scripts/check-links.sh`.

**Deploy to Swarm:** `./scripts/site.sh` assembles a self-contained `dist/site/` folder
(page + assets + PDF, nothing else) — upload that folder, e.g.
`swarm-cli upload dist/site --stamp <BATCH_ID>`.

---

Maintained by the Swarm **DevRel** team.
