class API < Grape::API
  format :json
  get "user/:user_id" do
    user = User.where(id: params[:user_id]).first

    if user
      user.as_json
    end

  end

end
