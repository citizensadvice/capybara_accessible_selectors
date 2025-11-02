# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#accessible_description" do
  describe "aria-describedby" do
    it "returns an accessible name from aria-describedby" do
      render <<~HTML
        <div role="group" aria-describedby="id2 id1" data-test-id="test">Contents</div>
        <span id="id1">description</span>
        <span id="id2">Accessible</span>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible description"
    end

    it "finds all hidden text on hidden elements"
    it "finds all visible text on visible elements"
  end

  describe "aria-description" do
    it "returns an accessible description from aria-description" do
      render <<~HTML
        <div role="group" aria-description="Accessible description" data-test-id="test" title="title">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible description"
    end

    it "does not return an accessible description from an aria-description if an empty aria-describedby is supplied" do
      render <<~HTML
        <div role="group" aria-describedby="" aria-description="Accessible description" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end
  end

  describe "native" do
    context "with a <table> type" do
      it "calculates from caption"
      it "it does not use if matching the accessible name"
    end

    %w[button submit reset].each do |type|
      context "with an <input> type #{type}" do
        it "calculates from value" do
          render <<~HTML
            <label for="id1">label</label>
            <input type="#{type}" id="id1" value="value" title="foo">
          HTML

          expect(find(:element, "input").accessible_description).to eq "value"
        end

        it "does not use if matching the accessible name"
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

    it "does not return an accessible description from tooltip if it matches the accessible name"
  end
end
