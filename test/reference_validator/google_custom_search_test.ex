defmodule Bullsource.ReferenceValidator.GoogleCustomSearchTest do
  use ExUnit.Case

  alias Bullsource.ReferenceValidator.GoogleCustomSearch

  setup do
    query_ref = make_ref()
    url = "http://www.facebook.com"
    owner = self()
    limit = 1
    {:ok, [query_ref: query_ref, url: url, owner: owner, limit: limit]}
  end
  test ".get_info should return a pid",%{query_ref: query_ref, url: url, owner: owner, limit: limit} do
    GoogleCustomSearch.get_info(url, query_ref, owner, limit)

    assert
  end
end