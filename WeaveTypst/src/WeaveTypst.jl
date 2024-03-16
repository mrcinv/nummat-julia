module WeaveTypst

struct ChunkOptions
  eval::Bool
  output::Bool
  term::Bool
end

struct Chunk
  source::String
  printed_source::String
  options::ChunkOptions
end

function parse(file)
end

function weave(file)
end

function weave_chunk(chunk::Chunk)
  result = chunk.options.eval ? eval(chunk.source) : nothing
  result
end

end # module WeaveTypst
