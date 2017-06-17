defmodule Bullsource.GraphQL.Schema do
#defines the shape of our api. We can practically do away with the router.
#this schema is a plug
  use Absinthe.Schema

  import_types Bullsource.GraphQL.Types.DiscussionTypes
  import_types Bullsource.GraphQL.Types.VoteTypes
  import_types Bullsource.GraphQL.Types.AccountTypes
  import_types Bullsource.GraphQL.Types.NewsTweetTypes

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

    @desc "Lists all the topics"
    field :topic, list_of(:topic),
      do: resolve &Bullsource.GraphQL.TopicResolver.list/2

    @desc "Lists all threads in topic"
    field :thread, list_of(:thread),
      do: resolve &Bullsource.GraphQL.ThreadResolver.list/2

    @desc "Lists all posts in thread"
    field :post, list_of(:post) do
      arg :id, non_null(:integer)
      resolve &Bullsource.GraphQL.PostResolver.list/2
    end


    @desc "Lists all the proofs"
    field :proof, list_of(:proof),
      do: resolve &Bullsource.GraphQL.ProofResolver.list/2

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
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Bullsource.GraphQL.UserResolver.login_user/2
      middleware Bullsource.Web.HandleError
    end



    @desc "Create a topic"
    field :create_topic, :topic do
      arg :name, non_null(:string)
      arg :description, :string
      #the args above will be passed in to the resolve/2 function as a map.
      resolve &Bullsource.GraphQL.TopicResolver.create/2
    end

    @desc "Create a thread"
    field :create_thread, :thread do
      arg :title, non_null(:string)
      arg :topic_id, non_null(:integer)
      arg :post, non_null(:input_post)
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.ThreadResolver.create/2
      middleware Bullsource.Web.HandleError
    end

    @desc "Create a post - for threads already made."
    field :create_post, :post do
      arg :thread_id, non_null(:integer)
      arg :post, non_null(:input_post)
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.PostResolver.create/2
      middleware Bullsource.Web.HandleError
    end




    @desc "Create a vote - posts, proofs and references"
    field :create_vote, :vote do
      arg :vote_type, non_null(:vote_type)
      arg :vote_type_id, non_null(:integer)
      arg :old_vote_type, :vote_type
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.VoteResolver.create/2
      middleware Bullsource.Web.HandleError
    end





    @desc "Edit a post - the intro/conclusion (implemented later)"
    field :edit_post, :post do
      arg :post_id, non_null(:integer)
      arg :intro, :string
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.PostResolver.edit/2
      middleware Bullsource.Web.HandleError
    end

    @desc "Edit an Article"
    field :edit_article, :article do
      arg :post_id, non_null(:integer)
      arg :article_id, non_null(:integer)
      arg :text, :string
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.ArticleResolver.edit/2
      middleware Bullsource.Web.HandleError
    end
    @desc "Edit a Comment"
    field :edit_comment, :comment do
      arg :post_id, non_null(:integer)
      arg :comment_id, non_null(:integer)
      arg :text, :string
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.CommentResolver.edit/2
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