defmodule TodoCollabWeb.TodoLive do
  use TodoCollabWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       pagination_page: 1
     )}
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
        as={:user}
        for={
          %Ecto.Changeset{
            action: :update,
            data: %{name: ""},
            errors: [
              text_input_with_error: {"can't be blank", [validation: :required]},
              text_input_with_error: {"must be at least 2 characters", [validation: :minimum]},
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
        <div>
          <.form_field
            type="checkbox_group"
            label="Checkbox group with row layout"
            layout={:row}
            form={f}
            field={:checkbox_group_row}
            options={[
              {"Option 1", "option_1"},
              {"Option 2", "option_2"},
              {"Option 3", "option_3"},
              {"Option 4", "option_4"}
            ]}
          />
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: "/live")}
  end

  def handle_event("close_slide_over", _, socket) do
    {:noreply, push_patch(socket, to: "/live")}
  end
end
