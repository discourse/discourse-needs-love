# frozen_string_literal: true

# name: discourse-needs-love
# about: Provides a "Needs Love" button that select users can press to add a tag to a topic.
# version: 0.0.1
# authors: Discourse
# url: http://github.com/discourse/discourse-needs-love
# required_version: 2.7.0
# transpile_js: true

enabled_site_setting :needs_love_enabled

register_svg_icon "band-aid" if respond_to?(:register_svg_icon)

load File.expand_path('../lib/discourse_needs_love/engine.rb', __FILE__)

Discourse::Application.routes.append do
  mount ::DiscourseNeedsLove::Engine, at: "/needs_love"
end

after_initialize do
  require_relative "app/controllers/discourse_needs_love/needs_love_controller.rb"

  add_to_class(:user, :can_needs_love?) do
    @can_needs_love ||= begin
      if admin?
        :true
      else
        allowed_groups = SiteSetting.needs_love_allowed_groups.split('|').compact
        allowed_groups.present? && groups.exists?(id: allowed_groups) ? :true : :false
      end
    end

    @can_needs_love == :true
  end

  add_to_serializer(:current_user, :can_needs_love) do
    object.can_needs_love?
  end

end
