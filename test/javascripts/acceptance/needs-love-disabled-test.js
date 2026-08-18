import { click, visit } from "@ember/test-helpers";
import { test } from "qunit";
import { clearTopicFooterButtons } from "discourse/lib/register-topic-footer-button";
import { acceptance } from "discourse/tests/helpers/qunit-helpers";

acceptance(
  "Discourse Needs Love | Needs Love disabled mobile",
  function (needs) {
    needs.user({ can_needs_love: true });
    needs.mobileView();
    needs.settings({ needs_love_enabled: false });
    needs.hooks.beforeEach(function () {
      clearTopicFooterButtons();
    });

    test("Footer dropdown does not contain button", async function (assert) {
      await visit("/t/internationalization-localization/280");
      await click(".topic-footer-mobile-dropdown-trigger");
      assert.dom("#topic-footer-button-needs-love").doesNotExist();
    });
  }
);
