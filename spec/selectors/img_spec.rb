# frozen_string_literal: true

describe "img selector" do
  before do
    visit "/img.html"
  end

  it "selects by aria-label" do
    img = find(:element, :div, text: "Aria label content")
    expect(find(:img, "aria-label")).to eq img
  end

  it "selects by partial aria-label" do
    img = find(:element, :div, text: "Aria label content")
    expect(find(:img, "aria-lab")).to eq img
  end

  it "selects by exact aria-label" do
    img = find(:element, :div, text: "Aria label content")
    expect(find(:img, "aria-label", exact: true)).to eq img
  end

  it "does not find exact aria-label with the wrong text" do
    expect do
      find(:img, "aria-labe", exact: true, wait: false)
    end.to raise_error Capybara::ElementNotFound
  end

  it "selects by multiple aria-labelledby" do
    img = find(:element, :div, text: "Split label content")
    expect(find(:img, "split label")).to eq img
  end

  it "selects by partial aria-labelledby" do
    img = find(:element, :div, text: "Split label content")
    expect(find(:img, "split la")).to eq img
  end

  it "selects by exact aria-labelledby" do
    img = find(:element, :div, text: "Split label content")
    expect(find(:img, "split label", exact: true)).to eq img
  end

  it "does not find by exact aria-labelledby with the wrong text" do
    expect do
      find(:img, "split la", exact: true, wait: false)
    end.to raise_error Capybara::ElementNotFound
  end

  it "selects by alt" do
    img = find(:element, :img) { |el| el["src"].include?("doesnt_matter.png") }
    expect(find(:img, "alt text")).to eq img
  end

  it "selects by src" do
    img = find(:element, :img) { |el| el["src"].include?("twice.png") }
    expect(find(:img, "twice", src: /twice\.png/)).to eq img
  end

  it "selects by partial alt" do
    img = find(:element, :img) { |el| el["src"].include?("doesnt_matter.png") }
    expect(find(:img, "alt te")).to eq img
  end

  it "selects by exact alt" do
    img = find(:element, :img) { |el| el["src"].include?("doesnt_matter.png") }
    expect(find(:img, "alt text", exact: true)).to eq img
  end

  it "does not find exact alt with the wrong text" do
    expect do
      find(:img, "alt tex", exact: true, wait: false)
    end.to raise_error Capybara::ElementNotFound
  end

  it "selects img tag by role and aria-label without alt" do
    img = find(:element, :img) { |el| el["src"].include?("by_aria_label.png") }
    expect(find(:img, "without alt")).to eq img
  end

  it "selects img tag by role and aria-labelledby without alt" do
    img = find(:element, :img) { |el| el["src"].include?("by_aria_labelledby.png") }
    expect(find(:img, "labelled by no alt")).to eq img
  end
end
