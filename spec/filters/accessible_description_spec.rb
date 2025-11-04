# frozen_string_literal: true

describe "accessible_description" do
  it "selects by accessible_description as a string" do
    render <<~HTML
      <section aria-label="xxx" aria-describedby="id1">
        <h1 id="id1">A heading</h1>
      </section>

      <section aria-label="xxx" aria-describedby="id2">
        <h1 id="id2">Another heading</h1>
      </section>

      <section>
        <h1>Unconnected Heading</h1>
      </section>
    HTML

    expect(page).to have_selector :element, :section, accessible_description: "A heading", count: 1
  end

  it "selects by accessible_name as a string using exact" do
    render <<~HTML
      <section aria-label="xxx" aria-describedby="id1">
        <h1 id="id1">Heading a</h1>
      </section>

      <section aria-label="xxx" aria-describedby="id2">
        <h1 id="id2">Heading b</h1>
      </section>

      <section>
        <h1>Unconnected Heading</h1>
      </section>
    HTML

    expect(page).to have_selector :element, :section, accessible_description: "Heading a", exact: true, count: 1
  end

  it "selects by accessible_name with a regular expression" do
    render <<~HTML
      <section aria-label="xxx" aria-describedby="id1">
        <h1 id="id1">Heading a</h1>
      </section>

      <section aria-label="xxx" aria-describedby="id2">
        <h1 id="id2">Another heading</h1>
      </section>

      <section>
        <h1>Unconnected Heading</h1>
      </section>
    HTML

    expect(page).to have_selector :element, :section, accessible_description: /An.* heading/, count: 1
  end

  it "includes the expected error description" do
    render <<~HTML
      <section>
        <h1>Heading</h1>
      </section>
    HTML

    expect do
      find :element, :section, accessible_description: "foo", wait: false
    end.to raise_error Capybara::ElementNotFound, /with accessible description "foo"/
  end

  it "composes the error description with the sibling filter" do
    render <<~HTML
      <section>
        <h1>Heading</h1>
      </section>
    HTML

    section = find :element, :section

    expect do
      section.sibling :section, accessible_description: "foo", wait: false
    end.to raise_error Capybara::ElementNotFound, /with accessible description "foo" that is a sibling/
  end
end
