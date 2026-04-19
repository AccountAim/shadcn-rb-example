class PreferencesController < ApplicationController
  # The demo keeps preferences in the session; an app would write them to
  # `current_user`. `state` is the sidebar's, `theme` / `mode` the switcher's.
  def update
    session[:preferences] = preferences.merge(params.permit(:theme, :mode, :state).to_h)
    head :no_content
  end
end
