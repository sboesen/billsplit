$:.unshift(File.join(File.dirname(__FILE__), "/../lib"))

require 'billsplit'
require 'highline/import'
require 'colored'
require 'money'

bill = Bill.new

# Get list of people

puts "welcome to billsplit!"

people = ask( "Enter names (or a blank line to quit):", lambda { |ans| ans =~ /^-?\d+$/ ? Integer(ans) : ans} ) do |q|
  q.gather = ""
end

say("People:")

lineitems = []
while true do
  puts "Enter grocery items (or a blank line to quit):"
  lineitem = gets.chomp

  break if lineitem == ""

  puts "Price?"
  price = gets.chomp
  
  break if price == ""

  lineitems.push [lineitem, Money.new(price.to_f*100, "USD")]
end

# Set option text to be like
#
# Adam: 0, Kathryn: 1, Stefan: 2
optionText = ""
i = 0
people.each do |person|
  optionText += "#{person}: "
  optionText += i.even? ? i.to_s.blue.bold : i.to_s.yellow.bold
  optionText += "," unless i == people.size-1
  optionText += " "
  i += 1
end

lineitems.each do |lineitem, price|
  puts lineitem
  puts "Who wants " + lineitem.red.bold + "? " + optionText 

  currentItem = LineItem.new
  currentItem.name = lineitem
  currentItem.price = price

  lineItemPeople = ask( "Enter numbers (or a blank line to quit):", lambda { |ans| ans =~ /^-?\d+$/ ? Integer(ans) : ans} ) do |q|
    q.gather = ""
  end

  currentItem.people = lineItemPeople
  bill.lineitems.push currentItem
end

# Print bill using ljust and paint
puts "Item                    Price"
puts "----                    -----"
bill.lineitems.each do |lineitem|
  i = 0
  people_string = ""
  people.each do |person|
    if lineitem.people.include? i
      #this person needs to pay for this
      people_string += person.rjust(16).white
      people_string += ": $" + (lineitem.price / lineitem.people.size).to_s.ljust(6)
    else
      people_string += person.rjust(16).white
      people_string += ": $" + "0.00".ljust(6)
    end
    i += 1
  end
  puts lineitem.name.ljust(24) + "$" + lineitem.price.to_s + people_string
end

# calculate totals

totals = Hash.new(Money.new(0, "USD"))
bill.lineitems.each do |lineitem|
  i = 0
  people.each do |person|
    if lineitem.people.include? i
      totals[i] += (lineitem.price / lineitem.people.size)
    end
    i += 1
  end
end

# print totals
puts "\nTotals                        "
puts "------------------------------"
# 30 chars then start printing
totals.each do |person, total|
  puts "#{people[person]}: #{total}"
end

