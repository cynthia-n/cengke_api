module V1
  class ChaptersApi < Grape::API
    resource :chapters, desc: "章节" do

      desc "章节课程卡详情", entity: ::Entities::Card
      params do
        requires :id, type: Integer, desc: 'id'
        optional :page, type: Integer, desc: '页码', default: 1
        optional :per_page, type: Integer, desc: '分页数', default: 10
      end
      get "/:id/cards" do
        data = paginate(
          Card.list_with_user(current_user.id).includes(:shares, :likes, :media, questions: [:options]).where(
            chapter_id: params[:id]
          ).order(id: :asc),
          params[:page], params[:per_page]
        )
        return_success(data, with: ::Entities::Card)
      end

      desc "章节分享"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      post "/:id/share" do
        chapert = Chapert.where(id: params[:id]).first
        return return_fail('不存在') if chapert.blank?
        share = Share.find_or_create_by(user: current_user, source: chapert)
        if share.id.present?
          return_success(true)
        else
          return_fail('分享失败')
        end
      end

      desc "章节蹭课情况", with: ::Entities::User
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/:id/current_cengke_info" do
        data = Cengke.includes(:card, :user).where(source_user_id: current_user.id, cards: {chapter_id: params[:id]}, is_new_friend: true).map(&:user)
        return_success(data, with: ::Entities::User)
      end

      desc "章节学习情况"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/:id/learning_situation" do
        return_success({beyond: 60 + (rand(398)/10.0)})
      end


      desc "章节奖励情况"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/:id/reward" do
        data = Reward.where(user_id: current_user.id, chapter_id: params[:id])
        return_success(data&.map{|c|{
          id: c.id,
          category: c.category,
          status: c.status
        }} || [])
      end

      desc "章节领取奖励"
      params do
        requires :reward_id, type: Integer, desc: 'id'
      end
      post "reward_receive" do
        data = Reward.where(user_id: current_user.id, id: params[:reward_id]).first
        return return_fail('不存在') if data.blank?
        if data.receive
          return_success(true)
        else
          return_fail('领取失败')
        end
      end

    end
  end
end
