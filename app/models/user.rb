class User < ApplicationRecord
  has_many :user_connections

  has_many :user_cards
  has_many :cards, through: :user_cards

  validates :token, uniqueness: true, allow_blank: true
  validates :wechat_unionid, uniqueness: true, presence: true

  def login(ip = nil)
    self.token = SecureRandom.uuid.gsub("-", '')
    self.last_sign_in_at = Time.now
    self.last_sign_in_ip = ip if ip.present?
    self.save
  end

  def self.get_user_by_wechat_auth_code(code, platform)
    ret = Auth::Wechat.get_user_info_by_code(code, platform)
    raise '登录授权失败' if ret[:status] == false
    user = User.find_or_create_by(wechat_unionid: ret.dig(:data, "unionid"))
    user.nickname = ret.dig(:data, "nickname")
    user.avatar = ret.dig(:data, "headimgurl")
    connection = UserConnection.find_or_create_by(
      openid: ret.dig(:data, "openid"),
      unionid: ret.dig(:data, "unionid"),
      platform: platform
    )
    connection.user = user
    connection.access_token = ret.dig(:data, "access_token")
    connection.last_auth_at = Time.now
    connection.info = ret[:data].to_json
    connection.save!
    user.save!
    user
  end

  def self.login_mini_program(code, data, scene = nil, share_ticket= nil)
    ret = Auth::Wechat.login_mini_program(code)
    raise '登录授权失败' if ret[:status] == false
    sign = Auth::Wechat.mini_program_encrypt(data["rawData"] + ret.dig(:data, "session_key"))
    raise '登录信息校验失败' unless sign == data["signature"]
    info = Auth::Wechat.mini_program_decrypt(
      data["encryptedData"],
      ret.dig(:data, "session_key"),
      data["iv"]
    )
    raise '登录信息校验失败.' if ret[:status] == false
    user = User.find_or_create_by(wechat_unionid: info.dig(:data, "unionId"))
    user.nickname = info.dig(:data, "nickName")
    user.avatar = info.dig(:data, "avatarUrl")
    connection = UserConnection.find_or_create_by(
      openid: info.dig(:data, "openId"),
      unionid: info.dig(:data, "unionId"),
      platform: 'mini_program'
    )
    connection.user = user
    connection.access_token = ret.dig(:data, "session_key")
    connection.scene ||= scene
    connection.share_ticket ||= share_ticket
    connection.last_auth_at = Time.now
    connection.info = info.to_json
    connection.save!
    user.save!
    user
  end

end
