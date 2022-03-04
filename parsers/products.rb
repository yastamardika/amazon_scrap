html = Nokogiri.HTML(content)

product = {}

product['url'] = page['url']
product['category'] = page['vars']['category']

# product['asin'] = html.css('[name="ASIN"] > @value').text
product['asin'] = html.css('[name="ASIN"] > @value').text
p product['asin']

# product['title'] = html.at_css('#productTitle').text.strip
# product['title'] = html.at_css('#productTitle')
product['title'] = html.css('a.a-link-normal.s-underline-text.s-underline-link-text.s-link-style.a-text-normal').text.strip
# p product['title']

seller_node = html.at_css('a#bylineInfo')
# p seller_node
if seller_node
    product['seller'] = seller_node.text.strip.gsub("Visit the ", "")
else
    product['author'] = html.css('a.contributorNameID').text.strip
end

#extract number of reviews
reviews_node = html.at_css('span#acrCustomerReviewText')
reviews_count = reviews_node ? reviews_node.text.strip.split(' ').first.gsub(',','') : nil
product['reviews_count'] = reviews_count =~ /^[0-9]*$/ ? reviews_count.to_i : 0
p product['reviews_count']

#extract price
price_node = html.at_css('#price_inside_buybox', '#priceblock_ourprice', '#priceblock_dealprice', '.offer-price')
if price_node
  product['price'] = price_node.text.strip.gsub(/[\$,]/,'').to_f
end

#extract availability
availability_node = html.at_css('#availability')
if availability_node
  product['available'] = availability_node.text.strip == 'In Stock.' ? true : false
else
  product['available'] = nil
end

#extract product description
description = ''
html.css('#feature-bullets li').each do |li|
  unless li['id'] || (li['class'] && li['class'] != 'showHiddenFeatureBullets')
    description += li.text.strip + ' '
  end
end
product['description'] = description.strip

# specify the collection where this record will be stored
product['_collection'] = "products"

# save the product to the job’s outputs
outputs << product
