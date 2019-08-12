# frozen_string_literal: true

module RubocopPr
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
      it('continue') { is_expected.to have_key :continue }
      it('issue_labels') { is_expected.to have_key :issue_labels }
      it('pull_request_labels') { is_expected.to have_key :pull_request_labels }
      it('issue_assignees') { is_expected.to have_key :issue_assignees }
      it('pull_request_assignees') { is_expected.to have_key :pull_request_assignees }
    end
  end
end
