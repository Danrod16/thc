class PassthroughController < ApplicationController
  def index
  path =  case current_user.role
          when 'Cook'
              root_path
          # when 'Delivery'
          #   rails_admin_path
          when 'Admin'
            orders_path
    end
    path = current_day
    redirect_to path
  end

  private

  def current_day
    day = Date.today.strftime("%A").downcase
    "/#{day}"
  end
end
