module Rubopop
  module Repositories
    module Github
      # Github repository
      class Repository < Rubopop::Repository
        class << self
          def checks
            super + [Rubopop::Repositories::Github::VerifyHubVersion]
          end
        end
      end
    end
  end
end
