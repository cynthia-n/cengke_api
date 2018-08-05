# frozen_string_literal: true
require "grape-swagger"

class ApiRoot < Grape::API
  use ActionDispatch::Session::CookieStore
  include ApiRootBase
  helpers ApiHelperBase

  mount V1::Base
end
