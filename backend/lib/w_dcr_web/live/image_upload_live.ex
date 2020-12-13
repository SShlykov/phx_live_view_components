defmodule WDcrWeb.ImageUploadLive do
  use WDcrWeb, :live_view
  import ShorterMaps

  @impl true
  def mount(_session, ~m{remote_ip, user_name}, socket) do
    socket =
      socket
      |> assign(user_ip: remote_ip, location: nil, user_name: user_name, detection: nil, base64_image: nil)
      |> allow_upload(:images, accept: ~w(.jpg .jpeg .png), auto_upload: true, max_entries: 10, max_file_size: 20 * 1024 * 1024)

    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("update", assigns, socket) do
    {:noreply, assign(socket, assigns, detection: nil, base64_image: nil)}
  end

  @impl true
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :images, ref)}
  end

  @impl true
  def handle_event("generate_yolo", _assigns, socket) do
    data =
      consume_uploaded_entries(socket, :images, fn %{path: path}, upload ->
        file = File.read!(path)
        detection =
          Yolo.Worker.request_detection(Yolo.Worker, file)
          |> Yolo.Worker.await()

        base64_image = base64_inline_image(file, upload.client_type)
        %{detection: detection, base64_image: base64_image, file: file}
      end)
      |> List.first()

    {:noreply, assign(socket, detection: data.detection, base64_image: data.base64_image)}
  end

  defp base64_inline_image(data, content_type) do
    image64 = Base.encode64(data)
    "data:#{content_type};base64,#{image64}"
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div style="display: flex;">
      <%= live_component @socket, WDcrWeb.Menu,
            id: :main_menu,
            user_ip: @user_ip,
            location: @location,
            user_name: @user_name %>

    </div>

    <div class="main-centred">
      <div>
        <div class="main">
          <h1>Этот модуль работает только с python окрижением, которое отсутствует в docker образе из-за чрезвычайно долгой загрузки</h1>
          <div class="container" phx-drop-target="<%= @uploads.images.ref %>">

            <form phx-change="update" phx-submit="generate_yolo" on-click="(e) => e.prventDefault()">
              <div class="while-submitting">Please wait while we save our content...</div>
              <div class="inputs">
                <%= live_file_input @uploads.images, class: "is-hidden" %>
                <input type="submit" name="save" value="submit"/>
              </div>
            </form>

            <%= if !is_nil(@detection) do %>
              <div style="padding: 50px 0; background-color: black">
                <svg width="<%= @detection.shape.width %>"
                        height="<%= @detection.shape.height + 20 %>" style="margin-top: 30px">
                    <g fill="grey" transform="scale(0.8 0.8)">
                    <image
                      width="<%= @detection.shape.width %>"
                      height="<%= @detection.shape.height %>"
                      xlink:href="<%= @base64_image %>"
                      alt="hello">
                    </image>

                      <%= for o <- @detection.objects do %>

                        <rect x="<%= o.x - 2%>" y="<%= o.y - 20%>" height="20" width="100" fill="blue"/>
                        <text x="<%= o.x %>" y="<%= o.y %>" dy="-5" font-family="sans-serif" font-size="16px" font-weight="bold" fill="white"><%= o.label %></text>

                        <rect x="<%= o.x %>" y="<%= o.y %>" width="<%= o.w %>" height="<%= o.h %>" style="fill:rgb(0,0,0,0);stroke-width:3;stroke:rgb(0,0,255)" />

                      <% end %>
                    </g>
                  </svg>
                </div>
            <% end %>
            <%= if is_nil(@detection) do %>
              <div class="secret">
                <%= for entry <- @uploads.images.entries do %>
                  <div class="uploading">
                    <div class="column"><%= live_img_preview(entry, height: 350) %></div>
                    <div class="column"> <progress max="100" value="<%= entry.progress %>" /> </div>
                    <div class="column">
                      <a href="#" phx-click="cancel-entry" phx-value-ref="<%= entry.ref %>">cancel</a>
                    </div>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
