Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  patch "preferences" => "preferences#update", as: :preferences

  scope "docs", as: :docs, controller: :docs do
    get "/"                                      => :introduction
    get "installation"                           => :installation
    get "themes"                                 => :themes
    get "persistence"                            => :persistence
    get "styles"                                 => :styles
    get "overriding"                             => :overriding
    get "components/sidebar/playground"          => :sidebar_playground, as: :sidebar_playground
    get "components/sidebar/playground/projects" => :sidebar_playground, as: :sidebar_playground_projects
    get "components/sidebar/playground/team"     => :sidebar_playground, as: :sidebar_playground_team
    get "components/:id"                         => :component,          as: :component
  end

  # Blocks
  get "blocks"      => "blocks#index",  as: :blocks
  get "blocks/:id"  => "blocks#show",   as: :block
  get "blocks/:id/preview" => "blocks#preview", as: :block_preview

  # Demos (lazy dialog + server-driven destroy)
  get "demos/lazy_dialog_content"         => "demos#lazy_dialog_content", as: :lazy_dialog_content
  get "demos/lazy_hover_card_content"     => "demos#lazy_hover_card_content", as: :lazy_hover_card_content
  get "demos/lazy_dropdown_items"         => "demos#lazy_dropdown_items",     as: :lazy_dropdown_items
  get "demos/lazy_dropdown_search"        => "demos#lazy_dropdown_search",    as: :lazy_dropdown_search
  get "demos/lazy_table_rows"             => "demos#lazy_table_rows",         as: :lazy_table_rows
  get "demos/more_orders"                 => "demos#more_orders",             as: :more_orders
  delete "demos/charts/:id"               => "demos#destroy_chart",       as: :destroy_demo_chart
end
