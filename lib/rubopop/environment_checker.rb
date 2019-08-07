# frozen_string_literal: true

module Rubopop
  # Service class, which only goal is to check that the system is suitable to run the script.
  class EnvironmentChecker
    def self.checks
      @checks ||= [GitStatus]
    end

    def self.call(repository, options)
      checks.each { |c| c.call options }
      repository.checks.each { |c| c.call options }
    end

    # Check that we do not have any un-commited changes
    module GitStatus
      module_function

      def call(*)
        return true if git_status.empty?
        raise 'You have un-commited changes in this branch'
      end

      def git_status
        Rubopop::Git.new.status
      end
    end
  end
end
