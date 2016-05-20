# -*- ruby -*-

require "rubygems"

gem 'hoe'
require "hoe"
Hoe.plugin :git
Hoe.plugin :gemspec
Hoe.plugin :bundler
Hoe.plugin :yard

require './lib/chef_steps/version.rb'

Hoe.spec "chef_steps" do
  developer "Step1Profit", "sales@step1profit.com"

  license "MIT"

  self.version      = ChefSteps::VERSION
  self.description  = "Removes all duplicates from an unsorted list of email addresses; leaving the resulting list in the original order (same as the input)"
  self.summary      = description
  self.urls         = ['https://github.com/step1profit/chef_steps']
  self.yard_title   = 'ChefSteps'
  self.yard_markup  = 'markdown'
  self.testlib      = :minitest


  self.extra_dev_deps += [
    ["hoe-bundler",               ">= 1.2"],
    ["hoe-gemspec",               ">= 1.0"],
    ["hoe-git",                   ">= 1.6"],
    ["minitest",                  "~> 5.9.0"],
    ["yard",                      "~> 0.8"],
    ["redcarpet",                 "~> 3.3"] # yard/markdown
  ]

  self.clean_globs += [
    '.yardoc',
    'vendor',
    'Gemfile.lock',
    '.bundle',
  ]

  self.spec_extras = {
    :required_ruby_version => '>= 1.9.2'
  }

end


# vim: syntax=ruby
