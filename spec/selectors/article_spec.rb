# frozen_string_literal: true

describe "article selector" do
  describe "locator" do
    context "when <article> element" do
      context "when direct descendant of body" do
        it "finds the first element" do
          render <<~HTML
            <article>Content</article>
          HTML

          expect(page).to have_selector :article, count: 1
        end

        it "finds based on [aria-label]" do
          render <<~HTML
            <article aria-label="Article article">Content</article>
          HTML

          expect(page).to have_selector :article, "Article article"
        end

        it "does not find differing on [aria-label]" do
          render <<~HTML
            <article aria-label="Article article">Content</article>
          HTML

          expect(page).to have_no_selector :article, "Not the right locator"
        end

        it "finds based on [aria-labelledby]" do
          render <<~HTML
            <article aria-labelledby="article_label">
              <h1 id="article_label">Article article</h1>
            </article>
          HTML

          expect(page).to have_selector :article, "Article article"
        end

        it "does not find differing on [aria-labelledby]" do
          render <<~HTML
            <article aria-labelledby="article_label">
              <h1 id="article_label">Article article</h1>
            </article>
          HTML

          expect(page).to have_no_selector :article, "Not the right locator"
        end
      end
    end

    context "when [role=article]" do
      context "when direct descendant of body" do
        it "finds the first element" do
          render <<~HTML
            <div role="article">Content</div>
          HTML

          expect(page).to have_selector :article, count: 1
        end

        it "finds based on [aria-label]" do
          render <<~HTML
            <div role="article" aria-label="Div article">Content</div>
          HTML

          expect(page).to have_selector :article, "Div article"
        end

        it "does not find differing on [aria-label]" do
          render <<~HTML
            <div role="article" aria-label="Div article">Content</div>
          HTML

          expect(page).to have_no_selector :article, "Not the right locator"
        end

        it "finds based on [aria-labelledby]" do
          render <<~HTML
            <div role="article" aria-labelledby="article_label">
              <h1 id="article_label">Div article</h1>
            </div>
          HTML

          expect(page).to have_selector :article, "Div article"
        end

        it "does not find differing on [aria-labelledby]" do
          render <<~HTML
            <div role="article" aria-labelledby="article_label">
              <h1 id="article_label">Div article</h1>
            </div>
          HTML

          expect(page).to have_no_selector :article, "Not the right locator"
        end
      end
    end
  end
end
