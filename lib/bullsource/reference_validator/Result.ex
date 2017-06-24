defmodule Bullsource.ReferenceValidator.Result do

#  defmodule Work do
#    defstruct DOI: nil,
#    indexed: %Bullsource.ReferenceValidator.Result.Indexed{},
#    "reference-count": nil,
#    publisher: nil,
#    funder: [%Funder{}],
#    type: nil,
#    "is-referenced-by-count": nil,
#    title: [],
#    author: [%Author{}],
#    reference: [%Reference{}],
#    "container-title": nil,
#    URL: nil,
#    ISSN: []
#  end

  defmodule Work do
    defstruct DOI: nil,
    indexed: Indexed,
    "reference-count": nil,
    publisher: nil,
    funder: [Funder],
    type: nil,
    "is-referenced-by-count": nil,
    title: [],
    author: [Author],
    reference: [Reference],
    "container-title": nil,
    URL: nil,
    ISSN: []
  end


  defmodule Indexed do
    defstruct "date-parts": [],"date-time": nil, timestamp: nil
  end

  defmodule Funder do
    defstruct DOI: nil,
      name: nil,
      "doi-asserted-by": nil,
      award: nil
  end

  defmodule Author do
    defstruct ORCID: nil,
      "authenticated-orcid": nil,
      given: nil,
      family: nil,
      affiliation: [Affiliation]
  end

  defmodule Affiliation, do: defstruct name: nil

  defmodule Reference do
    defstruct issue: nil,
      key: nil,
      "first-page": nil,
      DOI: nil,
      "article-title": nil,
      volume: nil,
      author: nil,
      year: nil,
      "journal-title": nil
  end

end