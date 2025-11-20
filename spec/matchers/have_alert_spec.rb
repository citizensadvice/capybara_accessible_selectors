# frozen_string_literal: true

describe "have_alert" do
  it "matches using a custom matcher" do
    render <<~HTML
      <div role="alert" data-test-id="test">
        Alert message
      <div>

      <div>
        Just a message
      </div>
    HTML

    expect(page).to have_alert(text: "Alert")
  end

  it "matches using a negated custom matcher" do
    render <<~HTML
      <div role="alert" data-test-id="test">
        Alert message
      <div>

      <div>
        Just a message
      </div>
    HTML

    expect(page).to have_no_alert(text: "foo")
  end
end
