class CommentsController < ApplicationController
  before_filter :login_required
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to deliveries_paths
    else
      render :action => 'edit'
    end
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to deliveries_paths
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to deliveries_paths
  end
end
