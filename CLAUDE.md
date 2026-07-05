# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A single-page portfolio website — pure HTML/CSS/vanilla JS, no build tools, no package manager, no framework. Open `index.html` directly in a browser; there is nothing to install or compile.

External resources (Google Fonts, Font Awesome, Devicons, EmailJS SDK) load from CDNs, so full styling requires an internet connection — offline, the page renders with fallback fonts and no icons. Project data is fully local (static JS file); **the published site contains zero API keys or credentials.**

## Architecture

**Five files, clear separation of concerns:**

| File                  | Role                                                                                                                                                                                                                             |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `index.html`          | All HTML sections in one page (loader → nav → hero → about → skills → gallery → projects → experience → contact → footer)                                                                                                        |
| `css/main.css`        | Design tokens (`:root`), all component styles, responsive breakpoints, and animation keyframes in one file                                                                                                                       |
| `js/projects-data.js` | **The database.** A static `const PROJECTS_DATA = [...]` array — single source of truth for projects. Edited locally, committed, pushed to publish.                                                                              |
| `js/db.js`            | Data layer over the static file. Exports a single `DB` object: `get()` (reads `PROJECTS_DATA`), `save()` (downloads a regenerated `projects-data.js`), `auth()`, `newId()`, `isLocal()`. **No network calls, no API keys.**      |
| `js/app.js`           | All runtime JS: loader, custom cursor, nav scroll, AOS observer, stat counters, project rendering/filtering, admin panel, gallery lightbox, particle canvas, 3D card tilt, button ripple, typewriter, char reveal, magnetic nav. |

**Script load order matters:** `projects-data.js` → `db.js` → `app.js` (guaranteed by DOM order at bottom of `<body>`). Note `PROJECTS_DATA` is a top-level `const` — it is a global *binding*, not a `window` property, so `db.js` reads it via a `typeof` guard, never `window.PROJECTS_DATA`.

`hero1.txt` is a CSS scratch/draft file — it is not referenced by any HTML or build step and can be ignored.

## Design Token System
    
All visual values live in `css/main.css` `:root`. Key tokens:

```css
--bg / --bg2 / --bg3   /* layered dark backgrounds (#060608 base) */
--a1 / --a2 / --a3     /* lime (#c8f542) / cyan (#60efff) accents */
--grad                 /* primary gradient: lime → cyan */
--grad-text            /* gradient text (stat numbers, highlights) */
--t1 / --t2 / --t3     /* text hierarchy: bright → muted → subtle */
--ff-display           /* Plus Jakarta Sans (700–800) — headings, logo, stats */
--ff-body              /* Plus Jakarta Sans (400–600) — body, buttons, nav (same family, weight hierarchy) */
--ff-mono              /* JetBrains Mono — code labels, badges */
--glass / --glass-h / --glass-b / --glass-blur  /* glassmorphism values */
--ease / --spring      /* CSS easing curves used throughout */
--r-s / --r-m / --r-l / --r-xl  /* border-radius scale */
```

## Key Patterns

**AOS (custom, not a library):** Elements with `[data-aos]` start at `opacity:0; transform:translateY(24px)`. `triggerAOS()` in `app.js` creates an `IntersectionObserver` that adds class `aos-in` when visible. Variants `fade-left` / `fade-right` use `translateX`. Delay via `data-aos-delay` attribute (ms).

**Project data flow:** `PROJECTS_DATA` (static file) → `DB.get()` → `projects[]` array → `renderProjects()` builds DOM cards → filter buttons call `renderProjects()` with a status filter. Admin edits mutate `projects[]` then call `DB.save()`, which downloads a regenerated `projects-data.js` — the user replaces the file and pushes to publish.

**Project schema** (fields used in `renderProjects` and the admin form):

```js
{ id, order, status, category, title, description,
  tech: [],       // comma-separated in admin form
  features: [],   // newline-separated in admin form
  url,            // optional external link
  imageUrl,       // optional card image
  createdAt, updatedAt }
```

**Admin panel (local-only):** The "Manage Projects" button is hidden unless `DB.isLocal()` is true (`file:` protocol or `localhost`/`127.0.0.1`) — it never appears on the live site. Password hardcoded in `db.js` as `ADMIN_PW` (default: `basith@2025`); it only gates the local editing UI, it is not a security boundary. When `isAdmin = true`, `renderProjects()` appends Edit/Delete buttons to each card. The admin panel form is always in the DOM but `display:none`. Activated by clicking "Manage Projects" → entering password via `prompt()`.

**Card 3D tilt:** Applied in JS to `.proj-card, .skill-cat-card, .ct-cta-card, .tl-content` using `perspective(700px) rotateX() rotateY()` via inline `style.transform`. Uses RAF-based lerp for smooth spring-back. Do not apply CSS `transform` to these elements on hover — inline style takes precedence.

**Particle canvas:** `<canvas id="heroCanvas">` inside `.mesh-bg`. 90 particles with mouse-repulsion (within 90px radius). Hues cycle between indigo (238), cyan (186), and pink (330). Sized to match its CSS dimensions on `resize`.

**Gallery lightbox:** `.gallery-item` click → reads `.phone-screen img` src + `.gl-name` text → opens `#galleryLightbox` with `class="open"`. Close via button, backdrop click, or Escape key.

**Typewriter:** `#typewriterText` cycles through a hardcoded `roles[]` array in `app.js` with type/delete animation. To change the rotating roles, edit the `roles` array in the `initTypewriter` IIFE.

**Section label typing:** Elements with class `.sec-label` get their text typed character-by-character when scrolled into view (18ms per character via `IntersectionObserver`).

## Customization Reference

| What                               | Where                                                                           |
| ---------------------------------- | ------------------------------------------------------------------------------- |
| Personal info (name, email, phone) | `index.html` — search and replace text                                          |
| WhatsApp number                    | `index.html` — `96566099743`                                                    |
| Instagram handle                   | `index.html` — `basith_dev`                                                     |
| Accent colors                      | `css/main.css` `:root` → `--a1`, `--a2`, `--a3`                                 |
| Fonts                              | `index.html` Google Fonts `<link>` + `css/main.css` `--ff-display`, `--ff-body` |
| Admin password                     | `js/db.js` — `const ADMIN_PW`                                                   |
| Typewriter roles                   | `js/app.js` — `roles` array in `initTypewriter` IIFE                            |
| Projects data                      | `js/projects-data.js` — `PROJECTS_DATA` array                                   |

## Projects Data & Publish Workflow (no cloud DB)

There is deliberately **no backend and no API keys** — an earlier JSONBin.io integration was removed for security before publishing. Projects live in `js/projects-data.js`. To change them: edit the array directly, **or** run the site locally → "Manage Projects" → edit in the form → an updated `projects-data.js` downloads → replace the file. Either way, `git commit` + `git push` publishes (GitHub Pages redeploys from `main`). Do not reintroduce credentials of any kind into client-side code.

## Responsive Breakpoints

Defined at the bottom of `css/main.css`:

- `≤1100px` — narrower hero/about/contact grids
- `≤900px` — single-column hero, burger menu visible, float pills hidden
- `≤640px` — stacked hero buttons, smaller stats, single-column skills
- `≤420px` — smallest text sizes, 3-column tech icon grid

## Contact Form (EmailJS)

EmailJS is wired up in `js/app.js` at the bottom — `initContactForm` IIFE. **Already configured and tested** — `EMAILJS_SERVICE`, `EMAILJS_TEMPLATE`, and `EMAILJS_PUBLIC` are set with real credentials.

Security features built in:

- **Honeypot** — hidden `#cfHoney` input; bot submissions are silently dropped
- **Rate limit** — max 2 submissions per 10 min, tracked via `localStorage` key `cf_submissions`
- **Input sanitisation** — strips `< > " ' \`` before sending

## Resume Download

A `.btn-cv` appears in the desktop nav and `.btn-download-cv` in hero btns, both linking to `Abdul_Basith_Flutter_Developer.pdf` with the `download` attribute. The PDF is present at `d:\Web Project\basith-portfolio\Abdul_Basith_Flutter_Developer.pdf`.

## Project Images (Cloudinary)

The admin panel image field includes a guide: upload screenshots to **cloudinary.com** (free tier), copy the image URL, paste into the "App Screenshot URL" field. The URL is stored as `imageUrl` on the project object in `js/projects-data.js`.

## SEO / Meta

OG tags, Twitter Card meta, and a canonical link are set in `<head>`, all pointing to the live URL `https://basithcreation.github.io/basith-portfolio/`. The social card is `og-image.png` (1200×630) in the repo root. If the site moves to a custom domain, update `og:url`, `og:image`, `twitter:image`, and the canonical link. `screenshots/` holds the README images.

## Available Skills

A `frontend-design` skill is installed at `.agents/skills/frontend-design/`. Use it when building new sections or redesigning UI components — it guides high-quality, non-generic frontend aesthetics (typography, motion, color, spatial composition).

## Logo / Brand Assets

SVG brand files live in `logo/`: `basithdev-logo.svg`, `basithdev-avatar.svg`, `basithdev-wordmark.svg`. The favicon in `index.html` references the avatar SVG inline as a data URI — to update the favicon, replace that data URI.

## Generated Files

`graphify-out/` is auto-generated by the `/graphify` skill (knowledge graph). Do not manually edit files in that directory.
