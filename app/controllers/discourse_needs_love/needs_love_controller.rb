# frozen_string_literal: true

module DiscourseNeedsLove
  class NeedsLoveController < ApplicationController
    requires_login
    before_action :ensure_logged_in

    def needs_love
      tag_name = SiteSetting.needs_love_tag

      topic = Topic.find_by(id: params[:topic_id])
      tag = Tag.find_by(name: tag_name)
      unless tag
        tag = Tag.create(name: tag_name)
      end

      old_tag_names = topic.tags.pluck(:name) || []
      tag_names = ([tag_name] + old_tag_names).uniq
      tags = Tag.where(name: tag_names)

      PostRevisor.new(topic.first_post, topic).revise!(current_user, { tags: tag_names }, validate_post: false)

      render json: success_json
    end
  end
end
