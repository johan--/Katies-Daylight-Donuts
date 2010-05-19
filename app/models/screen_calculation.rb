class ScreenCalculation
  
  attr_reader :error
  attr_accessor :result, :items
  
  # Creates a new screen calculation object
  #
  # params - The Hash of options
  #
  # Examples
  #
  # screen_calculation = ScreenCalculation.new(:item => item)
  #
  # Returns a new instance
  def initialize(params = {})
    @results = []
    if params[:item] && params[:item][:ids] && params[:item][:counts]
      data = []
      @items = Item.find(params[:item][:ids])
      @items.each_with_index do |item, index|
        data << [item, params[:item][:counts][index]]
      end
      return parse(data)
    end
    []
  end
  
  # Creates the html to display the screen counts
  #
  # Examples
  # 
  # screen_calculator.to_html
  # # => <ul id='screens'><li>Donuts 24</li></ul>
  #
  # Returns a String of html
  def to_html
    content = "<ul id='screens'>"
    @results.each do |result|
      content << "<li>#{result[0]}s #{result[1]} screens</li>"
    end
    content << "</ul>"
    content
  end
  
  private
  
  # Parse through the array and create a 
  # multi-dimensional array of results
  #
  # array - The Array of data
  #
  # Examples
  #
  # parse([item, 28])
  # # => [['Donut Holes', 288]]
  #
  # Returns the Array of results
  def parse(array)
    @results = []
    array.each do |line|
      item,count = line[0],line[1].to_i
      if count < 25
        count = 25
      end
      @results << [item.name, (count / (item.number_per_screen || 0)).ceil]
    end
    @results
  end
end