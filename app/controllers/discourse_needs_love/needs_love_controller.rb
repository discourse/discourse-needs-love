# frozen_string_literal: true

module DiscourseNeedsLove
  class NeedsLoveController < ApplicationController
    requires_plugin PLUGIN_NAME

    requires_login
    before_action :ensure_logged_in
    before_action :ensure_can_needs_love

    def needs_love
      topic = Topic.find_by(id: params[:topic_id])
      guardian.ensure_can_see!(topic)

      tag_name = SiteSetting.needs_love_tag
      Tag.find_or_create_by(name: tag_name)

      old_tag_names = topic.tags.pluck(:name) || []
      tag_names = ([tag_name] + old_tag_names).uniq

      PostRevisor.new(topic.first_post, topic).revise!(
        Discourse.system_user,
        { tags: tag_names },
        validate_post: false,
      )

      render json: success_json
    end

    private

    def ensure_can_needs_love
      raise Discourse::InvalidAccess.new unless current_user && current_user.can_needs_love?
    end
  end
end
