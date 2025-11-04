# frozen_string_literal: true

describe "article selector" do
  describe "locator" do
    context "with <article> element" do
      it "finds an article" do
        render <<~HTML
          <article data-test-id="test">Content</article>
          <div>Content</div>
        HTML

        expect(page.find(:article)).to eq page.find(:test_id, "test")
      end

      it "finds based on part accessible name" do
        render <<~HTML
          <article aria-label="Article one" data-test-id="test">Content</article>
          <article aria-label="Article two">Content</article>
        HTML

        expect(page.find(:article, "Article o")).to eq page.find(:test_id, "test")
      end

      it "finds based on exact accessible name" do
        render <<~HTML
          <article aria-label="Article" data-test-id="test">Content</article>
          <article aria-label="Article two">Content</article>
        HTML

        expect(page.find(:article, "Article", exact: true)).to eq page.find(:test_id, "test")
      end

      it "finds based on regular expression" do
        render <<~HTML
          <article aria-label="Article one" data-test-id="test">Content</article>
          <article aria-label="Article two">Content</article>
        HTML

        expect(page.find(:article, /Article o/)).to eq page.find(:test_id, "test")
      end
    end

    context "with [role=article]" do
      it "finds an article" do
        render <<~HTML
          <div role="article" data-test-id="test">Content</article>
          <div>Content</div>
        HTML

        expect(page.find(:article)).to eq page.find(:test_id, "test")
      end
    end
  end
end
