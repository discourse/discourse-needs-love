import { withPluginApi } from "discourse/lib/plugin-api";
import { ajax } from "discourse/lib/ajax";

function TagTopic(user, target) {
  return ajax(`/needs_love/needs_love/${target.id}`, {
    type: "PUT",
    data: {},
  });
}

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
      TagTopic(this.currentUser, this.topic);
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

    withPluginApi("0.8.28", (api) => registerTopicFooterButtons(api));
  },
};
