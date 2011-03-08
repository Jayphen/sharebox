class HomeController < ApplicationController
  def index
    if user_signed_in?
      #show only root folders with no parents
      @folders = current_user.folders.roots
      
      #load current_user's files(assets)
      @assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name desc")
    end
  end
  
  #for viewing folders
  def browse
    #folders owned/created by current_user
    @current_folder = current_user.folders.find(params[:folder_id])
    
    if @current_folder
      #getting the folders which are inside this @current_folder
      @folders = @current_folder.children
      
      #show only the files under this current folder
      @assets = @current_folder.assets.order("uploaded_file_file_name desc")
      
      render :action => "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own folder!"
      redirect_to root_url
    end
  end
end