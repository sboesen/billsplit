$:.unshift(File.join(File.dirname(__FILE__), "/../lib"))

require 'billsplit'
require 'highline/import'
require 'colored'

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

  lineitems.push [lineitem, price]
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

p bill.lineitems




# Print bill using ljust and paint
