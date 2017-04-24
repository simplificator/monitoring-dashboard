use Kitto.Job.DSL

job :new_relic, every: :minute do
  list = Kitto.Api.NewRelic.fetch
  broadcast! %{items: list}
end
