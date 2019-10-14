# frozen_string_literal: true

describe "locate_field" do
  context "locate_fields_on_labels is false" do
    around(:each) do |example|
      old = CapybaraAccessibleSelectors.locate_fields_on_labels
      CapybaraAccessibleSelectors.locate_fields_on_labels = false
      example.run
      CapybaraAccessibleSelectors.locate_fields_on_labels = old
    end

    before { visit "/locate_field.html" }

    it "locates fields using ids" do
      expect(page).to have_selector :field, "#foo"
    end

    it "does not locate on fieldsets using arrays"
  end
end
