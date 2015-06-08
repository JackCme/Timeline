class WallController < ApplicationController
	before_action :login_check
	skip_before_action :login_check, :only => [:posts]

  def write
		if !cookies[:user_id].nil?
			@current_user = User.find(cookies[:user_id])
		end
  end

	def write_complete
		p = Post.new
		p.name = params[:writer]
		p.content = params[:content]
		p.user_id = cookies[:user_id]

		if p.save
			redirect_to "/wall/posts"
		else
			flash[:alert] = p.errors[:content][0]
			redirect_to :back
		end
	end

  def posts
		@posts = Post.all
		if !cookies[:user_id].nil?
			@current_user = User.find(cookies[:user_id])
		end
  end

	def edit
		p = Post.find(params[:id])
		if !cookies[:user_id].nil?
			if p.user_id.to_i != cookies[:user_id].to_i
				flash[:alert] = "Cannot edit other's posts"
				redirect_to :back
			else
				@post_edit = p
			end	
		end

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
		p = Post.find(params[:id])
		if !cookies[:user_id].nil?
			if p.user_id.to_i != cookies[:user_id].to_i
				flash[:alert] = "Cannot delete other's posts"
				redirect_to :back
			else
				@post_delete = p
			end
		end
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

		if !cookies[:user_id].nil?
			@current_user = User.find(cookies[:user_id])
		end
	end

	def write_comment_complete
		c = Comment.new
		c.post_id = params[:post_id]
		c.name = params[:writer]
		c.content = params[:content]
		c.user_id = cookies[:user_id]	

		c.save

		redirect_to "/wall/posts"
	end

	def delete_comment
		c = Comment.find(params[:id])
		if !cookies[:user_id].nil?
			if c.user_id.to_i != cookies[:user_id].to_i
				flash[:alert] = "Cannot delete other's comments"
				redirect_to :back
			else
				@post_delete = c
			end
		end
	end

	def edit_comment
		c = Comment.find(params[:id])
		if !cookies[:user_id].nil?
			if c.user_id.to_i != cookies[:user_id].to_i
				flash[:alert] = "Cannot edit other's comments"
				redirect_to :back
			else
				@comment_id = c.id
				@post = Post.find(c.post_id)
			end
		end
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
