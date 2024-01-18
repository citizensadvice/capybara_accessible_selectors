# frozen_string_literal: true

describe "validation error filter" do
  context "with :field" do
    it "selects an invalid field" do
      render <<~HTML
        <label>Text invalid<input required></label>
        <label>Text valid<input></label>
      HTML
      expect(find(:field, "Text invalid")).to eq find(:field, "Text", validation_error: true)
    end

    it "selects a valid field" do
      render <<~HTML
        <label>Text invalid<input required></label>
        <label>Text valid<input></label>
      HTML
      expect(find(:field, "Text valid")).to eq find(:field, "Text", validation_error: false)
    end

    it "selects an invalid field with error message in the accessible description" do
      render <<~HTML
        <label>Text<input aria-describedby="id" required></label>
        <span id="id">Text error</span>
      HTML
      expect(page).to have_selector :field, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :field, "Text", validation_error: "different error"
    end

    it "selects an invalid field with error message in the accessible name" do
      render <<~HTML
        <label>Text<input aria-labelledby="id" required></label>
        <span id="id">Text error</span>
      HTML
      expect(page).to have_selector :field, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :field, "Text", validation_error: "different error"
    end

    it "selects an invalid field with error message in the implicit label" do
      render <<~HTML
        <label>Text error<input required></label>
      HTML
      expect(page).to have_selector :field, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :field, "Text", validation_error: "different error"
    end

    it "selects an invalid field with error message in the explicit label" do
      render <<~HTML
        <label for="id">Text error</label>
        <input id="id" required>
      HTML
      expect(page).to have_selector :field, "Text", validation_error: "Text error"
      expect(page).to have_no_selector :field, "Text", validation_error: "different error"
    end

    it "provides a friendly error if the error message does not match" do
      render <<~HTML
        <label>Text<input aria-describedby="description-id" required></label>
        <span id="description-id">Description</span>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: "Error", wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                         /expected to be described by "Error" but it was described by "Text Description"/
    end

    it "provides a friendly error if the error message does not match using an aria name" do
      render <<~HTML
        <label>Text<input aria-labelledby="label-id" aria-describedby="description-id" required></label>
        <span id="label-id">Label</span>
        <span id="description-id">Description</span>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: "Error", wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                         /expected to be described by "Error" but it was described by "Label Description"/
    end

    it "provides a friendly error if it is not a candidate for constraint validation" do
      render <<~HTML
        <label>Text<input disabled required></label>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: "is required", disabled: true, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected element to be a candidate for constraint validation/
    end

    it "provides a friendly error if expected to be invalid" do
      render <<~HTML
        <label>Text<input></label>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: true, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected element to be invalid/
    end

    it "provides a friendly error if expected to be valid and is invalid" do
      render <<~HTML
        <label>Text<input required></label>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: false, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected element not to be invalid/
    end

    it "provides a friendly error if expected to be valid and is aria-invalid" do
      render <<~HTML
        <label>Text<input aria-invalid="true"></label>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: false, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected element not to have aria-invalid=true/
    end

    it "provides a friendly error if aria-invalid contradicts an invalid element" do
      render <<~HTML
        <label>Text<input aria-invalid="false" required></label>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: false, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected aria-invalid not to be false if the element is invalid/
    end
  end

  context "with :fillable_field" do
    it "selects a field with an error message" do
      render <<~HTML
        <label>Text Field error<input required></label>
      HTML
      expect(page).to have_selector :fillable_field, "Text", validation_error: "Field error"
      expect(page).to have_no_selector :fillable_field, "Text", validation_error: "Different error"
    end
  end

  context "with :datalist_input" do
    it "selects a field with an error message" do
      render <<~HTML
        <label>Text Field error<input required list="list-id"></label>
        <datalist id="list-id">
          <option value="Option one">
          <option value="Option two">
        </datalist>
      HTML

      expect(page).to have_selector :datalist_input, "Text", validation_error: "Field error"
      expect(page).to have_no_selector :datalist_input, "Text", validation_error: "Different error"
    end
  end

  context "with :radio_button" do
    it "selects a field with an error message" do
      render <<~HTML
        <label>Radio Field error<input type="radio" required name="radio"></label>
      HTML
      expect(page).to have_selector :radio_button, "Radio", validation_error: "Field error"
      expect(page).to have_no_selector :radio_button, "Radio", validation_error: "another error"
    end
  end

  context "with :checkbox" do
    it "selects a field with an error message" do
      render <<~HTML
        <label>Checkbox Field error<input type="checkbox" required></label>
      HTML
      expect(page).to have_selector :checkbox, "Checkbox", validation_error: "Field error"
      expect(page).to have_no_selector :checkbox, "Checkbox", validation_error: "another error"
    end
  end

  context "with :select" do
    it "selects a field with an error message" do
      render <<~HTML
        <label>Select Field error<select required></select></label>
      HTML
      expect(page).to have_selector :select, "Select", validation_error: "Field error"
      expect(page).to have_no_selector :select, "Select", validation_error: "another error"
    end
  end

  context "with :file_field" do
    it "selects a field with an error message" do
      render <<~HTML
        <label>File Field error<input type="file" required></label>
      HTML
      expect(page).to have_selector :file_field, "File", validation_error: "Field error"
      expect(page).to have_no_selector :file_field, "File", validation_error: "another error"
    end
  end

  context "with :combo_box" do
    it "selects a field with an error message" do
      render <<~HTML
        <label>Combo box Field error<input role="combobox" required></label>
      HTML
      expect(page).to have_selector :combo_box, "Combo box", validation_error: "Field error"
      expect(page).to have_no_selector :combo_box, "Combo box", validation_error: "another error"
    end
  end

  context "with :rich_text" do
    it "selects a field with an error message" do
      render <<~HTML
        <div id="label-rich-text">Rich text</div>
        <div id="described-by-rich-text">Rich text error</div>
        <div contenteditable="true" role="textbox" aria-labelledby="label-rich-text" aria-describedby="described-by-rich-text" aria-invalid="true">
        </div>
      HTML
      expect(page).to have_selector :rich_text, "Rich text", validation_error: "Rich text error"
      expect(page).to have_no_selector :rich_text, "Rich text", validation_error: "another error"
    end

    it "provides a friendly error if aria-invalid is missing" do
      render <<~HTML
        <div id="label-rich-text">Rich text</div>
        <div id="described-by-rich-text">Rich text error</div>
        <div contenteditable="true" role="textbox" aria-labelledby="label-rich-text" aria-describedby="described-by-rich-text">
        </div>
      HTML
      expect do
        expect(page).to have_selector :rich_text, "Rich text", validation_error: "Rich text error", wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected element to have aria-invalid=true/
    end
  end

  context "with a regular expression" do
    it "selects an invalid field" do
      render <<~HTML
        <label>Text<input aria-describedby="id" required></label>
        <span id="id">Text error</span>
      HTML
      expect(page).to have_selector :field, "Text", validation_error: /error/
    end

    it "provides a friendly error" do
      render <<~HTML
        <label>Text<input aria-describedby="id" required></label>
        <span id="id">Text error</span>
      HTML
      expect do
        expect(page).to have_selector :field, "Text", validation_error: /foo/, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                         %r{expected to be described by /foo/ but it was described by "Text Text error"}
    end
  end
end
