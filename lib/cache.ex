defmodule Metex.Cache do
  use GenServer
  @name Cache

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def write(key, value) do
    GenServer.call(@name, {:write, key, value})
  end

  def delete(key) do
    GenServer.call(@name, {:delete, key})
  end

  def clear do
    GenServer.call(@name, {:clear})
  end

  def exist?(key) do
    GenServer.call(@name, {:exist?, key})
  end

  #callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, state) do
    {:reply, :ok, Map.put(state, key, value)}
  end

  def handle_call({:read, key}, _from, state) do
    case Map.fetch(state, key) do
      {:ok, value} ->
        {:reply, {:ok, value}, state}
      :error ->
        {:reply, :error, state}
    end
  end

  def handle_call({:delete, key}, _from, state) do
    {_, new_state} = Map.pop(state, key)
    {:reply, :ok, new_state}
  end

  def handle_call({:clear}, _from, _state), do: {:reply, :ok, %{}}

  def handle_call({:exist?, key}, _from, state) do
    {:reply, Map.has_key?(state, key), state}
  end
end
