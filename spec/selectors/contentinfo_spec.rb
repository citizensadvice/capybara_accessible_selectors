# frozen_string_literal: true

describe "contentinfo selector" do
  describe "locator" do
    context "when <footer> element" do
      it "finds the first element" do
        render <<~HTML
          <footer data-test-id="test">Content</footer>
          <div>Content</div>
        HTML

        expect(page.find(:contentinfo)).to eq page.find(:test_id, "test")
      end

      it "finds based on part accessible name" do
        render <<~HTML
          <footer aria-label="Footer one" data-test-id="test">Content</footer>
          <footer aria-label="Footer two">Content</footer>
        HTML

        expect(page.find(:contentinfo, "Footer o")).to eq page.find(:test_id, "test")
      end

      it "finds based on exact accessible name" do
        render <<~HTML
          <footer aria-label="Footer" data-test-id="test">Content</footer>
          <footer aria-label="Footer two">Content</footer>
        HTML

        expect(page.find(:contentinfo, "Footer", exact: true)).to eq page.find(:test_id, "test")
      end

      it "finds based on regular expression" do
        render <<~HTML
          <footer aria-label="Footer one" data-test-id="test">Content</footer>
          <footer aria-label="Footer two">Content</footer>
        HTML

        expect(page.find(:contentinfo, /Footer o/)).to eq page.find(:test_id, "test")
      end

      it "finds from self" do
        render <<~HTML
          <footer>Content</footer>
        HTML

        within :css, "footer" do
          expect(page).to have_selector :contentinfo, count: 1
        end
      end

      it "does find if a child of a div" do
        render <<~HTML
          <div>
            <footer>Content</footer>
          </div>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does not find if a child of an article" do
        render <<~HTML
          <article>
            <footer>Content</footer>
          </article>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of an aside" do
        render <<~HTML
          <aside>
            <footer>Content</footer>
          </aside>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of a main" do
        render <<~HTML
          <main>
            <footer>Content</footer>
          </main>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of a nav" do
        render <<~HTML
          <nav>
            <footer>Content</footer>
          </nav>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of a section" do
        render <<~HTML
          <section>
            <footer>Content</footer>
          </section>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does find if a child of a group" do
        render <<~HTML
          <div role="group">
            <footer>Content</footer>
          </div>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does not find if a child of an explicit role article" do
        render <<~HTML
          <div role="article">
            <footer>Content</footer>
          </div>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role complimentary" do
        render <<~HTML
          <div role="complimentary">
            <footer>Content</footer>
          </div>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role main" do
        render <<~HTML
          <div role="main">
            <footer>Content</footer>
          </div>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role navigation" do
        render <<~HTML
          <div role="navigation">
            <footer>Content</footer>
          </div>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role region" do
        render <<~HTML
          <div role="region">
            <footer>Content</footer>
          </div>
        HTML

        expect(page).to have_no_selector :contentinfo, "Wrong ancestor"
      end
    end

    context "when [role=contentinfo]" do
      it "finds the first element" do
        render <<~HTML
          <div role="contentinfo" data-test-id="test">Content</div>
          <div>Content</div>
        HTML

        expect(page.find(:contentinfo)).to eq page.find(:test_id, "test")
      end

      it "finds from self" do
        render <<~HTML
          <div role="contentinfo">Content</div>
        HTML

        within :css, "[role=contentinfo]" do
          expect(page).to have_selector :contentinfo, count: 1
        end
      end

      it "does find if a child of an article" do
        render <<~HTML
          <article>
            <div role="contentinfo">Content</div>
          </article>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of an aside" do
        render <<~HTML
          <aside>
            <div role="contentinfo">Content</div>
          </aside>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of a main" do
        render <<~HTML
          <main>
            <div role="contentinfo">Content</div>
          </main>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of a nav" do
        render <<~HTML
          <nav>
            <div role="contentinfo">Content</div>
          </nav>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of a section" do
        render <<~HTML
          <section>
            <div role="contentinfo">Content</div>
          </section>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of an explicit role article" do
        render <<~HTML
          <div role="article">
            <div role="contentinfo">Content</div>
          </div>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of an explicit role complimentary" do
        render <<~HTML
          <div role="complimentary">
            <div role="contentinfo">Content</div>
          </div>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of an explicit role main" do
        render <<~HTML
          <div role="main">
            <div role="contentinfo">Content</div>
          </div>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of an explicit role navigation" do
        render <<~HTML
          <div role="navigation">
            <div role="contentinfo">Content</div>
          </div>
        HTML

        expect(page).to have_selector :contentinfo
      end

      it "does find if a child of an explicit role region" do
        render <<~HTML
          <div role="region">
            <div role="contentinfo">Content</div>
          </div>
        HTML

        expect(page).to have_selector :contentinfo
      end
    end
  end
end
