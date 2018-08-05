module ApiRootBase
  extend ActiveSupport::Concern

  module ApiErrors
    AuthenticateFail  = Class.new StandardError
    NotLoggedIn  = Class.new StandardError
  end

  included do
    rescue_from :all do |e|
      err_msg = "\n"
      err_msg += "  "+e.class.name
      err_msg += "\n"
      err_msg += "  "+e.message
      err_msg += "\n"

      error_type, error_name = case e.class.name.demodulize
      when 'NotLoggedIn'
        ['NotLoggedIn','NotLoggedIn']
      when 'ValidationErrors'
        ['ValidationError','ValidationError']
      when 'AuthenticateFail'
        ['AuthenticateFail','AuthenticateFail']
      else
        err_msg += "  "+e.backtrace[0]
        err_msg += "\n\n"
        err_msg += "  "+e.backtrace[1..-1].join("\n  ")
        ['internal error','Exception']
      end

      logger = Rails.logger
      logger.error err_msg
      puts err_msg if Rails.env == 'test'

      if Settings.running_env == 'online'
        err_msg += "\n\n"
        err_msg += "-------------------------------\n"
        err_msg += "Request:\n"
        err_msg += "-------------------------------\n"
        err_msg += "\n"

        keys = [
          'HTTP_HOST',
          'REQUEST_METHOD',
          'REQUEST_PATH',
          'HTTP_USER_AGENT',
          'HTTP_ACCEPT_LANGUAGE',
          'rack.request.query_string',
          'rack.request.query_hash',
          'HTTP_COOKIE',
        ]
        err_msg += env.slice(*keys).map{|k,v| "#{k}:  #{v}"}.join("\n")

        Rails.logger.silence do
          ActionMailer::Base.mail(
            from: Settings.system_mail.from,
            to: Settings.exception_receiver_email,
            subject: "[#{error_name}][#{Settings.server_app}]#{e.message}",
            body: err_msg
          ).deliver_later
        end
      end

      ret = {status: false, error: error_type}
      ret[:test_error_msg] = err_msg unless Settings.running_env == 'online'
      ret[:login] = true if error_type == 'NotLoggedIn'
      error_response(status: 200, message: ret)
    end

    cascade false
    format          :json
    content_type    :json, 'application/json;charset=UTF-8'
    default_format  :json

  end
end
