using Random
begin
  Random.seed!(2)
  # sprehod
  using Plots
  sprehod = vcat([0.0], cumsum(2 * round.(rand(100)) .- 1))
  plot(sprehod, label=false)
  scatter!(
    sprehod,
    title="Prvih 100 korakov slučajnega sprehoda \$p=q=\\frac{1}{2}\$",
    label="\$X_k\$")
  # sprehod
end
savefig("img/03a_sprehod.svg")