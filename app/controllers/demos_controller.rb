class DemosController < ApplicationController
  layout false

  def lazy_dialog_content
    sleep 1 # simulate server work
    render partial: "demos/lazy_dialog_content"
  end

  def lazy_hover_card_content
    sleep 2.5 # simulate server work, long enough to see the loading skeleton
    render partial: "demos/lazy_hover_card_content"
  end

  def lazy_dropdown_items
    sleep 1 # simulate server work
    render partial: "demos/lazy_dropdown_items"
  end

  def lazy_dropdown_search
    render partial: "demos/lazy_dropdown_search"
  end

  def lazy_table_rows
    sleep 1 # simulate server work
    render partial: "demos/lazy_table_rows"
  end

  # Demo for server-driven confirmation dialogs.
  # First request: server detects risky condition, responds with a Turbo Stream that
  # appends a confirmation dialog to the overlay outlet.
  # Second request (with `confirm=true`): server does the action, responds with toast
  # and removes any leftover confirmation dialog.
  def destroy_chart
    confirmed = ActiveModel::Type::Boolean.new.cast(params[:confirm])

    if !confirmed && risky_chart?(params[:id])
      render turbo_stream: turbo_stream.append(
        Shadcnrb::BaseBuilder::OVERLAY_OUTLET_ID,
        partial: "demos/destroy_chart_confirmation",
        locals: { chart_id: params[:id], user_count: 12 }
      )
    else
      # Destructive red toast after a confirmed (risky) delete; default toast for a
      # safe delete — so both paths always notify.
      variant = confirmed ? :destructive : :default
      render turbo_stream: [
        turbo_stream.remove("destroy-chart-confirm-#{params[:id]}"),
        turbo_stream.append(
          Shadcnrb::Toast::CONTAINER_ID,
          partial: "demos/chart_deleted_toast",
          locals: { chart_id: params[:id], variant: variant, confirmed: confirmed }
        )
      ]
    end
  end

  private

  # In real code you'd query the chart. Here we say odd IDs are risky, even IDs are safe.
  def risky_chart?(id)
    id.to_i.odd?
  end
end
