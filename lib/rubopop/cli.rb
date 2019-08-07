# frozen_string_literal: true

module Rubopop
  # Cunner from CLI interface
  class CLI
    attr_reader :options, :repository, :rubocop

    def initialize(argv = [])
      @options = Options.new(argv).parse
      @repository = Repository.all.fetch(@options.repository)
      @rubocop = Rubopop::Rubocop.new(branch: options.rubocop_todo_branch)
    end

    def run!
      EnvironmentChecker.call(repository, options)
      run
    end

    private

    def run
      rubocop.each do |cop|
        rubocop.autofix
        next if Git.status.blank?
        Git.checkout(options.master_branch)
        title = "Fix Rubocop #{cop} warnings"
        Git.commit_all(title)
        issue_number = repository.create_issue(title: title)
        repository.create_pull_request(title: title, body: "Closes ##{issue_number}")
      end
    end
  end
end
