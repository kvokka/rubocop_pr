module RubocopPr
  # small helper for git commands, everything should be stubbed in tests
  class Git
    attr_reader :post_checkout, :origin

    def initialize(post_checkout: '', origin: '', **_options)
      @post_checkout = post_checkout
      @origin = origin
    end

    def checkout(file_or_branch)
      return process_post_checkout if exec_checkout(file_or_branch)
      exec_checkout file_or_branch, flags: ['-b']
      process_post_checkout
    end

    def commit_all(message)
      system 'git add .'
      system "git commit -m '#{message}'"
    end

    def push
      system "git push --set-upstream #{origin} #{current_branch}"
    end

    def current_branch
      `git branch --show-current`.chomp
    end

    def status
      `git status -s`
    end

    def branch
      `git branch`
    end

    private

    def process_post_checkout
      post_checkout.blank? ? true : exec_post_checkout
    end

    def exec_checkout(branch, flags: [])
      system "git checkout #{flags.join(' ')} #{branch}"
    end

    def exec_post_checkout
      system post_checkout.to_s
    end
  end
end
