# frozen_string_literal: true

module Rubopop
  # Cunner from CLI interface
  class CLI
    attr_reader :options, :repository, :rubocop, :git

    def initialize(argv = [])
      @options = Options.new(argv).parse
      @git = Git.new(post_checkout: @options.post_checkout, origin: @options.git_origin)
      @repository = Repository.all.fetch(@options.repository)
      @rubocop = Rubopop::Rubocop.new(branch: @options.rubocop_todo_branch, git: @git)
    end

    def run!
      EnvironmentChecker.call(repository, options)
      run
    end

    private

    def run
      rubocop.inject(0) do |counter, cop|
        next counter if git.status.blank?
        prepare_fixed_files(cop)
        next counter if git.status.blank?
        process_cop(cop)

        break if counter >= options.limit - 1
        counter + 1
      end
      git.checkout(options.master_branch)
    end

    def process_cop(cop)
      git.checkout(options.master_branch)
      title = "Fix Rubocop #{cop} warnings"
      issue_number = repository.create_issue(title: title)
      git.checkout("#{issue_number}-rubocop-fix-#{cop.underscore.tr('/_', '-')}")
      git.commit_all(title)
      git.push
      repository.create_pull_request(title: title, body: "Closes ##{issue_number}")
    end

    def prepare_fixed_files(cop)
      git.commit_all("Remove only Rubocop #{cop} from todo")
      rubocop.autofix
    end
  end
end
