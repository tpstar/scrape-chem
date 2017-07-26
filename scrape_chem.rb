require 'mechanize' #ruby library that makes automated web interaction easy.
require 'uri' # URI is a module providing classes to handle Uniform Resource Identifiers

puts "Please enter the name of a chemical."
chem_search_term = URI.encode(gets.strip)
agent = Mechanize.new
page = agent.get("http://www.sigmaaldrich.com/catalog/search?term=#{chem_search_term}
  &interface=All&N=0&mode=match%20partialmax&lang=en&region=US&focus=product")

# get chemical name
name = page.at("a .name").text
puts "name: #{name}"

# get properties from the page (formula, fw)
properties = []
page.search(".nonSynonymProperties p").map do |p|
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

# some chemical pages have a product link before the actual product link
# e.g. methylene chloride: in greener alternative ... there is a link to ethyl acetate/ethanol
# that element has class of resultsTextBanner
# Let's call that banner
banner = page.search(".resultsTextBanner").css("a").text

!!banner ? link_id = 1 : link_id = 0
#puts banner
# click product link
product_page = page.links_with(href: %r{^/catalog/product/\w+})[2].click
# some chemical pages have a product link before the actual product link
# e.g. methylene chloride: in greener alternative ... there is a link to ethyl acetate/ethanol
# get more properties from product page (generate arrays of strings of keys and values)
more_properties = []
product_page.css("#productDetailProperties td").text.split(/\n/).map do |p|
  more_properties.push(p.strip) unless p.strip.empty?
end

# get density (get index of "density" first; density value comes after "density" in more_properties array)
density_index = more_properties.index("density")
density = more_properties[density_index + 2]
puts "density: #{density}"
# get mp (get index of "mp" first; mp value comes after "mp" in more_properties array)
mp_index = more_properties.index("mp")
mp = more_properties[mp_index + 2]
puts "melting point: #{mp}"
# get bp (get index of "bp" first; bp value comes after "bp" in more_properties array)
bp_index = more_properties.index("bp")
bp = more_properties[bp_index + 2]
puts "boiling point: #{bp}"
