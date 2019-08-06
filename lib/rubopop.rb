# frozen_string_literal: true

require 'optparse'
require 'ostruct'

require 'pry'

require 'rubopop/version'
require 'rubopop/options'
require 'rubopop/environment_checker'

# The entry point
module Rubopop
  class Error < StandardError; end

  HUB_VERSION = '2.12.3'.freeze

  def run(args = [])
    @options = Options.new(args).parse!

    EnvironmentChecker.call(@options)
  end
end
