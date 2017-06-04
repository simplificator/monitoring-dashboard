defmodule GithubTest do
  use ExUnit.Case

  test "filter ruby versions" do
    versions = ["none", "none", "none", "2.3.3","2.3.3", "2.3.1"]
    result = MonitoringDashboard.Job.Github.filterVersions(versions, :ruby)
    assert result[:green] == 2
    assert result[:amber] == 3
    assert result[:red] == 1
  end

  test "filter rails versions" do
    versions = ["ok", "5.0.2", "4.0.13", "2.3.3","2.3.3", "2.3.1"]
    result = MonitoringDashboard.Job.Github.filterVersions(versions, :rails)
    assert result[:green] == 3
    assert result[:amber] == 0
    assert result[:red] == 3
  end

  test "version with regex" do
    content = "UEFUSAogIHJlbW90ZTogLgogIHNwZWNzOgogICAgYXNzZXRfcGlwZWxpbmVf\n\n"<>
               "aTE4biAoNC4wLjEuMikKICAgICAgcmFpbHMgKD49IDQuMC4wKQoKR0VNCiAg\n"<>
               "cmVtb3RlOiBodHRwczovL3J1YnlnZW1zLm9yZy8KICBzcGVjczoKICAgIGFj\n"<>
               "dGlvbm1haWxlciAoNC4xLjYpCiAgICAgIGFjdGlvbnBhY2sgKD0gNC4xLjYp\n"<>
               "CiAgICAgIGFjdGlvbnZpZXcgKD0gNC4xLjYpCiAgICAgIG1haWwgKH4+IDIu\n"<>
               "NSwgPj0gMi41LjQpCiAgICBhY3Rpb25wYWNrICg0LjEuNikKICAgICAgYWN0\n"<>
               "aW9udmlldyAoPSA0LjEuNikKICAgICAgYWN0aXZlc3VwcG9ydCAoPSA0LjEu\n"<>
               "NikKICAgICAgcmFjayAofj4gMS41LjIpCiAgICAgIHJhY2stdGVzdCAofj4g\n"<>
               "MC42LjIpCiAgICBhY3Rpb252aWV3ICg0LjEuNikKICAgICAgYWN0aXZlc3Vw\n"<>
               "cG9ydCAoPSA0LjEuNikKICAgICAgYnVpbGRlciAofj4gMy4xKQogICAgICBl\n"<>
               "cnViaXMgKH4+IDIuNy4wKQogICAgYWN0aXZlbW9kZWwgKDQuMS42KQogICAg\n"<>
               "ICBhY3RpdmVzdXBwb3J0ICg9IDQuMS42KQogICAgICBidWlsZGVyICh+PiAz\n"<>
               "LjEpCiAgICBhY3RpdmVyZWNvcmQgKDQuMS42KQogICAgICBhY3RpdmVtb2Rl\n"<>
               "bCAoPSA0LjEuNikKICAgICAgYWN0aXZlc3VwcG9ydCAoPSA0LjEuNikKICAg\n"<>
               "ICAgYXJlbCAofj4gNS4wLjApCiAgICBhY3RpdmVzdXBwb3J0ICg0LjEuNikK\n"<>
               "ICAgICAgaTE4biAofj4gMC42LCA+PSAwLjYuOSkKICAgICAganNvbiAofj4g\n"<>
               "MS43LCA+PSAxLjcuNykKICAgICAgbWluaXRlc3QgKH4+IDUuMSkKICAgICAg\n"<>
               "dGhyZWFkX3NhZmUgKH4+IDAuMSkKICAgICAgdHppbmZvICh+PiAxLjEpCiAg\n"<>
               "ICBhcmVsICg1LjAuMS4yMDE0MDQxNDEzMDIxNCkKICAgIGJ1aWxkZXIgKDMu\n"<>
               "Mi4yKQogICAgZXJ1YmlzICgyLjcuMCkKICAgIGhpa2UgKDEuMi4zKQogICAg\n"<>
               "aTE4biAoMC42LjExKQogICAganNvbiAoMS44LjEpCiAgICBtYWlsICgyLjYu\n"<>
               "MSkKICAgICAgbWltZS10eXBlcyAoPj0gMS4xNiwgPCAzKQogICAgbWltZS10\n"<>
               "eXBlcyAoMi4zKQogICAgbWluaXRlc3QgKDUuNC4yKQogICAgbXVsdGlfanNv\n"<>
               "biAoMS4xMC4xKQogICAgcmFjayAoMS41LjIpCiAgICByYWNrLXRlc3QgKDAu\n"<>
               "Ni4yKQogICAgICByYWNrICg+PSAxLjApCiAgICByYWlscyAoNC4xLjYpCiAg\n"<>
               "ICAgIGFjdGlvbm1haWxlciAoPSA0LjEuNikKICAgICAgYWN0aW9ucGFjayAo\n"<>
               "PSA0LjEuNikKICAgICAgYWN0aW9udmlldyAoPSA0LjEuNikKICAgICAgYWN0\n"<>
               "aXZlbW9kZWwgKD0gNC4xLjYpCiAgICAgIGFjdGl2ZXJlY29yZCAoPSA0LjEu\n"<>
               "NikKICAgICAgYWN0aXZlc3VwcG9ydCAoPSA0LjEuNikKICAgICAgYnVuZGxl\n"<>
               "ciAoPj0gMS4zLjAsIDwgMi4wKQogICAgICByYWlsdGllcyAoPSA0LjEuNikK\n"<>
               "ICAgICAgc3Byb2NrZXRzLXJhaWxzICh+PiAyLjApCiAgICByYWlsdGllcyAo\n"<>
               "NC4xLjYpCiAgICAgIGFjdGlvbnBhY2sgKD0gNC4xLjYpCiAgICAgIGFjdGl2\n"<>
               "ZXN1cHBvcnQgKD0gNC4xLjYpCiAgICAgIHJha2UgKD49IDAuOC43KQogICAg\n"<>
               "ICB0aG9yICg+PSAwLjE4LjEsIDwgMi4wKQogICAgcmFrZSAoMTAuMy4yKQog\n"<>
               "ICAgc3Byb2NrZXRzICgyLjEyLjIpCiAgICAgIGhpa2UgKH4+IDEuMikKICAg\n"<>
               "ICAgbXVsdGlfanNvbiAofj4gMS4wKQogICAgICByYWNrICh+PiAxLjApCiAg\n"<>
               "ICAgIHRpbHQgKH4+IDEuMSwgIT0gMS4zLjApCiAgICBzcHJvY2tldHMtcmFp\n"<>
               "bHMgKDIuMS40KQogICAgICBhY3Rpb25wYWNrICg+PSAzLjApCiAgICAgIGFj\n"<>
               "dGl2ZXN1cHBvcnQgKD49IDMuMCkKICAgICAgc3Byb2NrZXRzICh+PiAyLjgp\n"<>
               "CiAgICB0aG9yICgwLjE5LjEpCiAgICB0aHJlYWRfc2FmZSAoMC4zLjQpCiAg\n"<>
               "ICB0aWx0ICgxLjQuMSkKICAgIHR6aW5mbyAoMS4yLjIpCiAgICAgIHRocmVh\n"<>
               "ZF9zYWZlICh+PiAwLjEpCgpQTEFURk9STVMKICBydWJ5CgpERVBFTkRFTkNJ\n"<>
               "RVMKICBhc3NldF9waXBlbGluZV9pMThuIQo="
    regex = ~r/^\s*rails \(([\d\.]+)\)$/
    version_number = MonitoringDashboard.Job.Github.version(content, regex)
    assert version_number == "4.1.6"
  end

  @tag :skip
  @tag timeout: 300000
  test "simply" do
    assert MonitoringDashboard.Job.Github.fetchSimply() == %{amber: 0, green: 7, red: 79}
  end

  @tag :skip
  @tag timeout: 300000
  test "rails" do
    assert MonitoringDashboard.Job.Github.fetchRailsVersion == %{amber: 0, green: 34, red: 52}
  end

  test "read blacklist" do
    blacklist = MonitoringDashboard.Job.Github.readBlacklistToRegex("lib/jobs/blacklist.config")
    assert Regex.match?(blacklist, "mongomapper-tree")
  end
end
