require 'optparse'
require 'ostruct'

require 'pry'

require "rubopop/version"
require "rubopop/options"

module Rubopop
  class Error < StandardError; end


  def run(args = ARGV)
    @options = Options.new(args).parse!

    verify_hub_version(@options.hub_version)
  end

  private

  def verify_hub_version(version)
    matches = `hub  --version`.match(/hub version (?<hub_version>(.*))/)
    installed_version = Gem::Version.new matches.fetch('hub_version')
    return true if installed_version >= Gem::Version.new(version)
    warn 'Script was tested with hub version #{HUB_VERSION}'
  rescue => e
    raise ['Script requires https://github.com/github/hub', e.message].join("\n")
  end
end
