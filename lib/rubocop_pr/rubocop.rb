module RubocopPr
  # small helper for rubocop commands, everything should be stubbed in tests
  class Rubocop
    include Enumerable

    TODO_FILENAME = '.rubocop_todo.yml'.freeze

    class << self
      def generate_todo
        system 'bundle exec rubocop --auto-gen-config'
      end

      def correct!
        system 'bundle exec rubocop -a'
      end
    end

    attr_reader :branch, :git

    def initialize(**options)
      @branch = options.delete(:branch)
      @git = options.delete(:git)
    end

    def todo
      @todo ||= YAML.safe_load(read_or_generate_todo)
    end

    def each
      todo.keys.sort.reverse_each do |cop|
        git.checkout(branch)
        File.open(TODO_FILENAME, 'w') do |f|
          f.write todo.except(cop.to_s).blank? ? '' : YAML.dump(todo.except(cop.to_s))
        end
        yield Cop.new(name: cop)
      end
    end

    def read_or_generate_todo
      git.checkout(branch)
      return File.read(TODO_FILENAME) if File.exist?(TODO_FILENAME)
      self.class.generate_todo
      git.commit_all('Generate initial Rubocop todo file')
      File.read(TODO_FILENAME)
    end
  end
end
