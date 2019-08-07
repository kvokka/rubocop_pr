# Rubopop

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/8be41ff90d294d7bb4c01fb3c98ebac9)](https://app.codacy.com/app/kvokka/rubopop?utm_source=github.com&utm_medium=referral&utm_content=kvokka/rubopop&utm_campaign=Badge_Grade_Dashboard)

[![Version               ][rubygems_badge]][rubygems]
[![Build Status          ][travisci_badge]][travisci]
[![Codacy Badge          ][codacy_badge]][codacy]
[![Reviewed by Hound     ][hound_badge]][hound]

CLI Issues and PR creator for Rubocop Cops. 1 linter == 1 issue == 1 PR.

With Rubopop you can apply [Rubocop][rubocop_repo] clean and in a few minutes.

## Requirements

* Ruby 2.1+
* Hub 2.12.3 (tested with this version only, but should work with older versions)
* Github

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubopop', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubopop

## Usage

```bash
Usage: rubopop [options]
    -u, --hub-version [version]      Set manually minimum required version of 'hub' utility for github (default: 2.12.3)
    -b, --branch [branch]            internal branch with '.rubocop_todo.yml' (default: 'rubocop_todo_branch')
    -m, --master [branch]            branch which will be the base for all PR's (default: 'master')
    -r, --post-checkout [command]    Running after each git checkout (default: "")
    -l, --limit [limit]              Limit the PS's for one run (default: 10)
    -g, --repository [name]          Set repository host (default: github)
    -o, --origin [origin]            origin option for 'git push' (default: 'origin')
    -c, --continue                   Continue previous session (default: false)
    -v, --version                    Display version
    -h, --help                       Display help
```

#### Notes

* `brach` option is useful, if you want to prepare the `.rubocop-todo.yml` manually and feed it to `rubopop`
* `post-checkout` handy for old Ruby versions, when shell may "forget" Ruby version.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubopop. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant][contributor_covenant_link] code of conduct.

## License

The gem is available as open source under the terms of the [MIT License][mit_link].

## Code of Conduct

Everyone interacting in the Rubopop project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct][code_of_conduct_link].


[rubocop_repo]: https://github.com/rubocop-hq/rubocop
[contributor_covenant_link]: http://contributor-covenant.org
[mit_link]: https://opensource.org/licenses/MIT
[code_of_conduct_link]: https://github.com/[USERNAME]/rubopop/blob/master/CODE_OF_CONDUCT.md

[travisci_badge]: https://travis-ci.org/kvokka/rubopop.svg?branch=master
[travisci]: https://travis-ci.org/kvokka/rubopop
[rubygems]: https://rubygems.org/gems/rubopop
[rubygems_badge]: http://img.shields.io/gem/v/rubopop.svg
[codacy_badge]: https://api.codacy.com/project/badge/update_me
[codacy]: https://www.codacy.com/app/kvokka/rubopop?utm_source=github.com&amp;utm_medium=referral&amp;
       │ utm_content=kvokka/rubopop&amp;utm_campaign=Badge_Grade
[hound_badge]: https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg
[hound]: https://houndci.com