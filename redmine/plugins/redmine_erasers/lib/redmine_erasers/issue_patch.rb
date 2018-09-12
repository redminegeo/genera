require_dependency 'issue'

class Issue
  has_many :erasers, :as => :element

  after_create :clean_erasers_after_create
  after_update :clean_erasers_after_update
  
  def clean_erasers_after_create
    eraser = Eraser.find_for_issue(:element_id => 0, :user_id => User.current.id)
    eraser.destroy if eraser
  end
  
  def clean_erasers_after_update
    self.erasers.select{|d| d.user_id == User.current.id}.each(&:destroy)
  end
end
