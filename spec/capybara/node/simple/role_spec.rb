# frozen_string_literal: true

RSpec.describe Capybara::Node::Simple, "#role", driver: :rack_test do
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

  it "returns no role as nil" do
    render <<~HTML
      <meta name="foo" contents="bar">
    HTML
    expect(find(:element, "meta", name: "foo", visible: false).role).to be_nil
  end

  private

  attr_reader :page

  def render(html)
    @page = Capybara.string(html)
  end
end
