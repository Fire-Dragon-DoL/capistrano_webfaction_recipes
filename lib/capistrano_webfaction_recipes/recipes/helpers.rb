# encoding: utf-8
require 'active_support/all'
require 'action_pack'
require 'action_view'

module Helpers

  extend ::ActionView::Helpers::NumberHelper

  module Characters

    def self.success
      "✓ "
    end

    def self.success_fat
      "✔ "
    end

    def self.failure
      "✕ "
    end

    def self.failure_fat
      "✖ "
    end

    def self.up
      "↑"
    end

    def self.down
      "↓"
    end

    def self.left
      "←"
    end

    def self.right
      "→"
    end

  end

end