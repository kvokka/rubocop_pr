# frozen_string_literal: true

module Rubopop
  # Service class, which only goal is to check that the system is suitable to run the script.
  class EnvironmentChecker
    def self.call(options)
      VerifyHubVersion.call(options)
      GitStatus.call(options)
    end

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

    # Check that we do not have any un-commited changes
    module GitStatus
      module_function

      def call(*)
        return true if git_status.empty?
        raise 'You have un-commited changes in this branch'
      end

      def git_status
        `git status -s`
      end
    end
  end
end
