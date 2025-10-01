# frozen_string_literal: true

describe "banner selector" do
  describe "locator" do
    context "when <header> element" do
      it "finds the first element" do
        render <<~HTML
          <header>Content</header>
        HTML

        expect(page).to have_selector :banner, count: 1
      end

      it "finds from self" do
        render <<~HTML
          <header>Content</header>
        HTML

        within :css, "header" do
          expect(page).to have_selector :banner, count: 1
        end
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

      it "does find if a child of a div" do
        render <<~HTML
          <div>
            <header>Content</header>
          </div>
        HTML

        expect(page).to have_selector :banner
      end

      it "does not find if a child of an article" do
        render <<~HTML
          <article>
            <header>Content</header>
          </article>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of an aside" do
        render <<~HTML
          <aside>
            <header>Content</header>
          </aside>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of a main" do
        render <<~HTML
          <main>
            <header>Content</header>
          </main>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of a nav" do
        render <<~HTML
          <nav>
            <header>Content</header>
          </nav>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of a section" do
        render <<~HTML
          <section>
            <header>Content</header>
          </section>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does find if a child of a group" do
        render <<~HTML
          <div role="group">
            <header>Content</header>
          </div>
        HTML

        expect(page).to have_selector :banner
      end

      it "does not find if a child of an explicit role article" do
        render <<~HTML
          <div role="article">
            <header>Content</header>
          </div>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role complimentary" do
        render <<~HTML
          <div role="complimentary">
            <header>Content</header>
          </div>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role main" do
        render <<~HTML
          <div role="main">
            <header>Content</header>
          </div>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role navigation" do
        render <<~HTML
          <div role="navigation">
            <header>Content</header>
          </div>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end

      it "does not find if a child of an explicit role region" do
        render <<~HTML
          <div role="region">
            <header>Content</header>
          </div>
        HTML

        expect(page).to have_no_selector :banner, "Wrong ancestor"
      end
    end

    context "when [role=banner]" do
      it "finds the first element" do
        render <<~HTML
          <div role="banner">Content</div>
        HTML

        expect(page).to have_selector :banner, count: 1
      end

      it "finds from self" do
        render <<~HTML
          <div role="banner">Content</div>
        HTML

        within :css, "[role=banner]" do
          expect(page).to have_selector :banner, count: 1
        end
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

      it "does find if a child of an article" do
        render <<~HTML
          <article>
            <div role="banner">Content</div>
          </article>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of an aside" do
        render <<~HTML
          <aside>
            <div role="banner">Content</div>
          </aside>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of a main" do
        render <<~HTML
          <main>
            <div role="banner">Content</div>
          </main>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of a nav" do
        render <<~HTML
          <nav>
            <div role="banner">Content</div>
          </nav>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of a section" do
        render <<~HTML
          <section>
            <div role="banner">Content</div>
          </section>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of an explicit role article" do
        render <<~HTML
          <div role="article">
            <div role="banner">Content</div>
          </div>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of an explicit role complimentary" do
        render <<~HTML
          <div role="complimentary">
            <div role="banner">Content</div>
          </div>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of an explicit role main" do
        render <<~HTML
          <div role="main">
            <div role="banner">Content</div>
          </div>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of an explicit role navigation" do
        render <<~HTML
          <div role="navigation">
            <div role="banner">Content</div>
          </div>
        HTML

        expect(page).to have_selector :banner
      end

      it "does find if a child of an explicit role region" do
        render <<~HTML
          <div role="region">
            <div role="banner">Content</div>
          </div>
        HTML

        expect(page).to have_selector :banner
      end
    end
  end
end
