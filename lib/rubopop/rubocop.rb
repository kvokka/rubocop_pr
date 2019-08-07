module Rubopop
  # small helper for rubocop commands, everything should be stubbed in tests
  class Rubocop
    include Enumerable

    TODO_FILENAME = '.rubocop_todo.yml'.freeze

    attr_reader :branch, :git

    def initialize(**options)
      @branch = options.delete(:branch)
      @git = options.delete(:git)
    end

    def todo
      YAML.safe_load(read_or_generate_todo)
    end

    def each
      git.checkout(branch)
      todos_backup = todo
      todos_backup.each_key do |cop|
        git.checkout(branch)
        todos = todos_backup.dup
        todos.delete cop
        File.open(TODO_FILENAME, 'w') { |f| f.write todos.blank? ? '' : YAML.dump(todos) }
        yield cop
      end
    end

    def read_or_generate_todo
      return File.read(TODO_FILENAME) if File.exist?(TODO_FILENAME)
      generate_todo
      git.commit_all('Generate initial Rubocop todo file')
      File.read(TODO_FILENAME)
    end

    def generate_todo
      `bundle exec rubocop --auto-gen-config`
    end

    def autofix
      `bundle exec rubocop -a`
    end
  end
end
