defmodule Bullsource.ReferenceValidator.Result do

  defmodule Work do
    defstruct DOI: nil,
    indexed: nil,
    "reference-count": nil,
    publisher: nil,
    funder: nil,
    type: nil,
    "is-referenced-by-count": nil,
    title: nil,
    author: nil,
    reference: nil,
    "container-title": nil,
    URL: nil,
    ISSN: nil
  end

end