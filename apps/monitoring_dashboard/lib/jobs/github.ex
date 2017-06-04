defmodule MonitoringDashboard.Job.Github do

  def fetchRubyVersion() do
    client = getClient()
    repository = getRepository(client)
    versions = analyseRubyVersion(repository, client)
    filterVersions(versions, :ruby)
  end

  def fetchRailsVersion() do
    client = getClient()
    repository = getRepository(client)
    versions = analyseRailsVersion(repository, client)
    filterVersions(versions, :rails)
  end

  def fetchSimply() do
    client = getClient()
    repository = getRepository(client)
    has_simply = analyseSimply(repository, client)
    filterSimply(has_simply)
  end

  def analyseRubyVersion([], _), do: []
  def analyseRubyVersion([head|tail], client) do
    ruby_file = Tentacat.Contents.find(head["owner"]["login"], head["name"], ".ruby-version", client)
    gem_file = Tentacat.Contents.find(head["owner"]["login"], head["name"], "Gemfile", client)
    case gem_file do
      {404, _} ->
        case ruby_file do
          {404, _} -> analyseRubyVersion(tail, client)
          _ -> [ version(ruby_file["content"])| analyseRubyVersion(tail, client) ]
        end
      _ ->
        case ruby_file do
           {404, _} -> [ "none"  | analyseRubyVersion(tail, client) ]
           _ -> [ version(ruby_file["content"])| analyseRubyVersion(tail, client) ]
        end
    end
  end

  def analyseSimply([], _), do: []
  def analyseSimply([head|tail], client) do
    simply_file = Tentacat.Contents.find(head["owner"]["login"], head["name"], "bin/simply", client)
    binary_file = Tentacat.Contents.find(head["owner"]["login"], head["name"], "bin/simply-executables/setup", client)
    case simply_file do
      {404, _} ->
        [ :simply_not_present | analyseSimply(tail, client) ]
      _ ->
        case binary_file do
           {404, _} -> [ :binary_not_present  | analyseSimply(tail, client) ]
           _ -> [ :simply_and_binary_present | analyseSimply(tail, client) ]
        end
    end
  end

  def analyseRailsVersion([], _), do: []
  def analyseRailsVersion([head|tail], client) do
    gemlock_file = Tentacat.Contents.find(head["owner"]["login"], head["name"], "Gemfile.lock", client)
    case gemlock_file do
      {404, _} -> ["ok" | analyseRailsVersion(tail, client)]
      _ -> [version(gemlock_file["content"], ~r/^\s*rails \(([\d\.]+)\)$/) | analyseRailsVersion(tail, client)]
    end
  end

  def version(file_content, regex \\ "") do
    result = Base.decode64(String.replace(file_content,"\n",""))
    case regex do
      "" ->
        case result do
          {:ok, version} -> String.replace_trailing(version,"\n","")
          :error -> "error"
        end
      _ ->
        case result do
          {:ok, version} -> String.split(version, "\n") |> test_regex(regex) |> Enum.join("") |> String.trim
          :error -> "error"
        end
    end
  end

  def test_regex([],_), do: []
  def test_regex([head|tail],regex) do
    result = Regex.run(regex, head, capture: :all_but_first)
    case result do
      nil -> test_regex(tail, regex)
      _ -> result ++ test_regex(tail, regex)
    end
  end

  def filterVersions([], _), do: %{green: 0, amber: 0, red: 0}
  def filterVersions(versions, test) do
    versionList =
    case test do
      :ruby -> ["2.4.1", "2.3.3", "2.2.7", "2.1.10"]
      :rails -> ["5.0.2", "4.2.8", "4.1.16", "4.0.13", "3.2.22.5", "ok"]
    end
    versionMap = %{green: 0, amber: 0, red: 0}
    versions |>
    Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>
    Enum.reduce(versionMap,  fn ({version, count},versionMap) ->
      cond do
        version in versionList
          -> %{versionMap | green: versionMap[:green]+count}
        version in ["error", "none"]
          -> %{versionMap | amber: versionMap[:amber]+count}
        true
          -> %{versionMap | red: versionMap[:red]+count}
      end
    end )
  end

  def filterSimply([]), do: %{green: 0, amber: 0, red: 0}
  def filterSimply(simply) do
    versionMap = %{green: 0, amber: 0, red: 0}
    simply |>
    Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |>
    Enum.reduce(versionMap,  fn ({version, count},versionMap) ->
      cond do
        version == :simply_and_binary_present
          -> %{versionMap | green: versionMap[:green]+count}
        version == :binary_not_present
          -> %{versionMap | amber: versionMap[:amber]+count}
        version == :simply_not_present
          -> %{versionMap | red: versionMap[:red]+count}
        true -> versionMap
      end
    end )
  end

  def getClient() do
    Tentacat.Client.new(%{access_token: System.get_env("GITHUBAPI")})
  end
  def getRepository(client) do
    Tentacat.Repositories.list_mine(client)
    |> Enum.filter(fn element -> not Regex.match?(readBlacklistToRegex("lib/jobs/blacklist.config"),element["name"]) end)
  end
  def readBlacklistToRegex(file) do
    case File.read file do
      {:error, _} -> Regex.compile!("$a")
      {:ok, body} -> String.replace(body, "\n", "|") |> Regex.compile!
    end
  end
end
