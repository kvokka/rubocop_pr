# frozen_string_literal: true

module RubocopPr
  # Cunner from CLI interface
  class CLI
    attr_reader :options, :repository, :rubocop, :git

    def initialize(argv = [])
      @options = Options.new(argv).parse
      @git = Git.new(post_checkout: @options.post_checkout, origin: @options.git_origin)
      @repository = Repository.all.fetch(@options.repository)
      @rubocop = RubocopPr::Rubocop.new(branch: @options.rubocop_todo_branch, git: @git)
    end

    def run!
      EnvironmentChecker.call(repository, options)
      run
      git.checkout(options.master_branch)
    end

    private

    def run
      rubocop.inject(0) do |counter, cop|
        next counter if git.status.blank?
        next counter if options.continue && git.branch =~ /#{branch_suffix(cop)}\s/
        next counter unless rubocop.corrected?
        process_cop(cop)

        break if counter >= options.limit - 1
        counter + 1
      end
    end

    def process_cop(cop)
      git.checkout(options.master_branch)

      issue = repository.issue(cop: cop, **options.to_h).create

      git.checkout("#{issue.number}-#{branch_suffix(cop)}")
      git.commit_all(issue.title)
      git.push
      repository.pull_request(cop: cop, body: "Closes ##{issue.number}", **options.to_h).create
    end

    def branch_suffix(cop)
      "rubocop-fix-#{cop.underscore.tr('/_', '-')}"
    end
  end
end
