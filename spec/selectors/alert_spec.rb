# frozen_string_literal: true

describe "alert selector" do
  it "finds alerts" do
    render <<~HTML
      <div role="alert" data-test-id="test">
        Alert message
      <div>

      <div>
        Just a message
      </div>
    HTML

    expect(page.find(:alert)).to eq page.find(:test_id, "test")
  end
end
