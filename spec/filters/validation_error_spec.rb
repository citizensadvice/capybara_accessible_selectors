# frozen_string_literal: true

describe "validation error filter" do
  before { visit "/validation_error.html" }

  context "field" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :field, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :field, "Text", validation_error: "different error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :field, "Text", validation_error: "Text label error"
      expect(page).to have_no_selector :field, "Text", validation_error: "different error"
    end

    it "provides a friendly error if the error message does not match" do
      expect do
        expect(page).to have_selector :field, "Text", validation_error: "different error", wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected to be described by "different error" but it was described by "Text label error Text error"/
    end

    it "provides a friendly error if the validity state does not match" do
      fill_in("Text", with: "foo")
      expect(page).to have_no_selector :field, "Text", validation_error: "Text error"
      expect do
        expect(page).to have_selector :field, "Text", validation_error: "Text error", wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected element validity\.valid to be false/
    end

    it "provides a friendly error if aria-invalid is contradictory" do
      execute_script("arguments[0].setAttribute('aria-invalid', 'false')", find(:field, "Text"))
      expect(page).to have_no_selector :field, "Text", validation_error: "Text error"
      expect do
        expect(page).to have_selector :field, "Text", validation_error: "Text error", wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /aria-invalid cannot be false/
    end
  end

  context "fillable_field" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :fillable_field, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :fillable_field, "Text", validation_error: "different error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :fillable_field, "Text", validation_error: "Text label error"
      expect(page).to have_no_selector :fillable_field, "Text", validation_error: "different error"
    end
  end

  context "datalist_input" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :datalist_input, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :datalist_input, "Text", validation_error: "different error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :datalist_input, "Text", validation_error: "Text label error"
      expect(page).to have_no_selector :datalist_input, "Text", validation_error: "different error"
    end
  end

  context "radio_button" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :radio_button, "Radio", validation_error: "Radio error"
      expect(page).to have_no_selector :radio_button, "Radio", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :radio_button, "Radio", validation_error: "Radio label error"
      expect(page).to have_no_selector :radio_button, "Radio", validation_error: "another error"
    end
  end

  context "checkbox" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :checkbox, "Checkbox", validation_error: "Checkbox error"
      expect(page).to have_no_selector :checkbox, "Checkbox", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :checkbox, "Checkbox", validation_error: "Checkbox label error"
      expect(page).to have_no_selector :checkbox, "Checkbox", validation_error: "another error"
    end
  end

  context "select" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :select, "Select", validation_error: "Select error"
      expect(page).to have_no_selector :select, "Select", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :select, "Select", validation_error: "Select label error"
      expect(page).to have_no_selector :select, "Select", validation_error: "another error"
    end
  end

  context "file_field" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :file_field, "File", validation_error: "File error"
      expect(page).to have_no_selector :file_field, "File", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :file_field, "File", validation_error: "File label error"
      expect(page).to have_no_selector :file_field, "File", validation_error: "another error"
    end
  end

  context "combo_box" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :combo_box, "Combo box", validation_error: "Combo box error"
      expect(page).to have_no_selector :combo_box, "Combo box", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :combo_box, "Combo box", validation_error: "Combo box label error"
      expect(page).to have_no_selector :combo_box, "Combo box", validation_error: "another error"
    end
  end
end
