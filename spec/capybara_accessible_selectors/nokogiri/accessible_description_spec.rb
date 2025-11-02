# frozen_string_literal: true

RSpec.describe CapybaraAccessibleSelectors::Nokogiri::AccessibleDescription, driver: :rack_test do
  describe "aria-describedby" do
    it "returns an accessible name from aria-describedby" do
      render <<~HTML
        <div role="group" aria-describedby="id2 id1" data-test-id="test">Contents</div>
        <span id="id1">description</span>
        <span id="id2">Accessible</span>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible description"
    end
  end

  describe "aria-description" do
    it "returns an accessible description from aria-description" do
      render <<~HTML
        <div role="group" aria-description="Accessible description" data-test-id="test" title="title">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible description"
    end

    it "does not return an accessible description from aria-description if an empty aria-describedby is supplied" do
      render <<~HTML
        <div role="group" aria-describedby="" aria-description="Accessible description" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end
  end

  describe "native" do
    context "with an <input> type button" do
      it "calculates from title" do
        render <<~HTML
          <label for="id1">label</label>
          <input type="button" id="id1" value="value" title="foo">
        HTML

        expect(find(:element, "input").accessible_description).to eq "value"
      end
    end
  end

  describe "tooltip" do
    it "calculates from title" do
      render <<~HTML
        <article aria-label="xxx" title="title">
          Contents
        </article>
      HTML

      expect(find(:element, "article").accessible_description).to eq "title"
    end

    it "does not return an accessible description from tooltip if an empty aria-description is supplied" do
      render <<~HTML
        <div aria-label="xxx" role="group" aria-description="" title="title" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end
  end
end
