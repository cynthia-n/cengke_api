module V1::APIHelper
  extend ActiveSupport::Concern


  SKIP_AUTH_LIST = [
    "/api/v1/swagger_doc",
    "/api/v1/wechat/login",
    "/api/v1/wechat/auth_callback",
    "/api/v1/wechat/mini_program_login",
  ].freeze

  def need_auth?
    !(SKIP_AUTH_LIST.include?(request.path))
  end

end
