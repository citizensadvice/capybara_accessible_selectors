# frozen_string_literal: true

module CapybaraAccessibleSelectors
  # methods to extend DSL, page and nodes
  module Actions
  end
end

module Capybara
  module DSL
    include CapybaraAccessibleSelectors::Actions
  end

  module Node
    class Element
      include CapybaraAccessibleSelectors::Actions
    end
  end

  class Session
    include CapybaraAccessibleSelectors::Actions
  end
end
