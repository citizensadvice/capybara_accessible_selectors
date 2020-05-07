# frozen_string_literal: true

describe "combo_box selector" do
  before do
    visit "/combo_box.html"
  end

  (0..1).each do |iteration|
    context "ARIA 1.#{iteration}" do
      let(:label) { "aria 1.#{iteration}" }

      it "finds a combo box" do
        combo_box = find(:field, label)
        expect(find(:combo_box, label)).to eq combo_box
      end

      it "matches a combo_box" do
        combo_box = find(:field, label)
        expect(combo_box).to match_selector :combo_box
      end

      context "select_combo_box_option" do
        it "fills in a combo box" do
          expect(page).to have_selector :combo_box, label, with: ""
          select_combo_box_option "Banana", from: label
          expect(page).to have_selector :combo_box, label, with: "Banana"
        end

        it "fills in a combo box with exact option when non-exact also exists" do
          select_combo_box_option "Orange", from: label
          expect(page).to have_selector :combo_box, label, with: "Orange"
        end

        it "fills in a combo box with alternative search string" do
          select_combo_box_option "Blood", from: label, search: "or"
          expect(page).to have_selector :combo_box, label, with: "Blood orange"
        end

        it "allows finding an option with finder options" do
          select_combo_box_option from: label, option_match: :first, option_text: /orange/i
          expect(page).to have_selector :combo_box, label, with: "Orange"
        end

        context "currently_with" do
          it "finds a combo box with an existing value" do
            select_combo_box_option "Banana", from: label
            expect(page).to have_selector :combo_box, label, with: "Banana"
            expect(page).to have_no_selector :combo_box, label, with: "Apple"
          end

          it "fills in a combo box with an existing value" do
            select_combo_box_option "Banana", from: label
            select_combo_box_option "Apple", from: label, currently_with: "Banana"
            expect do
              select_combo_box_option "Banana", from: label, currently_with: "Foo", wait: false
            end.to raise_error Capybara::ElementNotFound
          end
        end

        context "called on the node" do
          it "fills in a combo box" do
            find(:combo_box, label).select_combo_box_option "Banana"
          end
        end
      end

      context "with filter" do
        it "selects based on the input value" do
          select_combo_box_option "Apple", from: label
          expect(page).to have_selector :combo_box, label, with: "Apple"
          expect(page).to have_no_selector :combo_box, label, with: "Banana"
        end
      end
    end
  end

  context "twitter" do
    it "finds a combo box" do
      combo_box = find(:field, "twitter")
      expect(find(:combo_box, "twitter")).to eq combo_box
    end

    context "select_combo_box_option" do
      it "fills in a combo box" do
        expect(page).to have_selector :combo_box, "twitter", with: ""
        select_combo_box_option "Banana", from: "twitter"
        expect(page).to have_selector :combo_box, "twitter", with: "Banana"
      end

      context "currently_with" do
        it "finds a combo box with an existing value" do
          select_combo_box_option "Banana", from: "twitter"
          expect(page).to have_selector :combo_box, "twitter", with: "Banana"
          expect(page).to have_no_selector :combo_box, "twitter", with: "Apple"
        end

        it "fills in a combo box with an existing value" do
          select_combo_box_option "Banana", from: "twitter"
          select_combo_box_option "Apple", from: "twitter", currently_with: "Banana"
          expect do
            select_combo_box_option "Banana", from: "twitter", currently_with: "Foo", wait: false
          end.to raise_error Capybara::ElementNotFound
        end
      end

      context "called on the node" do
        it "fills in a combo box" do
          find(:combo_box, "twitter").select_combo_box_option "Banana"
        end
      end
    end

    context "with filter" do
      it "selects based on the input value" do
        select_combo_box_option "Apple", from: "twitter"
        expect(page).to have_selector :combo_box, "twitter", with: "Apple"
        expect(page).to have_no_selector :combo_box, "twitter", with: "Banana"
      end
    end
  end
end
