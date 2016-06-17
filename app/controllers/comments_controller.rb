class CommentsController < ApplicationController
	http_basic_authenticate_with name: 'Noah', password: 'secret', only: 
		[:destroy, :destroy_all]

	def index
		redirect_to articles_path(@article)
	end

	def new
		@comment = Comment.new
	end

	def show
		@article = Article.find(params[:article_id])
		@comment = Comment.new
		redirect_to article_path(@article)
	end

	def create
		@article = Article.find(params[:article_id])
		@comment = @article.comments.new(comment_params)


		if @comment.save
			if @comment.commenter == ''
				@comment.commenter = 'Anonymous'
			end
			@comment.save
			redirect_to article_path(@article)
		else
			@fail = true
			render 'articles/show'
		end
	end

	def destroy
		@article = @article || Article.find(params[:article_id])
		@comment = @article.comments.find(params[:id])
		@comment.destroy

		redirect_to article_path(@article)
	end

	def destroy_all
		@article = @article || Article.find(params[:id])
		@article.comments.each{ |c| 
			c.destroy 
		}

		redirect_to article_path(@article)
	end

	private
		def comment_params
			params.require(:comment).permit(:commenter, :body)
		end
end
