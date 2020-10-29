# frozen_string_literal: true

# RailsSettings Model
class Setting < RailsSettings::Base
  EDITABLE_KEYS = %w[
    admin_emails
  ].freeze

  # Define your fields
  field :app_name, default: (ENV["app_name"] || "Portal Finder"), readonly: true
  # field :default_locale, default: "en", type: :string
  # field :confirmable_enable, default: "0", type: :boolean
  field :admin_emails, default: ENV["admin_emails"], type: :array
  # field :omniauth_google_client_id, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_ID"] || ""), type: :string, readonly: true
  # field :omniauth_google_client_secret, default: (ENV["OMNIAUTH_GOOGLE_CLIENT_SECRET"] || ""), type: :string, readonly: true\
  field :https, type: :boolean, default: (ENV["https"] || "true"), readonly: true

  class << self
    def editable_keys
      EDITABLE_KEYS
    end

    def protocol
      https? ? "https" : "http"
    end
  end
end
