use Kitto.Job.DSL

job :nodeping, every: :minute do
  list = Kitto.Jobs.NewRelic.fetch
  broadcast! %{items: list}
end
