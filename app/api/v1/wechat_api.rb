module V1
  class WechatApi < Grape::API
    resource :wechat, desc: "微信" do

      desc "跳转登陆"
      params do
        requires :client_type, type: String, values: [
          'official_account',
          'web_redirect',
          'web_iframe'
        ], default: 'official_account', desc: '终端类型'
        requires :success_url, type: String, desc: '成功重定向url'
        requires :fail_url, type: String, desc: '失败重定向url'
      end
      get "/login" do
        url = Auth::Wechat.build_auth_url( params[:client_type], {
          success_url: params[:success_url] || "",
          fail_url: params[:fail_url] || "",
          remote_ip: remote_ip
        })
        case params[:client_type]
        when 'web_iframe'
          return_success({url: url})
        else
          redirect url
        end
      end

      desc "微信授权回调"
      params do
      end
      get "/auth_callback" do
        begin
          origin_data = Auth::Wechat.get_state_info(params[:state])
          raise '授权超时' if origin_data.nil?
          raise '用户禁止授权' if params[:code].blank?
          user = User.get_user_by_wechat_auth_code(params[:code], origin_data[:platform])
          raise '登陆失败' unless user.login(origin_data[:remote_ip])
          uri =  URI.parse(URI.decode(origin_data[:success_url]))
          uri.query = [uri.query.blank? ? nil : uri.query, "token=#{user.token}"].compact.join('&')
          redirect uri.to_s
        rescue Exception => e
          Rails.logger.info e.to_json
          redirect URI.decode(origin_data[:fail_url])
        end
      end

      desc "微信小程序登录"
      params do
        requires :code, type: String, desc: 'wechat code'
      end
      post "/mini_program_login_session" do
        ret = Auth::Wechat.login_mini_program(params[:code])
        return return_fail('登录授权失败') if ret[:status] == false
        session = Redis::Value.new("mini_program_login_session_#{params[:code]}", expiration: 10.minutes, marshal: true)
        session.value = ret
        return_success(true)
      end

      desc "微信小程序登录"
      params do
        requires :code, type: String, desc: 'wechat code'
        requires :scene, type: String, desc: 'scene'
        optional :share_ticket, type: String, desc: 'share_ticket'
        requires :data, type: Hash do
          requires :userInfo, type: Hash, desc: '用户详情' do
            requires :nickName, type: String, desc: '昵称'
            requires :avatarUrl, type: String, desc: '头像'
            requires :gender, type: String, desc: '性别'
            requires :city, type: String, desc: '城市'
            requires :province, type: String, desc: '省份'
            requires :country, type: String, desc: '国家'
            requires :language, type: String, desc: '语言'
          end
          requires :rawData, type: String, desc: '原始数据字符串'
          requires :signature, type: String, desc: '签名'
          requires :encryptedData, type: String, desc: '加密数据'
          requires :iv, type: String, desc: '加密算法的初始向量'
        end
      end
      post "/mini_program_login" do
        begin
          user = User.login_mini_program(params[:code], params[:data], params[:scene], params[:share_ticket])
          raise '登陆失败' unless user.login(remote_ip)
          return_success({token: user.token})
        rescue Exception => e
          Rails.logger.info e.to_json
          return_fail(e.message)
        end
      end

    end
  end
end
