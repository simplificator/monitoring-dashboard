defmodule GithubTest do
  use ExUnit.Case

  test "filter ruby versions" do
    versions = ["none", "none", "none", "2.3.3","2.3.3", "2.3.1"]
    result = MonitoringDashboard.Job.Github.filterVersions(versions, :ruby)
    assert result[:green] == 2
    assert result[:amber] == 3
    assert result[:red] == 1
  end

  test "version with regex" do
    content = "UEFUSAogIHJlbW90ZTogLgogIHNwZWNzOgogICAgYXNzZXRfcGlwZWxpbmVf"<>
               "aTE4biAoNC4wLjEuMikKICAgICAgcmFpbHMgKD49IDQuMC4wKQoKR0VNCiAg"<>
               "cmVtb3RlOiBodHRwczovL3J1YnlnZW1zLm9yZy8KICBzcGVjczoKICAgIGFj"<>
               "dGlvbm1haWxlciAoNC4xLjYpCiAgICAgIGFjdGlvbnBhY2sgKD0gNC4xLjYp"<>
               "CiAgICAgIGFjdGlvbnZpZXcgKD0gNC4xLjYpCiAgICAgIG1haWwgKH4+IDIu"<>
               "NSwgPj0gMi41LjQpCiAgICBhY3Rpb25wYWNrICg0LjEuNikKICAgICAgYWN0"<>
               "aW9udmlldyAoPSA0LjEuNikKICAgICAgYWN0aXZlc3VwcG9ydCAoPSA0LjEu"<>
               "NikKICAgICAgcmFjayAofj4gMS41LjIpCiAgICAgIHJhY2stdGVzdCAofj4g"<>
               "MC42LjIpCiAgICBhY3Rpb252aWV3ICg0LjEuNikKICAgICAgYWN0aXZlc3Vw"<>
               "cG9ydCAoPSA0LjEuNikKICAgICAgYnVpbGRlciAofj4gMy4xKQogICAgICBl"<>
               "cnViaXMgKH4+IDIuNy4wKQogICAgYWN0aXZlbW9kZWwgKDQuMS42KQogICAg"<>
               "ICBhY3RpdmVzdXBwb3J0ICg9IDQuMS42KQogICAgICBidWlsZGVyICh+PiAz"<>
               "LjEpCiAgICBhY3RpdmVyZWNvcmQgKDQuMS42KQogICAgICBhY3RpdmVtb2Rl"<>
               "bCAoPSA0LjEuNikKICAgICAgYWN0aXZlc3VwcG9ydCAoPSA0LjEuNikKICAg"<>
               "ICAgYXJlbCAofj4gNS4wLjApCiAgICBhY3RpdmVzdXBwb3J0ICg0LjEuNikK"<>
               "ICAgICAgaTE4biAofj4gMC42LCA+PSAwLjYuOSkKICAgICAganNvbiAofj4g"<>
               "MS43LCA+PSAxLjcuNykKICAgICAgbWluaXRlc3QgKH4+IDUuMSkKICAgICAg"<>
               "dGhyZWFkX3NhZmUgKH4+IDAuMSkKICAgICAgdHppbmZvICh+PiAxLjEpCiAg"<>
               "ICBhcmVsICg1LjAuMS4yMDE0MDQxNDEzMDIxNCkKICAgIGJ1aWxkZXIgKDMu"<>
               "Mi4yKQogICAgZXJ1YmlzICgyLjcuMCkKICAgIGhpa2UgKDEuMi4zKQogICAg"<>
               "aTE4biAoMC42LjExKQogICAganNvbiAoMS44LjEpCiAgICBtYWlsICgyLjYu"<>
               "MSkKICAgICAgbWltZS10eXBlcyAoPj0gMS4xNiwgPCAzKQogICAgbWltZS10"<>
               "eXBlcyAoMi4zKQogICAgbWluaXRlc3QgKDUuNC4yKQogICAgbXVsdGlfanNv"<>
               "biAoMS4xMC4xKQogICAgcmFjayAoMS41LjIpCiAgICByYWNrLXRlc3QgKDAu"<>
               "Ni4yKQogICAgICByYWNrICg+PSAxLjApCiAgICByYWlscyAoNC4xLjYpCiAg"<>
               "ICAgIGFjdGlvbm1haWxlciAoPSA0LjEuNikKICAgICAgYWN0aW9ucGFjayAo"<>
               "PSA0LjEuNikKICAgICAgYWN0aW9udmlldyAoPSA0LjEuNikKICAgICAgYWN0"<>
               "aXZlbW9kZWwgKD0gNC4xLjYpCiAgICAgIGFjdGl2ZXJlY29yZCAoPSA0LjEu"<>
               "NikKICAgICAgYWN0aXZlc3VwcG9ydCAoPSA0LjEuNikKICAgICAgYnVuZGxl"<>
               "ciAoPj0gMS4zLjAsIDwgMi4wKQogICAgICByYWlsdGllcyAoPSA0LjEuNikK"<>
               "ICAgICAgc3Byb2NrZXRzLXJhaWxzICh+PiAyLjApCiAgICByYWlsdGllcyAo"<>
               "NC4xLjYpCiAgICAgIGFjdGlvbnBhY2sgKD0gNC4xLjYpCiAgICAgIGFjdGl2"<>
               "ZXN1cHBvcnQgKD0gNC4xLjYpCiAgICAgIHJha2UgKD49IDAuOC43KQogICAg"<>
               "ICB0aG9yICg+PSAwLjE4LjEsIDwgMi4wKQogICAgcmFrZSAoMTAuMy4yKQog"<>
               "ICAgc3Byb2NrZXRzICgyLjEyLjIpCiAgICAgIGhpa2UgKH4+IDEuMikKICAg"<>
               "ICAgbXVsdGlfanNvbiAofj4gMS4wKQogICAgICByYWNrICh+PiAxLjApCiAg"<>
               "ICAgIHRpbHQgKH4+IDEuMSwgIT0gMS4zLjApCiAgICBzcHJvY2tldHMtcmFp"<>
               "bHMgKDIuMS40KQogICAgICBhY3Rpb25wYWNrICg+PSAzLjApCiAgICAgIGFj"<>
               "dGl2ZXN1cHBvcnQgKD49IDMuMCkKICAgICAgc3Byb2NrZXRzICh+PiAyLjgp"<>
               "CiAgICB0aG9yICgwLjE5LjEpCiAgICB0aHJlYWRfc2FmZSAoMC4zLjQpCiAg"<>
               "ICB0aWx0ICgxLjQuMSkKICAgIHR6aW5mbyAoMS4yLjIpCiAgICAgIHRocmVh"<>
               "ZF9zYWZlICh+PiAwLjEpCgpQTEFURk9STVMKICBydWJ5CgpERVBFTkRFTkNJ"<>
               "RVMKICBhc3NldF9waXBlbGluZV9pMThuIQo="
    regex = ~r/^\s*rails \(([\d\.]+)\)$/
    version_number = MonitoringDashboard.Job.Github.version(content, regex)
    assert version_number == "4.1.6"
  end

  @tag :skip
  @tag timeout: 300000
  test "simply" do
    assert MonitoringDashboard.Job.Github.fetchSimply() == %{amber: 0, green: 7, red: 83}
  end

  test "read blacklist" do
    blacklist = MonitoringDashboard.Job.Github.readBlacklistToRegex("lib/jobs/blacklist.config")
    assert Regex.match?(blacklist, "mongomapper-tree")
  end
end
