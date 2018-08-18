module V1
  class CardsApi < Grape::API
    resource :cards, desc: "卡片" do

      desc "课程卡详情", entity: ::Entities::Card
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/:id" do
        data = Card.list_with_user(current_user.id).where(id: params[:id]).first
        return return_fail('不存在') if data.blank?
        return_success(data, with: ::Entities::Card)
      end

      desc "课程卡开始学习"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      post "/:id/learning" do
        card = Card.where(id: params[:id]).first
        return return_fail('不存在') if card.blank?
        return return_fail('该卡未解锁') if card.is_locked?(current_user.id)
        user_card = UserCard.find_or_create_by(user_id: current_user.id, card_id: card.id)
        user_card.status = 'learning'
        if user_card.save
          return_fail('开始学习失败')
        else
          return_success(true)
        end
      end

      desc "课程卡学完"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      post "/:id/finished" do
        card = Card.where(id: params[:id]).first
        return return_fail('不存在') if card.blank?
        user_card = UserCard.where(user_id: current_user.id, card_id: card.id).first
        return return_fail('该卡未开始学习') if user_card.blank?
        user_card.status = 'finished'
        if user_card.save
          return_fail('结束学习失败')
        else
          return_success(true)
        end
      end

      desc "课程卡点赞"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      post "/:id/liked" do
        card = Card.where(id: params[:id]).first
        return return_fail('不存在') if card.blank?
        like = Like.find_or_create_by(user: current_user, source: card)
        if like.id.present?
          return_success(true)
        else
          return_fail('点赞失败')
        end
      end

      desc "课程卡取消点赞"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      post "/:id/unliked" do
        card = Card.where(id: params[:id]).first
        return return_fail('不存在') if card.blank?
        Like.where(user: current_user, source: card).delete_all
        return_success(true)
      end

      desc "课程卡分享"
      params do
        requires :id, type: Integer, desc: 'id'
      end
      post "/:id/share" do
        card = Card.where(id: params[:id]).first
        return return_fail('不存在') if card.blank?
        share = Share.find_or_create_by(user: current_user, source: card)
        if share.id.present?
          return_success({share_id: share.id})
        else
          return_fail('分享失败')
        end
      end

      desc "课程卡分享详情", entity: ::Entities::Card
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/share/:id" do
        share = Share.where(id: params[:id], source_type: "Card").first
        return return_fail('该分享不存在') if share.blank?
        data = Card.list_with_user(current_user.id).where(id: share.source_id).first
        return return_fail('该卡片不存在') if data.blank?
        return_success(data, with: ::Entities::Card)
      end

      desc "课程卡分享首页详情", entity: ::Entities::Card
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/share/:id/general" do
        share = Share.where(id: params[:id], source_type: "Card").first
        return return_fail('该分享不存在') if share.blank?
        data = Card.list_with_user(current_user.id).where(id: share.source_id).first
        return return_fail('该卡片不存在') if data.blank?
        user = share.user
        return_success({
          user: {
            nickname: user.nickname,
            avatar: user.avatar
          },
          card: {
            title: data&.title
          },
          subject: {
            title: data&.chapter&.subject&.name
          },
          max_share_count: 20
        })
      end

      desc "蹭课程卡"
      params do
        requires :share_id, type: Integer, desc: '分享id'
      end
      post "cengke" do
        share = Share.where(id: params[:share_id], source_type: "Card").first
        return return_fail('该分享不存在') if share.blank?
        cengke = Cengke.find_or_initialize_by(
          user: current_user,
          source_user_id: share.user_id,
          card: card
        )
        if cengke.id.present? || cengke.save
          return_success({
            max_share_count: 20,
            current_share_count: Cengke.where(source_user_id: share.user_id,card: card).count
          })
        else
          return_fail("蹭课失败", format_vali_error_data(cengke))
        end
      end

    end
  end
end
