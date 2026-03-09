
// This file forwards Pandoc metadata values to the 'report' function defined
// in 'typst-template.typ'.
//
// Documentation on creating Typst templates:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates
#show: doc => report(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(author)$
  author: [$author$],
$endif$
$if(logo)$
  logo: "$logo$",
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(version)$
  version: [$version$],
$endif$
$if(bibliography)$
  bibliography: bibliography("$bibliography$"),
$endif$
$if(lof)$
  lof: $lof$,
$endif$
$if(lot)$
  lot: $lot$,
$endif$
  doc

)
