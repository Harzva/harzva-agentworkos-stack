---
name: readme-design
description: Design and rewrite polished GitHub README homepages for repositories and profile READMEs, especially Chinese/English open-source projects. Use when the user asks to beautify, redesign, improve, package, market, add a README logo or wordmark, or make a README more professional, visual, persuasive, scannable, or GitHub Pages-like. Focus on README aesthetics, layout, badges, screenshots, logo/wordmark identity, project positioning, information architecture, and Markdown/HTML that renders well on GitHub.
---

# README Design

Treat a README as the repository's homepage, not just documentation. Make the first screen explain what the project is, why it matters, where to try it, and what visual proof exists.

## Core Workflow

1. Audit the current README and repository assets.
2. Identify the audience: users, contributors, researchers, employers, investors, or open-source visitors.
3. Define the repository's first-viewport message: name, positioning, proof, primary links, and visual preview.
4. Decide whether the repository needs a top logo or wordmark. Product-like, visual, skill, plugin, app, CLI, and portfolio repositories usually benefit from one when no strong identity exists.
5. Redesign the README structure before rewriting prose.
6. Add useful visual assets: logo/wordmark, screenshots, architecture diagrams, workflow diagrams, badges, previews, or GitHub Pages links.
7. Keep Markdown portable and GitHub-rendered: avoid scripts, fragile CSS, and layout tricks that fail in GitHub README rendering.
8. Verify the README is scannable on mobile and desktop.

## First Screen Pattern

Use a strong opening block:

- Centered project name with a small original logo or wordmark when the repo is product-like.
- One concise positioning sentence in Chinese or bilingual form.
- Badges grouped by meaning: status, docs, license, release, stars, platform, build.
- Primary links: Demo, GitHub Pages, docs, paper, download, examples, changelog.
- A real screenshot or preview image within the first 1-2 scrolls.

Avoid a first screen that is only a title, one subtitle, many tiny links, and a horizontal rule.

## Logo And README Wordmark

When a product-like repository does not have a recognizable first-viewport identity, design a small original logo or wordmark for the README top.

Use this capability when the user asks for a README logo, when a repository feels like a product or public skill, or when the first screen has no memorable visual anchor.

Design rules:

- Keep the project name as the real `<h1>` and place the logo above or beside it with GitHub-safe `<img>` HTML.
- Prefer repo-owned assets such as `docs/readme-assets/logo.svg`, `docs/assets/logo.svg`, or `assets/logo.png`.
- Make the logo original and project-specific; do not copy reference images, third-party mascots, trademarks, or marketplace icons.
- Use SVG for crisp README rendering. Add PNG fallbacks only when thumbnails, social cards, or external platforms need them.
- Keep the first viewport useful: logo, positioning sentence, badges, primary links, and one proof image should fit without burying the project explanation.
- Match the logo to the repository's real domain: CLI tools can use terminal/code symbols, design systems can use layout marks, data repos can use charts, skills can use document/action marks.
- Verify the asset path, alt text, file size, and light/dark GitHub readability.

Logo safety gate:

- Prefer compact icon-only marks or short badges over wide text-heavy banners. Put the full project name in the README `<h1>`, not inside the SVG.
- Do not place long descriptions, long repository names, or full taglines inside the logo. SVG text should be avoided unless it is a tiny 1-3 word label that cannot overflow.
- Use a stable square or compact canvas such as `512x512`, `640x360`, or `760x360`; do not create a long horizontal banner that depends on GitHub scaling to remain readable.
- Keep at least 10% internal padding on every side. No strokes, shadows, text, icons, badges, or decorative shapes may touch or cross the viewBox edge.
- Avoid overlapping foreground elements. Every icon, badge, label, and connector must have a clear hit area and must remain readable at the README display width.
- Prefer abstract objects, abstract animals, devices, documents, route marks, cursors, windows, cameras, packages, or other memorable symbols that can stand alone without title text.
- If a logo references a cute object or animal, make it abstract and domain-specific; do not copy mascots, trademarks, emoji, clip-art, or a supplied reference image.
- Before publishing, inspect the README first viewport and revise if any logo text is clipped, hidden, too small, or visually competes with the `<h1>`.

Output contract:

- Save the primary logo under a stable repo-owned path.
- Add the logo to the README top with a width between `180` and `320` for compact icon marks, or at most `360` for marks with short labels.
- Mention the logo in the README asset table when the README already has one.
- If the repo has thumbnail or social-card assets, regenerate or update them so the new identity appears consistently.

Read `references/logo-wordmark.md` for the full decision tree, sizing guidance, and GitHub-safe snippets.

## README Visual Proof And Diagram Safety

README visuals include logos, screenshots, SVG diagrams, workflow illustrations, architecture maps, thumbnails, and generated preview images. Apply a visual safety gate to all of them, not only to logos.

When creating SVG diagrams or README visual proof:

- Prefer cards, lanes, tables, or Mermaid for text-heavy workflows. Do not force long labels into small circles, badges, bubbles, or narrow nodes.
- Keep connector lines behind cards or between shapes; never run a line through text.
- Give every text label a stable container with enough width and height at the intended README display size.
- Avoid relying on `font-size` alone to make text fit. If a label is long, enlarge the container, wrap the phrase, move detail into a subtitle, or use a table instead.
- Keep at least 10% internal padding inside diagram containers and at least 16 px visual spacing between neighboring text blocks at the SVG's native scale.
- Use short labels inside graphics and move explanations to README prose or tables.
- Do not ship a generated SVG or visual proof image if any text touches a border, overlaps another shape, crosses a connector, or becomes unreadable when displayed at the README width.

Visual proof safety gate:

1. Inspect the asset at the exact README display width, usually `700` to `900` px for wide proof images and `180` to `320` px for logos.
2. Check desktop and narrow mobile rendering when the README depends on a visual in the first two scrolls.
3. Revise any visual with clipped text, overlapping labels, connector-line collisions, edge collisions, or text that is too small to read.
4. If visual inspection is not available, prefer Markdown tables or Mermaid over a custom SVG diagram.
5. For public repositories, mention any important visual asset path in the README and verify the path exists.

## Layout Patterns

Prefer one of these:

- Product README: hero, preview, features, quick start, examples, architecture, roadmap, FAQ.
- Research/roadmap README: hero, scope, interactive index, topic map, comparison table, download center, citation/resources.
- Tool/library README: hero, install, 30-second usage, API examples, integrations, benchmarks, troubleshooting.
- Profile README: identity header, focus areas, featured projects, tech stack, writing links, stats, contact.
- Collection/awesome README: hero, categories, curated table, badges, contribution guide, update policy.

Read `references/patterns.md` when choosing a detailed pattern.

## Template Library

Use `assets/templates/default.md` when the user asks for a complete standard README. It includes the full checklist: hero, badges, primary links, preview flow, highlights, quick start, usage, project structure, roadmap, Star History, Activity Overview, contribution, and license.

Use `assets/templates/partials/logo-hero.md` when a README needs a top logo or wordmark block without replacing the entire document.

Use `assets/templates/styles/` when the user asks for a specific visual direction or when the repo clearly fits one style:

- `01-product-showcase.md`: product/app/browser extension README.
- `02-research-roadmap.md`: research, roadmap, paper, or company-analysis repo.
- `03-library-docs.md`: tool/library/API README.
- `04-profile-portfolio.md`: personal GitHub profile README.
- `05-awesome-curation.md`: curated list or awesome repository.
- `06-profile-activity-overview.md`: profile README with Activity Overview / contribution-type distribution.
- `07-startup-landing.md`: startup-style project homepage.
- `08-course-tutorial.md`: course/tutorial/learning path README.
- `09-bilingual-global.md`: Chinese-English global open-source README.
- `10-minimal-technical.md`: restrained technical README for infra/devtools.

Templates are written as polished sample READMEs, not raw placeholder dumps. Do not paste one blindly. Replace sample names, links, commands, numbers, and claims with repository facts; remove sections that do not match the project.

## Visual Standards

- Use real screenshots or generated preview images when they help visitors understand the project.
- Place screenshots under repo-owned paths such as `assets/`, `docs/assets/`, or `public/`.
- Place README logos under repo-owned paths and keep them independent from private local paths or generated temp folders.
- Keep image widths responsive with GitHub-safe HTML: `<img src="..." width="900" />` or `style="max-width:900px;width:100%;"`.
- Use Mermaid for architecture and workflow diagrams when a generated image is not necessary.
- For SVG workflow diagrams, prefer wide cards or lanes over small circular nodes when text labels are longer than one short word.
- Verify custom SVG diagrams for no overlap, no clipped text, no connector-line collisions, and readable text at README display width.
- Use shields.io badges sparingly and group them under the title.
- Use tables for comparisons, matrices, roadmap status, and project collections.
- Use callouts with blockquotes only for important warnings or positioning.

## Writing Standards

- Start with concrete value, not abstract slogans.
- Prefer short sections and descriptive headings.
- Use bilingual headings only when the repo targets both Chinese and global readers.
- Replace vague phrases like "very powerful" with capabilities, examples, metrics, or screenshots.
- Avoid generic AI phrasing such as "innovative", "seamless", "empowering", "next-generation", and "comprehensive" unless evidence makes the claim specific.
- Make the README persuasive but still truthful: do not invent stars, downloads, papers, benchmarks, or support status.
- For Chinese open-source repos, keep the tone confident, clean, and product-like; avoid dense academic paragraphs at the top.

## README Polish Checklist

- The first screen shows what the project is and why it matters.
- Product-like repos have an original README logo or a conscious decision not to add one.
- README logos pass the logo safety gate: no clipping, no hidden text, no overlapping elements, no long title embedded in the SVG, and no edge collisions.
- README visual proof and SVG diagrams pass the diagram safety gate: no label overlap, no connector-line collisions, no cramped text containers, and no unreadable text at display width.
- There is at least one visual proof element for UI/product/tutorial repos.
- The primary action links are visible near the top.
- Badges are relevant and not noisy.
- The table of contents is useful for long READMEs.
- Installation or usage appears before deep implementation details.
- File paths, URLs, and commands are current.
- Star History is included when growth/social proof matters.
- Activity Overview is included for profile or contributor-focused READMEs when contribution mix is part of the story.
- The license and contribution path are easy to find.
- The README still renders correctly without external CSS or JavaScript.

## Public Repository Quality Gate

For public GitHub repositories, make the README satisfy these three traits:

- **Professional:** accurate positioning, truthful badges and links, clear install/use path, license visibility, and no exaggerated claims.
- **Beautiful:** a strong first viewport, tasteful visual proof, readable spacing, restrained badge groups, and screenshots or diagrams that help people understand the project quickly.
- **Universal:** instructions and examples that work beyond the owner's machine, avoid private paths or account assumptions, and mention platform differences when they matter.

## Safety And Accuracy

- Check existing repository files before referencing screenshots, demos, docs, or badges.
- Do not claim GitHub Pages, CI, releases, license, or package support unless the repo actually has it or the user asks to create it.
- Do not copy a logo from a reference image. Use references only for composition direction and create a different original mark.
- Do not ship a README logo until you have verified that it renders safely at the README display width without cropping, overlap, or unreadable text.
- Preserve user content that represents project truth, but improve hierarchy, wording, and presentation.
- When changing README links, verify local paths exist where practical.
