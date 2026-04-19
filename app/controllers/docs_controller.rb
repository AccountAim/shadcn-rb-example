class DocsController < ApplicationController
  layout "docs"

  COMPONENTS = %w[
    alert avatar badge breadcrumb button button_group card checkbox codeblock collapsible data_grid dialog drawer dropdown_menu
    empty form_builder form_field hover_card icon input label layout link navigation_menu progress radio_group select separator
    sidebar skeleton switch table tabs textarea theme_switcher toast tooltip typography
  ].freeze

  def introduction
  end

  def installation
  end

  def styles
  end

  def themes
  end

  def persistence
  end

  def overriding
  end

  def component
    @component = params[:id]
    unless COMPONENTS.include?(@component)
      raise ActionController::RoutingError, "Unknown component: #{@component}"
    end
    render "docs/components/#{@component}"
  end

  def sidebar_playground
    render "docs/sidebar_playground", layout: "playground"
  end
end
