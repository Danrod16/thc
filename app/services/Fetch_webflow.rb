class FetchWebflow
  def self.get_webflow
    client = Webflow::Client.new(ENV['WEBFLOW_API'])
    Category.fetch_categories(client)
    Product.fetch_products(client)
    Order.create_orders(client)
  end
end
