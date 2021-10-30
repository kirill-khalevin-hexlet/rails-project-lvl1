# frozen_string_literal: true

require_relative "hexlet_code/version"

module HexletCode
  class Error < StandardError; end

  def self.form_for(user, **kwargs, &_block)
    Tag.build("form", action: kwargs[:action] || "#", method: :post)
  end

  # Tag builder
  module Tag
    SELF_CLOSING_TAGS = %w[area base basefont br col frame hr img input isindex link meta param].freeze

    def self.build(tag, **kwargs, &_block)
      tag_attrs = kwargs.map { |attr, param| " #{attr}=\"#{param}\"" }.join
      inner_and_closed_part = SELF_CLOSING_TAGS.include?(tag) ? "" : "#{yield if block_given?}</#{tag}>"

      "<#{tag}#{tag_attrs}>#{inner_and_closed_part}"
    end
  end
end
