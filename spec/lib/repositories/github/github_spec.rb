# frozen_string_literal: true

module RubocopPr
  module Repositories
    class Github < RubocopPr::Repository
      RSpec.describe Github do
        context 'class methods' do
          let(:cop) { 'cop_name' }
          let(:args) { { cop: cop } }
          it { expect(described_class.issue(**args)).to be_a Issue }
          it { expect(described_class.pull_request(**args)).to be_a PullRequest }
        end
      end

      RSpec.describe Issue do
        let(:cop) { 'cop_name' }
        subject { described_class.new(**args) }

        context 'no options' do
          let(:args) { { cop: cop } }
          let(:body) do
            'This issue was created by '\
            '[rubocop_pr](https://github.com/kvokka/rubocop_pr) for '\
            '[rubocop](https://github.com/rubocop-hq/rubocop)'
          end

          it('should use default name') { expect(subject.title).to eq 'Fix Rubocop cop_name warnings' }
          it('should use default body') { expect(subject.body).to eq body }
          it('assignees should not be set') { expect(subject.assignees).to be_empty }
          it('labels should not be set') { expect(subject.labels).to be_empty }
          it { expect(subject.assignees).to be_a Array }
          it { expect(subject.labels).to be_a Array }
        end

        context 'custom title' do
          let(:args) { { cop: cop, title: 'my_title' } }
          let(:build_command) do
            "hub issue create -m 'my_title' -m 'This issue was created by "\
            '[rubocop_pr](https://github.com/kvokka/rubocop_pr) for '\
            "[rubocop](https://github.com/rubocop-hq/rubocop)'"
          end

          it('should use my title') { expect(subject.title).to eq 'my_title' }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end

        context 'custom body' do
          let(:args) { { cop: cop, body: 'my_body' } }
          let(:build_command) { "hub issue create -m 'Fix Rubocop cop_name warnings' -m 'my_body'" }

          it('should use my body') { expect(subject.body).to eq 'my_body' }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end

        context 'custom assignees' do
          let(:args) { { cop: cop, issue_assignees: %w[me you] } }
          let(:build_command) do
            "hub issue create -m 'Fix Rubocop cop_name warnings' -m 'This issue was created by "\
            '[rubocop_pr](https://github.com/kvokka/rubocop_pr) for '\
            "[rubocop](https://github.com/rubocop-hq/rubocop)' -a 'me,you'"
          end

          it('should use assignees') { expect(subject.assignees).to match_array %w[me you] }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end

        context 'custom labels' do
          let(:args) { { cop: cop, issue_labels: %w[foo bar] } }
          let(:build_command) do
            "hub issue create -m 'Fix Rubocop cop_name warnings' -m 'This issue was created by "\
            '[rubocop_pr](https://github.com/kvokka/rubocop_pr) for '\
            "[rubocop](https://github.com/rubocop-hq/rubocop)' -l 'foo,bar'"
          end

          it('should use labels') { expect(subject.labels).to match_array %w[foo bar] }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end
      end

      RSpec.describe PullRequest do
        let(:cop) { 'cop_name' }
        subject { described_class.new(**args) }

        context 'no options' do
          let(:args) { { cop: cop } }

          it('should use default name') { expect(subject.title).to eq 'Fix Rubocop cop_name warnings' }
          it('should use default body') { expect(subject.body).to be_empty }
          it('assignees should not be set') { expect(subject.assignees).to be_empty }
          it('labels should not be set') { expect(subject.labels).to be_empty }
          it { expect(subject.assignees).to be_a Array }
          it { expect(subject.labels).to be_a Array }
        end

        context 'custom title' do
          let(:args) { { cop: cop, title: 'my_title' } }
          let(:build_command) { "hub pull-request create -m 'my_title'" }

          it('should use my title') { expect(subject.title).to eq 'my_title' }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end

        context 'custom body' do
          let(:args) { { cop: cop, body: 'my_body' } }
          let(:build_command) { "hub pull-request create -m 'Fix Rubocop cop_name warnings' -m 'my_body'" }

          it('should use my body') { expect(subject.body).to eq 'my_body' }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end

        context 'custom assignees' do
          let(:args) { { cop: cop, pull_request_assignees: %w[me you] } }
          let(:build_command) { "hub pull-request create -m 'Fix Rubocop cop_name warnings' -a 'me,you'" }

          it('should use assignees') { expect(subject.assignees).to match_array %w[me you] }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end

        context 'custom labels' do
          let(:args) { { cop: cop, pull_request_labels: %w[foo bar] } }
          let(:build_command) { "hub pull-request create -m 'Fix Rubocop cop_name warnings' -l 'foo,bar'" }

          it('should use labels') { expect(subject.labels).to match_array %w[foo bar] }
          it('build_command') { expect(subject.build_command).to eq build_command }
        end
      end
    end
  end
end
