# frozen_string_literal: true

module ::DiscourseNeedsLove
  PLUGIN_NAME = "discourse-needs-love"

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseNeedsLove
  end
end
