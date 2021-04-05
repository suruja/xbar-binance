# frozen_string_literal: true

class Formatter
  class << self
    def percent(value)
      "#{("%+.1f" % value).sub(".", ",")}%"
    end

    def arrow(value)
      value ? "▲" : "▼"
    end
  end
end
