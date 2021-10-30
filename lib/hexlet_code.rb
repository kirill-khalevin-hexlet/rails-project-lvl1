# frozen_string_literal: true

require_relative "hexlet_code/version"

module HexletCode
  class Error < StandardError; end

  module Tag
    SELF_CLOSING_TAGS = %w(area base basefont br col frame hr img input isindex link meta param).freeze

    def self.build(tag, **kwargs, &block)
      tag_attrs = kwargs.map { |attr, param| " #{attr}=\"#{param}\"" }.join
      inner_and_closed_part = SELF_CLOSING_TAGS.include?(tag) ? "" : "#{yield if block_given?}<#{tag}>"
      html_block = "<#{tag}#{tag_attrs}>#{inner_and_closed_part}"
    end
  end

end
