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

  post "friend/" do
    if params[:user_id] && params[:invite_id]
      userfriend = UserFriend.new(user_id: params[:user_id], friend_id: params[:invite_id]);
      frienduser = UserFriend.new(user_id: params[:invite_id], friend_id: params[:user_id]);
      if userfriend.save && frienduser.save
        {:result => "true"}.as_json
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
          friends = UserFriend.where("user_id = ?", params[:user_id])

          if friends
            match_dates = [];

            friends.each do |friend|
  #            dates = PreferredDate.where("user_id = ?", friend).order("created_at DESC").limit(7).
              isMatch = PreferredDate.where("user_id = ? and year = ? and month = ? and day = ?", friend, params[:year], params[:month], params[:day])

              if isMatch
                match_dates.push(isMatch)
              end
            end

            if match_dates.length != 0
              match_dates.sort_by!{|date| date.created_at}
              old_match = match_dates.first
              fr = User.find(old_match.user_id)
              #TODO: matchテーブルに追加

              #matchしている場合には相手のユーザ情報を返す
              {:result => true, :id => date.id, :year => params[:year], :month => params[:month], :day => params[:day], :match => true, :friend => {:user_id => fr.id, :user_name => fr.username}}.as_json
            else
              {:result => true, :id => date.id, :year => params[:year], :month => params[:month], :day => params[:day], :match => false, :friend => {}}.as_json
            end
          end

          {:result => true, :id => date.id, :year => params[:year], :month => params[:month], :day => params[:day], :match => false, :friend => {}}.as_json
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
