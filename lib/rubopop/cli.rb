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
      Rubopop::Rubocop.each(in_branch: options.rubocop_todo_branch) do |cop|
        Rubopop::Rubocop.autofix
        next if Git.status.blank?
        Git.checkout(options.master_branch)
        Git.commit_all("Fix Rubocop #{cop}")
      end
    end
  end
end
