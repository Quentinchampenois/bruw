# frozen_string_literal: true

require 'colorize'
require 'bruw/version'
require 'bruw/base'
require 'bruw/decidim'
require 'bruw/commands/decidim'
require 'byebug'

module Bruw
  class Error < StandardError; end
end
