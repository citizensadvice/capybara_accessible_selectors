# frozen_string_literal: true

describe "required" do
  context "with a checkbox" do
    before do
      render <<~HTML
        <input type="checkbox" required aria-label="required" />
        <input type="checkbox" aria-label="optional" />
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :checkbox, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :checkbox, required: false
    end
  end

  context "with a datalist_input" do
    before do
      render <<~HTML
        <input list="id" required aria-label="required" />
        <input list="id" aria-label="optional" />
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :datalist_input, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :datalist_input, required: false
    end
  end

  context "with a field" do
    before do
      render <<~HTML
        <input required aria-label="required" />
        <input aria-label="optional" />
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :field, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :field, required: false
    end
  end

  context "with a file_field" do
    before do
      render <<~HTML
        <input type="file" required aria-label="required" />
        <input type="file" aria-label="optional" />
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :field, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :field, required: false
    end
  end

  context "with a fillable_field" do
    before do
      render <<~HTML
        <input required aria-label="required" />
        <input aria-label="optional" />
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :fillable_field, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :fillable_field, required: false
    end
  end

  context "with a radio button" do
    before do
      render <<~HTML
        <input type="radio" required aria-label="required" />
        <input type="radio" aria-label="optional" />
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :radio_button, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :radio_button, required: false
    end
  end

  context "with a select" do
    before do
      render <<~HTML
        <select required aria-label="required"><option>One</option></select>
        <select aria-label="optional"><option>One</option></select></select>
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :select, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :select, required: false
    end
  end

  context "with a rich text" do
    before do
      render <<~HTML
        <div role="textbox" contenteditable="true" aria-required="true" aria-label="required"></div>
        <div role="textbox" contenteditable="true" aria-label="optional"></div>
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :rich_text, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :rich_text, required: false
    end
  end

  context "when unmatched" do
    it "displays an error message" do
      expect do
        expect(page).to have_selector :checkbox, required: true, wait: 0
      end.to raise_error RSpec::Expectations::ExpectationNotMetError, <<~EXPECTED.squish
        expected to find checkbox nil that is not disabled that is required but there were no matches
      EXPECTED
    end
  end

  context "with aria-required" do
    before do
      render <<~HTML
        <input aria-required="true" aria-label="required" />
        <input aria-required="false" aria-label="optional" />
      HTML
    end

    it "selects required" do
      expect(page).to have_selector :field, required: true
    end

    it "selects optional" do
      expect(page).to have_selector :field, required: false
    end
  end
end
