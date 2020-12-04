defmodule WDcr.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias WDcr.Repo

  alias WDcr.Chat.Message

  @topic "chat_room"
  @user_topic "user"

  def subscribe(user_id: user_id), do: Phoenix.PubSub.subscribe(WDcr.PubSub, "#{@user_topic}: #{user_id}")
  def subscribe(room_id), do: Phoenix.PubSub.subscribe(WDcr.PubSub, "#{@topic}: #{room_id}")
  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages, do: Repo.all(Message)
  def list_messages(user_id: uid), do: Message |> where(id: ^uid) |> Repo.all()
  def list_messages(room_id: rid), do: Message |> where(room_id: ^rid) |> Repo.all()


  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(%{room_id: room_id} = attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> notify_subs([:message, :inserted], @topic, room_id)
  end

  def create_message(%{room_id: room_id} = attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> notify_subs([:message, :inserted], @topic, room_id)
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, %{room_id: room_id} = attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
    |> notify_subs([:message, :updated], @topic, room_id)
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message, room_id) do
    message
    |> Repo.delete()
    |> notify_subs([:message, :deleted], @topic, room_id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end


  defp notify_subs({:error, reason}, _event, entity_id), do: {:error, reason}

  defp notify_subs({:ok, result}, event, topic, entity_id) when is_list(entity_id) do
    entity_id
    |> Enum.map(fn id -> Phoenix.PubSub.broadcast(WDcr.PubSub, "#{topic}: #{id}", {__MODULE__, event, result}) end)

    {:ok, result}
  end

  defp notify_subs({:ok, result}, event, topic, entity_id) do
    Phoenix.PubSub.broadcast(WDcr.PubSub, "#{topic}: #{entity_id}", {__MODULE__, event, result})
    {:ok, result}
  end

  alias WDcr.Chat.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  def list_rooms(user_id: uid) do
    WDcr.Accounts.User
    |> Repo.get(uid)
    |> Repo.preload(:rooms)
    |> Map.get(:rooms)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)


  def get_prepared_room(id) do
      Repo.get(Room, id)
      |> case do
        nil   -> {"Комната не найдена", []}
        room  ->
          room = room |> Repo.preload(:users)
          {room |> Map.get(:name), room |> Map.get(:users)}
      end
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value}, user_id)
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}, user_id) do
    user_comm = Map.get(attrs, "user_sec") |> WDcr.Accounts.get_user!()
    creator = WDcr.Accounts.get_user!(user_id)

    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert!()
    |> Repo.preload(:users)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:users, [creator, user_comm])
    |> Repo.update()
    |> notify_subs([:chat, :inserted], @user_topic, [user_id, Map.get(attrs, "user_sec")])
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    users =
      room
      |> Repo.preload(:users)
      |> Enum.map(& Map.get(&1, :id))

    room
    |> Room.changeset(attrs)
    |> Repo.update()
    |> notify_subs([:chat, :updated], @user_topic, users)
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room, user_id) do
    users =
      room
      |> Repo.preload(:users)
      |> Enum.map(& Map.get(&1, :id))

    Repo.delete(room)
    |> notify_subs([:chat, :deleted], @user_topic, users)
  end

  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  alias WDcr.Chat.UserRoom

  @doc """
  Returns the list of user_rooms.

  ## Examples

      iex> list_user_rooms()
      [%UserRoom{}, ...]

  """
  def list_user_rooms do
    Repo.all(UserRoom)
  end

  @doc """
  Gets a single user_room.

  Raises `Ecto.NoResultsError` if the User room does not exist.

  ## Examples

      iex> get_user_room!(123)
      %UserRoom{}

      iex> get_user_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_room!(id), do: Repo.get!(UserRoom, id)

  @doc """
  Creates a user_room.

  ## Examples

      iex> create_user_room(%{field: value})
      {:ok, %UserRoom{}}

      iex> create_user_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_room(attrs \\ %{}) do
    %UserRoom{}
    |> UserRoom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_room.

  ## Examples

      iex> update_user_room(user_room, %{field: new_value})
      {:ok, %UserRoom{}}

      iex> update_user_room(user_room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_room(%UserRoom{} = user_room, attrs) do
    user_room
    |> UserRoom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_room.

  ## Examples

      iex> delete_user_room(user_room)
      {:ok, %UserRoom{}}

      iex> delete_user_room(user_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_room(%UserRoom{} = user_room) do
    Repo.delete(user_room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_room changes.

  ## Examples

      iex> change_user_room(user_room)
      %Ecto.Changeset{data: %UserRoom{}}

  """
  def change_user_room(%UserRoom{} = user_room, attrs \\ %{}) do
    UserRoom.changeset(user_room, attrs)
  end
end
