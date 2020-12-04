defmodule WDcr.Plugs.IpPlug do
  alias Plug.Conn
  def init(deflt), do: deflt
  def call(%Conn{} = conn, _def), do: conn |> Conn.put_session(:remote_ip, fetch_ip(conn)) |> Conn.put_session(:user_name, fetch_username(conn))

  def fetch_username(conn) do
    case Map.get(conn.private[:plug_session], "user_id") do
      nil -> nil
      id when is_integer(id) -> WDcr.Accounts.get_username(id) |> map_to_name()
      _any -> nil
    end
  end

  def map_to_name(%{first_name: fname, last_name: lname}) do
    "#{fname} #{lname}"
    |> String.trim()
  end

  def map_to_name(_), do: "noname"

  def fetch_ip(conn) do
    conn.remote_ip
    |> Tuple.to_list
    |> Enum.reduce("", fn x, acc ->
      case acc do
        "" -> "#{x}"
        _  -> "#{acc}.#{x}"
      end
    end)
  end
end
