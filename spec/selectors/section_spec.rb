# frozen_string_literal: true

describe "section selector" do
  before do
    visit "/section.html"
  end

  it "finds a section by heading" do
    render <<~HTML
      <section>
        <h1>Heading</h1>
      </section>
    HTML
    section = find :element, :section
    expect(find(:section, "Heading")).to eq section
  end

  it "finds a section without a locator" do
    render <<~HTML
      <section>
        <h1>Heading</h1>
      </section>
    HTML
    section = find :element, :section
    expect(find(:section)).to eq section
  end

  it "does not find by subsequent headings" do
    render <<~HTML
      <section>
        <h1>Heading first</h1>
        <h1>Heading second</h1>
      </section>
    HTML
    expect(page).to have_no_section "Heading second"
  end

  it "does not find if not match" do
    render <<~HTML
      <div>
        <h1>Heading</h1>
      </div>
    HTML
    expect(page).to have_no_section
  end

  it "finds regardless of heading nesting" do
    render <<~HTML
      <section>
        <div>
          <h1>Heading</h1>
        </div>
      </section>
    HTML
    section = find :element, :section
    expect(find(:section, "Heading")).to eq section
  end

  it "does not find through another section" do
    render <<~HTML
      <section>
        <section data-test-id=test>
          <div>
            <h1>Heading</h1>
          </div>
        </section>
      <section>
    HTML
    section = find :css, "[data-test-id=test]"
    expect(find(:section, "Heading")).to eq section
  end

  %i[section article aside form main header footer].each do |section|
    it "finds #{section}" do
      render <<~HTML
        <#{section}>
          <h1>Heading</h1>
        </#{section}>
      HTML
      section = find :element, section
      expect(find(:section, "Heading")).to eq section
    end
  end

  (1..6).each do |heading|
    it "finds a h#{heading}" do
      render <<~HTML
        <section>
          <h#{heading}>Heading</h#{heading}>
        </section>
      HTML
      section = find :element, :section
      expect(find(:section, "Heading")).to eq section
    end

    it "finds an aria heading #{heading}" do
      render <<~HTML
        <section>
          <div role="heading" aria-level=#{heading}>Heading</div>
        </section>
      HTML
      section = find :element, :section
      expect(find(:section, "Heading")).to eq section
    end
  end

  context "with section_element" do
    it "finds limits to that section type" do
      render <<~HTML
        <section>
          <h1>Heading</h1>
        </section>
        <article>
          <h1>Heading</h1>
        </article>
      HTML
      section = find :element, :article
      expect(find(:section, "Heading", section_element: :article)).to eq section
    end
  end

  context "with heading level" do
    it "limits to that heading level" do
      render <<~HTML
        <section>
          <h1>Heading</h1>
        </section>
        <section data-test-id="test">
          <h2>Heading</h2>
        </section>
      HTML
      section = find :css, "[data-test-id=test]"
      expect(find(:section, "Heading", heading_level: 2)).to eq section
    end

    it "limits to that aria heading level" do
      render <<~HTML
        <section>
          <h1>Heading</h1>
        </section>
        <section data-test-id="test">
          <div role="heading">Heading</div>
        </section>
      HTML
      section = find :css, "[data-test-id=test]"
      expect(find(:section, "Heading", heading_level: 2)).to eq section
    end

    it "overrides a native level" do
      render <<~HTML
        <section>
          <h1 aria-level="3">Heading</h1>
        </section>
      HTML
      expect(page).to have_section "Heading", heading_level: 3
    end
  end

  describe "within_section" do
    it "limited to within a section" do
      render <<~HTML
        <section>
          <h1>Heading</h2>
          <p>Body</p>
        <section>
      HTML

      within_section "Heading" do
        expect(page).to have_text <<~TEXT.strip, exact: true
          Heading
          Body
        TEXT
      end
    end
  end
end
