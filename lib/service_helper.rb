# frozen_string_literal: true

module ServiceHelper
  def available?
    raise NotImplementedError
  end

  def fetch
    raise NotImplementedError
  end

  def reset
    raise NotImplementedError
  end

  def symbols
    raise NotImplementedError
  end

  def positive_symbols
    raise NotImplementedError
  end

  def balance_for(symbol)
    raise NotImplementedError
  end

  def coins_for(symbol)
    raise NotImplementedError
  end
end
