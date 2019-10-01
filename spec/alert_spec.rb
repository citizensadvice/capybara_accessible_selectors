# frozen_string_literal: true

describe "alert", type: :feature do
  before do
    visit "/alert.html"
  end

  it "finds alerts" do
    expect(page).to have_selector :alert, text: "Alert message"
  end
end
