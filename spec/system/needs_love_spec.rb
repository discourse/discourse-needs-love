# frozen_string_literal: true

RSpec.describe "Needs Love button", type: :system do
  fab!(:user)
  fab!(:group)
  fab!(:topic)
  fab!(:post) { Fabricate(:post, topic: topic) }

  let(:topic_page) { PageObjects::Pages::Topic.new }
  let(:needs_love_button) { PageObjects::Components::NeedsLoveButton.new }

  before do
    SiteSetting.needs_love_enabled = true
    SiteSetting.tagging_enabled = true
    SiteSetting.needs_love_allowed_groups = "#{group.id}"
  end

  it "allows user in allowed group to add the needs-love tag to a topic" do
    group.add(user)
    sign_in(user)

    topic_page.visit_topic(topic)
    expect(needs_love_button).to have_needs_love_button

    needs_love_button.click
    expect(needs_love_button).to have_disabled_needs_love_button
    expect(topic_page.topic_tags).to contain_exactly("needs-love")
  end

  it "does not show the needs-love button to user not in allowed group" do
    sign_in(user)

    topic_page.visit_topic(topic)
    expect(needs_love_button).to have_no_needs_love_button
  end
end
