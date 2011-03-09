class HomeController < ApplicationController
  def index
    if user_signed_in?
      #show folders shared by others
      @being_shared_folders = current_user.shared_folders_by_others
      
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
      #if under a sub folder, we shouldn't see any shared folders
      @being_shared_folders = []
      
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
  
  #handles ajax request for inviting others to share
  def share
    #separate the emails with the comma
    email_addresses = params[:email_addresses].split(",")
    
    email_addresses.each do |email_address|
      #save the details in the Sharefolder table
      @shared_folder = current_user.shared_folders.new
      @shared_folder.folder_id = params[:folder_id]
      @shared_folder.shared_email = email_address
      
      #get the shared user id if the email has already signed up
      #if not, shared_user_id will be left nil
      shared_user = User.find_by_email(email_address)
      @shared_folder.shared_user_id = shared_user.id if shared_user
      
      @shared_folder.message = params[:message]
      @shared_folder.save
      
      #now we need to email the shared user
      UserMailer.invitation_to_share(@shared_folder).deliver
    end
    
    #since this action is mainly for ajax, respond with js file back (share.js.erb)
    respond_to do |format|
      format.js {
      }
    end
  end
end