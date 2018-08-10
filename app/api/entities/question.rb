# frozen_string_literal: true
module Entities
  class Question < ::Entities::Base
    expose :id, documentation: { type: Integer, desc: "ID" }
    expose :title, documentation: { type: String, desc: "名称" }
    expose :category, documentation: { type: String, desc: "类型" }
    expose :options, documentation: { type: Array, using: "Entities::Option", desc: "选项" }, using: "Entities::Option", as: :options
  end
end
