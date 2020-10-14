class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.delivered.subject
  #
  def delivered
    @order = params[:order]
    @email = @order.customer_email
    @name = @order.customer_name
    mail(to: @email, subject: 'Tu Pedido ha sido entregado!')
  end
end
