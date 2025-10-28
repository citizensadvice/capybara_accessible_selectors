# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#accessible_name" do
  it "returns an accessible name from aria-labelledby" do
    render <<~HTML
      <article aria-labelledby="id2 id1" data-test-id="test">Contents</article>
      <span id="id1">name</span>
      <span id="id2">Accessible</span>
    HTML

    expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
  end

  it "returns an accessible name from aria-label" do
    render <<~HTML
      <article aria-label="Accessible name" data-test-id="test">Contents</article>
    HTML

    expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
  end

  it "returns an accessible name from contents" do
    render <<~HTML
      <h1 data-test-id="test">Accessible name</h1>
    HTML

    expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
  end

  it "returns an accessible name from title" do
    render <<~HTML
      <article title="Accessible name" data-test-id="test">Contents</article>
    HTML

    expect(find(:test_id, "test").accessible_name).to eq "Accessible name"
  end

  it "returns no name with no name" do
    render <<~HTML
      <div data-test-id="test">Contents</div>
    HTML

    expect(find(:test_id, "test").accessible_name).to eq ""
  end

  context "with accname specification examples" do
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
        <element1 id="el1" aria-labelledby="el3"></element1>
        <element2 id="el2" aria-labelledby="el1"></element2>
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
  end

  context "with an <input>" do
    it "calculates from aria-labelledby" do
      render <<~HTML
        <label for="id3">label</label>
        <input aria-labelledby="id1 id2" aria-label="aria label" id="id3" title="foo">
        <span id="id1">aria</span>
        <span id="id2">labelledby</span>
      HTML

      expect(find(:element, "input").accessible_name).to eq "aria labelledby"
    end

    it "calculates from aria-label" do
      render <<~HTML
        <label for="id3">label</label>
        <input aria-label="aria label" id="id3" title="foo">
      HTML

      expect(find(:element, "input").accessible_name).to eq "aria label"
    end

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
    it "calculates from aria-labelledby" do
      render <<~HTML
        <label for="id3">label</label>
        <textarea aria-labelledby="id1 id2" aria-label="aria label" id="id3" title="foo"></textarea>
        <span id="id1">aria</span>
        <span id="id2">labelledby</span>
      HTML

      expect(find(:element, "textarea").accessible_name).to eq "aria labelledby"
    end

    it "calculates from aria-label" do
      render <<~HTML
        <label for="id3">label</label>
        <textarea aria-label="aria label" id="id3" title="foo"></textarea>
      HTML

      expect(find(:element, "textarea").accessible_name).to eq "aria label"
    end

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
    it "calculates from aria-labelledby" do
      render <<~HTML
        <label for="id3">label</label>
        <select aria-labelledby="id1 id2" aria-label="aria label" id="id3" title="foo"></select>
        <span id="id1">aria</span>
        <span id="id2">labelledby</span>
      HTML

      expect(find(:element, "select").accessible_name).to eq "aria labelledby"
    end

    it "calculates from aria-label" do
      render <<~HTML
        <label for="id3">label</label>
        <select aria-label="aria label" id="id3" title="foo"></select>
      HTML

      expect(find(:element, "select").accessible_name).to eq "aria label"
    end

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
    it "calculates from aria-labelledby" do
      render <<~HTML
        <label for="id3">label</label>
        <input type="button" aria-labelledby="id1 id2" aria-label="aria label" id="id3" title="foo" value="value">
        <span id="id1">aria</span>
        <span id="id2">labelledby</span>
      HTML

      expect(find(:element, "input").accessible_name).to eq "aria labelledby"
    end

    it "calculates from aria-label" do
      render <<~HTML
        <label for="id3">label</label>
        <input type="button" aria-label="aria label" id="id3" title="foo" value="value">
      HTML

      expect(find(:element, "input").accessible_name).to eq "aria label"
    end

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
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from label"
    it "calculates from multiple labels"
    it "calculates from value"
    it "falls back to submit"
  end

  context "with an <input type=reset>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from label"
    it "calculates from multiple labels"
    it "calculates from value"
    it "falls back to reset"
  end

  context "with an <input type=img>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from label"
    it "calculates from multiple labels"
    it "calculates from alt"
    it "calculates from title"
    it "falls back to submit"
  end

  context "with a <button>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from label"
    it "calculates from multiple labels"
    it "calculates from subtree"
    it "calculates from title"
  end

  context "with a <fieldset>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from legend"
    it "calculates from title"
  end

  context "with an <output>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from label"
    it "calculates from multiple labels"
    it "calculates from title"
  end

  context "with a <summary>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from subtree"
    it "calculates from title"
    it "falls back to details"
  end

  context "with a <figure>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from figcaption"
    it "calculates from title"
  end

  context "with an <img>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from alt"
    it "calculates from title"
  end

  context "with an <table>" do
    it "calculates from aria-labelledby"
    it "calculates from aria-label"
    it "calculates from caption"
    it "calculates from title"
  end

  # tr td th title
  # a subtree
  # area alt title
  # iframe title
  # section title
  # name from content
  # core-aam resolutions
end
