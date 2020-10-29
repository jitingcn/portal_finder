# frozen_string_literal: true

json.extract! portal, :id, :created_at, :updated_at
json.url portal_url(portal, format: :json)
