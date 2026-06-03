# README Design Patterns

Use these patterns to choose the right README shape.

## Standard README Anatomy

A strong README usually needs these ten components:

1. Hero: name, logo/icon, one-sentence positioning.
2. Badges: status, license, docs, build, release, stars, platform.
3. Primary links: demo, GitHub Pages, docs, download, paper, examples, changelog.
4. Visual proof: screenshot, preview image, architecture map, or result sample.
5. Highlights: 3-6 concrete capabilities tied to user value.
6. Quick start: install and run with the shortest honest path.
7. Usage examples: commands, screenshots, inputs/outputs, or recipes.
8. Project structure: only when it helps readers navigate.
9. Roadmap: current status, next work, and planned direction.
10. Trust and community: Star History, contribution guide, license, citation, FAQ, or support.

Optional but useful:

- README logo or wordmark for product-like repositories without a memorable top identity.
- Activity Overview / contribution type distribution for profile or contributor-focused READMEs.
- Back-to-top links for long awesome lists or docs-heavy READMEs.
- Bilingual entry points for Chinese projects that want global reach.

## Visual And Copywriting Rules

- Make the first viewport feel intentional: title, positioning, links, proof.
- Use GitHub-safe emphasis: `<h1>`, `<strong>`, centered HTML blocks, compact tables, Mermaid, and real images.
- Avoid AI-ish phrasing: "powerful", "innovative", "seamless", "empowering", "comprehensive", "next-generation" unless backed by evidence.
- Prefer grounded claims: who it is for, what it does, how to try it, what changed, and where the proof is.
- Use Star History when social proof matters, but do not over-index on it for young repos.
- Treat Activity Overview as manual storytelling unless backed by a data source.

## Logo And Wordmark Pattern

Best for public products, skills, CLIs, plugins, templates, portfolios, and visual projects that need a stronger first impression.

Structure:

1. Original logo or wordmark stored in the repository.
2. Real `<h1>` project name below or beside the logo.
3. One concrete positioning sentence.
4. Primary links and trustworthy badges.
5. A screenshot, proof image, or output sample soon after the hero.

Use the logo as an identity anchor, not as the only explanation. The README should still work if images fail to load.

Good paths:

- `docs/readme-assets/logo.svg`
- `docs/assets/logo.svg`
- `assets/logo.png`

Avoid:

- `file://` URLs or local absolute paths.
- Copied brand marks, marketplace icons, or mascots from a reference image.
- Huge hero images that push the README's actual value proposition too far down.

## Product README

Best for apps, browser extensions, SaaS-like tools, dashboards, and visual projects.

Structure:

1. Hero block: name, short positioning, badges, primary links.
2. Preview image: real UI screenshot or product montage.
3. Why it exists: 3-6 bullets tied to user pain.
4. Core features: grouped by workflow, not implementation.
5. Quick start: minimal commands.
6. Screenshots: toolbar, main view, settings, export, examples.
7. Architecture or workflow diagram.
8. Roadmap and contribution.

## Research Or Roadmap README

Best for technical roadmap analysis, paper collections, company research, and educational repositories.

Structure:

1. Hero: project name, scope, target companies/topics.
2. Status badges and key links: GitHub Pages, PDF downloads, Markdown index, topic archive.
3. "Online Access" section with the primary URL first.
4. Topic map table: company/topic, artifacts, status, links.
5. Methodology: how analysis is produced.
6. Output formats: site, PDF, Markdown, data.
7. Update cadence and roadmap.
8. Citation, license, contribution.

Design notes:

- Use a compact topic table instead of a long list.
- Show a site screenshot or index preview near the top.
- Badges should support trust: Pages online, docs status, PDF count, roadmap count, license.
- Avoid a sterile first screen with only centered text and separators.

## Tool Or Library README

Structure:

1. Hero: what the tool does in one sentence.
2. Install command.
3. 30-second example.
4. Output preview.
5. API/configuration table.
6. Recipes.
7. Troubleshooting.

## Profile README

Structure:

1. Identity line and current focus.
2. Featured projects with screenshots or cards.
3. Tech stack grouped by domain.
4. Writing, talks, or open-source links.
5. GitHub stats only if they support the story.
6. Contact.

## Awesome List README

Inspired by curated GitHub profile README collections.

Structure:

1. Hero and curation promise.
2. Category index.
3. Curated entries in clean tables.
4. Contribution rules.
5. Update policy.
6. Maintainer/contact.

## Badge Guidelines

Good badge groups:

- Project health: build, pages, release, license.
- Distribution: npm, PyPI, Docker, Chrome Web Store, docs.
- Scope: platform, language, topic count, paper count.

Avoid:

- Too many social badges before the project is understood.
- Fake static badges that imply unsupported features.
- Multiple colors with no visual hierarchy.

## GitHub-Safe HTML

Useful snippets:

```html
<div align="center">
  <img src="./docs/readme-assets/logo.svg" alt="Project Name logo" width="320" />
  <h1>Project Name</h1>
  <p><strong>One concise positioning sentence.</strong></p>
  <p>
    <a href="https://example.com">Demo</a>
    ·
    <a href="./docs">Docs</a>
    ·
    <a href="./CHANGELOG.md">Changelog</a>
  </p>
</div>
```

```html
<p align="center">
  <img src="./assets/preview.png" alt="Project preview" style="max-width:900px;width:100%;" />
</p>
```

Use HTML sparingly. Prefer Markdown for maintainability.
