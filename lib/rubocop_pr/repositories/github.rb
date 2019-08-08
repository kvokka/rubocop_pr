module RubocopPr
  module Repositories
    # Github repository
    class Github < RubocopPr::Repository
      # The representation of the Issue
      class Issue
        attr_reader :title, :body

        def initialize(title:, **other)
          @title = title
          @body = other[:body] || default_body
        end

        def create
          link = `hub issue create -m '#{title}' -m '#{body}'`
          link.split('/').last.to_i
        end

        def default_body
          'This issue was created by [rubocop_pr](https://github.com/kvokka/rubocop_pr) for ' \
            '[rubocop](https://github.com/rubocop-hq/rubocop)'
        end
      end

      # The representation of the PR
      class PullRequest
        attr_reader :title, :body

        def initialize(title:, **other)
          @title = title
          @body = other[:body] || ''
        end

        def create
          link = `hub pull-request create -m '#{title}' -m '#{body}'`
          link.split('/').last.to_i
        end
      end

      class << self
        def checks
          super + [RubocopPr::Repositories::Github::Checks::VerifyHubVersion]
        end

        def create_issue(*args)
          Issue.new(*args).create
        end

        def create_pull_request(*args)
          PullRequest.new(*args).create
        end
      end
    end
  end
end
