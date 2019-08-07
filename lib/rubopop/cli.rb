# frozen_string_literal: true

module Rubopop
  # Cunner from CLI interface
  class CLI
    attr_reader :options, :repository

    def initialize(argv = [])
      @options = Options.new(argv).parse
      @repository = Repository.all.fetch(@options.repository)
    end

    def run!
      EnvironmentChecker.call(repository, options)
      run
    end

    private

    def run
      Rubopop::Rubocop.each(in_branch: options.rubocop_todo_branch) do |_cop|
        next if Git.status.blank?
      end
    end
  end
end
