# frozen_string_literal: true
module Entities
  class Card < ::Entities::Base
    expose :id, documentation: { type: Integer, desc: "ID" }
    expose :title, documentation: { type: String, desc: "名称" } do |data, _options|
      data.is_locked? ? '' : data.title
    end
    expose :content, documentation: { type: String, desc: "内容" } do |data, _options|
      data.is_locked? ? '' : data.content
    end
    expose :is_locked, documentation: { type: 'boolean', desc: "是否被锁住" } do |data, _options|
      data.is_locked?
    end
    expose :share_count, documentation: { type: Integer, desc: "分享数量" } do |data, _options|
      data.is_locked? ? nil : data.share_count
    end
    expose :like_count, documentation: { type: Integer, desc: "点赞数量" }
    expose :media, documentation: { type: Array, using: "Entities::Medium", desc: "多媒体资源" }, using: "Entities::Medium" do |data, _options|
      data.is_locked? ? data.media.select{|c| c.category == 'image'} : data.media
    end
    expose :questions, documentation: { type: Array, using: "Entities::Question", desc: "问题" }, using: "Entities::Question" do |data, _options|
      data.is_locked? ? [] : data.questions
    end
  end
end
