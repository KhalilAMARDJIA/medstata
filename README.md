# Medstata Format

A Quarto extension providing a professional Typst format for medical device reports, clinical evaluation reports, and regulatory documentation.

## Installing

```bash
quarto use template KhalilAMARDJIA/medstata
```

This will install the extension and create an example `template.qmd` as a starting point.

To add the format to an existing project without the example file:

```bash
quarto add KhalilAMARDJIA/medstata
```

## Requirements

### Quarto

Quarto `>= 1.7.0` is required.

### Fonts

The following fonts must be installed on your system:

| Font | Used for |
|---|---|
| [CMU Concrete](https://fontsource.org/fonts/cmu-concrete) | Body text (primary) |
| [STIX Two Text](https://github.com/stipub/stixfonts) | Body text (fallback) |
| [IBM Plex Sans](https://github.com/IBM/plex) | Headings and UI elements |
| [Iosevka NFM](https://github.com/ryanoasis/nerd-fonts) | Code blocks |

If a font is not found, Typst will fall back silently to a system font.

## Using

Set the format in your document YAML front matter:

```yaml
format:
  medstata-typst: default
```

### YAML Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | string | `"Add title"` | Document title (displayed on cover page) |
| `subtitle` | string | `none` | Document subtitle |
| `author` | string | `"Add author"` | Author name(s) |
| `date` | string | `none` | Report date (use `today` for current date) |
| `version` | string | `none` | Version number displayed on cover and footer |
| `logo` | path | `none` | Path to a logo image file for the cover page |
| `lof` | boolean | `false` | Append a List of Figures after the body |
| `lot` | boolean | `false` | Append a List of Tables after the body |
| `bibliography` | path | `none` | Path to a `.bib` bibliography file |

### Example

```yaml
---
title: "Clinical Evaluation Report"
subtitle: "Post-Market Clinical Follow-up Study"
author: "Dr. Jane Smith"
date: today
version: "1.0"
logo: "logo.png"
lof: true
lot: true
bibliography: references.bib
format:
  medstata-typst: default
execute:
  echo: false
  warning: false
---
```

## Features

- **Cover page** with logo, title, subtitle, author, date, and version
- **Automatic table of contents** with hierarchical styling
- **List of figures and tables** (opt-in via `lof`/`lot`)
- **Bibliography support**
- **Alternating-row table styling**
- **Cross-references** (`@fig-label`, `@tbl-label`) with styled highlights
- **Callout blocks** (note, tip, warning, important)
- **Panel tabsets** for organized content
- **Inline Typst** for advanced layouts (two-column grids, custom boxes, etc.)
- **Reproducibility section** via `sessionInfo()`

## Customizing Colors

Colors are defined at the top of `_extensions/medstata/typst-template.typ`:

```typst
#let dark_blue   = rgb(0, 85, 165)
#let accent_color = rgb("#09c482")   // Highlights
```

Edit these to match your organization's brand.
