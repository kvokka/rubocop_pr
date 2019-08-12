# frozen_string_literal: true

module RubocopPr
  # Parse the options from the command line
  class Options
    attr_reader :options, :args

    def initialize(args)
      @args = args
      @options = OpenStruct.new
    end

    def parse
      build_parser.parse!(args)
      options
    end

    class BuildParser
      def initialize

      end
    end

    private

    attr_accessor :opts

    def build_parser # rubocop:disable Metrics/MethodLength
      @parser = OptionParser.new do |op|
        self.opts = op
        opts.banner = 'Usage: rubocop_pr [options]'

        private_methods(false).map(&:to_s).select{|m| m.start_with?('add_') }.each{|m| send m }
      end
    end

    def add_limit_option
      @options.limit = 10
      msg = "Limit the PS's for one run (default: 10)"
      opts.on('-l [limit]', '--limit [limit]', Integer, msg) do |v|
        @options.limit = v
      end
    end

    def add_post_checkout_option
      @options.post_checkout = ''
      msg = 'Running after each git checkout (default: "")'
      opts.on('-r [command]', '--post-checkout [command]', String, msg) do |v|
        @options.post_checkout = v
      end
    end

    def add_rubocop_todo_branch_option
      @options.rubocop_todo_branch = 'rubocop_todo_branch'
      msg = "internal branch with '.rubocop_todo.yml' (default: 'rubocop_todo_branch')"
      opts.on('-b [branch]', '--branch [branch]', String, msg) do |v|
        @options.rubocop_todo_branch = v
      end
    end

    def add_master_branch_option
      @options.master_branch = 'master'
      msg = "branch which will be the base for all PR's (default: 'master')"
      opts.on('-m [branch]', '--master [branch]', String, msg) do |v|
        @options.master_branch = v
      end
    end

    def add_git_origin_option
      @options.git_origin = 'origin'
      msg = "origin option for 'git push' (default: 'origin')"
      opts.on('-o [origin]', '--origin [origin]', String, msg) do |v|
        @options.git_origin = v
      end
    end

    def add_hub_version_option
      @options.hub_version = HUB_VERSION
      msg = "Set manually minimum required version of 'hub' utility for github (default: #{HUB_VERSION})"
      opts.on('-u [version] ', '--hub-version [version]', msg) do |v|
        @options.hub_version = v
      end
    end

    def add_repository_option
      @options.repository = 'github'
      msg = 'Set repository host (default: github)'
      opts.on('-g [name] ', '--repository [name]', msg) do |v|
        @options.repository = v
      end
    end

    def add_continue_option
      @options.continue = false
      opts.on('-c', '--continue', 'Continue previous session (default: false)') do |_v|
        @options.continue = true
      end
    end

    def add_version_option
      opts.on('-v', '--version', 'Display version') do
        puts RubocopPr::VERSION
        exit
      end
    end

    def add_on_tail
      opts.on_tail('-h', '--help', 'Display help') do
        puts opts
        exit
      end
    end
  end
end
