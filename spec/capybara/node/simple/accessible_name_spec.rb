# frozen_string_literal: true

RSpec.describe Capybara::Node::Simple, "#accessible_name", driver: :rack_test do
  it "returns the accessible name of an element" do
    render <<~HTML
      <a href="http://example.com">
        contents
      </a>
    HTML
    expect(find(:element, "a").accessible_name).to eq "contents"
  end

  it "returns no name as empty" do
    render <<~HTML
      <div>
        contents
      </div>
    HTML
    expect(find(:element, "div").accessible_name).to eq ""
  end

  private

  attr_reader :page

  def render(html)
    @page = Capybara.string(html)
  end
end
