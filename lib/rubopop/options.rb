module Rubopop
  class Options
    attr_reader :options

    def initialize(args)
      @args = args
    end

    def parse # rubocop:disable Metrics/MethodLength
      @options = OpenStruct.new

      @parser = OptionParser.new do |opts|
        opts.banner = 'Usage: create_rubocop_prs [options]'

        @options.hub_version = '2.12.3'
        opts.on('-u [version] ','--hub-version [version]', 'Set manually minimum required version of `hub` utility (default: 2.12.3)') do |v|
          @options.hub_version = v
        end

        @options.rubocop_todo_branch = 'rubocop_todo_branch'
        opts.on('-b [branch]', '--branch [branch]', String, 'internal branch with `.rubocop_todo.yml` (default `rubocop_todo_branch`)') do |v|
          @options.rubocop_todo_branch = v
        end

        @options.post_checkout = ''
        opts.on('-r [command]', '--post-checkout [command]', String, 'Running after each git checkout (default "")') do |v|
          @options.seats = v
        end

        @options.limit = 10
        opts.on('-t [limit]', '--limit [limit]', Integer, "Limit the PS's for one run") do |v|
          @options.limit = v
        end

        @options.debug = false
        opts.on('--debug', 'Output debugging information (default false)') do |_v|
          @options.debug = true
        end

        opts.on_tail('-h', '--help', 'Display help') do
          puts opts
          exit
        end
      end

      parser.parse!(@args)

      @options
    end
  end
end
