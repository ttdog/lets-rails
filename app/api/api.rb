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

  post "preferred_date/" do
    if params[:user_id]
      user = User.find(params[:user_id])
      if user
        #ここでuserに紐づく形で希望日の登録
        date = PreferredDate.new(user_id: params[:user_id], year: params[:year], month: params[:month], day: params[:day])
        if date.save
          #ここでマッチングを行いその結果も返す
          {:result => "true", :id => date.id}.as_json
        else
          {:result => "false"}.as_json
        end
      else
        {:result => "false"}.as_json
      end
    else
      {:result => "false"}.as_json
    end

  end

end
