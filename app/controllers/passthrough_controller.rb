class PassthroughController < ApplicationController
  def index
  path =  case current_user.role
          when "admin"
            current_day
          when "cook"
            current_day
          when "rider"
              deliveries_path
    end
    redirect_to path
  end

  private

  def current_day
    day = Date.today.strftime("%A").downcase
    "/#{day}"
  end
end
