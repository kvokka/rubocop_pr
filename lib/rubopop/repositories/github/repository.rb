module Rubopop
  module Repositories
    module Github
      # Github repository
      class Repository < Rubopop::Repository
        # The representation of the Issue
        class Issue
          attr_reader :title, :body

          def initialize(title:, body:, **_other)
            @title = title
            @body = body
          end

          def create
            link = `hub issue create -m #{title} -m #{body}`
            link.split('/').last.to_i
          end
        end

        class << self
          def checks
            super + [Rubopop::Repositories::Github::VerifyHubVersion]
          end

          def create_issue(*args)
            Issue.new(*args).create
          end
        end
      end
    end
  end
end
