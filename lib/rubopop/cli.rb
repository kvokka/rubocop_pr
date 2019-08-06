# frozen_string_literal: true

module Rubopop
  # Cunner from CLI interface
  class CLI
    def run(args = [])
      @options = Options.new(args).parse!

      @repository = Repository.all.fetch(@options.repository)

      EnvironmentChecker.call(@repository, @options)
    end
  end
end
