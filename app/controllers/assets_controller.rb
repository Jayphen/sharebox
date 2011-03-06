class AssetsController < ApplicationController
  def index
    @assets = current_user.assets
  end

  def show
    @asset = current_user.assets.find(params[:id])
  end

  def new
    @asset = current_user.assets.new
  end

  def create
    @asset = current_user.assets.new(params[:asset])
    if @asset.save
      redirect_to @asset, :notice => "Successfully created asset."
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
