module FormalDocumentsHelper
  def user_options_tabs
    tabs = [{:name => 'general', :partial => 'formal_documents/new', :label => :label_general},
            {:name => 'memberships', :partial => 'formal_documents/dialog', :label => :label_project_plural}
            ]
    tabs
  end
end
