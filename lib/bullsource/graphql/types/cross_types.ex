 defmodule Bullsource.GraphQL.Types.CrossrefTypes do
   use Absinthe.Ecto, repo: Bullsource.Repo
   use Absinthe.Schema.Notation

 @desc "DOI -> Results from CrossRef"
  object :work do
    field :doi, :string
    field :indexed, :indexed
    field :reference_count, :integer
    field :publisher, :string
    field :funder, list_of(:funder)
    field :type, :string
    field :is_referenced_by_count, :integer
    field :title, list_of(:string)
    field :author, list_of(:author)
    field :reference, list_of(:reference_cite)
    field :container_title, list_of(:string)
    field :url, :string
    field :issn, list_of(:string)
  end

  object :indexed do
    field :date_parts, list_of(:integer)
    field :date_time, :string
    field :timestamp, :integer
  end

  @desc "Funder"
  object :funder do
    field :doi, :string
    field :name, :string
    field :doi_asserted_by, :string
    field :award, list_of(:string)
  end

  @desc "Author"
  object :author do
    field :ordid, :string
    field :authenticated_orcid, :boolean
    field :given, :string
    field :family, :string
    field :affiliation, list_of(:affiliation)
  end

  @desc "Affiliation - Authors are affiliated to."
  object :affiliation do
    field :name, :string
  end

  @desc "References this DOI has"
  object :reference_cite do
    field :issue, :string
    field :key, :string
    field :first_page, :string
    field :doi, :string
    field :article_title, :string
    field :volume, :string
    field :author, :string
    field :year, :string
    field :journal_title, :string
  end

end