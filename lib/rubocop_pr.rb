# frozen_string_literal: true

require 'optparse'
require 'ostruct'
require 'active_support/core_ext/hash'
require 'yaml'

require 'pry'

require 'rubocop_pr/version'
require 'rubocop_pr/options'
require 'rubocop_pr/environment_checker'
require 'rubocop_pr/cli/process_cop'
require 'rubocop_pr/cop'
require 'rubocop_pr/rubocop'
require 'rubocop_pr/git'
require 'rubocop_pr/repository'
require 'rubocop_pr/repositories/github'
require 'rubocop_pr/repositories/github/checks/verify_hub_version'
require 'rubocop_pr/cli'

# The entry point
module RubocopPr
  class Error < StandardError; end

  HUB_VERSION = '2.12.3'.freeze
end
