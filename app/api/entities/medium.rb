# frozen_string_literal: true
module Entities
  class Medium < ::Entities::Base
    expose :id, documentation: { type: Integer, desc: "ID" }
    expose :category, documentation: { type: String, desc: "类型" }
    expose :url, documentation: { type: String, desc: "链接" }
    expose :ratio54_url, documentation: { type: String, desc: "链接比例5比4" }
    expose :duration, documentation: { type: String, desc: "时长" }
  end
end
