# frozen_string_literal: true

describe "banner matchers" do
  describe "have_banner" do
    it "matches using a custom matcher" do
      render <<~HTML
        <header aria-label="A banner">Content</header>
      HTML

      expect(page).to have_banner("A banner")
    end
  end

  describe "have_no_banner" do
    it "matches using a negated custom matcher" do
      render <<~HTML
        <header aria-label="A banner">Content</header>
      HTML

      expect(page).to have_no_banner("Some junk")
    end
  end

  describe "within_banner" do
    it "scopes to inside a banner without text" do
      render <<~HTML
        <header>Some text</header>
      HTML

      within_banner do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a banner with text" do
      render <<~HTML
        <header aria-label="A banner">Some text</header>
      HTML

      within_banner "A banner" do
        expect(page).to have_text("Some text")
      end
    end
  end
end
