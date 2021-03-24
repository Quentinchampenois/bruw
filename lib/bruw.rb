# frozen_string_literal: true

require "colorize"
require "net/http"
require "byebug"
require "thor"

require "bruw/version"
require "bruw/base"
require "bruw/decidim"
require "bruw/commands/decidim"

module Bruw
  class Error < StandardError; end
end
