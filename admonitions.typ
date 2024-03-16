#let admonition(title: none, color: none, content) = box(width: 90%,
  stack(
    dir: ttb,
    rect(width: 100%, fill: color, stroke: 0.3pt, title),
    rect(width: 100%, fill: color.desaturate(80%),  stroke: 0.3pt, content)
  )
)

#let opomba(naslov: none, content) = admonition(
  title: emph[#smallcaps("Opomba!") #h(1em) #naslov],
  color: lime.desaturate(40%),
  content
)