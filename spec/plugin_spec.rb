# frozen_string_literal: true

require 'rails_helper'

describe DiscourseNeedsLove do
  describe 'can_needs_love?' do
    fab!(:group) { Fabricate(:group) }
    fab!(:user) { Fabricate(:user) }

    before do
      SiteSetting.needs_love_enabled = true
    end

    it 'returns true for user in allowed groups' do
      SiteSetting.needs_love_allowed_groups = "#{group.id}"

      expect(user.can_needs_love?).to eq(false)

      group.add(user)
      expect(User.find(user.id).can_needs_love?).to eq(true)
    end

    it 'returns true for admins' do
      expect(Fabricate(:admin).can_needs_love?).to eq(true)
      expect(user.can_needs_love?).to eq(false)
    end
  end

end
