# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#role" do
  it "returns the value of an implicit role" do
    render <<~HTML
      <a href="http://example.com">
        contents
      </a>
    HTML
    expect(find(:element, "a").role).to eq "link"
  end

  it "returns the value of an explicit role" do
    render <<~HTML
      <a role="option" href="http://example.com">
        contents
      </a>
    HTML
    expect(find(:element, "a").role).to eq "option"
  end

  it "returns no role as nil" do
    render <<~HTML
      <meta name="foo" contents="bar">
    HTML
    expect(find(:element, "meta", name: "foo", visible: false).role).to be_nil
  end

  it "does not return unknown roles" do
    render <<~HTML
      <div role="foo">contents</div>
    HTML
    expect(find(:element, "div").role).to be_nil
  end

  it "falls back to known roles" do
    render <<~HTML
      <div role="widget textbox">contents</div>
    HTML
    expect(find(:element, "div").role).to eq "textbox"
  end

  it "returns an implicit generic role as nil" do
    render <<~HTML
      <div>contents</div>
    HTML
    expect(find(:element, "div").role).to be_nil
  end

  it "returns an explicit generic role as nil" do
    render <<~HTML
      <div role="generic">contents</div>
    HTML
    expect(find(:element, "div").role).to be_nil
  end

  it "returns an explicit none role as nil" do
    render <<~HTML
      <ul role="none">
        <li role="none">contents</li>
      </ul>
    HTML
    expect(find(:element, "li").role).to be_nil
  end

  it "returns an explicit presentation role as nil" do
    render <<~HTML
      <ul role="none">
        <li role="presentation">contents</li>
      </ul>
    HTML
    expect(find(:element, "li").role).to be_nil
  end

  it "returns non-standard role names as nil (Chromium only)" do
    render <<~HTML
      <details>
        <summary>contents</summary>
      </details>
    HTML
    expect(find(:element, "summary").role).to be_nil
  end

  it "ignores role removal on focusable elements" do
    render <<~HTML
      <input aria-label="foo" role="none">
    HTML
    expect(find(:element, "input").role).to eq "textbox"
  end
end
