defmodule WDcrWeb.SearchLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <form phx-change="suggest" phx-submit="search">
      <input type="text" name="q" value="<%= @query %>" list="matches" placeholder="Search..."
             <%= if @loading, do: "readonly" %>/>
      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value="<%= match %>"><%= match %></option>
        <% end %>
      </datalist>
      <%= if !!@result and !is_binary(@result) do %>
        <%= live_component @socket, WDcrWeb.SearchLive.ResponseParcer, word: @word,  result: @result %>
      <% end %>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: nil, result: nil, loading: false, matches: [])}
  end

  def handle_event("suggest", %{"q" => query}, socket) when byte_size(query) <= 100 do
    {words, _} = System.cmd("grep", ~w"^#{query}.* -m 5 /usr/share/dict/words")
    {:noreply, assign(socket, matches: String.split(words, "\n"))}
  end

  def handle_event("search", %{"q" => query}, socket) when byte_size(query) <= 100 do
    send(self(), {:search, query})
    {:noreply, assign(socket, query: query, result: "Searching...", loading: true, matches: [], word: query)}
  end

  def handle_info({:search, query}, socket) do
    {:ok, %Tesla.Env{status: 200, body: body}} =
      Tesla.get("https://wordsapiv1.p.rapidapi.com/words/#{query}",
      headers: [
        {"X-RapidAPI-Host", "wordsapiv1.p.rapidapi.com"},
        {"X-RapidAPI-Key", "7427bbcde2msh72bc09ad549470bp18a98djsn56f17138a760"},
        {"useQueryString", true}
        ])
    result = Jason.decode!(body)
    {:noreply, assign(socket, loading: false, result: result, matches: [], word: query)}
  end
end


defmodule WDcrWeb.SearchLive.ResponseParcer do
  @moduledoc false
  use Phoenix.LiveComponent
  defmodule Description do
    use Phoenix.LiveComponent

    def mount(socket) do
      {:ok, socket}
    end

    def render(assigns) do
      ~L"""
        <div class="word-difinition__difinition">
          <div class="">
            Разъяснение
          </div>
          <div class="">
            <%= @desc["definition"] %>
          </div>

        </div>
      """
    end
  end
  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="word-container">
      <div class="word">
        <div class="word_self">Слово: <%= @word %></div>
        <div class="word_pronunciation">Произношение: <%= @result["pronunciation"]["all"] %></div>
      </div>
      <div class="word-difinitions">
        <%= for val <- @result["results"] do %>
          <%= live_component @socket, Description, desc: val %>
        <% end %>
      </div>

    </div>
    """
  end
end
