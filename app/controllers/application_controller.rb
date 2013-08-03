class ApplicationController < ActionController::Base
  before_filter :set_locale

  helper 'spree/products'
  protect_from_forgery

  def set_locale
	logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
	I18n.locale = extract_locale_from_accept_language_header
	logger.debug "* Locale set to '#{I18n.locale}'"
  end

  def default_url_options(options={})
	logger.debug "default_url_options is passed options: #{options.inspect}\n"
	{ locale: I18n.locale }
  end

  private
   def extract_locale_from_accept_language_header
	http_accept_language.user_preferred_languages
    available = %w{en en-US es}
    http_accept_language.compatible_language_from(available)
   end
end