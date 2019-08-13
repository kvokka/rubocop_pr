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

    # Cop processor
    class ProcessCop
      attr_reader :options, :git, :repository, :cop

      def initialize(git:, repository:, cop:, options:)
        @git = git
        @repository = repository
        @cop = cop
        @options = options
      end

      def call
        return false if exit_early?
        checkout_to_target_branch_throw_master_branch
        git.commit_all(issue.title)
        git.push
        create_pr
        true
      end

      private

      def rubocop
        @rubocop ||= RubocopPr::Rubocop.new(git: git)
      end

      def exit_early?
        return true if options.continue && cop_was_processed? || git.status.blank?
        Rubocop.correct!

        git.checkout Rubocop::TODO_FILENAME
        git.status.blank?
      end

      def cop_was_processed?
        git.branch.match cop.branch
      end

      def issue
        @issue ||= repository.issue(cop: cop, **options.to_h).create
      end

      def checkout_to_target_branch_throw_master_branch
        git.checkout(options.master_branch)
        git.checkout("#{issue.number}-#{cop.branch}")
      end

      def create_pr
        repository.pull_request(cop: cop, body: "Closes ##{issue.number}", **options.to_h).create
      end
    end

    private

    def run
      rubocop.each do |cop|
        break if options.limit <= 0

        ProcessCop.new(git: git, repository: repository, cop: cop, options: options).call
        options.limit -= 1
      end
    end
  end
end
