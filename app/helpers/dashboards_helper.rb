module DashboardsHelper
  def weather_icon(condition)
    case condition.text.downcase
    when "sunny"
      icon("weather")
    when "cloudy"
      icon("weather-cloud")
    when "foggy" || "smoky" || "haze" || "dust"
      icon("weather-fog")
    when "thunderstorms" || "thundershowers"
      icon("weather-lightning")
    when "snow" || "sleet"
      icon("weather-snow")
    else
      icon("weather")
    end
  end
end
