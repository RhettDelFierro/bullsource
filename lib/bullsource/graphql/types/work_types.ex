 defmodule Bullsource.GraphQL.Types.WorkTypes do
   use Absinthe.Ecto, repo: Bullsource.Repo
   use Absinthe.Schema.Notation

 @desc "DOI"
  object :crossref do
    field :DOI, :string
    field :indexed, :indexed
    field :"reference-count", :integer
    field :publisher, :string
    field :funder, list_of(:funder)
    field :type, :string
    field :"is-referenced-by-count", :integer
    field :title, list_of(:string)
    field :reference, list_of(:refernce)
    field :"container-title", list_of(:string)
    field :URL, :string
    field :ISSN, list_of(:string)
  end

  object :indexed do
    field :"date-parts", list_of[:integer]
    field :"date-time", :string
    field :timestamp, :integer
  end

  @desc "Funder"
  object :funder do
    field :doi, :string
    field :name, :string
    field :"doi-asserted-by", :string
    field :award, list_of(:string)
  end

  @desc "Author"
  object :author do
    field :ORCID, :string
    field :"authenticated-orcid", :boolean
    field :given, :string
    field :family, :string
    field :affiliation, list_of(:affiliation)
  end

  @desc "Affiliation - Authors are affiliated to."
  object :affiliation do
    field :name, :string
  end

  @desc "References this DOI has"
  object :reference do
    field :issue, :string
    field :key, :string
    field :"first-page", :string
    field :DOI, :string
    field :"article-title", :string
    field :volume, :string
    field :author, :string
    field :year, :string
    field :"journal-title", :string
  end

end