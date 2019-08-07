module Rubopop
  module Repositories
    class Github < Rubopop::Repository
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
            Gem::Version.new matches.named_captures.fetch('hub_version')
          rescue StandardError
            raise "Robopop requires https://github.com/github/hub version >= #{Rubopop::HUB_VERSION}"
          end

          def hub_version
            `hub  --version`
          end
        end
      end
    end
  end
end
