# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#accessible_name" do
  # TODO: embeded controls
  # TODO: figcaption
  # TODO: hidden - double check aria-hidden handling
  # TODO: no role / generic - can they be named?
  # TODO: cleanup

  describe "aria-labelledby" do
    it "returns an accessible name from aria-labelledby" do
      render <<~HTML
        <div role="group" aria-labelledby="id2 id1" data-test-id="test" aria-label="label" title="title">Contents</div>
        <span id="id1">name</span>
        <span id="id2">Accessible</span>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
    end
  end

  describe "aria-label" do
    it "returns an accessible name from aria-label" do
      render <<~HTML
        <div role="group" aria-label="Accessible name" data-test-id="test" title="title">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
    end
  end

  describe "tooltip" do
    it "returns an accessible name from title" do
      render <<~HTML
        <div role="group" title="Accessible name" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
    end
  end

  describe "native" do
    context "with an <input>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <input id="id1" title="foo">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <input id="id1">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label1 label2"
      end

      it "does not include aria-hidden labels" do
        render <<~HTML
          <label for="id1" aria-hidden="true">label1</label>
          <label for="id1">label2</label>
          <input id="id1">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label2"
      end

      it "does not include hidden labels" do
        render <<~HTML
          <label for="id1" hidden>label1</label>
          <label for="id1">label2</label>
          <input id="id1">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label2"
      end

      it "calculates from title with empty label" do
        render <<~HTML
          <label for="id"></label>
          <input id="id" title="foo">
        HTML

        expect(find(:element, "input").accessible_name).to eq "foo"
      end

      it "calculates from an implicit label" do
        render <<~HTML
          <label>
            foo
            <input title="title">
          </label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "foo"
      end

      it "calculates from an explicit label and an implicit label" do
        render <<~HTML
          <label>
            foo
            <input id="id" title="title">
          </label>
          <label for="id">bar</label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "bar foo"
      end

      it "calculates from nested implicit labels" do
        render <<~HTML
          <label>
            bar
            <label>
              foo
              <input title="title">
            </label>
          </label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "foo"
      end

      it "does not create infinite loops in a label" do
        render <<~HTML
          <label for="id1">
            <input id="id1" title="title">
          </label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "title"
      end

      it "uses the full algorithm in labels" do
        render <<~HTML
          <input id="id">
          <label for="id">foo <button aria-label="bar">xxx</button> fee</label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "foo bar fee"
      end

      it "ignores hidden labels" do
        render <<~HTML
          <input id="id" title="title">
          <label for="id" hidden>foo</label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "title"
      end

      it "ignores aria-hidden labels" do
        render <<~HTML
          <input id="id" title="title">
          <label for="id" aria-hidden="true">foo</label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "title"
      end

      it "ignores hidden sections in labels" do
        render <<~HTML
          <input id="id" title="title">
          <label for="id">foo<span hidden>xxx</span><span aria-hidden="true">yyy</span></label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "foo"
      end

      it "calculates from title" do
        render <<~HTML
          <input title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <input>
        HTML

        expect(find(:element, "input").accessible_name).to eq ""
      end
    end

    context "with a <textarea>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <textarea id="id1" title="foo"></textarea>
        HTML

        expect(find(:element, "textarea").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <textarea id="id1"></textarea>
        HTML

        expect(find(:element, "textarea").accessible_name).to eq "label1 label2"
      end

      it "calculates from title" do
        render <<~HTML
          <textarea title="title"></textarea>
        HTML

        expect(find(:element, "textarea").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <textarea></textarea>
        HTML

        expect(find(:element, "textarea").accessible_name).to eq ""
      end
    end

    context "with a <select>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <select id="id1" title="foo"></select>
        HTML

        expect(find(:element, "select").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <select id="id1"></select>
        HTML

        expect(find(:element, "select").accessible_name).to eq "label1 label2"
      end

      it "calculates from title" do
        render <<~HTML
          <select title="title"></select>
        HTML

        expect(find(:element, "select").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <select></select>
        HTML

        expect(find(:element, "select").accessible_name).to eq ""
      end
    end

    context "with an <input type=button>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <input type="button" id="id1" title="foo" value="value">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <input type="button" value="value" id="id1">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label1 label2"
      end

      it "calculates from value" do
        render <<~HTML
          <input type="button" value="value" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "value"
      end

      it "calculates from title" do
        render <<~HTML
          <input type="button" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <input type="button">
        HTML

        expect(find(:element, "input").accessible_name).to eq ""
      end
    end

    context "with an <input type=submit>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <input type="submit" id="id1" title="foo" value="value">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <input type="submit" value="value" id="id1">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label1 label2"
      end

      it "calculates from value" do
        render <<~HTML
          <input type="submit" value="value" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "value"
      end

      it "is Submit Query with no name" do
        render <<~HTML
          <input type="submit" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "Submit"
      end
    end

    context "with an <input type=reset>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <input type="reset" id="id1" title="foo" value="value">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <input type="reset" value="value" id="id1">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label1 label2"
      end

      it "calculates from value" do
        render <<~HTML
          <input type="reset" value="value" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "value"
      end

      it "is Reset with no name" do
        render <<~HTML
          <input type="reset" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "Reset"
      end
    end

    context "with an <input type=image>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <input type="image" id="id1" title="foo" value="value" alt="alt">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <input type="image" value="value" id="id1" alt="alt">
        HTML

        expect(find(:element, "input").accessible_name).to eq "label1 label2"
      end

      it "calculates from alt" do
        render <<~HTML
          <input type="image" value="value" alt="alt" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "alt"
      end

      it "calculates from title" do
        render <<~HTML
          <input type="image" value="value" title="title">
        HTML

        expect(find(:element, "input").accessible_name).to eq "title"
      end

      it "is Submit with no name" do
        render <<~HTML
          <input type="image"">
        HTML

        expect(find(:element, "input").accessible_name).to eq "Submit"
      end
    end

    context "with a <button>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <button id="id1" title="foo">content</button>
        HTML

        expect(find(:element, "button").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <button id="id1">content</button>
        HTML

        expect(find(:element, "button").accessible_name).to eq "label1 label2"
      end

      it "calculates from subtree" do
        render <<~HTML
          <button title="title">content</button>
        HTML

        expect(find(:element, "button").accessible_name).to eq "content"
      end

      it "calculates from title" do
        render <<~HTML
          <button title="title"></button>
        HTML

        expect(find(:element, "button").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <button></button>
        HTML

        expect(find(:element, "button").accessible_name).to eq ""
      end
    end

    context "with a <fieldset>" do
      it "calculates from legend" do
        render <<~HTML
          <fieldset title="title">
            <legend>legend</legend>
            contents
          </fieldset>
        HTML

        expect(find(:element, "fieldset").accessible_name).to eq "legend"
      end

      it "calculates from title with empty legend" do
        render <<~HTML
          <fieldset title="title">
            <legend></legend>
            contents
          </fieldset>
        HTML

        expect(find(:element, "fieldset").accessible_name).to eq "title"
      end

      it "calculates from title" do
        render <<~HTML
          <fieldset title="title">
            contents
          </fieldset>
        HTML

        expect(find(:element, "fieldset").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <fieldset>
            contents
          </fieldset>
        HTML

        expect(find(:element, "fieldset").accessible_name).to eq ""
      end
    end

    context "with an <output>" do
      it "calculates from label" do
        render <<~HTML
          <label for="id1">label</label>
          <output id="id1" title="foo">content</output>
        HTML

        expect(find(:element, "output").accessible_name).to eq "label"
      end

      it "calculates from multiple labels" do
        render <<~HTML
          <label for="id1">label1</label>
          <label for="id1">label2</label>
          <output id="id1">content</output>
        HTML

        expect(find(:element, "output").accessible_name).to eq "label1 label2"
      end

      it "calculates from title" do
        render <<~HTML
          <output title="title">content</output>
        HTML

        expect(find(:element, "output").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <output>content</output>
        HTML

        expect(find(:element, "output").accessible_name).to eq ""
      end
    end

    context "with a <summary>" do
      it "calculates from subtree" do
        render <<~HTML
          <details>
            <summary title="title">name</summary>
            contents
          </details>
        HTML

        expect(find(:element, "summary").accessible_name).to eq "name"
      end

      it "calculates from title" do
        render <<~HTML
          <details>
            <summary title="title"></summary>
            contents
          </details>
        HTML

        expect(find(:element, "summary").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <details>
            <summary></summary>
            contents
          </details>
        HTML

        expect(find(:element, "summary").accessible_name).to eq ""
      end
    end

    context "with a <figure>" do
      it "calculates from title and not figcaption" do
        render <<~HTML
          <figure title="title">
            content
            <figcaption>caption</figcaption>
          </figure>
        HTML

        expect(find(:element, "figure").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <figure>
            content
            <figcaption>caption</figcaption>
          </figure>
        HTML

        expect(find(:element, "figure").accessible_name).to eq ""
      end
    end

    context "with an <img>" do
      it "calculates from alt" do
        render <<~HTML
          <figure>
            <img title="title" alt="alt" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
            <figcaption>caption</figcaption>
          </figure>
        HTML

        expect(find(:element, "img").accessible_name).to eq "alt"
      end

      it "calculates from title" do
        render <<~HTML
          <figure>
            <img title="title" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
            <figcaption>caption</figcaption>
          </figure>
        HTML

        expect(find(:element, "img").accessible_name).to eq "title"
      end

      it "calculates from figcaption if the only child" do
        render <<~HTML
          <figure>
            <img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
            <figcaption>caption</figcaption>
          </figure>
        HTML

        expect(find(:element, "img").accessible_name).to eq "caption"
      end

      it "is not calculated from figcaption if not the only child" do
        render <<~HTML
          <figure>
            <img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
            foo
            <br>
            <figcaption>caption</figcaption>
          </figure>
        HTML

        expect(find(:element, "img").accessible_name).to eq ""
      end

      it "is empty with no name" do
        render <<~HTML
          <img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
        HTML

        expect(find(:element, "img").accessible_name).to eq ""
      end
    end

    context "with a <table>" do
      it "calculates from caption" do
        render <<~HTML
          <table title="title">
            <caption>caption</caption>
            <tr><td>cell</td><td>cell</td></tr>
            <tr><td>cell</td><td>cell</td></tr>
          </table>
        HTML

        expect(find(:element, "table").accessible_name).to eq "caption"
      end

      it "calculates from title" do
        render <<~HTML
          <table title="title">
            <tr><td>cell</td><td>cell</td></tr>
            <tr><td>cell</td><td>cell</td></tr>
          </table>
        HTML

        expect(find(:element, "table").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <table>
            <tr><td>cell</td><td>cell</td></tr>
            <tr><td>cell</td><td>cell</td></tr>
          </table>
        HTML

        expect(find(:element, "table").accessible_name).to eq ""
      end
    end

    context "with an <area>" do
      it "calculates from alt" do
        render <<~HTML
          <img usemap="#map" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
          <map name="map">
            <area href="http://example.com" shape="circle" coords="5,5,5" alt="alt" title="title">
          </map>
        HTML

        expect(find(:element, "area").accessible_name).to eq "alt"
      end

      it "calculates from title" do
        render <<~HTML
          <img usemap="#map" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
          <map name="map">
            <area href="http://example.com" shape="circle" coords="5,5,5" title="title">
          </map>
        HTML

        expect(find(:element, "area").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <img usemap="#map" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
          <map name="map">
            <area href="http://example.com" shape="circle" coords="5,5,5">
          </map>
        HTML

        expect(find(:element, "area").accessible_name).to eq ""
      end
    end

    context "with an <svg>" do
      it "calculates from title element" do
        render <<~HTML
          <svg height="500" width="500" alt="alt" title="title">
            <title>content</title>
            <polygon points="250,60 100,400 400,400">
          </svg>
          <span id="id1">aria</span>
          <span id="id2">labelledby</span>
        HTML

        expect(find(:element, "svg").accessible_name).to eq "content"
      end

      it "calculates from title" do
        render <<~HTML
          <svg height="500" width="500" alt="alt" title="title">
            <polygon points="250,60 100,400 400,400">
          </svg>
          <span id="id1">aria</span>
          <span id="id2">labelledby</span>
        HTML

        expect(find(:element, "svg").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <svg height="500" width="500" alt="alt">
            <polygon points="250,60 100,400 400,400">
          </svg>
          <span id="id1">aria</span>
          <span id="id2">labelledby</span>
        HTML

        expect(find(:element, "svg").accessible_name).to eq ""
      end
    end

    context "with a <tr>" do
      it "calculates from content" do
        render <<~HTML
          <table title="title">
            <caption>caption</caption>
            <tr data-test-id="test"><td>foo</td><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "foo bar"
      end
    end

    context "with a <td>" do
      it "calculates from content" do
        render <<~HTML
          <table title="title">
            <caption>caption</caption>
            <tr><td data-test-id="test">foo</td><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "foo"
      end
    end

    context "with a <th>" do
      it "calculates from content" do
        render <<~HTML
          <table title="title">
            <caption>caption</caption>
            <tr><th data-test-id="test">foo</th><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "foo"
      end
    end

    context "with an <a>" do
      it "calculates from content" do
        render <<~HTML
          <a href="#" data-test-id="test">Link text</a>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "Link text"
      end
    end

    %w[1 2 3 4 5 6].each do |level|
      context "with an <h#{level}>" do
        it "calculates from content" do
          render <<~HTML
            <h#{level} data-test-id="test">Heading</h#{level}>
          HTML

          expect(find(:test_id, "test").accessible_name).to eq "Heading"
        end
      end
    end

    context "with an <option>" do
      it "calculates from label attribute" do
        render <<~HTML
          <select><option data-test-id="test" label="label">Value</option></select>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "label"
      end

      it "calculates from content" do
        render <<~HTML
          <select><option data-test-id="test">value</option></select>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "value"
      end
    end

    context "with an <optgroup>" do
      it "calculates from label attribute" do
        render <<~HTML
          <select><optgroup data-test-id="test" label="label"><option>value</option></optgroup></select>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "label"
      end
    end
  end

  describe "no name" do
    it "returns no name with no name" do
      render <<~HTML
        <div data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq ""
    end
  end

  describe "name from content" do
    %w[button cell checkbox columnheader comment gridcell heading link menuitem menuitemcheckbox
       menuitemradio option radio row rowheader switch tab tooltip treeitem].each do |role|
      it "takes the accessible name from the content for role #{role}" do
        render <<~HTML
          <div role=#{role} data-test-id="test">content</div>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "content"
      end
    end

    %w[progressbar scrollbar searchbox separator slider spinbutton tabpanel textbox combobox
       grid listbox menu menubar radiogroup tablist tree treegrid application article blockquote caption code
       definition deletion directory document emphasis feed figure generic group img image insertion
       list listitem mark math meter none note paragraph presentation rowgroup sectionfooter sectionheader
       separator strong subscript suggestion superscript table term time toolbar banner complementary
       contentinfo form main navigation region search alert log marquee status timer alertdialog dialog].each do |role|
      it "does not take the accessible name from the content for role #{role}" do
        render <<~HTML
          <div role=#{role} data-test-id="test">content</div>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq ""
      end
    end

    it "recursively finds the name of child elements" do
      render <<~HTML
        <div role="button" data-test-id="test">
          <div><span>foo</span><span>bar</span>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foobar"
    end

    it "trims additional white space" do
      render <<~HTML
        <div role="button" data-test-id="test">
          <div>  <span>foo</span><span>bar</span>  <span>fee</span>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foobar fee"
    end

    it "uses the full algorithm on descendant nodes" do
      render <<~HTML
        <div role="button" data-test-id="test">
          <div><span aria-label="fee">foo</span>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "fee"
    end

    it "surrounds block level elements with space" do
      render <<~HTML
        <div role="button" data-test-id="test">
          <div>foo</div>bar<div>fee</div>
          <span>foo</span>bar<span>fee</span>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo bar fee foobarfee"
    end

    it "treats br as a space" do
      render <<~HTML
        <div role="button" data-test-id="test">
          foo<br>bar
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo bar"
    end

    it "adds space around image elements" do
      render <<~HTML
        <div role="button" data-test-id="test">
          foo<img alt="bar">fee
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo bar fee"
    end

    it "adds space around tooltips" do
      render <<~HTML
        <div role="button" data-test-id="test">
          foo<abbr title="bar">xxx</abbr>fee
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo bar fee"
    end

    it "does not create infinite loops" do
      render <<~HTML
        <div role="button" data-test-id="test">
          <div id="id">foo<button aria-labelledby="id">bar</button></div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo bar"
    end

    it "does not recurse hidden elements" do
      render <<~HTML
        <div role="button" data-test-id="test">
          <div aria-hidden="true">foo</div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq ""
    end

    it "does not recurse hidden elements when resolving visible aria-labelledby" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">foo<span hidden>bar</span></div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo"
    end

    it "does recurse hidden elements when resolving hidden aria-labelledby" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id" hidden>foo <span hidden>bar</span></div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo bar"
    end

    it "does not recurse display none elements when resolving visible aria-labelledby" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">foo <span style="display:none">bar</span></div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo"
    end

    it "does not recurse aria-hidden elements when resolving visible aria-labelledby" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">foo <span aria-hidden="true">bar</span></div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo"
    end

    it "does not recurse direct aria-hidden elements when resolving visible aria-labelledby" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id" aria-hidden="true">foo<span aria-hidden="true">bar</span></div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foobar"
    end

    it "does not recurse undisplayed elements" do
      render <<~HTML
        <div role="button" data-test-id="test">
          foo
          <template>xxx</template>
          <script>xxx</script>
          <style>xxx</style>
        </button>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo"
    end

    it "returns a trimmed flat string" do
      render <<~HTML
        <button data-test-id="test">
          <div>
            foo
            <img alt="bar\nfi  \t\rthumb" />
            <span>fee </span>  <span>foo</span><span>fox</span>
            <div aria-label=" foo " />
            <input value=" frog " aria-name="input"/>
          </div>
        </button>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foo bar fi thumb fee foofox foo frog"
    end
  end

  describe "accname specification examples" do
    it "passes example 1" do
      render <<~HTML
        <element1 id="el1" role="button" aria-labelledby="el2"></element1>
        <element2 id="el2" hidden>
          <element3 id="el3" hidden>hello</element3>
        </element2>
      HTML

      expect(find_by_id("el1", visible: :all).accessible_name).to eq "hello"
    end

    it "passes example 2" do
      render <<~HTML
        <element1 id="el1" role="button" aria-labelledby="el2"></element1>
        <element2 id="el2">
          <element3 id="el3" hidden>hello</element3>
        </element2>
      HTML

      expect(find_by_id("el1", visible: :all).accessible_name).to eq ""
    end

    it "passes example 3" do
      render <<~HTML
        <element1 id="el1" role="button" aria-labelledby="el3"></element1>
        <element2 id="el2" role="button" aria-labelledby="el1"></element2>
        <element3 id="el3"> hello </element3>
      HTML

      expect(find_by_id("el1", visible: :all).accessible_name).to eq "hello"
      expect(find_by_id("el2", visible: :all).accessible_name).to eq ""
    end

    it "passes example 4" do
      render <<~HTML
        <label for="flash">
          <input type="checkbox" id="flash">
          Flash the screen <span tabindex="0" role="textbox" aria-label="number of times" contenteditable>5</span> times.
        </label>
      HTML

      expect(find_by_id("flash").accessible_name).to eq "Flash the screen 5 times."
    end

    it "passes example 5" do
      render <<~HTML
        <h1>Files</h1>
        <ul>
          <li>
            <a id="file_row1" href="./files/Documentation.pdf">Documentation.pdf</a>
            <span role="button" tabindex="0" id="del_row1" aria-label="Delete" aria-labelledby="del_row1 file_row1"></span>
          </li>
          <li>
            <a id="file_row2" href="./files/HolidayLetter.pdf">HolidayLetter.pdf</a>
            <span role="button" tabindex="0" id="del_row2" aria-label="Delete" aria-labelledby="del_row2 file_row2"></span>
          </li>
        </ul>
      HTML

      expect(find_by_id("del_row1", visible: :all).accessible_name).to eq "Delete Documentation.pdf"
      expect(find_by_id("del_row2", visible: :all).accessible_name).to eq "Delete HolidayLetter.pdf"
    end

    it "passes github.com/w3c/accname/pull/53" do
      render <<~HTML
        <span aria-label="bar" data-test-id="one">foo</span>
        <button><span aria-label="bar" data-test-id="two">foo</span></button
      HTML

      expect(find(:test_id, "one").accessible_name).to eq ""
      expect(find(:test_id, "two").accessible_name).to eq "bar"
    end
  end

  #  describe('embedded controls', () => {
  #    context('when getting a name for a widget', () => {
  #      it('uses the value of an <input>', () => {
  #        const node = appendToBody('<div role="button"><input value="foo" /></div>');
  #        expect(accessibleName(node)).toEqual('foo');
  #      });

  #      it('uses the value of a <select>', () => {
  #        const node = appendToBody('<div role="button"><select><option>one</option><option selected>two</option></select></div>');
  #        expect(accessibleName(node)).toEqual('two');
  #      });

  #      it('uses the value of a <select multiple>', () => {
  #        const node = appendToBody(`<div role="button">
  #          <select multiple>
  #            <option>one</option>
  #            <option selected>two</option>
  #            <option selected>three</option>
  #          </select>
  #        </div>`);
  #        expect(accessibleName(node)).toEqual('two three');
  #      });

  #      it('uses the value of a <textarea>', () => {
  #        const node = appendToBody('<div role="button"><textarea aria-label="bar">foo</textarea></div>');
  #        expect(accessibleName(node)).toEqual('foo');
  #      });

  #      it('uses the value of a widget of type textbox', () => {
  #        const node = appendToBody('<div role="button"><span role="textbox" aria-label="bar">foo<span></div>');
  #        expect(accessibleName(node)).toEqual('foo');
  #      });

  #      it('uses the value of a widget of type searchbox', () => {
  #        const node = appendToBody('<div role="button"><span role="searchbox" aria-label="bar">foo<span></div>');
  #        expect(accessibleName(node)).toEqual('foo');
  #      });

  #      it('uses the value of a widget of type range using aria-valuenow', () => {
  #        const node = appendToBody('<button><div role="slider" aria-valuemin="0" aria-valuenow="102" aria-valuemax="255"></div></button>');
  #        expect(accessibleName(node)).toEqual('102');
  #      });

  #      it('uses the value of a widget of type range using aria-valuetext', () => {
  #        const node = appendToBody('<button><div role="slider" aria-valuemin="1" aria-valuenow="5" aria-valuetext="May" aria-valuemax="12"></div></button>');
  #        expect(accessibleName(node)).toEqual('May');
  #      });

  #      it('uses the widget value in preference to aria-label', () => {
  #        const node = appendToBody('<div role="button"><input value="foo" aria-label="bar" /></div>');
  #        expect(accessibleName(node)).toEqual('foo');
  #      });

  #      it('uses the widget value in preference to native label', () => {
  #        const id = uniqueId();
  #        const node = appendToBody(`
  #          <div role="button"><input value="foo" id="${id}" /></div>
  #          <label for="${id}">bar</label>
  #        `);
  #        expect(accessibleName(node)).toEqual('foo');
  #      });

  #      it('uses aria-labelledby in preference to the widget value', () => {
  #        const id = uniqueId();
  #        const node = appendToBody(`
  #          <div role="button"><input value="foo" aria-labelledby="${id}" /></div>
  #          <span id="${id}">bar</span>
  #        `);
  #        expect(accessibleName(node)).toEqual('bar');
  #      });
  #    });

  #    context('when getting a name for not a widget', () => {
  #      it('uses the accessible name of the <input>', () => {
  #        const node = appendToBody('<div role="heading"><input value="foo" aria-label="bar" /></div>');
  #        expect(accessibleName(node)).toEqual('bar');
  #      });
  #    });
  #  });
end
