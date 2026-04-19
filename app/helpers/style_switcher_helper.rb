# Dropdown UI to pick a shadcn-rb *style* (the structural look). Each option
# writes the cookie from the `style-switcher` Stimulus controller and reloads;
# `ApplicationController#apply_shadcnrb_style` picks it up on the next request
# and calls the matching `Shadcnrb::Styles::<Name>.apply!`.
module StyleSwitcherHelper
  COOKIE_KEY = "shadcnrb_style"

  def style_switcher(styles:, **opts)
    active  = (cookies[COOKIE_KEY] || "default").to_s
    current = styles.find { |s| s[:key] == active } || styles.first

    opts[:data] = (opts[:data] || {}).merge(
      controller: "style-switcher",
      style_switcher_cookie_value: COOKIE_KEY
    )

    sui.dropdown_menu(**opts) do |m|
      safe_join([
        m.trigger { sui.button "Style: #{current[:label]}", variant: :outline },
        *styles.map { |s| style_switcher_item(m, s, active) }
      ])
    end
  end

  private

  def style_switcher_item(m, style, active)
    selected = style[:key] == active

    m.item do
      tag.button(type: "button", class: "flex w-full items-center text-left",
        data: { action: "click->style-switcher#apply", style_switcher_key_param: style[:key] }) do
        safe_join([
          tag.span(style[:label], class: "flex-1"),
          selected ? tag.span("✓", class: "ml-2 text-xs opacity-70") : "".html_safe
        ])
      end
    end
  end
end
