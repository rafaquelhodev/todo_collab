defmodule TodoCollabWeb.TodoLive do
  use TodoCollabWeb, :live_view

  alias TodoCollab.Todos

  @impl true
  def mount(_params, _session, socket) do
    pid = self()

    Task.start(fn ->
      todos = Todos.list_todos()
      send(pid, %{loaded_todos: todos})
    end)

    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       pagination_page: 1,
       todos: [],
       total_added: 0,
       to_be_removed: []
     )}
  end

  @impl true
  def handle_info(%{loaded_todos: todos}, socket) do
    socket = assign(socket, todos: todos)

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, modal: false, slide_over: false)}

      :modal ->
        {:noreply, assign(socket, modal: params["size"])}

      :slide_over ->
        {:noreply, assign(socket, slide_over: params["origin"])}

      :pagination ->
        {:noreply, assign(socket, pagination_page: String.to_integer(params["page"]))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 gap-4 mb-6 md:grid-cols-2">
      <.form
        :let={f}
        multipart
        as={:todo_form}
        phx-submit="create_todo"
        for={
          %Ecto.Changeset{
            action: :update,
            data: %{name: ""},
            errors: [
              error_add_new_todo: {"can't be blank", [validation: :required]},
              error_add_new_todo: {"must be at least 2 characters", [validation: :minimum]},
              number_input_with_error: {"can't be blank", [validation: :required]},
              email_input_with_error: {"can't be blank", [validation: :required]},
              password_input_with_error: {"can't be blank", [validation: :required]},
              search_input_with_error: {"can't be blank", [validation: :required]},
              telephone_input_with_error: {"can't be blank", [validation: :required]},
              url_input_with_error: {"can't be blank", [validation: :required]},
              time_input_with_error: {"can't be blank", [validation: :required]},
              time_select_with_error: {"can't be blank", [validation: :required]},
              date_select_with_error: {"can't be blank", [validation: :required]},
              date_input_with_error: {"can't be blank", [validation: :required]},
              datetime_select_with_error: {"can't be blank", [validation: :required]},
              datetime_local_input_with_error: {"can't be blank", [validation: :required]},
              color_input_with_error: {"can't be blank", [validation: :required]},
              file_input_with_error: {"can't be blank", [validation: :required]},
              range_input_with_error: {"can't be blank", [validation: :required]},
              textarea_with_error: {"can't be blank", [validation: :required]},
              select_with_error: {"can't be blank", [validation: :required]},
              switch_with_error: {"can't be blank", [validation: :required]},
              checkbox_with_error: {"can't be blank", [validation: :required]},
              checkbox_group_col_with_error: {"can't be blank", [validation: :required]},
              checkbox_group_row_with_error: {"can't be blank", [validation: :required]},
              radio_with_error: {"can't be blank", [validation: :required]},
              radio_group_col_with_error: {"can't be blank", [validation: :required]},
              radio_group_row_with_error: {"can't be blank", [validation: :required]}
            ]
          }
        }
      >
        <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
          <div>
            <.form_field
              type="text_input"
              form={f}
              field={:add_new_todo}
              placeholder="Placeholder"
              phx-change="validate_new_todo"
            />
            <button class="btn btn-blue" type="submit" phx-disable-with="Adding...">
              Add new todo
            </button>
          </div>
        </div>

        <%= render_todos(assigns, f) %>
      </.form>
    </div>
    """
  end

  defp render_todos(assigns, form) do
    ~H"""
    <h1>My TODOs</h1>
    <div class="container">
      <%= for todo <- @todos do %>
        <div style="display: flex; align-items:baseline;">
          <.form_field
            id={todo.uuid}
            type="checkbox"
            form={form}
            field={:checkbox_form}
            label={todo.text}
            value={to_string(todo.done)}
            class="!line-through"
            phx-click="toggle_checkbox"
            phx-value-todo-id={todo.uuid}
          />

          <%= render_trash(assigns, todo) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp render_trash(assigns, todo) do
    ~H"""
    <div>
      <.icon_button
        size="md"
        link_type="button"
        type="button"
        color="info"
        phx-click="delete_todo"
        phx-value-todo-id={todo.uuid}
      >
        <Heroicons.trash solid />
      </.icon_button>
    </div>
    """
  end

  def handle_event(
        "create_todo",
        %{"todo_form" => %{"add_new_todo" => new_todo}},
        socket = %{assigns: %{todos: todos, total_added: total_added}}
      ) do
    socket =
      socket
      |> assign(
        todos: todos ++ [%{uuid: "added-#{total_added + 1}", text: new_todo, done: false}]
      )
      |> assign(total_added: total_added + 1)

    IO.inspect("CREATING TODO")
    {:noreply, socket}
  end

  def handle_event("validate_new_todo", params, socket) do
    IO.inspect(params, label: "VALIDATING NEW TODO")

    {:noreply, socket}
  end

  def handle_event("toggle_checkbox", %{"todo-id" => id}, socket = %{assigns: %{todos: todos}}) do
    IO.inspect(todos, label: "todos initial")

    todos =
      Enum.reduce(todos, [], fn todo, acc ->
        todo =
          cond do
            todo.uuid == id -> %{todo | done: !todo.done}
            true -> todo
          end

        acc ++ [todo]
      end)

    IO.inspect(todos, label: "todos final")

    socket = assign(socket, todos: todos)

    {:noreply, socket}
  end

  def handle_event("change_checkbox", params, socket) do
    IO.inspect(params, label: "CHANGING CHECKBOX")
    IO.inspect(socket.assigns, label: "CHANGING CHECKBOX")

    {:noreply, socket}
  end

  def handle_event(
        "delete_todo",
        %{"todo-id" => id},
        socket = %{assigns: %{todos: todos, to_be_removed: to_be_removed}}
      ) do
    todos =
      Enum.reduce(todos, [], fn todo, acc ->
        cond do
          todo.uuid == id -> acc
          true -> acc ++ [todo]
        end
      end)

    to_be_removed = update_to_be_removed(id, to_be_removed)

    socket = assign(socket, todos: todos, to_be_removed: to_be_removed)

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/live")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live")}
  end

  defp update_to_be_removed(id, to_be_removed) do
    case exists_in_db?(id) do
      true -> to_be_removed ++ [id]
      _ -> to_be_removed
    end
  end

  defp exists_in_db?("added-" <> _), do: false
  defp exists_in_db?(_), do: true
end
