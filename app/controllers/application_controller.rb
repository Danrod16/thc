class ApplicationController < ActionController::Base
  require 'Rufus-scheduler'
  scheduler = Rufus::Scheduler.new
  scheduler.every '4s', FetchWebflow.get_webflow
end
