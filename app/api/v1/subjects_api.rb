module V1
  class SubjectsApi < Grape::API
    resource :subjects, desc: "学科" do

      desc "学科列表", entity: ::Entities::Subject
      params do
        optional :page, type: Integer, desc: '页码', default: 1
        optional :per_page, type: Integer, desc: '分页数', default: 10
      end
      get "/" do
        data = paginate(
          Subject.all.order(id: :asc),
          params[:page], params[:per_page]
        )
        return_success(data, with: ::Entities::Subject)
      end

      desc "学科详情", entity: ::Entities::Subject
      params do
        requires :id, type: Integer, desc: 'id'
      end
      get "/:id" do
        data = Subject.where(id: params[:id]).first
        return_fail('不存在') if data.blank?
        return_success(data, with: ::Entities::Subject)
      end

      desc "学科章节详情", entity: ::Entities::Chapter
      params do
        requires :id, type: Integer, desc: 'id'
        optional :page, type: Integer, desc: '页码', default: 1
        optional :per_page, type: Integer, desc: '分页数', default: 10
      end
      get "/:id/chapters" do
        data = paginate(
          Chapter.where(subject_id: params[:id]).order(id: :asc),
          params[:page], params[:per_page]
        )
        return_success(data, with: ::Entities::Chapter)
      end

    end
  end
end
