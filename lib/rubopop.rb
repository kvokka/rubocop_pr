# frozen_string_literal: true

require 'optparse'
require 'ostruct'

require 'pry'

require 'rubopop/version'
require 'rubopop/options'
require 'rubopop/environment_checker'
require 'rubopop/repository'
require 'rubopop/repositories/github/repository'
require 'rubopop/repositories/github/verify_hub_version'
require 'rubopop/cli'

# The entry point
module Rubopop
  class Error < StandardError; end

  HUB_VERSION = '2.12.3'.freeze
end
