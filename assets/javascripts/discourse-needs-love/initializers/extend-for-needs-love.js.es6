import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";

function registerTopicFooterButtons(api) {
  api.registerTopicFooterButton({
    id: "needs-love",
    icon() {
      return "band-aid";
    },
    priority: 250,
    translatedTitle() {
      return "Needs Love";
    },
    translatedAriaLabel() {
      return "Needs Love";
    },
    translatedLabel() {
      return "Needs Love";
    },
    action() {
      // Add Tag
      alert('hi');
    },
    dropdown() {
      return this.site.mobileView;
    },
    classNames: ["needs-love"],
    dependentKeys: [],
    displayed() {
      return true;
    },
  });
}

export default {
  name: "extend-for-needs-love",

  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    if (!siteSettings.needs_love_enabled) {
      return;
    }

    const currentUser = container.lookup("current-user:main");

    //withPluginApi("0.11.0", (api) => initialize(api));
    withPluginApi("0.8.28", (api) => registerTopicFooterButtons(api));
  },
};

