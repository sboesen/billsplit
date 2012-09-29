class Bill
  # Manages all information required with a Bill
  #
  # Has People
  # Has LineItems
  # Maps LineItems to People

  attr_accessor :lineitems
  def initialize
    self.lineitems = []
  end
end

class LineItem
  attr_accessor :name, :price, :people
end
