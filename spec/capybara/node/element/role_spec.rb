# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#role" do
  it "returns the value of an explicit role attribute" do
    render <<~HTML
      <div role="listbox">
        <a role="option" href="http://example.com">
          contents
        </a>
      </div>
    HTML
    expect(find(:element, "a").role).to eq "option"
  end

  it "returns the value of an implicit role attribute" do
    render <<~HTML
      <a href="http://example.com">
        contents
      </a>
    HTML
    expect(find(:element, "a").role).to eq "link"
  end

  it "returns generic roles as nil" do
    render <<~HTML
      <div>
        contents
      </div>
    HTML
    expect(find(:element, "div").role).to be_nil
  end

  it "returns none roles as nil" do
    render <<~HTML
      <article role="none">content</article>
    HTML
    expect(find(:element, "article").role).to be_nil
  end

  it "returns presentation roles as nil" do
    render <<~HTML
      <article role="presentation">content</article>
    HTML
    expect(find(:element, "article").role).to be_nil
  end

  it "returns no role as nil" do
    render <<~HTML
      <meta name="foo" contents="bar">
    HTML
    expect(find(:element, "meta", name: "foo", visible: false).role).to be_nil
  end
end
