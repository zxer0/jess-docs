class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  belongs_to :role
  
  before_create :set_default_role
  
  def can_view?
    self.role_id != Role.none.id
  end
  
  def can_edit?
    self.role_id != Role.view_only.id && self.role_id != Role.none.id
  end
  
  def admin?
    self.role_id == Role.admin.id
  end
  
  private
    def set_default_role
      self.role ||= Role.none
    end
end