# frozen_string_literal: true

module DiscourseNeedsLove
  describe NeedsLoveController do
    fab!(:topic)
    fab!(:group)
    fab!(:post) { Fabricate(:post, topic: topic) }

    context "when signed in as an admin" do
      fab!(:signed_in_admin) { Fabricate(:admin, refresh_auto_groups: true) }

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
      fab!(:signed_in_user, :user)

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
        expect(topic.tags.exists?(name: "needs-love")).to eq(true)
      end

      it "blocks tagging topics the user cannot see" do
        group.add(signed_in_user)
        private_group = Fabricate(:group)
        private_category = Fabricate(:private_category, group: private_group)
        private_topic = Fabricate(:topic, category: private_category)
        Fabricate(:post, topic: private_topic)

        put "/needs_love/needs_love/#{private_topic.id}.json"

        expect(response.status).to eq(403)
        expect(response.parsed_body["errors"]).to be_present
        expect(private_topic.reload.tags.exists?(name: "needs-love")).to eq(false)
      end
    end
  end
end
