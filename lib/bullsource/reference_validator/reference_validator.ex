defmodule Bullsource.ReferenceValidator do
  @backends [Bullsource.ReferenceValidator.GoogleCustomSearch]
  
  defmodule Result do
    defstruct url: nil, title: nil, valid: false, result: nil
  end

  def verify_reference(url, opts \\ []) do
    limit = opts[:limit] || 1 # this will be the number of references I want to choose from. Maybe have the user choose which one. With a pop up component.
    # not going to have the function passed in here to determine which api to validate with. Just use @backends
    @backends
    |> Enum.map(&spawn_query(&1, url, limit))
    |> await_results(opts)
  end

  def start_link(backend, url, url_ref, owner, limit) do
    backend.start_link(url, url_ref, owner, limit)
  end

  @doc false
  defp spawn_query(backend, url, limit) do
    url_ref = make_ref() #unique identifier (e.g #Reference<0.0.2390148>)
    opts = [backend, url, url_ref, self(), limit] #self() will get the message to be sent into the verify_reference/2 pipeline. - this is called in Enum.map
    {:ok, pid} = Supervisor.start_child(Bullsource.ReferenceValidator.Supervisor, opts) #spawn a a child - context is this process we're in right now that the supervisor spawned.
    monitor_ref = Process.monitor(pid)
    {pid,  monitor_ref, url_ref}
  end

  defp await_results(children, opts) do
    timeout = opts[:timeout] || 5000
    timer = Process.send_after(self(), :timedout, timeout)
    results = await_result(children, [], :infinity)
    cleanup(timer)
    results
  end

  defp await_result([head|tail], acc, timeout) do
    {pid, monitor_ref, query_ref} = head

    receive do
      {:results, ^query_ref, results} ->
        Process.demonitor(monitor_ref, [:flush])
        await_result(tail, results ++ acc, timeout)
      {:DOWN, ^monitor_ref, :process, ^pid, _reason} ->
        await_result(tail, acc, timeout)
      :timeout ->
        kill(pid, monitor_ref)
    after
      timeout ->
        kill(pid, monitor_ref)
        await_result(tail, acc, 0)
    end
  end

  defp await_result([], acc, _) do
    acc
  end

  defp cleanup(timer) do
    :erlang.cancel_timer(timer)
    receive do
      :timedout -> :ok
    after
      0 -> :ok
    end
  end

  defp kill(pid, ref) do
    Process.demonitor(ref, [:flush])
    Process.exit(pid, :kill)
  end

end