html = Nokogiri.HTML(content)

products = html.css('[data-component-type="s-search-result"]', '.s-result-item')

products.each do |product|
    a_element = product.css('.s-title-instructions-style')
    # p a_element
    ef_url = a_element.css('.a-link-normal > @href')
    # p ef_url
    url = "https://amazon.com#{ef_url}"   
     # if a_element
    #   if url =~ /\Ahttps?:\/\//i
    #   end
    # end
    pages << {
        url: url,
        page_type: 'products',
        vars: { 
          category: page['vars']['category'],
          url: url
        }
      }
end
 
pagination_links = html.css('.s-pagination-item')
p pagination_links
pagination_links.each do |link|
page_num = link.text.strip
    if page_num =~ /[0-9]/
        url = "https://www.amazon.com/s/ref=sr_pg_3?rh=n%3A172282%2Cn%3A%21493964%2Cn%3A1266092011%2Cn%3A172659%2Cn%3A6459737011&page=#{page_num}&ie=UTF8"
        pages << {
            url: url,
            page_type: 'listings',
            method: "GET",
            vars: {
            category: page['vars']['category']
            },
            fetch_type: "browser"
        }
    end
end