# frozen_string_literal: true

helpers do
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end
