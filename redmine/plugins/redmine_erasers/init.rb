require 'redmine'

require 'redmine_erasers/hooks'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_erasers/issue_patch'
  require_dependency 'redmine_erasers/issues_controller_patch'
end

Redmine::Plugin.register :redmine_erasers do
  name 'Redmine Erasers plugin'
  description 'This plugin avoids losing data when editing issues by saving it regularly as a eraser'
  version '0.2.0'
  url 'https://github.com/jbbarth/redmine_erasers'
  author 'siim_vc PLANERP'
  author_url 'infoplanerp@gmail.com'
  requires_redmine :version_or_higher => '2.1.0'
  requires_redmine_plugin :redmine_base_rspec, :version_or_higher => '0.0.4' if Rails.env.test?
end
