module Rubopop
  # small helper for git commands, everything should be stubbed in tests
  class Git
    class << self
      def status
        `git status -s`
      end

      def checkout(branch)
        `git checkout #{branch}`
        return true if $CHILD_STATUS.success?
        `git checkout -b #{branch}`
      end

      def commit_all(message)
        `git add .`
        `git commit -m #{message}`
      end

      def push(origin)
        `git push --set-upstream #{origin} #{current_branch}`
      end

      def current_branch
        `git branch --show-current`.chomp
      end
    end
  end
end
