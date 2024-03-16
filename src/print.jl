using Logging

out(code) = open("out/$(code).out", "w")
"""
    log("bla") do
      # some stuf
    end

Run function with logging saved to `out/bla.out` file.
"""
function logger(name, fun)
  io = out(name)
  logger = SimpleLogger(io)
  with_logger(logger, fun)
  close(io)
end

"""
Print the variable in the named output file.
"""
function p(name, x)
  io = out(name)
  println(io, x)
  close(io)
end

"""
Print the variable in the named output file as it would be printed in the REPL.
"""
function term(name, x)
  io = out(name)
  context = IOContext(io,
    :limit => true,
    :displaysize => (20, 40))
  show(context, "text/plain", x)
  close(io)
end

export p, term, save_out, logger