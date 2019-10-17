# frozen_string_literal: true

describe "rich text" do
  before { visit "/rich_text.html" }

  context "inline" do
    context "aria-label" do
      it "finds a rich text area" do
        rich_text = page.find(:id, "rt-aria-label")
        expect(page.find(:rich_text, "with label")).to eq rich_text
      end

      it "matches a rich text area" do
        rich_text = page.find(:id, "rt-aria-label")
        expect(rich_text).to match_selector :rich_text
      end

      describe "#fill_in_rich_text" do
        it "fills in a rich text area" do
          fill_in_rich_text "with label", with: "foo"
          expect(page).to have_selector :rich_text, "with label", exact_text: "foo"
        end

        it "replaces text in a rich text area" do
          fill_in_rich_text "with label", with: "foo"
          fill_in_rich_text "with label", with: "bar"
          expect(page).to have_selector :rich_text, "with label", exact_text: "bar"
        end

        it "clears a rich text area" do
          fill_in_rich_text "with label", with: "foo"
          fill_in_rich_text "with label", with: ""
          expect(page).to have_no_selector :rich_text, "with label", text: "foo"
        end
      end
    end

    context "aria-labelledby" do
      it "finds a rich text area" do
        rich_text = page.find(:id, "rt-aria-labelledby")
        expect(page.find(:rich_text, "with aria-labelledby")).to eq rich_text
      end

      it "matches a rich text area" do
        rich_text = page.find(:id, "rt-aria-labelledby")
        expect(rich_text).to match_selector :rich_text
      end

      describe "#fill_in_rich_text" do
        it "fills in a rich text area" do
          fill_in_rich_text "with aria-labelledby", with: "foo"
          expect(page).to have_selector :rich_text, "with aria-labelledby", exact_text: "foo"
        end

        it "replaces text in a rich text area" do
          fill_in_rich_text "with aria-labelledby", with: "foo"
          fill_in_rich_text "with aria-labelledby", with: "bar"
          expect(page).to have_selector :rich_text, "with aria-labelledby", exact_text: "bar"
        end

        it "clears a rich text area" do
          fill_in_rich_text "with aria-labelledby", with: "foo"
          fill_in_rich_text "with aria-labelledby", with: ""
          expect(page).to have_no_selector :rich_text, "with label", text: "foo"
        end
      end
    end
  end

  context "iframe" do
    it "finds a rich text area" do
      rich_text = page.find(:id, "rt-iframe")
      expect(page.find(:rich_text, "editable iframe")).to eq rich_text
    end

    it "matches a rich text area" do
      rich_text = page.find(:id, "rt-iframe")
      expect(rich_text).to match_selector :rich_text
    end

    describe "#fill_in_rich_text" do
      it "fills in a rich text area" do
        fill_in_rich_text "editable iframe", with: "foo"
        within_frame find(:rich_text, "editable iframe") do
          expect(page).to have_text "foo", exact: true
        end
      end

      it "replaces text in a rich text area" do
        fill_in_rich_text "editable iframe", with: "foo"
        fill_in_rich_text "editable iframe", with: "bar"
        within_frame find(:rich_text, "editable iframe") do
          expect(page).to have_text "bar", exact: true
        end
      end

      it "clears a rich text area" do
        fill_in_rich_text "editable iframe", with: "foo"
        fill_in_rich_text "editable iframe", with: ""

        within_frame find(:rich_text, "editable iframe") do
          expect(page).to have_no_text "foo"
        end
      end
    end
  end
end
