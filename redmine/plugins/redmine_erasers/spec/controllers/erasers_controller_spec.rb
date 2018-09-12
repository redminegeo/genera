require "spec_helper"

describe ErasersController, :type => :controller do
  fixtures :erasers, :issues, :users, :issue_statuses, :projects, :projects_trackers, :trackers, :enumerations

  before do
    @request.session[:user_id] = nil
    Setting.default_language = 'en'
  end

  it "should anonymous user cannot autosave a eraser" do
    xhr :post, :autosave
    assert_response 401
  end

  it "should save eraser for existing issue" do
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              {:issue_id => 1,
               :user_id => 1,
               :issue => { :subject => "Changed the subject" },
               :notes => "Just a first try to add a note"
              }
    expect(response).to be_success
    eraser = Eraser.find_for_issue(:element_id => 1, :user_id => 1)
    refute_nil eraser
    expect(eraser.content.keys.sort).to eq ["issue", "notes"]
    expect(eraser.content[:issue][:subject]).to eq "Changed the subject"

    xhr :post, :autosave,
              {:issue_id => 1,
               :notes => "Ok, let's change this note entirely and see if eraser is duplicated",
               :user_id => 1,
               :issue => { :subject => "Changed the subject again !" }
              }
    expect(Eraser.where(:element_type => 'Issue', :element_id => 1, :user_id => 1).count).to eq 1
    eraser = Eraser.find_for_issue(:element_id => 1, :user_id => 1)
    expect(eraser.content[:issue][:subject]).to eq "Changed the subject again !"
  end

  it "should save eraser for existing issue with redmine 2 3 format" do
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              { :issue_id => 1,
                :user_id => 1,
                :issue => {
                  :notes => "A note in Redmine 2.3.x structure!"
                }
              }
    expect(response).to be_success
    eraser = Eraser.find_for_issue(:element_id => 1, :user_id => 1)
    refute_nil eraser
    expect(eraser.content[:notes]).to eq "A note in Redmine 2.3.x structure!"
  end

  it "should save eraser for new issue" do
    @request.session[:user_id] = 1
    xhr :post, :autosave,
              {:issue_id => 0,
               :user_id => 1,
               :issue => { :subject => "This is a totally new issue",
                           :description => "It has a description" },
              }
    expect(response).to be_success
    eraser = Eraser.find_for_issue(:element_id => 0, :user_id => 1)
    refute_nil eraser
    expect(eraser.content.keys).to eq ["issue", "notes"]
    expect(eraser.content[:issue][:subject]).to eq "This is a totally new issue"
  end

  it "should clean eraser after create" do
    User.current=User.find(1)
    Eraser.create(:element_type => 'Issue', :element_id => 0, :user_id => 1)
    refute_nil Eraser.find_for_issue(:element_id => 0, :user_id => 1)
    issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 1,
              :status_id => 1, :priority => IssuePriority.all.first,
              :subject => 'test_clean_after_eraser_create',
              :description => 'Eraser cleaning after_create')
    expect(issue.save).to be_truthy
    expect(Eraser.find_for_issue(:element_id => 0, :user_id => 1)).to be_nil
  end

  it "should clean eraser after update" do
    User.current = User.find(1)
    Eraser.create(:element_type => 'Issue', :element_id => 1, :user_id => 1)
    refute_nil Eraser.find_for_issue(:element_id => 1, :user_id => 1)
    Issue.find(1).save
    expect(Eraser.find_for_issue(:element_id => 1, :user_id => 1)).to be_nil
  end
end
