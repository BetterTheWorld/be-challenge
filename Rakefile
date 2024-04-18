require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require './app'

RSpec::Core::RakeTask.new(:spec)

desc "Generate ERD of all models"
task :erd do
  require "rails_erd/diagram/graphviz"
  RailsERD.options.filetype = :pdf
  RailsERD::Diagram::Graphviz.create
end
