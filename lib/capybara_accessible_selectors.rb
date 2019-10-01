# frozen_string_literal: true

require "capybara_accessible_selectors/version"
require "capybara"

##
# ### Filters
#
# #### focused: (Boolean)
#
# Selects an element that is focused.  Compatible with all selectors.
#
# ### Selectors
#
# #### alert
#
# Selects an element with a role of alert
#
# ```html
# <div role="alert">Important message</div>
# ```
#
# ```ruby
# page.find(:alert, text: "Successfully saved")
# ```
module CapybaraAccessibleSelectors
end

Dir[File.join(__dir__, "capybara_accessible_selectors", "selectors", "*.rb")].each { |f| require f }
