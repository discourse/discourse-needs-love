# frozen_string_literal: true

module DiscourseNeedsLove
  class NeedsLoveController < ApplicationController
    requires_login
    before_action :ensure_logged_in

    def needs_love
      tag_name = "needs-love" # Load from plugin site setting

      topic = Topic.find_by(id: params[:topic_id])
      tag = Tag.find_by(name: tag_name)
      unless tag
        tag = Tag.create(name: name)
      end

      old_tag_names = topic.tags.pluck(:name) || []
      tag_names = ([tag_name] + old_tag_names).uniq
      tags = Tag.where(name: tag_names)

      topic.tags = tags

      topic.tags_changed = true
      DiscourseEvent.trigger(
        :topic_tags_changed,
        topic, old_tag_names: old_tag_names, new_tag_names: [tag_name]
      )

      render json: success_json
    end
  end
end
