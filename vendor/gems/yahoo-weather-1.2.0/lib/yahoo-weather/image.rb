class YahooWeather::Image
  # the height of the image in pixels.
  attr_reader :height

  # the url intended to be used as a link wrapping the image, for
  # instance, to send the user to the main Yahoo Weather home page.
  attr_reader :link

  # the title of hte image.
  attr_reader :title

  # the full url to the image.
  attr_reader :url

  # the width of the image in pixels.
  attr_reader :width

  def initialize (payload)
    @title = payload['title']
    @link = payload['link']
    @url = payload['url']
    @height = payload['height'].to_i
    @width = payload['width'].to_i
  end
end
