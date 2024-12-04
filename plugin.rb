# frozen_string_literal: true

# name: discourse-needs-love
# about: Provides a "Needs Love" button that select users can press to add a tag to a topic.
# version: 0.0.1
# authors: Discourse
# url: http://github.com/discourse/discourse-needs-love
# required_version: 2.7.0

enabled_site_setting :needs_love_enabled

register_svg_icon "bandage" if respond_to?(:register_svg_icon)

require_relative "lib/discourse_needs_love/engine"

Discourse::Application.routes.append { mount ::DiscourseNeedsLove::Engine, at: "/needs_love" }

after_initialize do
  require_relative "app/controllers/discourse_needs_love/needs_love_controller"

  add_to_class(:user, :can_needs_love?) do
    return @can_needs_love if defined?(@can_needs_love)

    allowed_groups = SiteSetting.needs_love_allowed_groups.split("|").compact
    @can_needs_love = admin? || (allowed_groups.present? && groups.exists?(id: allowed_groups))
  end

  add_to_serializer(:current_user, :can_needs_love) { object.can_needs_love? }
end
