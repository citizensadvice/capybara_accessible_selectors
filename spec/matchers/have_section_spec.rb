# frozen_string_literal: true

describe "have_section" do
  before do
    visit "/section.html"
  end

  it "matches using a custom matcher" do
    render <<~HTML
      <main>
        <h1>Main</h1>
      </main>
    HTML
    expect(page).to have_section "Main"
  end

  it "matches using a negated custom matcher" do
    render <<~HTML
      <div>
        <h1>Main</h1>
      </div>
    HTML
    expect(page).to have_no_section "foo"
  end
end
