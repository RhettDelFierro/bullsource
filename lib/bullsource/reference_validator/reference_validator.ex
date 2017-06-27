defmodule Bullsource.ReferenceValidator do
  @backends [Bullsource.ReferenceValidator.CrossRef]

  alias Bullsource.ReferenceValidator.Result.Work

  def verify_doi(doi, opts \\ []) do
      limit = opts[:limit] || 1
      news_api = opts[:news_api] || nil

      @backends
      |> Enum.map(&spawn_query(&1, doi, limit))
      |> await_results(opts)
    end

  def start_link(backend, doi, doi_ref, owner, limit) do
    backend.start_link(doi, doi_ref, owner, limit)
  end

  @doc false
  defp spawn_query(backend, doi, limit) do
    doi_ref = make_ref() #unique identifier (e.g #Reference<0.0.2390148>)
    opts = [backend, doi, doi_ref, self(), limit] #self() will get the message to be sent into the verify_reference/2 pipeline. - this is called in Enum.map
    {:ok, pid} = Supervisor.start_child(Bullsource.ReferenceValidator.Supervisor, opts) #spawn a a child - context is this process we're in right now that the supervisor spawned.
    monitor_ref = Process.monitor(pid)
    {pid,  monitor_ref, doi_ref}
  end

  defp await_results(children, opts) do
    timeout = opts[:timeout] || 5000
    timer = Process.send_after(self(), :timedout, timeout)
    results = await_result(children, [], :infinity)
    cleanup(timer)
    results
  end

  defp await_result([], acc, _), do: acc
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