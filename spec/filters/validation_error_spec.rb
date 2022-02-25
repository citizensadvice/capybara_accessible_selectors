# frozen_string_literal: true

describe "validation error filter" do
  before { visit "/validation_error.html" }

  context "with :field" do
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
      end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                         /expected to be described by "different error" but it was described by "Text label error Text error"/
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

    it "provides a friendly error for a field this not a candidate for constriant validation" do
      expect do
        expect(page).to have_selector :field, "Disabled", validation_error: "is required", disabled: true, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected element validity\.willValidate to be true/
    end
  end

  context "with :fillable_field" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :fillable_field, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :fillable_field, "Text", validation_error: "different error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :fillable_field, "Text", validation_error: "Text label error"
      expect(page).to have_no_selector :fillable_field, "Text", validation_error: "different error"
    end
  end

  context "with :datalist_input" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :datalist_input, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :datalist_input, "Text", validation_error: "different error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :datalist_input, "Text", validation_error: "Text label error"
      expect(page).to have_no_selector :datalist_input, "Text", validation_error: "different error"
    end
  end

  context "with :radio_button" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :radio_button, "Radio", validation_error: "Radio error"
      expect(page).to have_no_selector :radio_button, "Radio", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :radio_button, "Radio", validation_error: "Radio label error"
      expect(page).to have_no_selector :radio_button, "Radio", validation_error: "another error"
    end
  end

  context "with :checkbox" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :checkbox, "Checkbox", validation_error: "Checkbox error"
      expect(page).to have_no_selector :checkbox, "Checkbox", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :checkbox, "Checkbox", validation_error: "Checkbox label error"
      expect(page).to have_no_selector :checkbox, "Checkbox", validation_error: "another error"
    end
  end

  context "with :select" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :select, "Select", validation_error: "Select error"
      expect(page).to have_no_selector :select, "Select", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :select, "Select", validation_error: "Select label error"
      expect(page).to have_no_selector :select, "Select", validation_error: "another error"
    end
  end

  context "with :file_field" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :file_field, "File", validation_error: "File error"
      expect(page).to have_no_selector :file_field, "File", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :file_field, "File", validation_error: "File label error"
      expect(page).to have_no_selector :file_field, "File", validation_error: "another error"
    end
  end

  context "with :combo_box" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :combo_box, "Combo box", validation_error: "Combo box error"
      expect(page).to have_no_selector :combo_box, "Combo box", validation_error: "another error"
    end

    it "selects a field with a label error message" do
      expect(page).to have_selector :combo_box, "Combo box", validation_error: "Combo box label error"
      expect(page).to have_no_selector :combo_box, "Combo box", validation_error: "another error"
    end
  end

  context "with :rich_text" do
    it "selects a field with an aria-describedby error message" do
      expect(page).to have_selector :rich_text, "Rich text", validation_error: "Rich text error"
      expect(page).to have_no_selector :rich_text, "Rich text", validation_error: "Another error"
    end

    it "provides a friendly error if aria-invalid is missing" do
      node = page.find :rich_text, "Rich text"
      page.execute_script "arguments[0].setAttribute('aria-invalid', 'false')", node
      expect do
        expect(page).to have_selector :rich_text, "Rich text", validation_error: "Rich text error", wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected aria-invalid to be true/
    end
  end
end
