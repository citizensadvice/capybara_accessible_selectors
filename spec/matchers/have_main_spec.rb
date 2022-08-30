# frozen_string_literal: true

describe "main matchers" do
  describe "have_main" do
    it "matches using a custom matcher" do
      render <<~HTML
        <main aria-label="A main">Content</main>
      HTML

      expect(page).to have_main("A main")
    end
  end

  describe "have_no_main" do
    it "matches using a negated custom matcher" do
      render <<~HTML
        <main aria-label="A main">Content</main>
      HTML

      expect(page).to have_no_main("Some junk")
    end
  end

  describe "within_main" do
    it "scopes to inside a main without text" do
      render <<~HTML
        <main>Some text</main>
      HTML

      within_main do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a main with text" do
      render <<~HTML
        <main aria-label="A main">Some text</main>
      HTML

      within_main "A main" do
        expect(page).to have_text("Some text")
      end
    end
  end
end
