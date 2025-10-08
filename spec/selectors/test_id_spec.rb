# frozen_string_literal: true

describe "test_id selector" do
  around do |scenario|
    initial_test_id = Capybara.test_id
    scenario.call
    Capybara.test_id = initial_test_id
  end

  it "finds by a test attribute as a string" do
    Capybara.test_id = "data-test-id"

    render <<~HTML
      <section data-test-id="foo" id="one">Section 1</section>
      <section data-test-id="bar" id="two">Section 2</section>
    HTML
    section = find_by_id "one"
    expect(find(:test_id, "foo")).to eq section
  end

  it "finds by a test attribute as a symbol" do
    Capybara.test_id = "data-test-id"

    render <<~HTML
      <section data-test-id="foo" id="one">Section 1</section>
      <section data-test-id="bar" id="two">Section 2</section>
    HTML
    section = find_by_id "one"
    expect(find(:test_id, :foo)).to eq section
  end

  it "raises an error without test_id set" do
    Capybara.test_id = nil

    expect do
      find(:test_id, :foo)
    end.to raise_error "Capybara.test_id must be set"
  end

  describe "#find_by_test_id" do
    it "finds using the test id" do
      Capybara.test_id = "data-test-id"

      render <<~HTML
        <section data-test-id="foo" id="one">Section 1</section>
        <section data-test-id="bar" id="two">Section 2</section>
      HTML
      section = find_by_id "one"
      expect(find_by_test_id(:foo)).to eq section
    end

    it "passed options" do
      Capybara.test_id = "data-test-id"

      render <<~HTML
        <section data-test-id="foo" id="one" hidden>Section 1</section>
        <section data-test-id="bar" id="two">Section 2</section>
      HTML
      section = find_by_id "one", visible: :all
      expect(find_by_test_id(:foo, visible: :all)).to eq section
    end
  end
end
