# frozen_string_literal: true

describe "have_img" do
  before do
    visit "/img.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_img "Img title"
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_img "foo"
  end
end
