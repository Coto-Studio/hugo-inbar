# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Documentary film website for "Identifying Nelson / Buscando a Roberto" - a bilingual (English/Spanish) Hugo site about El Salvador's Disappeared Children. Custom implementation based on the "Landscape" template by Pixelarity.

## Build Commands

```bash
# Local development server (includes drafts, binds to all interfaces)
hugo server -D --bind 0.0.0.0

# Production build
hugo --minify --environment main

# Staging build
hugo --minify --environment dev

# Docker build (mirrors CI/CD)
docker build --build-arg ENVIRONMENT=main -t inbar .
```

## Claude Code Behavior

Consult the `hugo` skill for dev server and build patterns. This project uses the standard configuration with no overrides.

## Branch Workflow

```
feature branch → dev (beta.identifyingnelson.com) → main (identifyingnelson.com)
```

- **dev**: Deploys to beta.\* domains for testing
- **main**: Deploys to production domains
- Always test on dev before merging to main

## Architecture

### Configuration System

Hugo environment-based config in `/config/`:

- `_default/` - Base configuration (params, markdown settings)
- `main/` - Production domains (identifyingnelson.com, buscandoaroberto.com)
- `dev/` - Staging domains (beta.\*)

Language-specific base URLs are set per environment in `languages.yaml`.

### Content Structure

Bilingual content under `/content/{en,es}/articles/`. Front matter controls:

- `id` - Anchor ID for single-page navigation
- `menu: true` - Include in nav header
- `weight` - Sort order
- `style` - CSS class applied to section
- `social: true` - Show social links in section

### Layout System

Single-page scrolling site with sections rendered from article content:

- `layouts/index.html` - Iterates articles by weight, renders via `components/article.html`
- `layouts/partials/header/nav.html` - Builds nav from articles with `menu: true`
- `layouts/shortcodes/image.html` - Responsive images with WEBP conversion, lazy loading
- `layouts/shortcodes/form.html` / `form-es.html` - Newsletter signup with Botpoison protection

### Asset Pipeline

SASS compilation via Hugo Pipes (Dart Sass):

- Entry point: `assets/sass/main.scss`
- Variables/mixins: `assets/sass/libs/`
- Components: `assets/sass/components/`

JavaScript bundled in `partials/head/scripts.html` via Hugo's `resources.Concat`.

## Deployment

Automated via GitHub Actions on push to `main` or `dev`:

1. Docker multi-stage build (Hugo build → nginx serve)
2. Image pushed to GHCR
3. Docker stack deployed via Coto Studio shared workflows

The `docker-stack-op.yaml.tpl` template configures Traefik routing for both environments.

## Key Files

| File                               | Purpose                                          |
| ---------------------------------- | ------------------------------------------------ |
| `config/_default/params.yaml`      | Site metadata, social links, theme colors        |
| `config/{main,dev}/languages.yaml` | Environment-specific domain URLs                 |
| `layouts/shortcodes/image.html`    | Image processing (resize, WEBP, lazy load)       |
| `layouts/shortcodes/form.html`     | Form with submit-form.com + Botpoison            |
| `default.conf`                     | Nginx config with redirects for podcast episodes |
