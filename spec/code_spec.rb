# frozen_string_literal: true

require 'spec_helper'

User = Struct.new(:name, :job, keyword_init: true)

RSpec.describe HexletCode do
  it 'new' do
    user = User.new name: 'rob'

    actual = HexletCode.form_for user, url: '#' do |f|
      f.input :name, class: 'user-input'
      f.input :job
      f.submit
    end

    expected_matcher = have_tag('form') do
      with_tag 'label', with: { for: 'name' }
      with_tag 'input', with: { value: user.name, name: 'name', type: 'text', class: 'user-input' }
      with_tag 'label', with: { for: 'job' }
      with_tag 'input', with: { type: 'text', name: 'job' }
      with_tag 'input', with: { type: 'submit', value: 'Save' }
    end

    expect(actual).to expected_matcher
  end

  it 'existed' do
    user = User.new job: 'hexlet'

    actual = HexletCode.form_for user, url: '#' do |f|
      f.input :name
      f.input :job, as: :text, rows: 50, cols: 50
      f.submit 'Wow'
    end

    expected_matcher = have_tag('form') do
      with_tag 'label', with: { for: 'name' }
      with_tag 'input', with: { name: 'name', type: 'text' }
      with_tag 'label', with: { for: 'job' }
      with_tag 'textarea', with: { name: 'job', rows: 50, cols: 50 }
      with_tag 'input', with: { type: 'submit', value: 'Wow' }
    end

    expect(actual).to expected_matcher
  end

  it 'send not exists user method' do
    user = User.new

    actual = lambda do
      HexletCode.form_for user do |f|
        f.input :company
        f.submit 'Boom!'
      end
    end

    expect(actual).to raise_error NoMethodError
  end
end
