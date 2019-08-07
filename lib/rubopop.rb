# frozen_string_literal: true

require 'optparse'
require 'ostruct'
require 'active_support/core_ext/hash'
require 'yaml'

require 'pry'

require 'rubopop/version'
require 'rubopop/options'
require 'rubopop/environment_checker'
require 'rubopop/rubocop'
require 'rubopop/git'
require 'rubopop/repository'
require 'rubopop/repositories/github'
require 'rubopop/repositories/github/checks/verify_hub_version'
require 'rubopop/cli'

# The entry point
module Rubopop
  class Error < StandardError; end

  HUB_VERSION = '2.12.3'.freeze
end
