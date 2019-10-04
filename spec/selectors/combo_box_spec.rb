# frozen_string_literal: true

describe "alert selector" do
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

      context "select_combo_box_option" do
        it "fills in a combo box" do
          expect(page).to have_selector :combo_box, label, with: ""
          select_combo_box_option "Banana", from: label
          within "#listbox-aria1#{iteration}" do
            expect(page).to have_selector :css, "[role=option][aria-selected=true]", text: "Banana"
          end
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

      context "rspec" do
        it "matches using a custom matcher" do
          expect(page).to have_combo_box label
        end

        it "matches using a negated custom matcher" do
          expect(page).to have_no_combo_box "foo"
        end
      end
    end
  end
end
