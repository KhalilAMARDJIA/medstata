// ============================================================================
// MEDSTATA TYPST TEMPLATE
// Professional Medical Device Report Template
// ============================================================================
//
// This template provides a comprehensive layout for medical device reports,
// clinical evaluation reports, and regulatory documentation.
//
// Features:
// - Custom branded cover page with version control
// - Automated table of contents with hierarchical styling
// - List of figures and tables
// - Professional color scheme with customizable branding
// - Tables with a tinted header row, hairline row rules and a closing rule;
//   long tables break between rows and repeat their header
// - Section numbers hung in the left margin, sans headings
// - AMA superscript citations in bold navy
// - PDF metadata (title, author) and an optional short running title
// ============================================================================

// ============================================================================
// COLOR PALETTE CONFIGURATION
// Stata s2color / journal scheme — the de-facto standard in academic
// medical statistics. Muted, warm-cool balanced, institutional.
// ============================================================================



// Base colors
#let dark_navy  = rgb("#1a476f")   // Stata navy   — primary
#let light_bg   = rgb("#f9f9f7")   // Soft neutral paper tint

// Theme colors
#let main_color       = light_bg              // Backgrounds and subtle accents
#let secondary_color  = dark_navy             // Headers, borders, emphasis
#let accent_color     = rgb("#6e8e84")        // Stata teal — highlights
#let cover_page_color = rgb("#0d2b42")        // Deep navy — cover background

// Text colors
#let dark_text        = rgb("#1a1a1a")        // Near-black body text
#let cover_page_text  = light_bg       // Light slate on dark cover
#let cover_page_line  = rgb("#6e8e84").transparentize(30%)  // Muted teal rule

// ============================================================================
// FONT CONFIGURATION: Libertinus Serif body, IBM Plex for the apparatus
// ============================================================================

#let main_fonts      = ("Libertinus Serif", "IBM Plex Serif")   // Body text
#let secondary_fonts = ("Libertinus Serif", "IBM Plex Serif")   // Running head, footer, cover
#let code_fonts      = ("IBM Plex Mono", "Libertinus Mono")                      // Code blocks

// ============================================================================
// DESIGN TOKENS (ms-*): used by headings, tables and captions, and available
// to documents in raw typst blocks (e.g. `fill: ms-tint`)
// ============================================================================

#let ms-ink        = dark_text
#let ms-petrol     = dark_navy                // headings, rules, citations, links
#let ms-signal     = dark_navy                // one accent colour
#let ms-muted      = rgb("#5B676C")           // running head, footer, meta lines
#let ms-rule       = rgb("#C9D3DD")           // table row rules
#let ms-tint       = rgb("#EEF2F6")           // table header ground
#let ms-code-tint  = rgb("#F2F2EF")           // search-string panels: barely off the page tint
#let ms-serif      = main_fonts
#let ms-sans       = ("IBM Plex Sans", "Libertinus Sans")
#let ms-sans-semi  = ("IBM Plex Sans SmBld", "IBM Plex Sans")
#let ms-mono       = ("IBM Plex Mono", "Libertinus Mono")
#let ms-body-size  = 10pt
#let ms-table-size = 8.5pt
#let ms-margin     = (bottom: 2.5cm, left: 2.5cm, right: 2.5cm, top: 2.5cm)
#let ms-hang       = 14mm      // section numbers sit in the margin, right-aligned to this
#let ms-hang-gap   = 3.5mm
#let ms-keep-table = 7cm       // captioned tables shorter than this never break

// Number hung in the left margin, baseline-aligned with the heading text.
#let ms-hung(num) = place(
  left, dx: -ms-hang,
  box(width: ms-hang - ms-hang-gap, align(right, num)),
)

// Plain text of a content value (PDF metadata, tests on heading text).
#let ms-plain(c) = {
  if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(ms-plain).join("") }
  else if c.has("body") { ms-plain(c.body) }
  else if c == [ ] { " " }
  else { "" }
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/// Blockquote styling
/// Creates a styled quote block with left border accent
///
/// Parameters:
/// - body: Quote content to display
#let blockquote(body) = {
  block(
    width: 100%,
    fill: dark_navy.lighten(95%),
    inset: (top: 1em, bottom: 1em, left: -3em, right: -3em),
    outset: (top: 0em, bottom: 0em, left: 3em, right: 3em),
    radius: 0.3em,
    stroke: (
      left: (paint: dark_navy, thickness: 3pt, dash: "solid"),
    ),
    body,
  )
}

// Apply blockquote styling to all quote elements
#show quote: it => {
  blockquote(
    text(
      it,
      size: 0.9em,
      weight: 400,
      font: secondary_fonts,
      fill: dark_text,
    ),
  )
}

// ============================================================================
// MAIN REPORT FUNCTION
// ============================================================================

/// Main report template function
///
/// Parameters:
/// - title: Report title (required)
/// - subtitle: Report subtitle (optional)
/// - author: Author name(s) (required)
/// - logo: Path to logo image (optional)
/// - date: Report date (optional, defaults to current date)
/// - version: Version number (optional)
/// - short-title: Running header text (optional, defaults to the title)
/// - lof: Display list of figures (boolean, default: false)
/// - lot: Display list of tables (boolean, default: false)
/// - body: Main document content (required)
#let report(
  title: [Add title],
  subtitle: none,
  short-title: none,
  author: [Add author],
  logo: none,
  date: none,
  version: none,
  lof: false,
  lot: false,
  body,
) = {
  // ==========================================================================
  // DOCUMENT SETUP
  // ==========================================================================

  // PDF metadata: the subtitle is the descriptive title when there is one
  set document(
    title: if subtitle != none { subtitle } else { title },
    author: ms-plain(author),
  )
  set page(paper: "a4")
  set text(hyphenate: false)
  set par(justify: true)

  // ==========================================================================
  // COVER PAGE
  // ==========================================================================

  page(
    background: rect(fill: cover_page_color, width: 100%, height: 100%),
    margin: (top: 6em, bottom: 1em, left: 5em, right: 5em),

    // Header with logo and version
    header: grid(
      columns: (1fr, 1fr, 1fr),
      align: (left + horizon, center + horizon, right + horizon),

      // Logo (left)
      [#if logo != none {
        image(logo, height: 3em)
      }],

      // Center (empty)
      [],

      // Version (right)
      text(
        size: 1em,
        fill: cover_page_text,
        weight: 400,
        font: main_fonts,
      )[VERSION | *#version*],
    ),

    // Main cover content
    box(
      grid(
        columns: 1fr,
        rows: (2fr, 0.8fr, 0.8fr),

        // Title and subtitle section
        grid(
          columns: 1,
          gutter: 4em,

          // Title (right-aligned with right border)
          box(
            text(
              size: 1.5em,
              fill: cover_page_text,
              weight: 600,
              font: secondary_fonts,
              align(upper(title), right),
            ),
            width: 85%,
            stroke: (right: cover_page_line),
            inset: 1em,
          ),

          // Subtitle (left-aligned with left border)
          box(
            text(
              size: 1.3em,
              fill: cover_page_text,
              weight: 400,
              font: secondary_fonts,
              align(subtitle, left),
            ),
            width: 85%,
            inset: 1em,
            stroke: (left: cover_page_line),
          ),
        ),

        // Decorative gradient polygon
        [#polygon(
          fill: gradient.linear(
            accent_color,
            secondary_color.transparentize(100%),
            angle: 360deg,
          ),
          (130%, 10cm),
          (130%, 12cm),
          (0%, 8cm),
          (-10%, 9cm),
        )],

        // Author and date footer
        grid(
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),

          // Author
          text(
            size: 1em,
            fill: cover_page_text,
            weight: 200,
            font: main_fonts,
          )[#author],

          // Center (empty)
          [],

          // Date
          text(
            size: 1em,
            fill: cover_page_text,
            weight: 400,
            font: main_fonts,
          )[#date],
        ),

        align: center + horizon,
      ),
      stroke: (top: cover_page_line + 0.1em),
    ),
  )

  // ==========================================================================
  // PAGE LAYOUT AND TYPOGRAPHY
  // ==========================================================================

  // Page margins, full-page tint, and running header
  set page(
    margin: ms-margin,
    background: rect(fill: light_bg, width: 100%, height: 100%),
    header: context {
      // Running chapter: the level-1 heading that starts on this page, else the last one before it
      let here-page = here().page()
      let hs = query(heading.where(level: 1)).filter(h => h.location().page() <= here-page)
      let on-page = hs.filter(h => h.location().page() == here-page)
      let chapter = if on-page.len() > 0 { on-page.first() } else if hs.len() > 0 { hs.last() } else { none }
      set text(size: 7.5pt, fill: accent_color.darken(20%), font: secondary_fonts, weight: 400)
      grid(
        columns: (1fr, auto),
        align: (left + bottom, right + bottom),
        if chapter != none {
          if chapter.numbering != none [#counter(heading).at(chapter.location()).first()#h(0.5em)]
          chapter.body
        },
        [#upper(if short-title != none { short-title } else { title })#if version != none [ #h(0.6em) | #h(0.6em) v#version ]],
      )
      v(-0.6em)
      line(length: 100%, stroke: 0.4pt + accent_color)
    },
  )

  // Paragraph settings
  set par(
    justify: true,
    leading: 0.65em, // Space between lines
    spacing: 1.5em,  // Space between paragraphs
  )
  set block(spacing: 1.2em)

  // Text settings
  set text(
    font: main_fonts,
    size: 10pt,
    weight: 400,
    hyphenate: false,
    spacing: 100%,
  )

  // Code block styling
  show raw: set text(font: ms-mono, size: 1.1em)  // typst already scales raw to 0.8em

  // ==========================================================================
  // FOOTER CONFIGURATION
  // ==========================================================================

  set page(
    footer: grid(
      columns: (1fr, 1fr, 1fr),
      align: (left, center, right),
      gutter: 0.5em,

      // Author (left)
      text(size: 7.5pt, fill: ms-muted, font: secondary_fonts)[#author],

      // Center (empty)
      [],

      // Page numbering (right)
      context text(size: 7.5pt, fill: ms-muted, font: secondary_fonts)[
        Page #counter(page).display() of #counter(page).final().first()
      ],
    ),

  )

  // ==========================================================================
  // LIST STYLING
  // ==========================================================================

  // Bullet list settings
  set list(
    tight: false,
    indent: 1.5em,
    body-indent: 1em,
    spacing: auto,
    marker: ([•], [--], [○], [‣]), // Multi-level markers
  )

  show list: set par(justify: false)

  // Numbered list settings
  set enum(
    tight: false,
    indent: 1.5em,
    body-indent: 1em,
    spacing: auto,
  )

  // ==========================================================================
  // LINK AND REFERENCE STYLING
  // ==========================================================================

  // URLs and cross-references navy; citation numbers (links to <ref-*>) in
  // bold Plex Sans so they read apart from the serif text.
  show link: it => {
    if type(it.dest) == label and str(it.dest).starts-with("ref-") {
      text(font: ms-sans-semi, weight: 600, fill: ms-signal, it)
    } else {
      text(fill: ms-petrol, it)
    }
  }

  // Cross-references to figures and tables: "Table 3" as one link
  show ref: it => {
    let el = it.element
    if el != none and el.func() == figure {
      let sup = if it.supplement == auto { el.supplement } else { it.supplement }
      link(el.location(), context [#sup~#numbering(el.numbering, ..el.counter.at(el.location()))])
    } else { it }
  }

  // Pandoc citeproc emits #super[#link(<ref-key>)[n]]
  set super(size: 0.68em, baseline: -0.42em)

  // ==========================================================================
  // HEADING HIERARCHY
  // ==========================================================================

  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    set par(justify: false, leading: 0.4em)
    set text(font: ms-sans-semi, weight: 600, size: 15pt, fill: ms-petrol)
    // Unnumbered "Annex ..." headings get a closing rule: annexes read as a
    // separate register from the numbered report sections.
    let annex = it.numbering == none and ms-plain(it.body).starts-with("Annex")
    block(above: 2.3em, below: 1.1em, sticky: true, width: 100%)[
      #if it.numbering != none {
        ms-hung(text(context counter(heading).display(it.numbering)))
      }
      #it.body
      #if annex {
        v(-0.35em)
        line(length: 100%, stroke: 0.7pt + ms-petrol)
      }
    ]
  }

  show heading.where(level: 2): it => {
    set par(justify: false, leading: 0.4em)
    set text(font: ms-sans-semi, weight: 600, size: 11pt, fill: ms-petrol)
    block(above: 1.8em, below: 0.8em, sticky: true, width: 100%)[
      #if it.numbering != none {
        ms-hung(text(context counter(heading).display(it.numbering)))
      }
      #it.body
    ]
  }

  show heading.where(level: 3): it => {
    set par(justify: false)
    set text(font: ms-sans-semi, weight: 600, size: 9.5pt, fill: ms-petrol)
    // Reserve room for what follows (often a long table whose first row
    // would otherwise go to the next page and leave the heading orphaned).
    let room = 7em
    block(above: 1.5em, below: 0.6em, sticky: true, breakable: false)[
      #if it.numbering != none {
        ms-hung(text(context counter(heading).display(it.numbering)))
      }
      #it.body
      #v(room)
    ]
    v(-room)
  }

  show heading: set text(font: ms-sans, weight: 500, size: ms-body-size, fill: ms-ink)

  // ==========================================================================
  // FIGURES, TABLES, CAPTIONS
  // ==========================================================================
  show figure.caption: it => {
    set text(fill: dark_text, weight: 400, size: 1em)
    // sticky + unbreakable: a caption never ends a page apart from its table
    block(it, inset: (left: 5em, right: 5em, top: 0em, bottom: 0em), breakable: false, sticky: true)
  }
  set figure(gap: 0.6em)
  show figure: set block(above: 1.5em, below: 1.4em)

  // Tables: caption on top. Tables taller than ms-keep-table break between
  // rows (never inside one) and repeat their header, so long tables do not
  // leave part-empty pages; shorter tables stay whole.
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: "quarto-float-tbl"): set block(breakable: true)
  show figure.where(kind: "quarto-float-tbl"): it => context {
    let w = page.width - ms-margin.left - ms-margin.right
    if measure(it, width: w).height > ms-keep-table { it } else { block(breakable: false, it) }
  }
  set table.cell(breakable: false)
  show table: set par(justify: false, leading: 0.5em)
  show table: set text(font: ms-sans, size: ms-table-size, number-type: "lining", number-width: "tabular")
  show table.cell.where(y: 0): set text(weight: 700, fill: ms-petrol)
  set table.hline(stroke: 0.7pt + ms-petrol)
  set table(
    inset: (x: 5pt, y: 4.2pt),
    fill: (_, y) => if y == 0 { ms-tint },
    stroke: (_, y) => (
      top: if y == 0 { 0.7pt + ms-petrol } else { 0.4pt + ms-rule },
      x: none,
    ),
  )
  // Closing rule under every table
  // (block sized to the table, so narrow tables get a rule of their own width)
  show table: it => block(stroke: (bottom: 0.7pt + ms-petrol), it)

  // ==========================================================================
  // TABLE OF CONTENTS
  // ==========================================================================

  // Reset page numbering (exclude cover page)
  counter(page).update(1)

  // Custom table of contents
  context {
    let custom_outline_fill = box(width: 1fr, repeat("  . "))

    set outline(title: "Table of Contents")
    set outline.entry(fill: custom_outline_fill)

    // Tight spacing for all entries
    show outline.entry: set block(spacing: 0.4em)

    // Extra spacing before level 1 entries (except first)
    show outline.entry.where(level: 1): set block(above: 1.2em)

    // Level 1 entries: bold, colored, no fill dots
    show outline.entry.where(level: 1): it => {
      show repeat: none
      text(
        it,
        fill: secondary_color,
        font: secondary_fonts,
        weight: 600,
      )
    }

    // Slightly smaller font for all entries
    show outline.entry: it => [
      #set text(size: 0.9em)
      #it
    ]

    outline(indent: auto, depth: 5)

    pagebreak()
  }

  // ==========================================================================
  // MAIN DOCUMENT BODY
  // ==========================================================================

  body

  // ==========================================================================
  // LIST OF FIGURES AND TABLES
  // ==========================================================================

  if lof {
    context {
      pagebreak()
      outline(
        title: [List of Figures],
        target: figure.where(kind: "quarto-float-fig"),
      )
      outline(
        title: none,
        target: figure.where(kind: image),
      )
    }
  }

  if lot {
    context {
      pagebreak()
      outline(
        title: [List of Tables],
        target: figure.where(kind: "quarto-float-tbl"),
      )
      outline(
        title: none,
        target: figure.where(kind: table),
      )
    }
  }
}

// ============================================================================
// USAGE EXAMPLE
// ============================================================================
//
// #import "medstata-template.typ": report
//
// #show: report.with(
//   title: "Clinical Evaluation Report",
//   subtitle: "Post-Market Clinical Follow-up Study",
//   author: "Dr. Jane Smith",
//   date: datetime.today().display(),
//   version: "1.0",
//   logo: "logo.png",
//   lof: true,
//   lot: true,
// )
//
// = Introduction
// Your content here...
//
// ============================================================================
