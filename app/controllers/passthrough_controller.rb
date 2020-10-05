class PassthroughController < ApplicationController
  def index
  # path =  case current_user.role
  #         when 'cook'
  #             current_day
  #         when 'delivery'
  #           rails_admin_path
  #         when 'admin'
  #           set_teacher
  #           teacher_path(@teacher)
  #   end
    path = current_day
    redirect_to path
  end

  private

  def current_day
    day = Date.today.strftime("%A").downcase
    "/#{day}"
  end
end
