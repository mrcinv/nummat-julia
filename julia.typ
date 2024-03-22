#let readlines(file, start, end) = {
  let content = read(file)
  let lines = content.split(regex("\n\r{0,1}"))
  lines.slice(start - 1, end).join("\n")
}
// print a part of a julia file as a code block 
#let jl(file, start, end) = raw(
  readlines(file, start, end),
  block: true,
  lang: "jl"
)

// create a virtual box for Julia code and other code
#let code_box(content) = box(width:100%, inset: 1em, content)

#let prompt_jl = text(green)[*`julia>`* #h(0.6em)]
#let prompt_pkg(env) = text(blue,
 weight: "bold")[#raw("("+env +") pkg>") #h(0.6em)]

// a single line for REPL
#let repl_line(command, block, prompt: prompt_jl) = stack(
      dir: ltr,
      prompt,
      raw(lang:"jl", block: block, command)
    )  

// write a single entry to Julia REPL
#let repl(command, out, block: false) = stack(
    dir: ttb,
    spacing: 0.6%,
    repl_line(command, block, prompt: prompt_jl),
    if out != none {
      raw(out) 
    }
    else
    {
      v(-9pt)
    }
  )

// A single line of REPL in package mode
#let pkg(command, out, env: "@v1.10") = stack(
    dir: ttb,
    spacing: 0.6%,
    repl_line(command, false, prompt: prompt_pkg(env)),
    if out != none{
      raw(out)
    }
    else
    {
      v(-9pt)
    }
  )

#let blk(file, start) = {
  let content = read(file)
  let r = regex("(?s)" + start + "[\r\n]*(.*?)" + start)
  let match = content.match(r)
  if match == none { 
    "No match for " + start + " in " + file
  }
  else {
    match.captures.first()
  }
}

#let jlb(file, start) = raw(
  blk(file, start),
  block: true,
  lang: "jl"
)

#let out(file) = raw(read(file))