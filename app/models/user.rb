class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me
  
  validates :email, :presence => true, :uniqueness => true

  has_many :assets
  has_many :folders
  
  #for folders which this user has shared
  has_many :shared_folders, :dependent => :destroy
  
  #for folders which the user has been shared by others
  has_many :being_shared_folders, :class_name => "SharedFolder", :foreign_key => "shared_user_id", :dependent => :destroy
  
  #for getting Folders shared with the user by others
  has_many :shared_folders_by_others, :through => :being_shared_folders, :source => :folder
  
  after_create :check_and_assign_shared_ids_to_shared_folders
  
  def check_and_assign_shared_ids_to_shared_folders
    #first check if the new user's email exists in any of the sharefolder records
    shared_folders_with_same_email = SharedFolder.find_all_by_shared_email(self.email)
    
    if shared_folders_with_same_email
      #loop and update the shared user id with this new user id
      shared_folders_with_same_email.each do |shared_folder|
        shared_folder.shared_user_id = self.id
        shared_folder.save
      end
    end
  end
  
  # to check if a user has access to this specific folder
  def has_share_access?(folder)
    # has share access if the folder is one of his own
    return true if self.folders.include?(folder)
    
    # has share access if the folder is one of the shared_folders_by_others
    return true if self.shared_folders_by_others.include?(folder)
    
    # for checking sub folders under one of the being_shared_folders
    return_value = false
    
    folder_ancestors.each do |ancestor_folder|
      if return_value #if it's true
        return true
      end
    end
    
    return false
  end
end