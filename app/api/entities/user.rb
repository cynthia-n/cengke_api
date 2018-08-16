# frozen_string_literal: true
module Entities
  class User < ::Entities::Base
    expose :id, documentation: { type: Integer, desc: "ID" }
    expose :nickname, documentation: { type: String, desc: "昵称" }
    expose :avatar, documentation: { type: String, desc: "头像" }
  end
end
