defmodule WDcr.ChatTest do
  use WDcr.DataCase

  alias WDcr.Chat

  describe "messages" do
    alias WDcr.Chat.Message

    @valid_attrs %{content: "some content", username: "some username"}
    @update_attrs %{content: "some updated content", username: "some updated username"}
    @invalid_attrs %{content: nil, username: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chat.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chat.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Chat.create_message(@valid_attrs)
      assert message.message == "some content"
      assert message.username == "some username"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = Chat.update_message(message, @update_attrs)
      assert message.message == "some updated content"
      assert message.username == "some updated username"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_message(message, @invalid_attrs)
      assert message == Chat.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chat.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chat.change_message(message)
    end
  end

  describe "rooms" do
    alias WDcr.Chat.Room

    @valid_attrs %{description: "some description", icon_link: "some icon_link", name: "some name"}
    @update_attrs %{description: "some updated description", icon_link: "some updated icon_link", name: "some updated name"}
    @invalid_attrs %{description: nil, icon_link: nil, name: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Chat.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Chat.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Chat.create_room(@valid_attrs)
      assert room.description == "some description"
      assert room.icon_link == "some icon_link"
      assert room.name == "some name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Chat.update_room(room, @update_attrs)
      assert room.description == "some updated description"
      assert room.icon_link == "some updated icon_link"
      assert room.name == "some updated name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_room(room, @invalid_attrs)
      assert room == Chat.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Chat.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Chat.change_room(room)
    end
  end

  describe "user_rooms" do
    alias WDcr.Chat.UserRoom

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_room_fixture(attrs \\ %{}) do
      {:ok, user_room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_user_room()

      user_room
    end

    test "list_user_rooms/0 returns all user_rooms" do
      user_room = user_room_fixture()
      assert Chat.list_user_rooms() == [user_room]
    end

    test "get_user_room!/1 returns the user_room with given id" do
      user_room = user_room_fixture()
      assert Chat.get_user_room!(user_room.id) == user_room
    end

    test "create_user_room/1 with valid data creates a user_room" do
      assert {:ok, %UserRoom{} = user_room} = Chat.create_user_room(@valid_attrs)
    end

    test "create_user_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_user_room(@invalid_attrs)
    end

    test "update_user_room/2 with valid data updates the user_room" do
      user_room = user_room_fixture()
      assert {:ok, %UserRoom{} = user_room} = Chat.update_user_room(user_room, @update_attrs)
    end

    test "update_user_room/2 with invalid data returns error changeset" do
      user_room = user_room_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_user_room(user_room, @invalid_attrs)
      assert user_room == Chat.get_user_room!(user_room.id)
    end

    test "delete_user_room/1 deletes the user_room" do
      user_room = user_room_fixture()
      assert {:ok, %UserRoom{}} = Chat.delete_user_room(user_room)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_user_room!(user_room.id) end
    end

    test "change_user_room/1 returns a user_room changeset" do
      user_room = user_room_fixture()
      assert %Ecto.Changeset{} = Chat.change_user_room(user_room)
    end
  end
end
