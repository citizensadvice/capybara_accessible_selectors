# frozen_string_literal: true

describe "Disclosure" do
  before { visit "/disclosure.html" }

  context "with Details/Summary" do
    it "selects a details" do
      details = page.find(:element, :details, text: "Summary button")
      expect(page.find(:disclosure, "Summary button")).to eq details
      expect(page).to have_selector :disclosure, "Summary button", expanded: false
      expect(page).to have_no_selector :disclosure, "Summary button", expanded: true
    end

    it "matches a details" do
      details = page.find(:element, :details, text: "Summary button")
      expect(details).to match_selector :disclosure
      expect(details).to match_selector :disclosure, expanded: false
    end

    it "finds a disclosure using the accessible name filter" do
      details = page.find(:element, :details, text: "Summary button")
      expect(find(:disclosure, accessible_name: "Summary")).to eq details
      expect(find(:disclosure, accessible_name: /Summary/)).to eq details
      expect(page).to have_no_selector :disclosure, accessible_name: "foo"
    end

    it "provides a friendly error message with an accessible name filter" do
      expect do
        find(:disclosure, accessible_name: "foo", wait: false)
      end.to raise_error Capybara::ElementNotFound, /with accessible name "foo"/
    end

    it "selects a summary button" do
      summary = page.find(:element, :summary, text: "Summary button")
      expect(page.find(:disclosure_button, "Summary button")).to eq summary
      expect(page).to have_selector :disclosure_button, "Summary button", expanded: false
      expect(page).to have_no_selector :disclosure_button, "Summary button", expanded: true
    end

    it "matches a summary button" do
      summary = page.find(:element, :summary, text: "Summary button")
      expect(summary).to match_selector :disclosure_button
    end

    describe "#toggle_disclosure" do
      it "toggles a details open and closed" do
        expect(page).to have_selector :disclosure, "Summary button", expanded: false
        # Open
        toggle_disclosure("Summary button")
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
        expect(page).to have_selector :disclosure_button, "Summary button", expanded: true
        # Force open
        toggle_disclosure("Summary button", expand: true)
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
        expect(page).to have_selector :disclosure_button, "Summary button", expanded: true
        # Close
        toggle_disclosure("Summary button")
        expect(page).to have_selector :disclosure, "Summary button", expanded: false
        # Force close
        toggle_disclosure("Summary button", expand: false)
        expect(page).to have_selector :disclosure, "Summary button", expanded: false
      end

      it "returns the summary node" do
        summary = page.find(:element, :summary, text: "Summary button")
        expect(toggle_disclosure("Summary button")).to eq summary
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
      end

      it "can be called on a details node" do
        details = page.find(:element, :details, text: "Summary button")
        details.toggle_disclosure
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
      end

      it "can be called on a summary node" do
        summary = page.find(:element, :summary, text: "Summary button")
        summary.toggle_disclosure
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
      end

      it "runs the block within in the disclosure" do
        toggle_disclosure("Summary button") do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Summary button
            Details content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the summary node" do
        summary = page.find(:element, :summary, text: "Summary button")
        summary.toggle_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Summary button
            Details content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the details node" do
        details = page.find(:element, :details, text: "Summary button")
        details.toggle_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Summary button
            Details content
          TEXT
        end
      end

      it "toggles a disclosure using the accessible_name filter" do
        expect(page).to have_selector :disclosure, accessible_name: "Summary button", expanded: false
        # Open
        toggle_disclosure accessible_name: "Summary button"
        expect(page).to have_selector :disclosure, accessible_name: "Summary button", expanded: true
      end
    end

    describe "#select_disclosure" do
      it "opens and returns a closed disclosure" do
        disclosure = find(:disclosure, "Summary button", expanded: false)
        expect(select_disclosure("Summary button")).to eq disclosure
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
      end

      it "returns an open disclosure" do
        disclosure = find(:disclosure, "Summary button", expanded: false)
        select_disclosure("Summary button")
        expect(select_disclosure("Summary button")).to eq disclosure
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
      end

      it "can be called on a details node" do
        details = page.find(:element, :details, text: "Summary button")
        details.select_disclosure
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
      end

      it "can be called on a summary node" do
        summary = page.find(:element, :summary, text: "Summary button")
        summary.select_disclosure
        expect(page).to have_selector :disclosure, "Summary button", expanded: true
      end

      it "runs the block within in the disclosure" do
        select_disclosure("Summary button") do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Summary button
            Details content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the summary" do
        summary = page.find(:element, :summary, text: "Summary button")
        summary.select_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Summary button
            Details content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the details" do
        details = page.find(:element, :details, text: "Summary button")
        details.select_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Summary button
            Details content
          TEXT
        end
      end

      it "opens and returns a closed disclosure using the accessible name filter" do
        disclosure = find(:disclosure, accessible_name: "Summary button", expanded: false)
        expect(select_disclosure(accessible_name: "Summary button")).to eq disclosure
        expect(page).to have_selector :disclosure, accessible_name: "Summary button", expanded: true
      end
    end

    describe "#within_disclosure" do
      it "finds a disclosure" do
        toggle_disclosure("Summary button")
        within_disclosure "Summary button" do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Summary button
            Details content
          TEXT
        end
      end
    end
  end

  context "with disclosure pattern with button" do
    it "selects the button" do
      button = page.find(:button, "Disclosure button")
      expect(page.find(:disclosure_button, "Disclosure button")).to eq button
      expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
      expect(page).to have_no_selector :disclosure_button, "Disclosure button", expanded: true
    end

    it "selects the disclosure" do
      # The disclosure isn't visible
      disclosure = page.find(:element, :div, text: "Disclosure content", visible: false)
      expect(page.find(:disclosure, "Disclosure button", visible: false)).to eq disclosure
      expect(page).to have_no_selector :disclosure, "Disclosure button"
    end

    it "finds a disclosure using the accessible name filter" do
      disclosure = page.find(:element, :div, text: "Disclosure content", visible: false)
      expect(find(:disclosure, accessible_name: "Disclosure bu", visible: false)).to eq disclosure
      expect(find(:disclosure, accessible_name: /Disclosure bu/, visible: false)).to eq disclosure
    end

    describe "#toggle_disclosure" do
      it "toggles a disclosure open and closed" do
        expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
        # Open
        toggle_disclosure("Disclosure button")
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
        expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: true
        # Force open
        toggle_disclosure("Disclosure button", expand: true)
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
        expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: true
        # Close
        toggle_disclosure("Disclosure button")
        expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
        # Force close
        toggle_disclosure("Disclosure button", expand: false)
        expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
      end

      it "returns the button" do
        button = page.find(:button, "Disclosure button")
        expect(toggle_disclosure("Disclosure button")).to eq button
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      end

      it "can be called on a disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure content", visible: false)
        disclosure.toggle_disclosure
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      end

      it "can be called on a disclosure button" do
        button = page.find(:button, "Disclosure button")
        button.toggle_disclosure
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      end

      it "runs the block within in the disclosure" do
        toggle_disclosure "Disclosure button" do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure content", visible: false)
        disclosure.toggle_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the button" do
        button = page.find(:button, "Disclosure button")
        button.toggle_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure content
          TEXT
        end
      end

      it "toggles a disclosure using the accessible_name filter" do
        expect(page).to have_selector :disclosure_button, accessible_name: "Disclosure button", expanded: false
        toggle_disclosure(accessible_name: "Disclosure button")
        expect(page).to have_selector :disclosure, accessible_name: "Disclosure button", expanded: true
      end
    end

    describe "#select_disclosure" do
      it "opens and returns a closed disclosure" do
        disclosure = find(:id, "disclosure-button-content", visible: false)
        expect(select_disclosure("Disclosure button")).to eq disclosure
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      end

      it "returns an open disclosure" do
        disclosure = find(:id, "disclosure-button-content", visible: false)
        select_disclosure("Disclosure button")
        expect(select_disclosure("Disclosure button")).to eq disclosure
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      end

      it "can be called on a disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure content", visible: false)
        disclosure.select_disclosure
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      end

      it "can be called on a disclosure button" do
        button = page.find(:button, "Disclosure button")
        button.select_disclosure
        expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      end

      it "runs the block within in the disclosure" do
        select_disclosure "Disclosure button" do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure content", visible: false)
        disclosure.select_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the button" do
        button = page.find(:button, "Disclosure button")
        button.select_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure content
          TEXT
        end
      end

      it "opens and returns a closed disclosure using the accessible name filter" do
        disclosure = find(:id, "disclosure-button-content", visible: false)
        expect(select_disclosure(accessible_name: "Disclosure button")).to eq disclosure
        expect(page).to have_selector :disclosure, accessible_name: "Disclosure button", expanded: true
      end
    end

    describe "#within_disclosure" do
      it "finds within a disclosure" do
        toggle_disclosure("Disclosure button")
        within_disclosure "Disclosure button" do
          expect(page).to have_text "Disclosure content", exact: true
        end
      end
    end
  end

  context "with disclosure pattern with simulated button" do
    it "selects the button" do
      button = page.find(:element, :span, text: "Disclosure span button")
      expect(page.find(:disclosure_button, "Disclosure span button")).to eq button
      expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
      expect(page).to have_no_selector :disclosure_button, "Disclosure span button", expanded: true
    end

    it "selects the disclosure" do
      # The disclosure isn't visible
      button = page.find(:element, :div, text: "Disclosure span content", visible: false)
      expect(page.find(:disclosure, "Disclosure span button", visible: false)).to eq button
      expect(page).to have_no_selector :disclosure, "Disclosure span button"
    end

    it "finds a disclosure using the accessible name filter" do
      disclosure = page.find(:element, :div, text: "Disclosure span content", visible: false)
      expect(find(:disclosure, accessible_name: "Disclosure span", visible: false)).to eq disclosure
      expect(find(:disclosure, accessible_name: /Disclosure span/, visible: false)).to eq disclosure
    end

    describe "#toggle_disclosure" do
      it "toggles a disclosure open and closed" do
        expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
        # Open
        toggle_disclosure("Disclosure span button")
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
        expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: true
        # Force open
        toggle_disclosure("Disclosure span button", expand: true)
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
        expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: true
        # Close
        toggle_disclosure("Disclosure span button")
        expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
        # Force close
        toggle_disclosure("Disclosure span button", expand: false)
        expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
      end

      it "returns the button" do
        button = page.find(:element, "span", text: "Disclosure span button")
        expect(toggle_disclosure("Disclosure span button")).to eq button
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      end

      it "can be called on a disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure span content", visible: false)
        disclosure.toggle_disclosure
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      end

      it "can be called on a disclosure button" do
        button = page.find(:element, :span, text: "Disclosure span button")
        button.toggle_disclosure
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      end

      it "runs the block within in the disclosure" do
        toggle_disclosure "Disclosure span button" do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure span content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the button" do
        button = page.find(:element, :span, text: "Disclosure span button")
        button.toggle_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure span content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure span content", visible: false)
        disclosure.toggle_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure span content
          TEXT
        end
      end

      it "toggles a disclosure using the accessible_name filter" do
        expect(page).to have_selector :disclosure_button, accessible_name: "Disclosure span button", expanded: false
        toggle_disclosure accessible_name: "Disclosure span button"
        expect(page).to have_selector :disclosure, accessible_name: "Disclosure span button", expanded: true
      end
    end

    describe "#select_disclosure" do
      it "opens and returns a closed disclosure" do
        disclosure = find(:id, "disclosure-span-content", visible: false)
        expect(select_disclosure("Disclosure span button")).to eq disclosure
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      end

      it "returns an open disclosure" do
        disclosure = find(:id, "disclosure-span-content", visible: false)
        select_disclosure("Disclosure span button")
        expect(select_disclosure("Disclosure span button")).to eq disclosure
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      end

      it "can be called on a disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure span content", visible: false)
        disclosure.select_disclosure
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      end

      it "can be called on a disclosure button" do
        button = page.find(:element, :span, text: "Disclosure span button")
        button.select_disclosure
        expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      end

      it "runs the block within in the disclosure" do
        select_disclosure "Disclosure span button" do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure span content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the disclosure" do
        disclosure = page.find(:element, :div, text: "Disclosure span content", visible: false)
        disclosure.select_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure span content
          TEXT
        end
      end

      it "runs the block within in the disclosure when called on the button" do
        button = page.find(:element, :span, text: "Disclosure span button")
        button.select_disclosure do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Disclosure span content
          TEXT
        end
      end

      it "opens and returns a closed disclosure using the accessible name filter" do
        disclosure = find(:id, "disclosure-span-content", visible: false)
        expect(select_disclosure(accessible_name: "Disclosure span button")).to eq disclosure
        expect(page).to have_selector :disclosure, accessible_name: "Disclosure span button", expanded: true
      end
    end

    describe "#within_disclosure" do
      it "finds within a disclosure" do
        toggle_disclosure("Disclosure span button")
        within_disclosure "Disclosure span button" do
          expect(page).to have_text "Disclosure span content", exact: true
        end
      end
    end
  end
end
