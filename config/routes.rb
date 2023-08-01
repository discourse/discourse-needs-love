# frozen_string_literal: true

DiscourseNeedsLove::Engine.routes.draw { put "/needs_love/:topic_id" => "needs_love#needs_love" }
