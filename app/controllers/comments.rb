class App
  ALLOWED_COMMENT_PARAMS = %i[content]

  namespace '/builds' do
    post '/:build_id/comments' do
      @build = Build[params[:build_id]]
      halt 404 unless @build
      @comment = Comment.new
      params.merge!(JSON.parse(request.body.read))
      if @comment.set_fields(params.merge(user_id: current_user.id), %i[build_id content user_id]).save
        status 201
        json(comment: @comment, user: current_user)
      else
        status 422
        json @comment.errors
      end
    end

    patch '/:build_id/comments/:comment_id' do
      @comment = User.where(id: current_user.id).comments.where(id: params[:comment_id].to_i, build_id: params[:build_id].to_i).first
      halt 404 unless @comment
      params.merge!(JSON.parse(request.body.read))
      if @comment.update_fields(params, %i[content])
        status 200
        json @comment
      else
        status 422
        json @comment.errors
      end
    end

    delete '/:build_id/comments/:comment_id' do
      @comment = User.where(id: current_user.id).comments.where(id: params[:comment_id].to_i, build_id: params[:build_id].to_i)
      halt 404 unless @comment
      @comment.destroy
      status 200
      json(message: 'Deleted')
    end
  end
end
