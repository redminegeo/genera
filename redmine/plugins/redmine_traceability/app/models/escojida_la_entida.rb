class ESCOJIDALaEntida < ActiveRecord::Base
  include Redmine::SafeAttributes

  
  

  scope :visible, lambda { |*args|
    where(ESCOJIDALaEntida.visible_condition(args.shift || User.current, *args))
  }
  
  scope :sorted, lambda { order("#{table_name}.name ASC") }
  

  
  
  

  attr_protected :id


  safe_attributes 'name'


  def self.visible_condition(user, options={})
    '1=1'
  end

  def self.css_icon
    'icon icon-user'
  end

  def project
    nil
  end

  def visible?(user = nil)
    user ||= User.current
    user.allowed_to?(:view_escojida_la_entidas, self.project, global: true)
  end

  def editable?(user = nil)
    user ||= User.current
    user.allowed_to?(:manage_escojida_la_entidas, self.project, global: true)
  end

  def deletable?(user = nil)
    user ||= User.current
    user.allowed_to?(:manage_escojida_la_entidas, self.project, global: true)
  end

  def attachments_visible?(user = nil)
    visible?(user)
  end

  def attachments_editable?(user = nil)
    editable?(user)
  end

  def attachments_deletable?(user = nil)
    deletable?(user)
  end

  def to_s
    name.to_s
  end

  def created_on
    created_at
  end

  def updated_on
    updated_at
  end


end
