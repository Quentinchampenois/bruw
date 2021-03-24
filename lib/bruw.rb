# frozen_string_literal: true

require "colorize"
require "net/http"
require "byebug"

require "bruw/version"
require "bruw/base"
require "bruw/decidim"

module Bruw
  class Error < StandardError; end
end
