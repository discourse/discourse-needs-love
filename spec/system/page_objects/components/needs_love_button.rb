# frozen_string_literal: true

module PageObjects
  module Components
    class NeedsLoveButton < PageObjects::Components::Base
      def click
        find("#topic-footer-button-needs-love").click
        self
      end

      def has_needs_love_button?
        page.has_css?("#topic-footer-button-needs-love")
      end

      def has_no_needs_love_button?
        page.has_no_css?("#topic-footer-button-needs-love")
      end

      def has_disabled_needs_love_button?
        page.has_css?("#topic-footer-button-needs-love-disabled")
      end
    end
  end
end
