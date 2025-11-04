# frozen_string_literal: true

RSpec.describe Capybara::Node::Simple, "#accessible_description", driver: :rack_test do
  it "returns the accessible description of an element" do
    render <<~HTML
      <a href="http://example.com" aria-description="foo">
        contents
      </a>
    HTML
    expect(find(:element, "a").accessible_description).to eq "foo"
  end

  it "returns no name as empty" do
    render <<~HTML
      <div>
        contents
      </div>
    HTML
    expect(find(:element, "div").accessible_description).to eq ""
  end

  private

  attr_reader :page

  def render(html)
    @page = Capybara.string(html)
  end
end
