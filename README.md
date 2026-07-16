# Swarm Cheatsheets

> **Maintained by:** devrel team

Printable, single-source reference cards for building on [Ethereum Swarm](https://ethswarm.org).

Link to Cheatsheets: https://swarm-devrel.bzz.link/

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
src/cheatsheets/<topic>/   one folder per cheatsheet:
                             cheatsheet.html  the self-contained card (SOURCE)
                             chrome.css/toolbar.html/footer.html  hosted-page partials
                             index.html       the web page (GENERATED — do not edit)
assets/                    vendored fonts + QR library
dist/                      generated PDFs (+ v1 reference)
scripts/                   build-web.sh, pdf.sh, check-links.sh
docs/PLAN.md               build plan & content roadmap
```

`cheatsheet.html` is the single source — the self-contained card an external app can extract as-is.
The hosted `index.html` is generated from it by `./scripts/build-web.sh` (which splices in the page chrome); never hand-edit `index.html`.

No build step to preview: open a `cheatsheet.html` (or the generated `index.html`) in a browser, or `python3 -m http.server 8080`.
Regenerate `index.html` with `./scripts/build-web.sh`; regenerate the PDFs with `./scripts/pdf.sh`; verify all card links with `./scripts/check-links.sh`.

**Deploy to Swarm:** `./scripts/site.sh` assembles a self-contained `dist/site/` folder
(page + assets + PDF, nothing else) — upload that folder, e.g.
`swarm-cli upload dist/site --stamp <BATCH_ID>`.

---

Maintained by the Swarm **DevRel** team.
