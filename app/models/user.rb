class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  belongs_to :role
  
  before_create :set_default_role
  
  def can_edit?
    self.role_id != Role.view_only.id
  end
  
  def admin?
    self.role_id == Role.admin.id
  end
  
  private
    def set_default_role
      self.role ||= Role.view_only
    end
end