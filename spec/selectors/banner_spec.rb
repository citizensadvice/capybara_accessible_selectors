# frozen_string_literal: true

require "spec_helper"

describe "banner selector" do
  describe "locator" do
    context "when <header> element" do
      context "when direct descendant of body" do
        it "finds the first element" do
          render <<~HTML
            <header>Content</header>
          HTML

          expect(page).to have_selector :banner, count: 1
        end

        it "finds based on [aria-label]" do
          render <<~HTML
            <header aria-label="Header banner">Content</header>
          HTML

          expect(page).to have_selector :banner, "Header banner"
        end

        it "does not find differing on [aria-label]" do
          render <<~HTML
            <header aria-label="Header banner">Content</header>
          HTML

          expect(page).to have_no_selector :banner, "Not the right locator"
        end

        it "finds based on [aria-labelledby]" do
          render <<~HTML
            <header aria-labelledby="banner_label">
              <h1 id="banner_label">Header banner</h1>
            </header>
          HTML

          expect(page).to have_selector :banner, "Header banner"
        end

        it "does not find differing on [aria-labelledby]" do
          render <<~HTML
            <header aria-labelledby="banner_label">
              <h1 id="banner_label">Header banner</h1>
            </header>
          HTML

          expect(page).to have_no_selector :banner, "Not the right locator"
        end
      end

      context "when descendant of another element" do
        it "does not find any elements" do
          html = %w[article aside main nav section].map do |element|
            "<#{element}><header>Content</header></#{element}>"
          end.join

          render html

          expect(page).to have_no_selector :banner
        end

        it "does not find based on [aria-label]" do
          render <<~HTML
            <section>
              <header aria-label="Header banner">Content</header>
            </section>
          HTML

          expect(page).to have_no_selector :banner, "Header banner"
        end

        it "does not find based on [aria-labelledby]" do
          render <<~HTML
            <section>
              <header aria-labelledby="banner_label">
                <h1 id="banner_label">Header banner</h1>
              </header>
            </section>
          HTML

          expect(page).to have_no_selector :banner, "Header banner"
        end
      end
    end

    context "when [role=banner]" do
      context "when direct descendant of body" do
        it "finds the first element" do
          render <<~HTML
            <div role="banner">Content</div>
          HTML

          expect(page).to have_selector :banner, count: 1
        end

        it "finds based on [aria-label]" do
          render <<~HTML
            <div role="banner" aria-label="Header banner">Content</div>
          HTML

          expect(page).to have_selector :banner, "Header banner"
        end

        it "does not find differing on [aria-label]" do
          render <<~HTML
            <div role="banner" aria-label="Header banner">Content</div>
          HTML

          expect(page).to have_no_selector :banner, "Not the right locator"
        end

        it "finds based on [aria-labelledby]" do
          render <<~HTML
            <div role="banner" aria-labelledby="banner_label">
              <h1 id="banner_label">Header banner</h1>
            </div>
          HTML

          expect(page).to have_selector :banner, "Header banner"
        end

        it "does not find differing on [aria-labelledby]" do
          render <<~HTML
            <div role="banner" aria-labelledby="banner_label">
              <h1 id="banner_label">Header banner</h1>
            </div>
          HTML

          expect(page).to have_no_selector :banner, "Not the right locator"
        end
      end

      context "when descendant of another element" do
        it "does not find any elements" do
          html = %w[article aside main nav section].map do |element|
            %(<#{element}><div role="banner">Content</div></#{element}>)
          end.join

          render html

          expect(page).to have_no_selector :banner
        end

        it "does not find based on [aria-label]" do
          render <<~HTML
            <section>
              <div role="banner" aria-label="Header banner">Content</div>
            </section>
          HTML

          expect(page).to have_no_selector :banner, "Header banner"
        end

        it "does not find based on [aria-labelledby]" do
          render <<~HTML
            <section>
              <div role="banner" aria-labelledby="banner_label">
                <h1 id="banner_label">Header banner</h1>
              </div>
            </section>
          HTML

          expect(page).to have_no_selector :banner, "Header banner"
        end
      end
    end
  end
end
