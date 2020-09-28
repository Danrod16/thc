class WebflowCall < ApplicationController
  require 'webflow-ruby'

  def create
    webflow_client
  end

  private
  def webflow_client
    client = Webflow::Client.new(ENV['WEBFLOW_API'])
  end
end
