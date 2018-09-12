module AssignedsHelper
	def assigneds_checkboxes(object, users, checked=nil)
	    users.map do |user|	
	      c = checked.nil? ? object.watched_by?(user) : checked
	      tag = check_box_tag 'assigned_user_ids[]', user.id, c, :id => nil
	      content_tag 'label', "#{tag} #{h(user)}".html_safe,
	                  :id => "issue_assigned_user_ids_#{user.id}",
	                  :class => "floating"
	    end.join.html_safe
	end

	def assigneds_checkboxes_groups(object, assigneds, checked=nil)
		assigneds.map do |assigned|
			if assigned.group.present?
			    c = checked.nil? ? object.watched_by?(assigned.group) : checked
			    tag = check_box_tag 'assigned_user_ids[]', assigned.group.id, c, :id => nil
			      content_tag 'label', "#{tag} #{h(assigned.group)}".html_safe,
	                :id => "issue_assigned_user_ids_#{assigned.group.id}",
	                :class => "floating"
			end
		end.join.html_safe
	end

	def assigneds_checkboxes_users(object, assigneds, checked=nil)
		assigneds.map do |assigned|
			if assigned.user.present?
			    c = checked.nil? ? object.watched_by?(assigned.user) : checked
			    tag = check_box_tag 'assigned_user_ids[]', assigned.user.id, c, :id => nil
			      content_tag 'label', "#{tag} #{h(assigned.user)}".html_safe,
	                :id => "issue_assigned_user_ids_#{assigned.user.id}",
	                :class => "floating"
			end
		end.join.html_safe
	end

 	# Returns a comma separated list of users watching the given object
  	def assigneds_list(object)
    	content = ''.html_safe
    	object.assigneds.each do |assigned|
	      	s = ''.html_safe

	      	if assigned.user.present?
	      		s << avatar(assigned.user, :size => "16").to_s
		      	s << link_to_user(assigned.user, :class => 'user')
			    url = {:controller => 'assigneds',
		    		       :action => 'remove',
		               		:assigned => assigned ,
		               		:issue => object}
		        s << ' '
		        #if User.current.admin
			    #    s <<link_to(l(:button_remove), url,:class => 'icon icon-del',:remote => true,
			    #    	:data => {:confirm => l(:text_assigneds_remove_confirmation_user)+assigned.user.to_s+l(:text_question_fin) },
			    #    	:method => 'post')
			    #end
	      		content << content_tag('li', s, :class => "user-#{assigned.user.id}")
	      	end

	      	if assigned.group.present?
		      	s << link_to(h(assigned.group), group_path(assigned.group))
			    url = {:controller => 'assigneds',
		    		       :action => 'remove',
		               		:assigned => assigned,
		               		:issue => object }
		        s << ' '
		        #if User.current.admin
		        #	s <<link_to(l(:button_remove), url,:class => 'icon icon-del',:remote => true,
		        #	:data => {:confirm => l(:text_assigneds_remove_confirmation_group)+assigned.group.to_s+l(:text_question_fin) },
		        #	:method => 'post')
		        #end
	      		content << content_tag('li', s, :class => "group-#{assigned.group.id}")
	      	end

    	end

    	content.present? ? content_tag('ul', content, :class => 'watchers') : content
  	end
 	
end
