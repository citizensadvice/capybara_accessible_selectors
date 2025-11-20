# frozen_string_literal: true

describe "image selector" do
  it "finds an img" do
    render <<~HTML
      <img alt="alt" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10" data-test-id="test">
    HTML

    expect(find(:image)).to eq find(:test_id, "test")
  end

  it "finds by name" do
    render <<~HTML
      <img alt="foo" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10" data-test-id="test">
      <img alt="bar" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
    HTML

    expect(find(:image, "foo")).to eq find(:test_id, "test")
  end

  it "does not find an img with an empty alt" do
    render <<~HTML
      <img alt="" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
    HTML

    expect(page).to have_no_selector :image
  end

  it "selects by src" do
    render <<~HTML
      <img alt="foo" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10" data-test-id="test">
      <img alt="bar" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIW2P4v5ThPwAG7wKklwQ/bwAAAABJRU5ErkJggg==" width="10" height="10">
    HTML

    expect(find(:image, src: "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==")).to eq find(:test_id, "test")
  end

  it "selects by src using a regular expression" do
    render <<~HTML
      <img alt="foo" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10" data-test-id="test">
      <img alt="bar" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIW2P4v5ThPwAG7wKklwQ/bwAAAABJRU5ErkJggg==" width="10" height="10">
    HTML

    expect(find(:image, src: /ICTAEAOw/)).to eq find(:test_id, "test")
  end

  it "finds an explicit image" do
    render <<~HTML
      <div role="img" aria-labelledby="label-part-1 label-part-2" data-test-id="test">
        <h2>
          <span id="label-part-2">label</span>
          <span id="label-part-1">split</span>
        </h2>
        Split label content
      </div>
    HTML

    expect(find(:image, "split label")).to eq find(:test_id, "test")
  end

  it "finds an svg", skip_driver: :safari do
    render <<~HTML
      <svg height="500" width="500" data-test-id="test">
        <title>Title</title>
        <polygon points="250,60 100,400 400,400">
      </svg>
    HTML

    expect(find(:image, "Title")).to eq find(:test_id, "test")
  end
end
