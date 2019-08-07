# frozen_string_literal: true

module Rubopop
  RSpec.describe Options do
    context 'parse' do
      subject { described_class.new([]).parse }

      it('should be OpenStruct') { is_expected.to be_a OpenStruct }
    end

    context 'has default values for' do
      subject { described_class.new([]).parse.to_h }

      it('hub_version') { is_expected.to have_key :hub_version }
      it('repository') { is_expected.to have_key :repository }
      it('rubocop_todo_branch') { is_expected.to have_key :rubocop_todo_branch }
      it('master_branch') { is_expected.to have_key :master_branch }
      it('post_checkout') { is_expected.to have_key :post_checkout }
      it('git_origin') { is_expected.to have_key :git_origin }
      it('limit') { is_expected.to have_key :limit }
      it('debug') { is_expected.to have_key :debug }
    end
  end
end
