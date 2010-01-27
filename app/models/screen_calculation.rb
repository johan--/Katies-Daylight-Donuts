class ScreenCalculation
  
  attr_reader :error
  attr_accessor :result, :items
  
  def initialize(params = {})
    @results = []
    if params[:item] && params[:item][:ids] && params[:item][:counts]
      data = []
      @items = Item.find(params[:item][:ids])
      @items.each_with_index do |item, index|
        data << [item, params[:item][:counts][index]]
      end
      return parse(data)
    else
      raise Exception, "Fuck"
    end
    []
  end
  
  def to_html
    content = "<ul id='screens'>"
    @results.each do |result|
      content << "<li>#{result[0]}s #{result[1]} screens</li>"
    end
    content << "</ul>"
    content
  end
  
  private
  
  def parse(array)
    @results = []
    array.each do |line|
      item,count = line[0],line[1].to_i
      if count < 25
        count = 25
      end
      @results << [item.name, (count / item.number_per_screen).ceil]
    end
    @results
  end
end