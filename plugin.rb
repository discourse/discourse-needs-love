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

after_initialize do
end
