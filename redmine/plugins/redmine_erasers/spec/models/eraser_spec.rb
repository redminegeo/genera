require "spec_helper"

describe "Eraser" do
  fixtures :erasers

  it "should should be valid" do
    assert Eraser.new.valid?
  end

  it "should nil content" do
    expect(Eraser.new.content).to eq Hash.new
  end

  it "should find for issue" do
    assert Eraser.find_for_issue(:element_id => 1, :user_id => 1).is_a?(Eraser)
  end

  it "should find or create for issue" do
    expect(Eraser.find_for_issue(:element_id => 3, :user_id => 1)).to be_nil
    eraser = Eraser.find_or_create_for_issue(:element_id => 3, :user_id => 1)
    assert eraser.is_a?(Eraser)
    assert eraser.valid?
  end
end
