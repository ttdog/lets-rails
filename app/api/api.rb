class API < Grape::API
  format :json
  get "user/:user_id" do
    user = User.where(id: params[:user_id]).first

    if user
      user.as_json
    end
  end

  post "user/" do
    if params[:username] && params[:email]
      user = User.new(username: params[:username], email: params[:email])
      if user.save
        {:result => "true", :id => user.id}.as_json
      else
        {:result => "false"}.as_json
      end
    end
  end

end
