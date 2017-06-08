defmodule Bullsource.SocialMedia.Supervisor do
  use Supervisor

  ###
  # Supervisor API
  ###
  def start_link do
    Supervisor.start_link(__MODULE__,[], name: __MODULE__) #A) start_link is just linking to the supervisor inside the module (itself?) from use Supervisor.
  end

  def init(_) do
    children = [
      supervisor(Bullsource.SocialMedia.Twitter, [], id: "twitter"),
    ]
    supervise(children, strategy: :one_for_one) # :simple_one_for_one is a better strategy to use when you're going to dynamically add children to a supervisor.
  end

end