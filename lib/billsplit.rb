class Bill
  # Manages all information required with a Bill
  #
  # Has People
  # Has LineItems
  # Maps LineItems to People

  attr_accessor :lineitems, :people
end

class Person
end

class LineItem
end
