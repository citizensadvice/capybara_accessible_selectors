# frozen_string_literal: true

RSpec.describe Capybara::Node::Element, "#accessible_name" do
  it "returns the accessible name of an element" do
    render <<~HTML
      <element1 id="el1" role="button" aria-labelledby="el2">content</element1>
      <element2 id="el2" hidden>
        <element3 id="el3" hidden>hello</element3>
      </element2>
    HTML
    expect(find_by_id("el1").accessible_name).to eq "hello"
  end

  it "returns no name as empty" do
    render <<~HTML
      <div>
        contents
      </div>
    HTML
    expect(find(:element, "div").accessible_name).to eq ""
  end
end
