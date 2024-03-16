#let readlines(file, start, end) = {
  let content = read(file)
  let lines = content.split(regex("\n\r{0,1}"))
  lines.slice(start - 1, end).join("\n")
}
// print a part of a julia file as a code block 
#let jl(file, start, end) = rect(raw(
  readlines(file, start, end),
  block: true,
  lang: "jl"
))

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