module V1::APIHelper
  extend ActiveSupport::Concern


  SKIP_AUTH_LIST = [
    "/api/v1/swagger_doc"
  ].freeze

  def need_auth?
    !(SKIP_AUTH_LIST.include?(request.path))
  end

end
