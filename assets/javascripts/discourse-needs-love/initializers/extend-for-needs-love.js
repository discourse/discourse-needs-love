import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { withPluginApi } from "discourse/lib/plugin-api";

function tagTopic(user, target) {
  ajax(`/needs_love/needs_love/${target.id}`, {
    type: "PUT",
  }).catch((reason) => {
    popupAjaxError(reason);
  });
}

function disableNeedsLoveButton(topic, tagName) {
  const tags = topic.tags || [];
  return tags.includes(tagName);
}

function registerTopicFooterButtons(api, tagName) {
  api.registerTopicFooterButton({
    id: "needs-love",
    priority: 250,
    classNames: ["needs-love"],
    dependentKeys: ["topic.tags"],

    icon() {
      return "band-aid";
    },

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
      tagTopic(this.currentUser, this.topic);
    },

    dropdown() {
      return this.site.mobileView;
    },

    displayed() {
      return (
        this.get("currentUser.can_needs_love") &&
        !disableNeedsLoveButton(this.topic, tagName)
      );
    },
  });

  api.registerTopicFooterButton({
    id: "needs-love-disabled",
    priority: 250,
    classNames: ["needs-love", "disabled"],
    dependentKeys: ["topic.tags"],

    icon() {
      return "band-aid";
    },

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
      // No action. Button is disabled.
    },

    dropdown() {
      return this.site.mobileView;
    },

    displayed() {
      return (
        this.get("currentUser.can_needs_love") &&
        disableNeedsLoveButton(this.topic, tagName)
      );
    },
  });
}

export default {
  name: "extend-for-needs-love",

  initialize(container) {
    const siteSettings = container.lookup("service:site-settings");
    if (!siteSettings.needs_love_enabled) {
      return;
    }
    const tagName = siteSettings.needs_love_tag;

    withPluginApi("0.8.28", (api) => registerTopicFooterButtons(api, tagName));
  },
};
