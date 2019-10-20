# frozen_string_literal: true

module CapybaraAccessibleSelectors
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
