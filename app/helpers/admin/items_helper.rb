module Admin::ItemsHelper
  def items_performance_chart
    data = []
    Item.available.each do |item|
      data.push([item.line_items.map(&:quantity).to_a.compact.sum,item.name])
    end
    url = "http://chart.apis.google.com/chart?cht=bhg&chd=t:#{data.map{|c,n| c }.join(',')}&chs=350x150&chl=#{data.map{|c,n| CGI.escape((n + " #{c}")) }.join('|')}"
    image_tag(url)
  end
end
