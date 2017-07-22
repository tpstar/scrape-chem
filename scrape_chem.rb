require 'mechanize' #ruby library that makes automated web interaction easy.

puts "Please enter the name of a chemical."
chem_search_term = gets.strip
agent = Mechanize.new
page = agent.get("http://www.sigmaaldrich.com/catalog/search?term=#{chem_search_term}
  &interface=All&N=0&mode=match%20partialmax&lang=en&region=US&focus=product")
# get chemical name
name = page.at("a .name").text

puts name
