# frozen_string_literal: true

require 'rails_helper'

module DiscourseNeedsLove
  describe NeedsLoveController do
    fab!(:topic) { Fabricate(:topic) }
    fab!(:post) { Fabricate(:post, topic: topic) }

    context "signed in as an admin" do
      fab!(:signed_in_user) { Fabricate(:admin) }
      fab!(:another_admin) { Fabricate(:admin) }

      before do
        SiteSetting.needs_love_enabled = true
        SiteSetting.tagging_enabled = true

        sign_in signed_in_user
      end

      it 'adds the needs-love tag' do
        put "/needs_love/needs_love/#{post.topic.id}.json"
        expect(response.status).to eq(200)
        expect(topic.tags.pluck(:name).include?("needs-love")).to eq(true)
      end
    end
  end
end
