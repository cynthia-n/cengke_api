# frozen_string_literal: true
module Entities
  class Subject < ::Entities::Base
    expose :id, documentation: { type: Integer, desc: "ID" }
    expose :name, documentation: { type: String, desc: "名称" }
    expose :introduction, documentation: { type: String, desc: "简介" }
    expose :image_url, documentation: { type: String, desc: "图片地址" }
    expose :remark, documentation: { type: String, desc: "备注" }
    expose :status, documentation: { type: String, desc: "状态" }
    expose :display_size, documentation: { type: String, desc: "展示大小" }
    expose :detail, documentation: { type: String, desc: "详细内容" }
    expose :crowd_arr, documentation: { type: Array, desc: "人群标签" }
    expose :fee, documentation: { type: Float, desc: "现价" }
    expose :origin_fee, documentation: { type: Float, desc: "原价" }
    expose :count, documentation: { type: Integer, desc: "正在学人数" } do |data, _options|
      data.status == 'pending' ? 0 : data.learning_count
    end
    expose :users, documentation: { type: Integer, desc: "正在学人" } do |data, _options|
      data.status == 'pending' ? [] : [
        {avatar: "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKnF0VhzEIvZPiaTVls3qqaTmA0DO43EtggDItzibKonqZ16m5wnyV9RzalFlny81bFyRLcM1pQUiapA/132"},
        {avatar: "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKnF0VhzEIvZPiaTVls3qqaTmA0DO43EtggDItzibKonqZ16m5wnyV9RzalFlny81bFyRLcM1pQUiapA/132"},
        {avatar: "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKnF0VhzEIvZPiaTVls3qqaTmA0DO43EtggDItzibKonqZ16m5wnyV9RzalFlny81bFyRLcM1pQUiapA/132"},
        {avatar: "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKnF0VhzEIvZPiaTVls3qqaTmA0DO43EtggDItzibKonqZ16m5wnyV9RzalFlny81bFyRLcM1pQUiapA/132"}
      ]
    end
  end
end
