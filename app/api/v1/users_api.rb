module V1
  class UsersApi < Grape::API
    resource :users, desc: "用户" do

      desc "test"
      params do
      end
      get "/" do
        return_success({a: 1})
      end


    end
  end
end
