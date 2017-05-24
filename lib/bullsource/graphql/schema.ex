defmodule Bullsource.GraphQL.Schema do
#defines the shape of our api. We can practically do away with the router.
#this schema is a plug
  use Absinthe.Schema

  import_types Bullsource.GraphQL.Types

  query do
    @desc "Lists all the topics"
    field :topic, list_of(:topic) do
      resolve &Bullsource.GraphQL.TopicResolver.list/2
    end

    @desc "Lists all threads in topic"
    field :thread, list_of(:thread) do
      resolve &Bullsource.GraphQL.ThreadResolver.list/2
    end

    @desc "Lists all posts in thread"
    field :post, list_of(:post) do
      arg :id, non_null(:integer)
      resolve &Bullsource.GraphQL.PostResolver.list/2
    end

    @desc "Lists all the proofs"
    field :proof, list_of(:proof) do
      resolve &Bullsource.GraphQL.ProofResolver.list/2
    end

    # no matter what, check to see if user is resolved:
    @desc "Get a user by id :: nil || User"
    field :current_user, :user do
      resolve &Bullsource.GraphQL.UserResolver.get_current_user/2
    end

  end

  mutation do
    @desc "Register a user"
    field :register_user, :token do
      arg :username, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Bullsource.GraphQL.UserResolver.register/2
      middleware Bullsource.Web.HandleError
    end

    @desc "Login a user"
    field :login_user, :token do
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
      middleware Bullsource.Web.Authentication
      resolve &Bullsource.GraphQL.VoteResolver.create/2
      middleware Bullsource.Web.HandleError
    end

  end

end