class PassthroughController < ApplicationController
  def index
  path =  case current_user.role
          when 'Cook'
              current_day
          when 'Delivery'
              deliveries_path
          when 'Admin'
            orders_path
    end
    redirect_to path
  end

  private

  def current_day
    day = Date.today.strftime("%A").downcase
    "/#{day}"
  end
end
