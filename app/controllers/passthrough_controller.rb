class PassthroughController < ApplicationController
  def index
  path =  case current_user.role
          when "admin"
            current_day
          when "cook"
            current_day
          when "rider"
            rider_path(current_user.riders.first)
    end
    redirect_to path
  end

  private

  def current_day
    day = Date.today.strftime("%A").downcase
    if day == "sunday" || day == "saturday"
      "/monday"
    else
      "/#{day}"
    end
  end
end
