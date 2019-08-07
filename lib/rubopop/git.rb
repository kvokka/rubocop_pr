module Rubopop
  # small helper for git commands
  class Git
    class << self
      def status
        `git status -s`
      end

      def checkout(branch)
        `git checkout #{branch}`
        return true if $?.success?
        `git checkout -b #{branch}`
      end

      def commit_all(message)
        `git add .`
        `git commit -m #{message}`
      end
    end
  end
end