#let conf(title: none, authors: (), doc) = {
  // define how a equation label should look
  let equation-label(heading, equation) = [(#heading.#equation)]

  // define the numbering for an equation
  // first locate, where we are in the document
  set math.equation(
    numbering: equation => context {
        // get the heading index at the location at offset 0 for heading level 1
        let heading-index = counter(heading).at(here()).at(0)
        // create the label
        return equation-label(heading-index, equation)
    }
  )

  // overwrite, how a reference is displayed
  show ref: it => {
    // skip if the label has no corresponding element to point at
    if it.element == none {
      return it
    }
    // get the type of the thing the ref points at
    let f = it.element.func()
    if f == math.equation {
      // for an equation do this block
      // a locate is required for a query
      context {
          // query the location of the equation the reference points at
          let equation-location = query(it.target).first().location()
          // get the index of the heading at the location of the equation
          let heading-index = counter(heading).at(equation-location).at(0)
          // get the index of the equation
          let equation-index = counter(math.equation).at(equation-location).at(0)
          // create the label with the supplement and the custom look
          link(equation-location,
            equation-label(heading-index, equation-index)
          )
        }
    } else {
      // for anything else use the default
      it
    }
  }

  show heading: it => [
    #v(0.7em)
    #it
    #v(1em)
  ]
  show heading.where(level: 1): it => [
    // pagebreak before new chapter
    #pagebreak()
    // reset the counter
    #counter(math.equation).update(0)
    #it
  ]
  show link: set text(blue.darken(20%))
  show figure.where(kind: raw): it => block(width: 100%)[
    #align(left)[#it.body]
    #align(center)[#it.caption]
  ]
  set document(title: title)
  set heading(numbering: "1.1")
  set page(paper: "a4", numbering: none)
  set par(justify: true)
  set align(center)
  v(1fr)
  text(25pt, smallcaps(title))
  linebreak()
  v(1em)
  text(18pt, authors.join(", "))
  v(2fr)
  text(14pt, [
    #datetime.today().display("[year]")
    #v(2em)
    Univerza v Ljubljani

    Fakulteta za računalništvo in informatiko
  ]
  )
  set align(left)
  set page(numbering: "1")
  doc
}
