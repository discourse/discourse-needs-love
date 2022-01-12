# frozen_string_literal: true

module DiscourseNeedsLove
  class NeedsLoveController < ApplicationController
    requires_login
    before_action :ensure_logged_in

    def needs_love
      tag = "needs-love" # Load from plugin site setting
      topic = Topic.find_by(id: params[:topic_id])
      tags = (topic.tags.pluck(:name) + [tag]).uniq
      results = PostRevisor.new(topic.first_post, topic).revise!(current_user, { tags: tags }, validate_post: false)
      if results == true
        render json: success_json
      else
        render json: failed_json
      end
    end
  end
end
