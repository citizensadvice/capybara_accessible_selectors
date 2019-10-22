# frozen_string_literal: true

describe "has_validation_errors" do
  before { visit "/have_validation_errors.html" }

  it "validates all validation errors" do
    within(:section, "Form with many errors") do
      expect(page).to have_validation_errors do
        field "Text", validation_error: "is required"
        radio_button "Radio", validation_error: "is required"
        checkbox "Checkbox", validation_error: "is required"
        select "Select", validation_error: "is required"
        file_field "File field", validation_error: "is required"
        combo_box "Combo box", validation_error: "is required"
        rich_text "Rich text", validation_error: "is required"
      end
    end
  end

  it "rejects for a missing error" do
    expect do
      expect(page).to have_validation_errors do
        field "Text", validation_error: "is required"
        radio_button "Radio", validation_error: "is required"
        checkbox "Checkbox", validation_error: "is required"
        select "Select", validation_error: "is required"
        file_field "File field", validation_error: "is required"
        combo_box "Combo box", validation_error: "is required"
        rich_text "Rich text", validation_error: "is required"
      end
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, <<~MESSAGE.strip
      expected <input required="" type="text"> to have no error
    MESSAGE
  end

  it "rejects for an extra error" do
    expect do
      within(:section, "Form with one error") do
        expect(page).to have_validation_errors do
          field "Another", validation_error: "is required"
          field "I'm OK", validation_error: "is required", wait: false
        end
      end
    end.to raise_error Capybara::ExpectationNotMet
  end

  it "rejects for an incorrect error" do
    expect do
      within(:section, "Form with one error") do
        expect(page).to have_validation_errors do
          field "Another", validation_error: "is not required", wait: false
        end
      end
    end.to raise_error Capybara::ExpectationNotMet
  end

  context "negated matcher" do
    it "validates there are no validation errors" do
      within(:section, "Form with no errors") do
        expect(page).to_not have_validation_errors
      end
    end
  end
end
