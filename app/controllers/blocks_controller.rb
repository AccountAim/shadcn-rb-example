class BlocksController < ApplicationController
  layout "marketing"

  BLOCKS = [
    {id: "app_shell", name: "App Shell",
     description: "Settings-style app shell with sidebar, header, cards, and forms. Built entirely from layout primitives and existing components."},
    {id: "nav_and_sidebar", name: "Nav + Sidebar",
     description: "Full-width top navigation over an icon-collapsible sidebar + inset. Top bar carries product/account links; sidebar owns primary app navigation."}
  ].freeze

  def index
    @blocks = BLOCKS
  end

  def show
    @block = find_block
    render "blocks/#{@block[:id]}"
  end

  # The block alone, as a page for the preview iframe.
  def preview
    @block = find_block
    render "blocks/preview", layout: "playground"
  end

  private

  def find_block
    BLOCKS.find { |b| b[:id] == params[:id] } or
      raise ActionController::RoutingError, "Unknown block: #{params[:id]}"
  end
end
