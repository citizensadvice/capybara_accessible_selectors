# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#accessible_name" do
  describe "aria-labelledby" do
    it "returns an accessible name from aria-labelledby" do
      render <<~HTML
        <div role="group" aria-labelledby="id2 id1" data-test-id="test" aria-label="label" title="title">Contents</div>
        <span id="id1">name</span>
        <span id="id2">Accessible</span>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
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

    it "recurses direct aria-hidden elements when resolving visible aria-labelledby" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id" aria-hidden="true">foo<span aria-hidden="true">bar</span></div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "foobar"
    end

    it "does recurse direct inert elements when resolving visible aria-labelledby" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id" inert>foo</div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "xxx"
    end
  end

  describe "embedded control" do
    it "uses the value of a textbox inputs" do
      render <<~HTML
        <button aria-labelledby="id1" data-test-id="test">xxx</button>
        <div id="id1">
          label
          <input value="foo" aria-label="xxx">
          <input value="bar" type="email" aria-label="xxx">
          <input value="42" type="number" aria-label="xxx">
          <input value="10" type="range" aria-label="xxx">
          <input value="" aria-label="xxx">
          <input value="datalist" aria-label="xxx" list="id2">
          <input value="xxx" type="radio" aria-label="radio">
          <input value="xxx" type="checkbox" aria-label="checkbox">
          <input value="xxx" type="button" aria-label="button">
          <input value="xxx" type="submit" aria-label="submit">
          <input value="xxx" type="reset" aria-label="reset">
          <input value="xxx" type="image" aria-label="image">
        </div>
        <datalist id="id2"></datalist>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label foo bar 42 10 datalist radio checkbox button submit reset image"
    end

    it "uses the value of a select" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">
          label
          <select aria-label="xxx">
            <option>xxx</option>
            <option label="foo" selected>yyy</option>
          </select>
          <select aria-label="xxx"></select>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label foo"
    end

    it "uses the value of a multiple select" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">
          label
          <select aria-label="xxx" multiple>
            <option>xxx</option>
            <option label="foo" selected>yyy</option>
            <option selected>bar</option>
          </select>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label foo bar"
    end

    it "uses the value of a textarea" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">
          label
          <textarea aria-label="xxx">textbox</textarea>
          <textarea aria-label="xxx"></textarea>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label textbox"
    end

    it "uses the value of a textbox role" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">
          label
          <div contenteditable role="textbox">
            <b>bold</b>
          </div>
          <div contenteditable role="textbox"></div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label bold"
    end

    it "uses the value of a range role" do
      render <<~HTML
        <button aria-labelledby="id" data-test-id="test">xxx</button>
        <div id="id">
          label
          <div role="spinbutton" aria-valuenow="5"></div>
          <div role="slider" aria-valuetext="large"></div>
          <div role="slider"></div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label 5 large"
    end

    it "uses the value of a combobox role" do
      render <<~HTML
        <button aria-labelledby="id1" data-test-id="test">xxx</button>
        <div id="id1">
          label
          <div role="combobox">
            <div role="listbox">
              <div role="option">xxx</div>
              <div role="option" aria-selected="true">foo</div>
            </div>
          </div>
          <div role="combobox" aria-controls="id1 id2"></div>
          <div role="listbox" id="id2">
            <div role="option">xxx</div>
            <div role="option" aria-selected="true">bar</div>
          </div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label foo bar"
    end

    it "uses the value of a listbox role" do
      render <<~HTML
        <button aria-labelledby="id1" data-test-id="test">xxx</button>
        <div id="id1">
          label
          <div role="listbox">
            <div role="option">xxx</div>
            <div role="option" aria-selected="true">foo</div>
          </div>
          <div role="listbox">
            <div role="option">xxx</div>
            <div role="option" aria-selected="true">bar</div>
            <div role="option" aria-selected="true">fee</div>
          </div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "label foo bar fee"
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

      it "uses full algorithm in labels" do
        render <<~HTML
          <input id="id" title="title">
          <label for="id">foo <span role="navigation" aria-label="bar">xxx</span> fee</label>
        HTML

        expect(find(:element, "input").accessible_name).to eq "foo bar fee"
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
          <table>
            <tr data-test-id="test" title="title"><td>foo</td><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "foo bar"
      end

      it "calculates from title" do
        render <<~HTML
          <table>
            <tr data-test-id="test" title="title"><td></td><td></td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "title"
      end

      it "is empty with no content" do
        render <<~HTML
          <table>
            <tr data-test-id="test"><td></td><td></td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq ""
      end
    end

    context "with a <td>" do
      it "calculates from content" do
        render <<~HTML
          <table>
            <tr><td data-test-id="test" title="title">foo</td><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "foo"
      end

      it "calculates from title" do
        render <<~HTML
          <table>
            <tr><td data-test-id="test" title="title"></td><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <table>
            <tr><td data-test-id="test"></td><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq ""
      end
    end

    context "with a <th>" do
      it "calculates from content" do
        render <<~HTML
          <table>
            <tr><th data-test-id="test" title="title" abbr="abbr">foo</th><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "foo"
      end

      it "calculates from title" do
        render <<~HTML
          <table>
            <tr><th data-test-id="test" title="title"></th><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq "title"
      end

      it "is empty with no name" do
        render <<~HTML
          <table>
            <tr><th data-test-id="test"></th><td>bar</td></tr>
          </table>
        HTML

        expect(find(:test_id, "test").accessible_name).to eq ""
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

    it "does not add space around inline" do
      render <<~HTML
        <div role="button" data-test-id="test">
          foo<span>xxx</span>fee
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "fooxxxfee"
    end

    it "adds space around inline roles" do
      render <<~HTML
        <div role="button" data-test-id="test">
          foo<span role="button" title="bar">xxx</span>fee
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "fooxxxfee"
    end

    it "adds space around tooltips" do
      render <<~HTML
        <div role="button" data-test-id="test">
          foo<span role="navigation" title="bar"></span>fee
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
          <div hidden>foo</div>
          <div style="display:none">foo</div>
          <div style="visibility:hidden">foo</div>
          <div inert>foo</div>
          <div style="visibility:hidden">
            <div style="visibility:visible">
              bar
            </div>
          </div>
          <template>xxx</template>
          <script>xxx</script>
          <style>xxx</style>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq ""
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

  describe "tooltip" do
    it "returns an accessible name from title" do
      render <<~HTML
        <div role="group" title="Accessible name" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
    end
  end

  describe "name disallowed" do
    it "returns no name for an unknown element" do
      render <<~HTML
        <foo role="" data-test-id="test">Contents</foo>
      HTML

      expect(find(:test_id, "test").accessible_name).to eq ""
    end

    describe "for a element with a role allowing a name" do
      it "returns no name for a hidden element" do
        render <<~HTML
          <div role="button" data-test-id="test" hidden>Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a element with a hidden ancestor" do
        render <<~HTML
          <div hidden>
            <div role="button" data-test-id="test">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for an aria-hidden element" do
        render <<~HTML
          <div role="button" data-test-id="test" aria-hidden="true">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a element with an aria-hidden ancestor" do
        render <<~HTML
          <div aria-hidden="true">
            <div role="button" data-test-id="test">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for an inert element" do
        render <<~HTML
          <div role="button" data-test-id="test" inert">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a element with an inert ancestor" do
        render <<~HTML
          <div inert>
            <div role="button" data-test-id="test">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a display none element" do
        render <<~HTML
          <div role="button" data-test-id="test" style="display:none">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a element with a display none ancestor" do
        render <<~HTML
          <div style="display:none">
            <div role="button" data-test-id="test">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a visibility hidden element" do
        render <<~HTML
          <div role="button" data-test-id="test" style="visibility:hidden">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a element with a visibility hidden ancestor" do
        render <<~HTML
          <div style="visibility: hidden">
            <div role="button" data-test-id="test">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a visibility collapse element" do
        render <<~HTML
          <div role="button" data-test-id="test" style="visibility:collapse">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns no name for a element with a visibility collapse ancestor" do
        render <<~HTML
          <div style="visibility: collapse">
            <div role="button" data-test-id="test">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
      end

      it "returns a name for a element with visibility visible" do
        render <<~HTML
          <div style="visibility: collapse">
            <div role="button" data-test-id="test" style="visibility:visible">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq "Contents"
      end

      it "returns a name for a element with visibility visible ancestor" do
        render <<~HTML
          <div style="visibility: collapse">
            <div style="visibility: visible">
              <div role="button" data-test-id="test">Contents</button>
            </div>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_name).to eq "Contents"
      end
    end

    describe "roles with name disallowed" do
      %w[caption code definition deletion emphasis insertion mark generic none
         paragraph strong subscript suggestion superscript term time presentation].each do |role|
        it "returns nothing for the explict role #{role}" do
          render <<~HTML
            <div role="#{role}" aria-labelledby="id2 id1" data-test-id="test" aria-label="label" title="title">Contents</div>
            <span id="id1">name</span>
            <span id="id2">Accessible</span>
          HTML

          expect(find(:test_id, "test").accessible_name).to eq ""
        end
      end
    end

    describe "elements with implicit roles with name disallowed" do
      %w[abbr b bdi bdo br cite code dfn em i kbd mark q rp rt ruby s samp small strong sub sup time u var wbr
         div span p pre address dl form a audio canvas meta link template slot style script].each do |name|
        it "returns no name for <#{name}>" do
          render <<~HTML
            <#{name} data-test-id="test">Contents</#{name}>
          HTML

          expect(find(:test_id, "test", visible: :all).accessible_name).to eq ""
        end
      end
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
end
