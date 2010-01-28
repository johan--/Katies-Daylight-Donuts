module ActionView
  class Base
    def current_host
      Rails.env =~ /production/ ? PRODUCTION_HOST : DEVELOPMENT_HOST
    end
  end
end