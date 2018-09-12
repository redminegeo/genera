module RedmineErasers
  class Hooks < Redmine::Hook::ViewListener
    # Add our own elements to issue show view (in show and form sections)
    #
    # NB: This works too, maybe for future use if we have many things to 
    # do before rendering :
    #
    #   def view_issues_form_details_bottom(context)
    #     template = context[:controller].instance_variable_get("@template")
    #     template.render :partial => "erasers/issue_form", :locals => {:context => context}
    #   end
    #
    render_on :view_issues_form_details_bottom, :partial => "erasers/issue_form"
    render_on :view_issues_show_details_bottom, :partial => "erasers/issue_show"

    # Add our css/js on each page
    def view_layouts_base_html_head(context)
      javascript_include_tag('jquery.observe-form.js', :plugin => 'redmine_erasers')
    end
  end
end
