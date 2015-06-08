class WallController < ApplicationController
	before_action :login_check
	skip_before_action :login_check, :only => [:posts]

  def write
  end

	def write_complete
		p = Post.new
		p.name = params[:writer]
		p.content = params[:content]

		if p.save
			redirect_to "/wall/posts"
		else
			flash[:alert] = p.errors[:content][0]
			redirect_to :back
		end
	end

  def posts
		@posts = Post.all
  end

	def edit
		@post_edit = Post.find(params[:id])
	end

	def edit_complete
		p = Post.find(params[:id])
		p.name = params[:writer_edit]
		p.content = params[:content_edit]

		if p.save
			redirect_to "/wall/posts"
		else
			flash[:alert] = p.errors[:content][0]
			redirect_to :back
		end
	end
	
	def delete
		@post_delete = Post.find(params[:id])
	end

	def delete_complete
		id = params[:id]
		c = Comment.where("post_id = #{id}")
		p = Post.find(params[:id])
	  p.destroy
		c.destroy_all
			
		redirect_to "/wall/posts"
		
	end
	
	def write_comment
		@post_comment = Post.find(params[:id])
	end

	def write_comment_complete
		c = Comment.new
		c.post_id = params[:post_id]
		c.name = params[:writer]
		c.content = params[:content]
		
		c.save

		redirect_to "/wall/posts"
	end

	def delete_comment
		@post_delete = Comment.find(params[:id])
	end

	def edit_comment
		c = Comment.find(params[:id])
		@comment_id = c.id
		@post = Post.find(c.post_id)
	end

	def delete_comment_complete
		c = Comment.find(params[:id])
		c.destroy

		redirect_to "/wall/posts"
	end

	def edit_comment_complete
		c = Comment.find(params[:comment_id])
		c.name = params[:writer]
		c.content = params[:content]

		if c.save
			redirect_to "/wall/posts"
	#	else
	#		flash[:alert] = p.errors[:content][0]
	#		redirect_to :back
		end
	end

end
