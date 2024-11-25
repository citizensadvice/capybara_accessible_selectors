# frozen_string_literal: true

describe "role" do
  it "selects an element with a matching role" do
    render <<~HTML
      <div id="test" role="tablist">Tablist</div>
      <div role="tab">Tab</div>
      <div>Not a role</div>
    HTML

    expect(find(:element, "div", role: "tablist")).to eq find_by_id("test")
  end

  it "selects an element with a matching implicit role" do
    render <<~HTML
      <input id="test">
      <input role="searchbox">
    HTML

    expect(find(:element, "input", role: "textbox")).to eq find_by_id("test")
  end

  it "selects an element with no role" do
    render <<~HTML
      <div role="tablist">Tablist</div>
      <div role="tab">Tab</div>
      <div id="test">Not a role</div>
    HTML

    expect(find(:element, "div", role: nil)).to eq find_by_id("test")
  end

  it "provides a friendly error for role" do
    render <<~HTML
      <button type="button" role="tab">Tab</button>
    HTML

    expect do
      expect(page).to have_selector :button, "Tab", role: "tablist", wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected to have role "tablist" but it had role "tab"/
  end

  it "provides a friendly error for an element unexpectedly with no role" do
    render <<~HTML
      <div>Element</div>
    HTML

    expect do
      expect(page).to have_element :div, role: "tablist", wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected to have role "tablist" but it had no role/
  end

  it "provides a friendly error for an element unexpectedly with a role" do
    render <<~HTML
      <div role="tablist">Element</div>
    HTML

    expect do
      expect(page).to have_element :div, role: nil, wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, /expected to have no role but it had role "tablist"/
  end
end
