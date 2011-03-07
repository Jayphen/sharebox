class FoldersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @folders = current_user.folders
  end

  def show
    @folder = current_user.folders.find(params[:id])
  end

  def new
    @folder = current_user.folders.new
  end

  def create
    @folder = current_user.folders.new(params[:folder])
    if @folder.save
      redirect_to @folder, :notice => "Successfully created folder."
    else
      render :action => 'new'
    end
  end

  def edit
    @folder = current_user.folders.find(params[:id])
  end

  def update
    @folder = current_user.folders.find(params[:id])
    if @folder.update_attributes(params[:folder])
      redirect_to @folder, :notice  => "Successfully updated folder."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @folder = current_user.folders.find(params[:id])
    @folder.destroy
    redirect_to folders_url, :notice => "Successfully destroyed folder."
  end
end
