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

      context "with a single fieldset" do
        it "selects with an implicit label" do
          expect(page).to have_selector selector, "#{label} implicit", count: 2
          expect(find(selector,
                      ["Inner circle", "#{label} implicit"])).to eq find(:fieldset, "Inner circle").find(:field, "#{label} implicit")
        end

        it "selects with an explicit label" do
          expect(page).to have_selector selector, "#{label} explicit", count: 2
          expect(find(selector,
                      ["Inner circle", "#{label} explicit"])).to eq find(:fieldset, "Inner circle").find(:field, "#{label} explicit")
        end
      end

      context "with two fieldsets" do
        it "selects with an implicit label" do
          expect(page).to have_selector selector, "#{label} implicit", count: 2
          expected = find(:fieldset, "Outer circle").find(:fieldset, "Inner circle").find(:field, "#{label} implicit")
          expect(find(selector, ["Outer circle", "Inner circle", "#{label} implicit"])).to eq expected
        end

        it "selects with an explicit label" do
          expect(page).to have_selector selector, "#{label} explicit", count: 2
          expected = find(:fieldset, "Outer circle").find(:fieldset, "Inner circle").find(:field, "#{label} explicit")
          expect(find(selector, ["Outer circle", "Inner circle", "#{label} explicit"])).to eq expected
        end
      end
    end
  end

  context "with rich_text" do
    it "selects a rich_text" do
      expect(page).to have_selector :rich_text, "Rich text", count: 2
      expect(page).to have_selector :rich_text, ["Inner circle", "Rich text"], count: 1
      expect(page).to have_selector :rich_text, ["Outer circle", "Inner circle", "Rich text"], count: 1
    end
  end

  context "with button" do
    it "selects a button" do
      expect(page).to have_selector :button, "Button", count: 2
      expect(page).to have_selector :button, ["Inner circle", "Button"], count: 1
      expect(page).to have_selector :button, ["Outer circle", "Inner circle", "Button"], count: 1
    end
  end

  context "with link" do
    it "selects a link" do
      expect(page).to have_selector :link, "Link", count: 2
      expect(page).to have_selector :link, ["Inner circle", "Link"], count: 1
      expect(page).to have_selector :link, ["Outer circle", "Inner circle", "Link"], count: 1
    end
  end

  context "with link_or_button" do
    it "selects a link_or_button" do
      expect(page).to have_selector :link_or_button, "Link", count: 2
      expect(page).to have_selector :link_or_button, ["Inner circle", "Link"], count: 1
      expect(page).to have_selector :link_or_button, ["Outer circle", "Inner circle", "Link"], count: 1
    end
  end
end
