# frozen_string_literal: true

describe "have_image" do
  it "matches using a custom matcher" do
    render <<~HTML
      <img alt="Img title" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10" data-test-id="test">
    HTML

    expect(page).to have_image "Img title"
  end

  it "matches using a negated custom matcher" do
    render <<~HTML
      <img alt="Img title" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10" data-test-id="test">
    HTML

    expect(page).to have_no_image "foo"
  end
end
