# frozen_string_literal: true
module Entities
  class Option < ::Entities::Base
    expose :id, documentation: { type: Integer, desc: "ID" }
    expose :title, documentation: { type: String, desc: "名称" }
    expose :is_correct, documentation: { type: 'boolean', desc: "是否正确" }
  end
end
