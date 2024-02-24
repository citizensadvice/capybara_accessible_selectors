# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#accessible_name" do
  it "returns an accessible name" do
    render <<~HTML
      <article aria-labelledby="id2 id1" data-test-id="test">Contents</article>
      <span id="id1">name</span>
      <span id="id2">Accessible</span>
    HTML

    expect(find(:element, "article").accessible_name).to eq "Accessible name"
  end

  it "returns an empty string if there no accessible name" do
    render <<~HTML
      <div>foo</div>
    HTML

    expect(find(:element, "div").accessible_name).to eq ""
  end
end
