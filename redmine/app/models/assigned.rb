class Assigned < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue
  validates :user, presence: true
  validates :issue, presence: true
  
  def group
    Group.joins('INNER JOIN assigneds ON assigneds.is_deleted = false and assigneds.user_id = users.id and assigneds.id='+self.id.to_s).first;
  end
end
