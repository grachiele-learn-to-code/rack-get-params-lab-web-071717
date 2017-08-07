class Application

  @@cart = []

  @@items = ["Apples","Carrots","Pears"]

  def call(env)
    @resp = Rack::Response.new
    @req = Rack::Request.new(env)

    if @req.path.match(/items/)
      @@items.each do |item|
        @resp.write "#{item}\n"
      end
    elsif @req.path.match(/search/)
      search_term = @req.params["q"]
      @resp.write handle_search(search_term)
    elsif @req.path.match(/cart/)
      cart_display_or_empty
    elsif @req.path.match(/add/)
      item = @req.params["item"]
      add_stuff_to_cart(item)
      # binding.pry
    else
      @resp.write "Path Not Found"
    end

    @resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def cart_display_or_empty
    if @@cart.empty?
      @resp.write "Your cart is empty"
    else
      @@cart.each do |item|
        @resp.write "#{item}\n"
      end
    end
  end

  def add_stuff_to_cart(item)
    if @@items.include?(item)
      @@cart << item
      @resp.write "added #{item}"
    else
      @resp.write "We don't have that item"
    end
  end
end
