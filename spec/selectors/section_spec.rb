# frozen_string_literal: true

describe "section selector" do
  before do
    visit "/section.html"
  end

  it "finds by first heading" do
    main = find :element, :main
    expect(find(:section, "Main", exact: true)).to eq main
  end

  it "does not find by subsequent headings" do
    expect(page).to have_no_selector :section, "Section 1", text: "This is the main"
  end

  it "finds regardless of first heading nesting" do
    article = find :element, :article, text: "This is an article where the heading is nested"
    expect(find(:section, "Nested heading")).to eq article
  end

  it "finds within section" do
    expect(page).to have_selector :section, "Main", text: "This is an article"
    expect(page).to have_no_selector :section, "Main", text: "This is the footer"
  end

  it "finds by heading_level" do
    expect(page).to have_selector :section, "Main", heading_level: 2
    expect(page).to have_no_selector :section, "Main", heading_level: 3
  end

  it "finds by section_element" do
    expect(page).to have_selector :section, "Main", section_element: :main
    expect(page).to have_no_selector :section, "Main", section_element: :footer
  end

  it "does not find by unknown section elements" do
    blockquote = page.find(:element, :blockquote)
    expect(blockquote).to have_selector :xpath, XPath.child(:h3), text: "Block quote"
    expect(page).to have_no_selector :section, "Block quote"
  end

  it "matches a section" do
    main = find :element, :main
    expect(main).to match_selector :section
  end

  it "matches a section by heading" do
    main = find :element, :main
    expect(main).to match_selector :section, "Main"
  end

  %i[main section article header footer aside form].each do |element|
    context "<#{element}>" do
      it "finds by #{element}" do
        expect(page).to have_selector :section, element.to_s.capitalize, section_element: element, count: 1
      end
    end
  end
end
