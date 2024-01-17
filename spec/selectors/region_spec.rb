# frozen_string_literal: true

describe "region selector" do
  describe "locator" do
    context "when <section> element" do
      it "does not find with no accessible label" do
        render <<~HTML
          <section>Content</section>
        HTML

        expect(page).to have_no_selector :region
      end

      it "finds based on [aria-label]" do
        render <<~HTML
          <section aria-label="Section region">Content</section>
          <section aria-label="Other region">Content</section>
        HTML

        expect(page).to have_selector :region, "Section region", count: 1
      end

      it "does not find differing on [aria-label]" do
        render <<~HTML
          <section aria-label="Section region">Content</section>
        HTML

        expect(page).to have_no_selector :region, "Not the right locator"
      end

      it "finds based on [aria-labelledby]" do
        render <<~HTML
          <section aria-labelledby="section_label">
            <h1 id="section_label">Section region</h1>
          </section>
          <section aria-labelledby="section_other">
            <h1 id="section_other">Other region</h1>
          </section>
        HTML

        expect(page).to have_selector :region, "Section region", count: 1
      end

      it "does not find differing on [aria-labelledby]" do
        render <<~HTML
          <section aria-labelledby="section_label">
            <h1 id="section_label">Section region</h1>
          </section>
        HTML

        expect(page).to have_no_selector :region, "Not the right locator"
      end

      it "does not find with empty aria-label" do
        render <<~HTML
          <section aria-label=" ">Content</section>
        HTML

        expect(page).to have_no_selector :region
      end

      it "does not find with empty aria-labelledby" do
        render <<~HTML
          <section aria-labelledby="id">Content</section>
          <div id="id"></div>
        HTML

        expect(page).to have_no_selector :region
      end
    end

    context "when [role=region]" do
      it "finds the first element" do
        render <<~HTML
          <div role="region">Content</div>
        HTML

        expect(page).to have_selector :region, count: 1
      end

      it "finds based on [aria-label]" do
        render <<~HTML
          <div role="region" aria-label="Div region">Content</div>
        HTML

        expect(page).to have_selector :region, "Div region"
      end

      it "does not find differing on [aria-label]" do
        render <<~HTML
          <div role="region" aria-label="Div region">Content</div>
        HTML

        expect(page).to have_no_selector :region, "Not the right locator"
      end

      it "finds based on [aria-labelledby]" do
        render <<~HTML
          <div role="region" aria-labelledby="region_label">
            <h1 id="region_label">Div region</h1>
          </div>
        HTML

        expect(page).to have_selector :region, "Div region"
      end

      it "does not find differing on [aria-labelledby]" do
        render <<~HTML
          <div role="region" aria-labelledby="region_label">
            <h1 id="region_label">Div region</h1>
          </div>
        HTML

        expect(page).to have_no_selector :region, "Not the right locator"
      end
    end
  end
end
