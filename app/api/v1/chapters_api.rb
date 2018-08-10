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
          Card.includes(:media, questions: [:options]).where(
            chapter_id: params[:id]
          ).order(id: :asc),
          params[:page], params[:per_page]
        )
        return_success(data, with: ::Entities::Card)
      end

    end
  end
end
