module V1
  class CardsApi < Grape::API
    resource :cards, desc: "卡片" do

      desc "课程卡详情", entity: ::Entities::Card
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/:id" do
        data = Card.list_with_user(current_user.id).where(id: params[:id]).first
        return_fail('不存在') if data.blank?
        return_success(data, with: ::Entities::Card)
      end

    end
  end
end
