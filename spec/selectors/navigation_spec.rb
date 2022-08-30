# frozen_string_literal: true

require "spec_helper"

describe "navigation selector" do
  describe "locator" do
    context "when <nav> element" do
      it "finds the first element" do
        render <<~HTML
          <nav>Content</nav>
        HTML

        expect(page).to have_selector :navigation, count: 1
      end

      it "finds based on [aria-label]" do
        render <<~HTML
          <nav aria-label="Nav navigation">Content</nav>
        HTML

        expect(page).to have_selector :navigation, "Nav navigation"
      end

      it "does not find differing on [aria-label]" do
        render <<~HTML
          <nav aria-label="Nav navigation">Content</nav>
        HTML

        expect(page).to have_no_selector :navigation, "Not the right locator"
      end

      it "finds based on [aria-labelledby]" do
        render <<~HTML
          <nav aria-labelledby="nav_label">
            <h1 id="nav_label">Nav navigation</h1>
          </nav>
        HTML

        expect(page).to have_selector :navigation, "Nav navigation"
      end

      it "does not find differing on [aria-labelledby]" do
        render <<~HTML
          <nav aria-labelledby="nav_label">
            <h1 id="nav_label">Nav navigation</h1>
          </nav>
        HTML

        expect(page).to have_no_selector :navigation, "Not the right locator"
      end
    end

    context "when [role=navigation]" do
      it "finds the first element" do
        render <<~HTML
          <div role="navigation">Content</div>
        HTML

        expect(page).to have_selector :navigation, count: 1
      end

      it "finds based on [aria-label]" do
        render <<~HTML
          <div role="navigation" aria-label="Div navigation">Content</div>
        HTML

        expect(page).to have_selector :navigation, "Div navigation"
      end

      it "does not find differing on [aria-label]" do
        render <<~HTML
          <div role="navigation" aria-label="Div navigation">Content</div>
        HTML

        expect(page).to have_no_selector :navigation, "Not the right locator"
      end

      it "finds based on [aria-labelledby]" do
        render <<~HTML
          <div role="navigation" aria-labelledby="navigation_label">
            <h1 id="navigation_label">Div navigation</h1>
          </div>
        HTML

        expect(page).to have_selector :navigation, "Div navigation"
      end

      it "does not find differing on [aria-labelledby]" do
        render <<~HTML
          <div role="navigation" aria-labelledby="navigation_label">
            <h1 id="navigation_label">Div navigation</h1>
          </div>
        HTML

        expect(page).to have_no_selector :navigation, "Not the right locator"
      end
    end
  end
end
