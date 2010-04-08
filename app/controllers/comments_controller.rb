class CommentsController < ApplicationController
  before_filter :login_required
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to deliveries_path
    else
      render :nothing => true
    end
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @commentable = Delivery.find(params[:comment][:commentable_id])
    if @comment.save
      flash[:notice] = "Successfully created comment."
      respond_to do |format|
        format.html{ redirect_to deliveries_path }
        format.js{  
          render :update do |page|
            page.replace_html(:"comments_count_for_#{@commentable.id}", "#{@commentable.comments.size} Comments")
            page.insert_html(:top, :"comments_for_#{@commentable.id}", :partial => "deliveries/comment", :object => @comment)
            page.visual_effect(:fade, params[:object])
            page.visual_effect(:highlight, "comment_#{@comment.id}")
          end
        }
      end
    else
      render :nothing => true
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to deliveries_path
  end
end
