# frozen_string_literal: true

describe "region matchers" do
  describe "have_region" do
    it "matches using a custom matcher" do
      render <<~HTML
        <section aria-label="A region">Content</section>
      HTML

      expect(page).to have_region("A region")
    end
  end

  describe "have_no_region" do
    it "matches using a negated custom matcher" do
      render <<~HTML
        <section aria-label="A region">Content</section>
      HTML

      expect(page).to have_no_region("Some junk")
    end
  end

  describe "within_region" do
    it "scopes to inside a region with text" do
      render <<~HTML
        <section aria-label="A region">Some text</section>
      HTML

      within_region "A region" do
        expect(page).to have_text("Some text")
      end
    end
  end
end
