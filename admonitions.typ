#let admonition(title: none, color: none, content) = align(center,
  box(
    width: 98%,
    align(left,
      stack(
        dir: ttb,
        rect(width: 100%, fill: color, stroke: 0.3pt, title),
        rect(width: 100%, fill: color.desaturate(80%), stroke: 0.3pt, content),
      )
    )
  )
)
#let admtitle(type, title) = emph[#smallcaps(type) #h(1em) #title]
#let opomba(naslov: none, content) = admonition(
  title: emph(naslov),
  color: lime.desaturate(40%),
  content,
)
#let naloga(content) = admonition(
  title: emph[Samostojno delo],
  color: orange.desaturate(40%),
  content,
)
