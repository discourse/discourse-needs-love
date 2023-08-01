# frozen_string_literal: true

require "rails_helper"

module DiscourseNeedsLove
  describe NeedsLoveController do
    fab!(:topic) { Fabricate(:topic) }
    fab!(:group) { Fabricate(:group) }
    fab!(:post) { Fabricate(:post, topic: topic) }

    context "when signed in as an admin" do
      fab!(:signed_in_admin) { Fabricate(:admin) }

      before do
        SiteSetting.needs_love_enabled = true
        SiteSetting.tagging_enabled = true
        SiteSetting.needs_love_allowed_groups = "#{group.id}"

        sign_in signed_in_admin
      end

      it "adds the needs-love tag" do
        put "/needs_love/needs_love/#{post.topic.id}.json"
        expect(response.status).to eq(200)
        expect(topic.tags.pluck(:name).include?("needs-love")).to eq(true)
      end
    end

    context "when signed in as a user" do
      fab!(:signed_in_user) { Fabricate(:user) }

      before do
        SiteSetting.needs_love_enabled = true
        SiteSetting.tagging_enabled = true
        SiteSetting.needs_love_allowed_groups = "#{group.id}"

        sign_in signed_in_user
      end

      it "raises invalid access if user is not in allowed group" do
        put "/needs_love/needs_love/#{post.topic.id}.json"

        expect(response.status).to eq(403)
      end

      it "allows the user when part of the specified group" do
        group.add(signed_in_user)
        put "/needs_love/needs_love/#{post.topic.id}.json"

        expect(response.status).to eq(200)
      end
    end
  end
end
