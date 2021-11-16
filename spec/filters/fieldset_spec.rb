# frozen_string_literal: true

describe "fieldset filter" do
  before do
    visit "/fieldset.html"
  end

  {
    field: "Text",
    fillable_field: "Text",
    datalist_input: "Text",
    radio_button: "Radio",
    checkbox: "Checkbox",
    file_field: "File",
    combo_box: "Combo box"
  }.each do |selector, label|
    context selector.to_s do
      let(:label) { selector.to_s.tr("_", " ").capitalize }

      context "single fieldset" do
        it "selects with an implicit label" do
          expect(page).to have_selector selector, "#{label} implicit", count: 2
          expect(find(selector, "#{label} implicit",
                      fieldset: "Inner circle")).to eq find(:fieldset, "Inner circle").find(:field, "#{label} implicit")
        end

        it "selects with an explicit label" do
          expect(page).to have_selector selector, "#{label} explicit", count: 2
          expect(find(selector, "#{label} explicit",
                      fieldset: "Inner circle")).to eq find(:fieldset, "Inner circle").find(:field, "#{label} explicit")
        end
      end

      context "two fieldsets" do
        it "selects with an implicit label" do
          expect(page).to have_selector selector, "#{label} implicit", count: 2
          expected = find(:fieldset, "Outer circle").find(:fieldset, "Inner circle").find(:field, "#{label} implicit")
          expect(find(selector, "#{label} implicit", fieldset: ["Outer circle", "Inner circle"])).to eq expected
        end

        it "selects with an explicit label" do
          expect(page).to have_selector selector, "#{label} explicit", count: 2
          expected = find(:fieldset, "Outer circle").find(:fieldset, "Inner circle").find(:field, "#{label} explicit")
          expect(find(selector, "#{label} explicit", fieldset: ["Outer circle", "Inner circle"])).to eq expected
        end
      end
    end
  end

  context "rich text" do
    it "selects a rich text" do
      expect(page).to have_selector :rich_text, "Rich text", count: 2
      expect(page).to have_selector :rich_text, "Rich text", fieldset: "Inner circle", count: 1
      expect(page).to have_selector :rich_text, "Rich text", fieldset: ["Outer circle", "Inner circle"], count: 1
    end
  end

  context "button" do
    it "selects a button" do
      expect(page).to have_selector :button, "Button", count: 2
      expect(page).to have_selector :button, "Button", fieldset: "Inner circle", count: 1
      expect(page).to have_selector :button, "Button", fieldset: ["Outer circle", "Inner circle"], count: 1
    end
  end

  context "link" do
    it "selects a link" do
      expect(page).to have_selector :link, "Link", count: 2
      expect(page).to have_selector :link, "Link", fieldset: "Inner circle", count: 1
      expect(page).to have_selector :link, "Link", fieldset: ["Outer circle", "Inner circle"], count: 1
    end
  end

  context "link_or_button" do
    it "selects a link_or_button" do
      expect(page).to have_selector :link_or_button, "Link", count: 2
      expect(page).to have_selector :link_or_button, "Link", fieldset: "Inner circle", count: 1
      expect(page).to have_selector :link_or_button, "Link", fieldset: ["Outer circle", "Inner circle"], count: 1
    end
  end
end
