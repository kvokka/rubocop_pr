module RubocopPr
  module Repositories
    class Github < RubocopPr::Repository
      module Checks
        # Check, if `hub` installed and have right version
        module VerifyHubVersion
          module_function

          def call(options)
            return true if system_hub_version >= Gem::Version.new(options.hub_version)
            warn "Script was tested with hub version #{HUB_VERSION}, while you are using #{system_hub_version}"
            true
          end

          def system_hub_version
            matches = hub_version.match(/hub version (?<hub_version>(.*))/)
            Gem::Version.new matches.captures.last
          rescue StandardError
            raise "Robopop requires https://github.com/github/hub version >= #{RubocopPr::HUB_VERSION}"
          end

          def hub_version
            `hub  --version`
          end
        end
      end
    end
  end
end
