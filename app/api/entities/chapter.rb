# frozen_string_literal: true
module Entities
  class Chapter < ::Entities::Base
    expose :id, documentation: { type: Integer, desc: "ID" }
    expose :title, documentation: { type: String, desc: "名称" }
    expose :fee, documentation: { type: Float, desc: "现价" }
    expose :origin_fee, documentation: { type: Float, desc: "原价" }
  end
end
