# frozen_string_literal: true

describe "has_validation_errors" do
  before { visit "/have_validation_errors.html" }

  it "finds all validation errors in page" do
    expect(page).to have_validation_errors do
      field "Text", validation_error: "is required"
    end
  end
end
