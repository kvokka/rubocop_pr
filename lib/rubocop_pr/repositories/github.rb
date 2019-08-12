module RubocopPr
  module Repositories
    # Github repository
    class Github < RubocopPr::Repository
      # Base class for working with `hub` utility
      class Base
        attr_reader :title, :body, :cop, :number

        def initialize(cop:, **options)
          @cop = cop
          @options = options
          @title = options.delete(:title) || default_title
          @body = options.delete(:body) || default_body
        end

        def create
          @number = `#{build_command}`.split('/').last.to_i
          self
        end

        def assignees
          @assignees ||= Array options[:assignees]
        end

        def labels
          @labels ||= Array options[:labels]
        end

        def build_command
          [command, cli_options].join ' '
        end

        private

        attr_reader :options

        def command
          raise NotImplemented
        end

        def cli_options
          [].tap do |opt|
            opt << "-m '#{title}'"
            opt << "-m '#{body}'" unless body.blank?
            opt << "-a '#{assignees.join(',')}'" unless assignees.blank?
            opt << "-l '#{labels.join(',')}'" unless labels.blank?
          end.join(' ')
        end

        def default_title
          "Fix Rubocop #{cop} warnings"
        end

        def default_body
          ''
        end
      end

      # The representation of the Issue
      class Issue < Base
        def initialize(cop:, **opt)
          super
          @assignees = Array opt[:issue_assignees]
          @labels = Array opt[:issue_labels]
        end

        private

        def command
          'hub issue create'
        end

        def default_body
          'This issue was created by [rubocop_pr](https://github.com/kvokka/rubocop_pr) for ' \
            '[rubocop](https://github.com/rubocop-hq/rubocop)'
        end
      end

      # The representation of the PR
      class PullRequest < Base
        def initialize(cop:, **opt)
          super
          @assignees = Array opt[:pull_request_assignees]
          @labels = Array opt[:pull_request_labels]
        end

        private

        def command
          'hub pull-request create'
        end
      end

      class << self
        def checks
          super + [RubocopPr::Repositories::Github::Checks::VerifyHubVersion]
        end

        def issue(*args)
          Issue.new(*args)
        end

        def pull_request(*args)
          PullRequest.new(*args)
        end
      end
    end
  end
end
