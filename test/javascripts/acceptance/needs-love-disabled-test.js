import { visit } from "@ember/test-helpers";
import { test } from "qunit";
import { clearTopicFooterButtons } from "discourse/lib/register-topic-footer-button";
import {
  acceptance,
  updateCurrentUser,
} from "discourse/tests/helpers/qunit-helpers";
import selectKit from "discourse/tests/helpers/select-kit-helper";

acceptance(
  "Discourse Needs Love | Needs Love disabled mobile",
  function (needs) {
    needs.user();
    needs.mobileView();
    needs.settings({ needs_love_enabled: false });
    needs.hooks.beforeEach(function () {
      clearTopicFooterButtons();
    });

    test("Footer dropdown does not contain button", async function (assert) {
      updateCurrentUser({ can_needs_love: true });
      const menu = selectKit(".topic-footer-mobile-dropdown");

      await visit("/t/internationalization-localization/280");
      await menu.expand();

      assert.false(menu.rowByValue("needs-love").exists());
    });
  }
);
