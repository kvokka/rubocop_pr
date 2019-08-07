module Rubopop
  # small helper for rubocop commands, everything should be stubbed in tests
  class Rubocop
    class << self
      TODO_FILENAME = '.ruby-rubocop.yml'.freeze

      def todo
        YAML.safe_load(read_or_generate_todo)
      end

      def read_or_generate_todo
        return File.read(TODO_FILENAME) if File.exist?(TODO_FILENAME)
        generate_todo
        File.read(TODO_FILENAME)
      end

      def generate_todo
        `bundle exec rubocop --auto-gen-config`
      end
    end
  end
end
