import { withPluginApi } from "discourse/lib/plugin-api";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

function tagTopic(user, target) {
  try {
    let result = ajax(`/needs_love/needs_love/${target.id}`, {
      type: "PUT",
      data: {},
    });
    return result;
  } catch (error) {
    popupAjaxError(error);
  }
}

function disableNeedsLoveButton(topic, tagName) {
  const tags = topic.tags || [];
  return tags.includes(tagName);
}

function getClassNames(topic) {
  const classNames = ["needs-love"];
  if (disableNeedsLoveButton(topic)) {
    classNames.push("disabled");
  }
  return classNames;
}

function registerTopicFooterButtons(api, tagName) {
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
      tagTopic(this.currentUser, this.topic)
      .then(() => {
        this.appEvents.trigger("post-stream:refresh", {
          id: this.topic.postStream.firstPostId,
        });
      });
    },
    dropdown() {
      return this.site.mobileView;
    },
    classNames: ["needs-love"],
    dependentKeys: ["topic.tags"],
    displayed() {
      return !disableNeedsLoveButton(this.topic, tagName);
    },
  });

  api.registerTopicFooterButton({
    id: "needs-love-disabled",
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
      // No action. Button is disabled.
    },
    dropdown() {
      return this.site.mobileView;
    },
    classNames: ["needs-love", "disabled"],
    dependentKeys: ["topic.tags"],
    displayed() {
      return disableNeedsLoveButton(this.topic, tagName);
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
    const tagName = siteSettings.needs_love_tag;

    withPluginApi("0.8.28", (api) => registerTopicFooterButtons(api, tagName));
  },
};
