class FetchWebflow
  def self.get_webflow
    client = Webflow::Client.new(ENV['WEBFLOW_API'])
    orders = Order.create_orders(client)

    Product.fetch_products(client)
    Category.fetch_categories(client)
  end
end
