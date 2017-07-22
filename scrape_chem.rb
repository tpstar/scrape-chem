require 'mechanize' #ruby library that makes automated web interaction easy.

puts "Please enter the name of a chemical."
chem_search_term = gets.strip
agent = Mechanize.new
page = agent.get("http://www.sigmaaldrich.com/catalog/search?term=#{chem_search_term}
  &interface=All&N=0&mode=match%20partialmax&lang=en&region=US&focus=product")
# get chemical name
name = page.at("a .name").text
puts "name: #{name}"

# get properties from the page (formula, fw)
properties = []
page.at(".nonSynonymProperties").css("p").map do |p|
  property = p.text
  properties.push(property)
end
# get formula
formula = properties[0].split(":").last
formula[0] = "" #this is to remove weird white space left after split
puts "formula: #{formula}"
# get molecular weight (formula weight)
fw = properties[1].split(":").last
fw[0] = ""  #this is to remove weird white space left after split
puts "molecular weight: #{fw}"
