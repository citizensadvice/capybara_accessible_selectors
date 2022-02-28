# frozen_string_literal: true

describe "rich text" do
  before { visit "/rich_text.html" }

  context "when inline" do
    context "with aria-label" do
      it "finds a rich text area" do
        rich_text = page.find(:id, "rt-aria-label")
        expect(page.find(:rich_text, "with label")).to eq rich_text
      end

      it "finds a rich text area with a partial label" do
        rich_text = page.find(:id, "rt-aria-label")
        expect(page.find(:rich_text, "with la")).to eq rich_text
      end

      it "finds a rich text area with exact and the exact text" do
        rich_text = page.find(:id, "rt-aria-label")
        expect(page.find(:rich_text, "with label", exact: true)).to eq rich_text
      end

      it "does finds a rich text area with exact and not the exact text" do
        expect do
          page.find(:rich_text, "with labe", exact: true, wait: 0)
        end.to raise_error Capybara::ElementNotFound
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

        it "fills in a rich text area without clearing" do
          fill_in_rich_text "with label", with: "foo"
          fill_in_rich_text "with label", with: "bar", clear: false
          expect(page).to have_selector :rich_text, "with label", exact_text: "foobar"
        end
      end
    end

    context "with aria-labelledby" do
      it "finds a rich text area" do
        rich_text = page.find(:id, "rt-aria-labelledby")
        expect(page.find(:rich_text, "with aria-labelledby")).to eq rich_text
      end

      it "finds a rich text area with a partial label" do
        rich_text = page.find(:id, "rt-aria-labelledby")
        expect(page.find(:rich_text, "with aria-")).to eq rich_text
      end

      it "finds a rich text area with exact and the exact text" do
        rich_text = page.find(:id, "rt-aria-labelledby")
        expect(page.find(:rich_text, "with aria-labelledby", exact: true)).to eq rich_text
      end

      it "does finds a rich text area with exact and not the exact text" do
        expect do
          page.find(:rich_text, "with aria-", exact: true, wait: 0)
        end.to raise_error Capybara::ElementNotFound
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
          expect(page).to have_no_selector :rich_text, "aria-labelledby", text: "foo"
        end

        it "fills in a rich text area without clearing" do
          fill_in_rich_text "with aria-labelledby", with: "foo"
          fill_in_rich_text "with aria-labelledby", with: "bar", clear: false
          expect(page).to have_selector :rich_text, "with aria-labelledby", exact_text: "foobar"
        end
      end
    end
  end

  context "with an iframe" do
    it "finds a rich text area" do
      rich_text = page.find(:id, "rt-iframe")
      expect(page.find(:rich_text, "editable iframe")).to eq rich_text
    end

    it "finds a rich text area with a partial label" do
      rich_text = page.find(:id, "rt-iframe")
      expect(page.find(:rich_text, "editable i")).to eq rich_text
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

      it "fills in a rich text area without clearing" do
        fill_in_rich_text "editable iframe", with: "foo"
        fill_in_rich_text "editable iframe", with: "bar", clear: false

        within_frame find(:rich_text, "editable iframe") do
          expect(page).to have_text "foobar"
        end
      end
    end
  end

  describe "within_rich_text" do
    context "when inline" do
      it "works if called on page" do
        fill_in_rich_text "with label", with: "foo"
        within_rich_text("with label") do
          expect(page).to have_text "foo", exact: true
        end
      end

      it "works if called on a parent node" do
        fill_in_rich_text "with label", with: "foo"
        page.find(:css, "body").within_rich_text("with label") do
          expect(page).to have_text "foo", exact: true
        end
      end

      it "works if called on the rich text" do
        fill_in_rich_text "with label", with: "foo"
        page.find(:rich_text, "with label").within_rich_text do
          expect(page).to have_text "foo", exact: true
        end
      end
    end

    context "with an iframe" do
      it "works if called on page" do
        fill_in_rich_text "editable iframe", with: "foo"
        within_rich_text("editable iframe") do
          expect(page).to have_text "foo", exact: true
        end
      end

      it "works if called on a parent node" do
        fill_in_rich_text "editable iframe", with: "foo"
        page.find(:css, "body").within_rich_text("editable iframe") do
          expect(page).to have_text "foo", exact: true
        end
      end

      it "works if called on the rich text" do
        fill_in_rich_text "editable iframe", with: "foo"
        page.find(:rich_text, "editable iframe").within_rich_text do
          expect(page).to have_text "foo", exact: true
        end
      end
    end
  end
end
