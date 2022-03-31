# frozen_string_literal: true

require 'rails_helper'

describe CurrentUserSerializer do
  describe 'can_needs_love?' do
    fab!(:group) { Fabricate(:group) }
    fab!(:admin) { Fabricate(:admin) }
    fab!(:user) { Fabricate(:user) }

    before do
      SiteSetting.needs_love_enabled = true
    end

    it 'should not be included when plugin is disabled' do
      SiteSetting.needs_love_enabled = false
      json = CurrentUserSerializer.new(user, scope: Guardian.new(user), root: false).as_json

      expect(json[:can_needs_love]).to eq(nil)
    end

    it 'should be false when user can not use needs love' do
      SiteSetting.needs_love_allowed_groups = "#{group.id}"
      json = CurrentUserSerializer.new(user, scope: Guardian.new(user), root: false).as_json

      expect(json[:can_needs_love]).to eq(false)
    end

    it 'returns true for user in allowed groups' do
      SiteSetting.needs_love_allowed_groups = "#{group.id}"
      group.add(user)
      json = CurrentUserSerializer.new(user, scope: Guardian.new(user), root: false).as_json

      expect(json[:can_needs_love]).to eq(true)
    end

    it 'returns true for admins' do
      json = CurrentUserSerializer.new(admin, scope: Guardian.new(admin), root: false).as_json

      expect(json[:can_needs_love]).to eq(true)
    end

  end
end
