# frozen_string_literal: true

describe "img selector" do
  it "finds an img" do
    render <<~HTML
      <img alt="alt" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10" data-test-id="test">
    HTML
    allow(Capybara::Helpers).to receive(:warn)

    expect(find(:img)).to eq find(:test_id, "test")

    expect(Capybara::Helpers).to have_received(:warn)
  end
end
