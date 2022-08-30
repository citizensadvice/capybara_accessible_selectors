# frozen_string_literal: true

require "spec_helper"

describe "main selector" do
  describe "locator" do
    context "when <main> element" do
      context "when direct descendant of body" do
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

      context "when descendant of another element" do
        it "does not find any elements" do
          html = %w[article aside nav section].map do |element|
            "<#{element}><main>Content</main></#{element}>"
          end.join

          render html

          expect(page).to have_no_selector :main
        end

        it "does not find based on [aria-label]" do
          render <<~HTML
            <section>
              <main aria-label="Main main">Content</main>
            </section>
          HTML

          expect(page).to have_no_selector :main, "Main main"
        end

        it "does not find based on [aria-labelledby]" do
          render <<~HTML
            <section>
              <main aria-labelledby="main_label">
                <h1 id="main_label">Main main</h1>
              </main>
            </section>
          HTML

          expect(page).to have_no_selector :main, "Main main"
        end
      end
    end

    context "when [role=main]" do
      context "when direct descendant of body" do
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

      context "when descendant of another element" do
        it "does not find any elements" do
          html = %w[article aside nav section].map do |element|
            %(<#{element}><div role="main">Content</div></#{element}>)
          end.join

          render html

          expect(page).to have_no_selector :main
        end

        it "does not find based on [aria-label]" do
          render <<~HTML
            <section>
              <div role="main" aria-label="Main main">Content</div>
            </section>
          HTML

          expect(page).to have_no_selector :main, "Main main"
        end

        it "does not find based on [aria-labelledby]" do
          render <<~HTML
            <section>
              <div role="main" aria-labelledby="main_label">
                <h1 id="main_label">Main main</h1>
              </div>
            </section>
          HTML

          expect(page).to have_no_selector :main, "Main main"
        end
      end
    end
  end
end
