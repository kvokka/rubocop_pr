module Rubopop
  # small helper for rubocop commands, everything should be stubbed in tests
  class Rubocop
    class << self
      TODO_FILENAME = '.ruby-rubocop.yml'.freeze

      def todo
        YAML.safe_load(read_or_generate_todo)
      end

      def each(in_branch: nil)
        Git.checkout(in_branch) if in_branch
        todos = todo
        todos.each_key do |cop|
          Git.checkout(in_branch) if in_branch
          todos.delete cop
          File.open(TODO_FILENAME, 'w') { |f| f.write todos.blank? ? '' : YAML.dump(todos) }
          Git.commit_all("Remove Rubocop #{cop} from todo")
          yield cop
        end
      end

      def read_or_generate_todo
        return File.read(TODO_FILENAME) if File.exist?(TODO_FILENAME)
        generate_todo
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
end
