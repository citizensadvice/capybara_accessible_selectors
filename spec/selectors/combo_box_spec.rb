# frozen_string_literal: true

describe "combo_box selector" do
  before do
    visit "/combo_box.html"
  end

  ["aria 1.0", "aria 1.1"].each do |label|
    context label do
      it "finds a combo box" do
        combo_box = find(:field, label)
        expect(find(:combo_box, label)).to eq combo_box
      end

      it "matches a combo_box" do
        combo_box = find(:field, label)
        expect(combo_box).to match_selector :combo_box
      end

      describe "expanded" do
        context "when true" do
          it "finds expanded" do
            find(:field, label).click
            expect(page).to have_selector :combo_box, label, expanded: true
          end

          it "does not find not expanded" do
            expect(page).to have_no_selector :combo_box, label, expanded: true
          end
        end

        context "when false" do
          it "finds not expanded" do
            expect(page).to have_selector :combo_box, label, expanded: false
          end

          it "does not find expanded" do
            find(:field, label).click
            expect(page).to have_no_selector :combo_box, label, expanded: false
          end
        end
      end

      describe "options" do
        it "asserts with matching exact options" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, options: ["Apple", "Banana", "Disabled", "Orange", "Blood orange"]
        end

        it "asserts with matching exact options with partial string match" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, options: %w[Apple Banana Disabled Orange Blood]
        end

        it "assets with matching a regular expression" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, options: ["Apple", "Banana", "Disabled", /orange/i, "Blood orange"]
        end

        it "fails assertion without matching exact options" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, options: ["Banana", "Disabled", "Orange", "Blood orange"], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected options ["Banana", "Disabled", "Orange", "Blood orange"]
            found ["Apple", "Banana", "Disabled", "Orange", "Blood orange"]
          EXPECTED
        end

        it "fails with matching all exact regular expression" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, options: [/potato/i, "Banana", "Disabled", "Orange", "Blood orange"],
                                                             wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected options [/potato/i, "Banana", "Disabled", "Orange", "Blood orange"]
            found ["Apple", "Banana", "Disabled", "Orange", "Blood orange"]
          EXPECTED
        end
      end

      describe "with_options" do
        it "asserts with matching partial options" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, with_options: %w[Orange Banana]
        end

        it "asserts with matching partial options and a partial string match" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, with_options: %w[Orange Blood]
        end

        it "asserts with matching regular expression" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, with_options: [/orange/i, "Blood orange"]
        end

        it "fails assertion without matching options" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, with_options: %w[Orange Potato], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected with at least options ["Orange", "Potato"]
            found ["Apple", "Banana", "Disabled", "Orange", "Blood orange"]
          EXPECTED
        end

        it "fails without matching regular expression" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, with_options: [/blood/i, /blood/i], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected with at least options [/blood/i, /blood/i]
            found ["Apple", "Banana", "Disabled", "Orange", "Blood orange"]
          EXPECTED
        end
      end

      describe "enabled_options" do
        it "asserts with matching exact enabled options" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, enabled_options: ["Apple", "Banana", "Orange", "Blood orange"]
        end

        it "assets with matching a regular expression" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, enabled_options: ["Apple", "Banana", /orange/i, "Blood orange"]
        end

        it "fails assertion without matching exact options" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, enabled_options: ["Banana", "Orange", "Blood orange"], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected enabled options ["Banana", "Orange", "Blood orange"]
            found ["Apple", "Banana", "Orange", "Blood orange"]
          EXPECTED
        end

        it "fails with matching all exact regular expression" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, enabled_options: [/potato/i, "Banana", "Orange", "Blood orange"], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected enabled options [/potato/i, "Banana", "Orange", "Blood orange"]
            found ["Apple", "Banana", "Orange", "Blood orange"]
          EXPECTED
        end
      end

      describe "with_enabled_options" do
        it "asserts with matching enabled options" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, with_enabled_options: %w[Orange Banana]
        end

        it "asserts with matching regular expression" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, with_enabled_options: [/orange/i, "Blood orange"]
        end

        it "fails assertion without matching options" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, with_enabled_options: %w[Orange Disabled], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected with at least enabled options ["Orange", "Disabled"]
            found ["Apple", "Banana", "Orange", "Blood orange"]
          EXPECTED
        end

        it "fails without matching regular expression" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, with_enabled_options: [/orange/i, /disabled/i], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
            Expected with at least enabled options [/orange/i, /disabled/i]
            found ["Apple", "Banana", "Orange", "Blood orange"]
          EXPECTED
        end
      end

      describe "disabled_options" do
        it "asserts with matching exact disabled options" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, disabled_options: "Disabled"
        end

        it "assets with matching a regular expression" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, disabled_options: /disabled/i
        end

        it "fails assertion without matching exact options" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, disabled_options: ["Banana"], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError, include('Expected disabled options ["Banana"] found ["Disabled"]')
        end

        it "fails with matching all exact regular expression" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, disabled_options: /banana/i, wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                             include('Expected disabled options [/banana/i] found ["Disabled"]')
        end
      end

      describe "with_disabled_options" do
        it "asserts with matching disabled options" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, with_disabled_options: "Disabled"
        end

        it "assets with matching a regular expression" do
          find(:field, label).click
          expect(page).to have_selector :combo_box, label, with_disabled_options: /disabled/i
        end

        it "fails assertion without matching exact options" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, with_disabled_options: ["Banana"], wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                             include('Expected with at least disabled options ["Banana"] found ["Disabled"]')
        end

        it "fails with matching all exact regular expression" do
          find(:field, label).click
          expect do
            expect(page).to have_selector :combo_box, label, with_disabled_options: /banana/i, wait: false
          end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                             include('Expected with at least disabled options [/banana/i] found ["Disabled"]')
        end
      end

      describe "select_combo_box_option" do
        it "fills in a combo box" do
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

        describe "currently_with" do
          it "fills in a combo box with an existing value" do
            select_combo_box_option "Banana", from: label
            select_combo_box_option "Apple", from: label, currently_with: "Banana"
            expect do
              select_combo_box_option "Banana", from: label, currently_with: "Foo", wait: false
            end.to raise_error Capybara::ElementNotFound
          end
        end

        context "with a disabled option" do
          it "does not select a disabled option" do
            expect do
              select_combo_box_option "Disabled", from: label, wait: false
            end.to raise_error(Capybara::ElementNotFound, /Unable to find option "Disabled" that is not disabled/)
          end
        end

        context "when called on the node" do
          it "fills in a combo box" do
            find(:combo_box, label).select_combo_box_option "Banana"
            expect(page).to have_selector :field, label, with: "Banana"
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

  describe "twitter typeahead" do
    label = "twitter"

    it "finds a combo box" do
      combo_box = find(:field, label)
      expect(find(:combo_box, label)).to eq combo_box
    end

    it "matches a combo_box" do
      combo_box = find(:field, label)
      expect(combo_box).to match_selector :combo_box
    end

    describe "options" do
      it "asserts with matching exact options" do
        find(:field, label).click
        expect(page).to have_selector :combo_box, label, options: ["Apple", "Banana", "Orange", "Blood orange"]
      end

      it "assets with matching a regular expression" do
        find(:field, label).click
        expect(page).to have_selector :combo_box, label, options: ["Apple", "Banana", /orange/i, "Blood orange"]
      end

      it "fails assertion without matching exact options" do
        find(:field, label).click
        expect do
          expect(page).to have_selector :combo_box, label, options: ["Banana", "Orange", "Blood orange"], wait: false
        end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
          Expected options ["Banana", "Orange", "Blood orange"]
          found ["Apple", "Banana", "Orange", "Blood orange"]
        EXPECTED
      end

      it "fails with matching all exact regular expression" do
        find(:field, label).click
        expect do
          expect(page).to have_selector :combo_box, label, options: [/potato/i, "Banana", "Orange", "Blood orange"], wait: false
        end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
          Expected options [/potato/i, "Banana", "Orange", "Blood orange"]
          found ["Apple", "Banana", "Orange", "Blood orange"]
        EXPECTED
      end
    end

    describe "with_options" do
      it "asserts with matching partial options" do
        find(:field, label).click
        expect(page).to have_selector :combo_box, label, with_options: %w[Orange Banana]
      end

      it "asserts with matching regular expression" do
        find(:field, label).click
        expect(page).to have_selector :combo_box, label, with_options: [/orange/i, "Blood orange"]
      end

      it "fails assertion without matching options" do
        find(:field, label).click
        expect do
          expect(page).to have_selector :combo_box, label, with_options: %w[Orange Potato], wait: false
        end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
          Expected with at least options ["Orange", "Potato"]
          found ["Apple", "Banana", "Orange", "Blood orange"]
        EXPECTED
      end

      it "fails without matching regular expression" do
        find(:field, label).click
        expect do
          expect(page).to have_selector :combo_box, label, with_options: [/blood/i, /blood/i], wait: false
        end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
          Expected with at least options [/blood/i, /blood/i]
          found ["Apple", "Banana", "Orange", "Blood orange"]
        EXPECTED
      end
    end

    describe "select_combo_box_option" do
      it "fills in a combo box" do
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

      describe "currently_with" do
        it "fills in a combo box with an existing value" do
          select_combo_box_option "Banana", from: label
          select_combo_box_option "Apple", from: label, currently_with: "Banana"
          expect do
            select_combo_box_option "Banana", from: label, currently_with: "Foo", wait: false
          end.to raise_error Capybara::ElementNotFound
        end
      end

      context "with a disabled option" do
        it "does not select a disabled option" do
          expect do
            select_combo_box_option "Disabled", from: label, wait: false
          end.to raise_error(Capybara::ElementNotFound, /Unable to find option "Disabled" that is not disabled/)
        end
      end

      context "when called on the node" do
        it "fills in a combo box" do
          find(:combo_box, label).select_combo_box_option "Banana"
          expect(page).to have_selector :field, label, with: "Banana"
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

  context "with a table list box" do
    it "fills in a combo box" do
      select_combo_box_option "Banana", from: "table"
      expect(page).to have_selector :combo_box, "table", with: "Banana Yellow"
    end

    it "matches options without normalised space" do
      find(:field, "table").click
      expect(page).to have_selector :combo_box, "table", with_options: ["Banana Yellow"]
    end
  end
end
