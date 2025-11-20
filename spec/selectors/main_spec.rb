# frozen_string_literal: true

describe "main selector" do
  describe "locator" do
    context "when <main> element" do
      it "finds the first element" do
        render <<~HTML
          <main>Content</main>
        HTML

        expect(page).to have_selector :main, count: 1
      end

      it "finds based on [aria-label]" do
        render <<~HTML
          <main aria-label="Main main">Content</main>
        HTML

        expect(page).to have_selector :main, "Main main"
      end

      it "does not find differing on [aria-label]" do
        render <<~HTML
          <main aria-label="Main main">Content</main>
        HTML

        expect(page).to have_no_selector :main, "Not the right locator"
      end

      it "finds based on [aria-labelledby]" do
        render <<~HTML
          <main aria-labelledby="main_label">
            <h1 id="main_label">Main main</h1>
          </main>
        HTML

        expect(page).to have_selector :main, "Main main"
      end

      it "does not find differing on [aria-labelledby]" do
        render <<~HTML
          <main aria-labelledby="main_label">
            <h1 id="main_label">Main main</h1>
          </main>
        HTML

        expect(page).to have_no_selector :main, "Not the right locator"
      end
    end

    context "when [role=main]" do
      it "finds the first element" do
        render <<~HTML
          <div role="main">Content</div>
        HTML

        expect(page).to have_selector :main, count: 1
      end

      it "finds based on [aria-label]" do
        render <<~HTML
          <div role="main" aria-label="Main main">Content</div>
        HTML

        expect(page).to have_selector :main, "Main main"
      end

      it "does not find differing on [aria-label]" do
        render <<~HTML
          <div role="main" aria-label="Main main">Content</div>
        HTML

        expect(page).to have_no_selector :main, "Not the right locator"
      end

      it "finds based on [aria-labelledby]" do
        render <<~HTML
          <div role="main" aria-labelledby="main_label">
            <h1 id="main_label">Main main</h1>
          </div>
        HTML

        expect(page).to have_selector :main, "Main main"
      end

      it "does not find differing on [aria-labelledby]" do
        render <<~HTML
          <div role="main" aria-labelledby="main_label">
            <h1 id="main_label">Main main</h1>
          </div>
        HTML

        expect(page).to have_no_selector :main, "Not the right locator"
      end
    end
  end
end
