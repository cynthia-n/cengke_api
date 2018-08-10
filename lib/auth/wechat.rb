module Auth
  module Wechat

    AUTHORIZE_URL = "https://open.weixin.qq.com/connect/oauth2/authorize".freeze
    WEB_AUTHORIZE_URL = "https://open.weixin.qq.com/connect/qrconnect".freeze
    ACCESS_TOKEN_URL = "https://api.weixin.qq.com/sns/oauth2/access_token".freeze
    USER_INFO_URL = "https://api.weixin.qq.com/sns/userinfo".freeze
    LOGIN_MINI_PROGRAM= "https://api.weixin.qq.com/sns/jscode2session"

    REDIRECT_URI = "/api/v1/wechat/auth_callback".freeze

    def self.build_auth_url(type = 'official_account', data = {})
      case type
      when 'official_account'
        option = {
          appid: Settings.third_party.wechat.official_account.appid,
          redirect_uri: (Settings.host || '') + REDIRECT_URI,
          response_type: "code",
          scope: 'snsapi_userinfo',
          state: generate_state(data.merge!(platform: 'official_account'))
        }
        AUTHORIZE_URL + "?" + option.map{|k,v| "#{k}=#{CGI::escape(v)}"}.join("&") + "#wechat_redirect"
      when 'web_redirect'
        option = {
          appid: Settings.third_party.wechat.open_platform.appid,
          redirect_uri: (Settings.host || '') + REDIRECT_URI,
          response_type: "code",
          scope: 'snsapi_login',
          state: generate_state(data.merge!(platform: 'web_redirect'))
        }
        WEB_AUTHORIZE_URL + "?" + option.map{|k,v| "#{k}=#{CGI::escape(v)}"}.join("&") + "#wechat_redirect"
      when 'web_iframe'
        option = {
          appid: Settings.third_party.wechat.open_platform.appid,
          redirect_uri: (Settings.host || '') + REDIRECT_URI,
          response_type: "code",
          scope: 'snsapi_login',
          state: generate_state(data.merge!(platform: 'web_iframe')),
          login_type: 'jssdk',
          self_redirect: "default",
          style: "black"
        }
        WEB_AUTHORIZE_URL + "?" + option.map{|k,v| "#{k}=#{CGI::escape(v)}"}.join("&")
      else
        ''
      end
    end

    def self.generate_state(data)
      ret = Digest::MD5.hexdigest(data.to_json)
      state = Redis::Value.new("wechat_auth_#{ret}", expiration: 30.minutes, marshal: true)
      state.value = data
      ret
    end

    def self.get_state_info(key)
      ret = Redis::Value.new("wechat_auth_#{key}", expiration: 30.minutes, marshal: true)
      info = ret.value
      ret.delete
      info
    end

    def self.get_access_token(code, platform = 'official_account')
      case platform
      when 'official_account'
        option = {
          appid: Settings.third_party.wechat.official_account.appid,
          secret: Settings.third_party.wechat.official_account.secret,
          code: code,
          grant_type: 'authorization_code'
        }
      # when 'mini_program'
      #   option = {
      #     appid: Settings.third_party.wechat.mini_program.appid,
      #     secret: Settings.third_party.wechat.mini_program.secret,
      #     code: code,
      #     grant_type: 'authorization_code'
      #   }
      else
        option = {
          appid: Settings.third_party.wechat.open_platform.appid,
          secret: Settings.third_party.wechat.open_platform.secret,
          code: code,
          grant_type: 'authorization_code'
        }
      end
      url = ACCESS_TOKEN_URL + "?" + option.map{|k,v| "#{k}=#{v}"}.join("&")
      ret = JSON.parse(Typhoeus.get(url).body)
      if ret["errcode"].present?
        {status: false, code: ret["errcode"], msg: ret["errmsg"]}
      else
        {status: true, data: ret}
      end
      # {"access_token"=>"D0VoVPcsHoDcrg2DobAQYe2cexQvA7l5RyOhn282Q", "expires_in"=>7200, "refresh_token"=>"Z5J8YqsgxWune7UZtJ_EOHXx3QOts1fF7Kn5VAk", "openid"=>"ovNbHwhPmuyHzmF7tVreA", "scope"=>"snsapi_userinfo"}
    end

    def self.login_mini_program(code)
      option = {
        appid: Settings.third_party.wechat.mini_program.appid,
        secret: Settings.third_party.wechat.mini_program.secret,
        js_code: code,
        grant_type: 'authorization_code'
      }
      url = LOGIN_MINI_PROGRAM + "?" + option.map{|k,v| "#{k}=#{v}"}.join("&")
      ret = JSON.parse(Typhoeus.get(url).body)
      if ret["errcode"].present?
        {status: false, code: ret["errcode"], msg: ret["errmsg"]}
      else
        {status: true, data: ret}
      end
    end

    def self.mini_program_encrypt(content)
      Digest::SHA1.hexdigest(content)
    end

    def self.mini_program_decrypt(encrypted_data, session_key, iv)
      session_key = Base64.decode64(session_key)
      encrypted_data= Base64.decode64(encrypted_data)
      iv = Base64.decode64(iv)
      cipher = OpenSSL::Cipher::AES128.new(:CBC)
      cipher.decrypt
      cipher.key = session_key
      cipher.iv = iv
      decrypted = JSON.parse(cipher.update(encrypted_data) + cipher.final)
      if decrypted['watermark']['appid'] != Settings.third_party.wechat.mini_program.appid
        {status: false}
      else
        {status: true, data: decrypted}
      end
    end

    def self.get_user_info(access_token, openid)
      option = {
        access_token: access_token,
        openid: openid,
        lang: 'zh_CN'
      }
      url = USER_INFO_URL + "?" + option.map{|k,v| "#{k}=#{v}"}.join("&")
      ret = JSON.parse(Typhoeus.get(url).body)
      if ret["errcode"].present?
        {status: false, code: ret["errcode"], msg: ret["errmsg"]}
      else
        {status: true, data: ret}
      end
      # sex 2: female, 1: male
      # {"openid"=>"ovNbHwhPmuyHzmF7tVreAvXwfVjA", "nickname"=>"123123", "sex"=>2, "language"=>"en", "city"=>"123", "province"=>"123", "country"=>"中国", "headimgurl"=>"http://wx.qlogo.cn/mmopen/123213", "privilege"=>[]}
    end

    def self.get_user_info_by_code(code, platform)
      ret = get_access_token(code, platform)
      return ret if ret[:status] == false
      res = get_user_info(ret[:data]['access_token'], ret[:data]['openid'])
      return res if res[:status] == false
      {status: true, data: ret[:data].merge!(res[:data])}
    end

  end
end
