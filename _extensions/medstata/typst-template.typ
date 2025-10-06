
#let dark_blue = rgb(0, 85, 165)
#let light_blue = dark_blue.lighten(90%).desaturate(10%).rotate(180deg)

// color palette settings
#let main_color = light_blue
#let secondary_color = dark_blue
#let accent_color = rgb("#09c482")
#let cover_page_color = main_color.rotate(180deg).rotate(180deg).desaturate(50%)
// fonts settings
#let dark_text = rgb(15, 10, 10)
#let cover_page_text = main_color.negate().saturate(10%).rotate(180deg)

#let main_fonts = ("STIX Two Text")
#let secondary_fonts = ("IBM Plex Sans")

#let cover_page_line = cover_page_color.saturate(99%).rotate(180deg).negate().transparentize(50%)

#let version_box(body) = {
  box(
    fill: main_color.lighten(90%),
    inset: 0.1em,
    outset: 0.1em,
    stroke: (paint: main_color, thickness: 0.3pt, dash: "solid"),
    radius: 0.3em,
    body,
  )
}

#let blockquote(body) = {
  block(
    width: 100%,
    fill: dark_blue.lighten(95%),
    inset: (top: 1em, bottom: 1em, left: -3em, right: -3em),
    outset: (top: 0em, bottom: 0em, left: 3em, right: 3em),
    radius: 0.3em,
    stroke: (
      left: (paint: dark_blue, thickness: 3pt, dash: "solid"),
    ),

    body,
  )
}

#show quote: it => {
  blockquote(text(it, size: 0.9em, weight: 300, font: secondary_fonts, fill: dark_text))
}

#let report(
  title: [Add title],
  subtitle: none,
  author: [Add author],
  logo: none,
  date: none,
  version: none,
  bibliography: none,
  lof: false,
  lot: false,
  body,
)= {
  // // Set the document's metadata.
  // set cite(style: "american-medical-association")


  // Set Cover page
  set page(paper: "a4")
  set text(hyphenate: false)
  set par(justify: true)
  page(
    background: rect(fill: cover_page_color, width: 100%, height: 100%),
    margin: (top: 6em, bottom: 1em, left: 5em, right: 5em),
    header: grid(
      columns: (1fr, 1fr, 1fr),
      [#if logo != none {
          image(logo, height: 3em)
        }],
      [],
      text(
        size: 1em,
        fill: cover_page_text,
        weight: 400,
        font: main_fonts,
      )[VERSION | *#version*],
      align: (left + horizon, center + horizon, right),
    ),
    box(
      grid( // the box is only for the top stroke
        columns: (1fr),
        rows: (2fr, 0.8fr, 0.8fr),
        grid(columns: 1, gutter: 4em, box(text(
          size: 1.5em,
          fill: cover_page_text,
          weight: 600,
          font: secondary_fonts,
          align(upper(title), right),
        ), width: 85%, stroke: (right: cover_page_line), inset: 1em), box(text(
          size: 1.3em,
          fill: cover_page_text,
          weight: 400,
          font: secondary_fonts,
          align(subtitle, left),
        ), width: 85%, inset: 1em, stroke: (left: cover_page_line))),
        [#polygon(
            fill: gradient.linear(accent_color, secondary_color.transparentize(100%), angle: 360deg),
            (130%, 10cm),
            (130%, 12cm),
            (0%, 8cm),
            (-10%, 9cm),
          )],
        grid(columns: (1fr, 1fr, 1fr), text(
          size: 1.3em,
          fill: cover_page_text,
          weight: 200,
          font: main_fonts,
        )[#author], [], text(
          size: 1.3em,
          fill: cover_page_text,
          weight: 400,
          font: main_fonts,
        )[#date], align: (left, center, right)),
        align: center + horizon,
      ),
      stroke: (top: cover_page_line + 0.1em),
    ),
  )

  // Set page margins
  set page(margin: (bottom: 4cm, left: 2.5cm, right: 2.5cm, top: 2.5cm))

  // Paragraph settings
  set par(justify: true, leading : 0.6em)
  set block(spacing: 1.5em) // space between paragraphs
  set text(font: main_fonts, size: 11pt, weight: 300, hyphenate: false, spacing : 100%)
  show raw: set text(size: 0.8em, font: "Iosevka NFM") 

  // Footer settings
  // Configure footer
  
  set page(footer: grid(
    columns: (1fr, 1fr, 1fr),
    align: (left, center, right),
    gutter: 0.5em,
    if version != none {
      [Version : #version_box(version)]
    },
    [],
    context {counter(page).display("1 of 1", both: true)},
  ))


  // Set bulette list settings
  set list(
    tight: false,
    indent: 1.5em,
    body-indent: 1em,
    spacing: auto,
    marker: ([•], [--], [○], [‣]))

  // Set number list settings
  set enum(
    tight: false,
    indent: 1.5em,
    body-indent: 1em,
    spacing: auto,
  )

   // Link settings
  show link : it =>[
    #h(0.3em)
    #set text(weight: "regular")
    #box(
      [#it],
      stroke: main_color + 0.04em,
      fill: main_color.lighten(90%),
      outset: 0.2em,
      radius: 0.2em,
    )
    #h(0.3em)
  ]

  // cross-reference settings
  show ref: it =>[
    #set text(weight: "regular")
    #box(
      [#it],
          stroke: (
      bottom: (paint: accent_color, thickness: 0.1em, dash: "solid"),
    ),
      fill: main_color.lighten(50%),
    )
  ]

  // Headings settings
  set heading(numbering: "1.1.")

  show heading.where(level: 1): it => [
    #set text(fill: secondary_color, weight: 800, size: 1.3em, font: secondary_fonts)

    #block(
      smallcaps(it),
      inset: (top: 0.5em, bottom: 0.5em, rest: 0em),
      

    )

  ]
    show heading.where(level: 2): it => [
    #set text(fill: accent_color.darken(50%), weight: 500, size: 1.1em, font: secondary_fonts)

    #block(
      underline(smallcaps(it)),
      inset: (top: 0.5em, bottom: 0.5em, rest: 0em),

    )

  ]

 
show heading.where(level: 3): it => [
    #set text(fill: dark_blue.darken(50%), weight: 400, size: 1em, font: secondary_fonts)

    #block(
      smallcaps(it),
      inset: (top: 0.5em, bottom: 0.5em, rest: 0em),

    )

  ]


  show heading.where(level: 4): set text(fill: dark_text, weight: 300, size: 1em)
  show heading.where(level: 5): set text(fill: dark_text, weight: 300, size: 1em)
  show heading.where(level: 6): set text(fill: dark_text, weight: 300, size: 1em)
  show heading.where(level: 7): set text(fill: dark_text, weight: 300, size: 1em)
  show heading.where(level: 8): set text(fill: dark_text, weight: 300, size: 1em)

  // Figure settings
  show figure.caption: it =>{
    set text(fill: cover_page_text, weight: 400, size: 1.1em)
    block(it, inset: 1em)
  }

  // Table settings

  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set block(breakable: true)
  show table.cell : set text(size: 0.8em)
  show figure.where(kind: "quarto-float-tbl"): set block(breakable: true)
  show figure.where(kind: "quarto-float-tbl"): set table.header(repeat: true) 

  set table(

    // Increase the table cell's padding
    fill: (_, y) => {
      if (calc.odd(y)) {
        return accent_color.lighten(90%).desaturate(90%);
      } else if (y == 0) {
        return main_color.lighten(10%).desaturate(5%);
      }
    },
    inset: 0.7em,
    stroke: (_, y) => (
      x: 0.2pt,
      top: if y <= 1 { 0.5pt } else { 0pt },
      bottom: 0.5pt,
    ),
  )

  
  // // Display bibliography.
  // if bibliography != none {
  //   pagebreak()
  //   // show bibliography: set text(0.85em)
  //   // // Use default paragraph properties for bibliography.
  //   // show bibliography: set par(leading: 0.65em, justify: false, linebreaks: auto)
  //   bibliography
  // }

   // page numbering from page 2 (do not count the title page)
  counter(page).update(1)
  // add table of content
  let custom_outline_fill = box(width: 1fr, repeat(" ."))
  context {
    show outline.entry: it =>{
    text([#it], size: 1em)
  }
    
  
    show outline.entry.where(level: 1): it => [
      #v(0.2em)
      #strong(text(
        it,
        fill: secondary_color,
        font: secondary_fonts, 
        weight: 500
        ))
    ]
    show outline.entry: it => [
      #set text(size: 0.8em)
      #it
    ]
    
    outline(indent: auto, depth: 5)
    
    pagebreak()
  }
  

  body

  

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

  

  //   context {
  //   let elems = query(figure.where(kind: "quarto-float-tbl"), here())
  //   let count = elems.len()
  //   show outline.entry: it => [
  //     #set text(fill: dark_text, weight: 100, size: 1em)

  //     #box(
  //       it,
  //       inset: 0em,
  //     )
  //   ]

  //     outline(
  //       title: [List of QUARTO Tabless],
  //       fill: custom_outline_fill,
  //       target: figure.where(kind: "quarto-float-tbl"),
  //     )

  // }

}

