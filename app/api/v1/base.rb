# frozen_string_literal: true

module V1
  class Base < Grape::API
    helpers V1::APIHelper

    prefix    "api"
    version   'v1', using: :path

    before do
      if need_auth? && current_user.nil?
        raise ApiRootBase::ApiErrors::NotLoggedIn
      end
      status 200
    end

    Dir.new(File.dirname(__FILE__)).each do |filename|
      next if %w(base.rb api_helper.rb . ..).include?(filename)
      next unless filename.end_with?('.rb')
      mount "V1::#{filename[0..-4].camelize}".constantize
    end

    unless Settings.running_env == 'online'
      add_swagger_documentation({
        api_version: "api/v1",
        hide_documentation_path: true,
        hide_format: false,
        info: {
          title: "接口文档",
          description: "v1.0"
        }
      })
    end

  end
end
