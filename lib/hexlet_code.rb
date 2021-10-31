# frozen_string_literal: true

require_relative "hexlet_code/version"

# Lesson, create gem with Hexlet
module HexletCode
  class Error < StandardError; end

  def self.form_for(obj, **kwargs, &_block)
    form_obj = FormObj.new(obj)
    yield form_obj
    Tag.build("form", action: kwargs[:action] || "#", method: :post) { "\n#{form_obj.build_body}\n" }
  end

  # Tag builder
  module Tag
    SELF_CLOSING_TAGS = %w[area base basefont br col frame hr img input isindex link meta param].freeze

    def self.build(tag, **kwargs, &_block)
      tag_build = tag.to_s.downcase
      tag_attrs = kwargs.map { |attr, param| " #{attr}=\"#{param}\"" }.join
      inner_and_closed_part = SELF_CLOSING_TAGS.include?(tag_build) ? "" : "#{yield if block_given?}</#{tag_build}>"

      "<#{tag_build}#{tag_attrs}>#{inner_and_closed_part}"
    end
  end

  # struct_object with tags generator by block
  class FormObj
    def initialize(struct_object)
      @struct_object = struct_object
      @body_tags = []
    end

    def input(name_column, **kwargs)
      @body_tags << Tag.build(:label, for: name_column) { name_column.capitalize }
      add_tag = :input
      value = @struct_object.method(name_column.to_sym).call
      if kwargs[:as] == :text
        add_tag = :textarea
        attrs = { cols: 20, rows: 40, name: name_column }
        @body_tags << Tag.build(add_tag, attrs) { value }
      else
        attrs = { name: name_column, type: :text, value: value }
        @body_tags << Tag.build(add_tag, attrs)
      end
    end

    def submit
      @body_tags << Tag.build(:input, { name: :commit, type: :submit, value: :Save })
    end

    def build_body
      "\t#{@body_tags.join("\n\t")}"
    end
  end
end
