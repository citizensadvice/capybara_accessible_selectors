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

    it "excludes hidden text if description block is not hidden" do
      render <<~HTML
        <button aria-describedby="id" data-test-id="test">xxx</button>
        <div id="id">
          foo
          <span hidden>a</span>
          <span style="display:none">c</span>
          <span style="visibility:hidden">d</span>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "foo"
    end

    it "includes hidden text if description block is hidden" do
      render <<~HTML
        <button aria-describedby="id" data-test-id="test">xxx</button>
        <div id="id" hidden>
          foo
          <span hidden>a</span>
          <span aria-hidden="true">b</span>
          <span style="display:none">c</span>
          <span style="visibility:hidden">d</span>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "foo a b c d"
    end

    it "handles missing ids" do
      render <<~HTML
        <div role="group" aria-describedby="id2 id1" data-test-id="test">Contents</div>
        <span id="id2">Accessible</span>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible"
    end

    it "does not use if matching the accessible name" do
      render <<~HTML
        <div role="group" aria-labelledby="id" aria-describedby="id" data-test-id="test">Contents</div>
        <span id="id">xxx</span>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
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

    it "does not use if matching the accessible name" do
      render <<~HTML
        <div role="group" title="title" aria-description="title" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end
  end

  describe "native" do
    %w[button submit reset].each do |type|
      context "with an <input> type #{type}" do
        it "calculates from value" do
          render <<~HTML
            <label for="id1">label</label>
            <input type="#{type}" id="id1" value="value" title="foo">
          HTML

          expect(find(:element, "input").accessible_description).to eq "value"
        end

        it "does not use if matching the accessible name" do
          render <<~HTML
            <input type="#{type}" value="value" title="title">
          HTML

          expect(find(:element, "input").accessible_description).to eq "title"
        end
      end
    end

    context "with an <table>" do
      it "uses the caption" do
        render <<~HTML
          <table title="title" aria-label="xxx">
            <caption>caption</caption>
            <tr><td>cell</td><td>cell</td></tr>
            <tr><td>cell</td><td>cell</td></tr>
          </table>
        HTML

        expect(find(:element, "table").accessible_description).to eq "caption"
      end

      it "does not use the caption if empty" do
        render <<~HTML
          <table title="title" aria-label="xxx">
            <caption></caption>
            <tr><td>cell</td><td>cell</td></tr>
            <tr><td>cell</td><td>cell</td></tr>
          </table>
        HTML

        expect(find(:element, "table").accessible_description).to eq "title"
      end

      it "does not use the caption if the accessible name" do
        render <<~HTML
          <table title="title">
            <caption>caption</caption>
            <tr><td>cell</td><td>cell</td></tr>
            <tr><td>cell</td><td>cell</td></tr>
          </table>
        HTML

        expect(find(:element, "table").accessible_description).to eq "title"
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

    it "does not use if matching the accessible name" do
      render <<~HTML
        <div role="group" title="title" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end
  end
end
