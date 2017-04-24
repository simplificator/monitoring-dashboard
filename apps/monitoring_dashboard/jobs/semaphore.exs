use Kitto.Job.DSL

job :semaphore, every: :minute do
  list = Kitto.Api.Semaphore.fetch
  broadcast! %{items: list}
end
