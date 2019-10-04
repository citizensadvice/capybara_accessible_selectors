# frozen_string_literal: true

describe "fieldset filter" do
  before do
    visit "/fieldset.html"
  end

  {
    field: "Text",
    fillable_field: "Text",
    radio_button: "Radio",
    checkbox: "Checkbox",
    file_field: "File",
    combo_box: "Combo box"
  }.each do |selector, label|
    context selector.to_s do
      let(:label) { selector.to_s.tr("_", " ").capitalize }

      it "selects with an implicit label" do
        expect(page).to have_selector selector, "#{label} implicit", count: 2
        expect(find(:field, "#{label} implicit", fieldset: "Grouped")).to eq find(:fieldset, "Grouped").find(:field, "#{label} implicit")
      end

      it "selects with an explicit label" do
        expect(page).to have_selector selector, "#{label} explicit", count: 2
        expect(find(:field, "#{label} explicit", fieldset: "Grouped")).to eq find(:fieldset, "Grouped").find(:field, "#{label} explicit")
      end
    end
  end

  context "button" do
    it "selects a button" do
      expect(page).to have_selector :button, "Button", count: 2
      expect(page).to have_selector :button, "Button", fieldset: "Grouped", count: 1
    end
  end
end
