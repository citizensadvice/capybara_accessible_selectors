# frozen_string_literal: true

module CapybaraAccessibleSelectors
  # Methods to extend the DSL and page
  module Session
  end
end

module Capybara
  module DSL
    include CapybaraAccessibleSelectors::Session
  end

  class Session
    include CapybaraAccessibleSelectors::Session
  end
end
