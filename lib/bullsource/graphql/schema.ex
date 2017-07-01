defmodule Bullsource.GraphQL.Schema do
#defines the shape of our api. We can practically do away with the router.
#this schema is a plug
  use Absinthe.Schema

  import_types Bullsource.GraphQL.Types.DiscussionTypes
  import_types Bullsource.GraphQL.Types.VoteTypes
  import_types Bullsource.GraphQL.Types.AccountTypes
  import_types Bullsource.GraphQL.Types.NewsTweetTypes
  import_types Bullsource.GraphQL.Types.CrossrefTypes

  query do

    # no matter what, check to see if user is resolved:
    @desc "Get a user by id :: nil || User"
    field :current_user, :user,
      do: resolve &Bullsource.GraphQL.UserResolver.get_current_user/2



    @desc "Get the top news and tweets"
    field :news_tweets, list_of(:news_tweet),
      do: resolve &Bullsource.GraphQL.NewsTweetsResolver.list/2

    @desc "Get the top news and tweets filtered by category"
    field :news_tweets_by, list_of(:news_tweet) do

      @desc "The Category of the NewsTweets"
      arg :category, non_null(:string)
      resolve &Bullsource.GraphQL.NewsTweetsResolver.filter/2
    end

    @desc "Get one NewsTweet."
    field :news_tweet, :news_tweet do

      @desc "The title of the NewsTweet"
      arg :title, non_null(:string)
      resolve &Bullsource.GraphQL.NewsTweetsResolver.get_one_by_title/2
    end




    @desc "Check a DOI and receive it's info'"
    field :doi, list_of(:work) do

      @desc "DOI"
      arg :doi, non_null(:string)
      resolve &Bullsource.GraphQL.DOIResolver.check_doi/2
    end



    @desc "Lists all the topics"
    field :topic, list_of(:topic),
      do: resolve &Bullsource.GraphQL.TopicResolver.list/2

    @desc "Lists all headliness in topic"
    field :headline, list_of(:headline),
      do: resolve &Bullsource.GraphQL.HeadlineResolver.list/2

    @desc "Lists all posts in headline"
    field :thread, list_of(:post) do

      @desc "Need the headline_id"
      arg :title, :string
      arg :network, :string

      resolve &Bullsource.GraphQL.PostResolver.list_thread/2
    end

    @desc "Lists all the references"
    field :reference, list_of(:reference),
      do: resolve &Bullsource.GraphQL.ReferenceResolver.list/2

  end

  mutation do

    @desc "Register a user"
    field :register_user, :signed_in_user do
      arg :username, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Bullsource.GraphQL.UserResolver.register/2
      middleware Bullsource.Web.HandleError
    end

    @desc "Login a user"
    field :login_user, :signed_in_user do
      arg :username, non_null(:string)
      arg :password, non_null(:string)
      resolve &Bullsource.GraphQL.UserResolver.login_user/2
      middleware Bullsource.Web.HandleError
    end

    field :sign_out, :user do
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.UserResolver.sign_out/2
    end

    @desc "Create a topic"
    field :create_topic, :topic do
      arg :name, non_null(:string)
      arg :description, :string
      #the args above will be passed in to the resolve/2 function as a map.
      resolve &Bullsource.GraphQL.TopicResolver.create/2
    end

    @desc "Create a headline"
    field :create_headline, :headline do
      arg :title, non_null(:string)
      arg :network, non_null(:string)
      arg :url, non_null(:string)
      arg :description, :string
      arg :published_at, :string
      arg :topic_id, non_null(:integer)
      arg :post, non_null(:input_post)
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.HeadlineResolver.create/2
      middleware Bullsource.Web.HandleError
    end

    @desc "Create a post - for headlines already made."
    field :create_post, :post do
      arg :headline_id, non_null(:integer)
      arg :post, non_null(:input_post)
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.PostResolver.create/2
      middleware Bullsource.Web.HandleError
    end




    @desc "Create a vote - posts and references"
    field :create_vote, :vote do
      arg :vote_type, non_null(:vote_type)
      arg :vote_type_id, non_null(:integer)
      arg :old_vote_type, :vote_type
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.VoteResolver.create/2
      middleware Bullsource.Web.HandleError
    end




# going to have to add references.
    @desc "Edit a post"
    field :edit_post, :post do
      arg :post_id, non_null(:integer)
      arg :body, :input_body
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.PostResolver.edit/2
      middleware Bullsource.Web.HandleError
    end

    @desc "Edit a Reference"
    field :edit_reference, :reference do
      arg :post_id, non_null(:integer)
      arg :reference, non_null(:input_reference)
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.ReferenceResolver.edit/2
      middleware Bullsource.Web.HandleError
    end


  end


end