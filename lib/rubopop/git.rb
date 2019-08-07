module Rubopop
  # small helper for git commands, everything should be stubbed in tests
  class Git
    attr_reader :post_checkout

    def initialize(post_checkout: '', **_options)
      @post_checkout = post_checkout
    end

    def status
      `git status -s`
    end

    def checkout(branch)
      `git checkout #{branch}`
      return process_post_checkout if $CHILD_STATUS.success?
      `git checkout -b #{branch}`
      process_post_checkout
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

    private

    def process_post_checkout
      post_checkout.blank? ? true : `#{post_checkout}`
    end
  end
end
