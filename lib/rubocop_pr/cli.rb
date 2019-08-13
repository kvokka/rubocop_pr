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
      git.checkout Rubocop::TODO_FILENAME
      git.checkout(options.master_branch)
    end

    private

    def run
      rubocop.each do |cop|
        break if options.limit <= 0

        next unless ProcessCop.new(git: git, repository: repository, cop: cop, options: options).call
        options.limit -= 1
      end
    end
  end
end
