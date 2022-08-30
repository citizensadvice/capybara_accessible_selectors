# frozen_string_literal: true

require "spec_helper"

describe "contentinfo selector" do
  describe "locator" do
    context "when <footer> element" do
      context "when direct descendant of body" do
        it "finds the first element" do
          render <<~HTML
            <footer>Content</footer>
          HTML

          expect(page).to have_selector :contentinfo, count: 1
        end

        it "finds based on [aria-label]" do
          render <<~HTML
            <footer aria-label="Footer contentinfo">Content</footer>
          HTML

          expect(page).to have_selector :contentinfo, "Footer contentinfo"
        end

        it "does not find differing on [aria-label]" do
          render <<~HTML
            <footer aria-label="Footer contentinfo">Content</footer>
          HTML

          expect(page).to have_no_selector :contentinfo, "Not the right locator"
        end

        it "finds based on [aria-labelledby]" do
          render <<~HTML
            <footer aria-labelledby="contentinfo_label">
              <h1 id="contentinfo_label">Footer contentinfo</h1>
            </footer>
          HTML

          expect(page).to have_selector :contentinfo, "Footer contentinfo"
        end

        it "does not find differing on [aria-labelledby]" do
          render <<~HTML
            <footer aria-labelledby="contentinfo_label">
              <h1 id="contentinfo_label">Footer contentinfo</h1>
            </footer>
          HTML

          expect(page).to have_no_selector :contentinfo, "Not the right locator"
        end
      end

      context "when descendant of another element" do
        it "does not find any elements" do
          html = %w[article aside main nav section].map do |element|
            "<#{element}><footer>Content</footer></#{element}>"
          end.join

          render html

          expect(page).to have_no_selector :contentinfo
        end

        it "does not find based on [aria-label]" do
          render <<~HTML
            <section>
              <footer aria-label="Footer contentinfo">Content</footer>
            </section>
          HTML

          expect(page).to have_no_selector :contentinfo, "Footer contentinfo"
        end

        it "does not find based on [aria-labelledby]" do
          render <<~HTML
            <section>
              <footer aria-labelledby="contentinfo_label">
                <h1 id="contentinfo_label">Footer contentinfo</h1>
              </footer>
            </section>
          HTML

          expect(page).to have_no_selector :contentinfo, "Footer contentinfo"
        end
      end
    end

    context "when [role=contentinfo]" do
      context "when direct descendant of body" do
        it "finds the first element" do
          render <<~HTML
            <div role="contentinfo">Content</div>
          HTML

          expect(page).to have_selector :contentinfo, count: 1
        end

        it "finds based on [aria-label]" do
          render <<~HTML
            <div role="contentinfo" aria-label="Footer contentinfo">Content</div>
          HTML

          expect(page).to have_selector :contentinfo, "Footer contentinfo"
        end

        it "does not find differing on [aria-label]" do
          render <<~HTML
            <div role="contentinfo" aria-label="Footer contentinfo">Content</div>
          HTML

          expect(page).to have_no_selector :contentinfo, "Not the right locator"
        end

        it "finds based on [aria-labelledby]" do
          render <<~HTML
            <div role="contentinfo" aria-labelledby="contentinfo_label">
              <h1 id="contentinfo_label">Footer contentinfo</h1>
            </div>
          HTML

          expect(page).to have_selector :contentinfo, "Footer contentinfo"
        end

        it "does not find differing on [aria-labelledby]" do
          render <<~HTML
            <div role="contentinfo" aria-labelledby="contentinfo_label">
              <h1 id="contentinfo_label">Footer contentinfo</h1>
            </div>
          HTML

          expect(page).to have_no_selector :contentinfo, "Not the right locator"
        end
      end

      context "when descendant of another element" do
        it "does not find any elements" do
          html = %w[article aside main nav section].map do |element|
            %(<#{element}><div role="contentinfo">Content</div></#{element}>)
          end.join

          render html

          expect(page).to have_no_selector :contentinfo
        end

        it "does not find based on [aria-label]" do
          render <<~HTML
            <section>
              <div role="contentinfo" aria-label="Footer contentinfo">Content</div>
            </section>
          HTML

          expect(page).to have_no_selector :contentinfo, "Footer contentinfo"
        end

        it "does not find based on [aria-labelledby]" do
          render <<~HTML
            <section>
              <div role="contentinfo" aria-labelledby="contentinfo_label">
                <h1 id="contentinfo_label">Footer contentinfo</h1>
              </div>
            </section>
          HTML

          expect(page).to have_no_selector :contentinfo, "Footer contentinfo"
        end
      end
    end
  end
end
