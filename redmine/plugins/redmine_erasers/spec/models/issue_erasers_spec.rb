require "spec_helper"

describe "IssueErasers" do
  fixtures :users, :issues, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  it "should clean erasers on create" do
    User.current = User.find(3)
    project = Project.first
    issue = Issue.new(:project => project, :author => User.current, :subject => 'test_create', :description => 'IssueTest#test_create',
                      :status => IssueStatus.first, :tracker => project.trackers.first, :priority => IssuePriority.first)
    conds = {:user_id => 3, :element_id => 0}
    assert Eraser.find_or_create_for_issue(conds).is_a?(Eraser)
    refute_nil Eraser.find_for_issue(conds)
    assert issue.save
    expect(Eraser.find_for_issue(conds)).to be_nil
  end

  it "should clean erasers on update" do
    issue = Issue.find(1)
    User.current = issue.author
    conds = {:user_id => issue.author.id, :element_id => issue.id}
    assert Eraser.find_or_create_for_issue(conds).is_a?(Eraser)
    refute_nil Eraser.find_for_issue(conds)
    issue.subject = "Another wonderful subject"
    issue.save
    expect(Eraser.find_for_issue(conds)).to be_nil
  end
end
