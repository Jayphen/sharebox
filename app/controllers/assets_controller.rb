class AssetsController < ApplicationController
  def index
    @assets = current_user.assets
  end

  def show
    @asset = current_user.assets.find(params[:id])
  end

  def new
    @asset = current_user.assets.build
    if params[:folder_id] #if we want to upload a file inside another folder
      @current_folder = current_user.folders.find(params[:folder_id])
      @asset.folder_id = @current_folder.id
    end
  end

  def create
    @asset = current_user.assets.build(params[:asset])
    if @asset.save
      flash[:notice] = "Successfully uploaded the file."
      
      if @asset.folder #checking if we have a parent folder for this file
        redirect_to browse_path(@asset.folder) #redirect to the parent folder
      else
        direct_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @asset = current_user.assets.find(params[:id])
  end

  def update
    @asset = current_user.assets.find(params[:id])
    if @asset.update_attributes(params[:asset])
      redirect_to @asset, :notice  => "Successfully updated asset."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @asset = current_user.assets.find(params[:id])
    @asset.destroy
    redirect_to assets_url, :notice => "Successfully destroyed asset."
  end
  
  #this action will let users download the files (after an auth check)
  def get
    asset = current_user.assets.find_by_id(params[:id])
    if asset
      #Parse the URL for special chars first before downloading
      data = open(URI.parse(URI.encode(asset.uploaded_file.url)))
      
      #then again, use the send_data method to send the binary data as a file
      send_data data, :filename => asset.uploaded_file_file_name
      
      #redirect to amazon S3 url
      #redirect_to asset.uploaded_file.url, :type => asset.uploaded_file_content_type
    else
      flash[:error] = "Don't be cheeky! Mind your own assets!"
      redirect_to assets_path
    end
  end
end
