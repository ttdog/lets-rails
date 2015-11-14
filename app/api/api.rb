class API < Grape::API
  format :json
  get "user/:user_id" do
    user = User.where(id: params[:user_id]).first

    if user
      user.as_json
    end
  end

  post "user/" do
    if params[:username]
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
      #TODO: findに失敗するとエラーが発生するが
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

  get "invite/" do
    if params[:user_id]
      cookies[:invite_id] = {
        value: params[:user_id],
        expires: 1.year.from_now,
        domain: '.amazonaws.com',
        path: '/'
      }
    end
    #アプリのストア
#    redirect 'http://yahoo.co.jp'
  end

  get "landing/" do
    #アプリに遷移
    #redirect "path://ab/?invite_id=#{cookies[:invite_id]}"
  end

  get "temp/" do
    {:id => cookies[:invite_id]}.as_json
  end
end
