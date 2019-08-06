# frozen_string_literal: true

module Rubopop
  # Cunner from CLI interface
  class CLI
    def run(args = [])
      @options = Options.new(args).parse!

      EnvironmentChecker.call(@options)
    end
  end
end
