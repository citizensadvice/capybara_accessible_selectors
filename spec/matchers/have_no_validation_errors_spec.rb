# frozen_string_literal: true

describe "have_no_validation_errors", skip_driver: :rack_test do
  before { visit "/have_validation_errors.html" }

  it "validates there are no validation errors" do
    within(:section, "Form with no errors") do
      expect(page).to have_no_validation_errors
    end
  end

  it "rejects if there are errors" do
    within(:section, "Form with one error") do
      expect do
        expect(page).to have_no_validation_errors
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, <<~MESSAGE.strip
        expected <input required="" type="text"> not to be invalid
      MESSAGE
    end
  end
end
