class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :set_public_cache_headers
  before_action :apply_shadcnrb_style

  helper_method :shadcnrb_style_options, :preferences

  # Named styles shown in the picker. `default` is the built-in look and
  # maps to `Shadcnrb::Style.reset`; anything else resolves dynamically to
  # `Shadcnrb::Styles::<Name>`.
  SHADCNRB_STYLE_OPTIONS = [
    { key: "default",      label: "Default shadcn" },
    { key: "neobrutalism", label: "Neobrutalism" }
  ].freeze

  def shadcnrb_style_options = SHADCNRB_STYLE_OPTIONS

  def preferences = session[:preferences] || {}

  private

  def set_public_cache_headers
    return unless Rails.env.production?
    return unless request.get? || request.head?

    request.session_options[:skip] = true
    expires_in 1.hour, public: true, "stale-while-revalidate": 86400
  end

  def apply_shadcnrb_style
    Shadcnrb::Style.apply(cookies[StyleSwitcherHelper::COOKIE_KEY])
  end
end
