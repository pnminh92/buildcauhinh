class App
  ALLOWED_COMMENT_PARAMS = %i[content]

  before do
    @build = Build[params[:id]]
    halt 404 unless @build
  end

  namespace '/builds' do
    post '/:build_id/comments' do
      @comment = Comment.new
      if @comment.set_fields(params.merge(user_id: current_user.id, build_id: build.id), %i[build_id content user_id], missing: :skip).save
        status 201
        json @comment
      else
        status 422
        json @comment.errors
      end
    end

    route :patch, :put, '/:build_id/comments/:comment_id' do
      @comment = @build.comments[params[:comment_id]]
      if @comment.update_fields(params, %[content], missing: :skip)
        status 200
        json @comment
      else
        status 422
        json @comment.errors
      end
    end

    delete '/:build_id/comments/:comment_id' do
      @comment = @build.comments[params[:comment_id]]
      @comment.destroy
      status 200
      json { message: 'Deleted' }
    end
  end
end
