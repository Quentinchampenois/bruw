# frozen_string_literal: true

require 'cucumber/rspec/doubles'
require 'bruw/decidim'

Given('I am in a Decidim project') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I run "bruw decidim version" in a Decidim project') do
  allow(Bruw::Decidim).to receive(:version).and_return('0.23.4')
end
