# frozen_string_literal: true

describe "heading selector" do
  it "finds an aria heading with no locator" do
    render <<~HTML
      <div role="heading">Heading</div>
    HTML

    expect(page).to have_heading
  end

  it "does not find an absence of an aria heading with no locator" do
    render <<~HTML
      <div role="nav">Heading</div>
    HTML

    expect(page).to have_no_heading
  end

  it "finds an aria heading by text" do
    render <<~HTML
      <div role="heading">Heading 1</div>
      <div role="heading">Heading 2</div>
    HTML

    expect(page).to have_heading "Heading 1", count: 1
  end

  it "finds an aria heading by aria-label" do
    render <<~HTML
      <div role="heading" aria-label="Foo">Bar</div>
    HTML

    expect(page).to have_heading "Foo", count: 1
  end

  it "finds an aria heading by aria-labelledby" do
    render <<~HTML
      <div role="heading" aria-labelledby="id">Bar</div>
      <div id="id">Foo</div>
    HTML

    expect(page).to have_heading "Foo", count: 1
  end

  it "finds an aria heading by exact aria-label" do
    render <<~HTML
      <div role="heading" aria-label="Foo">Bar</div>
      <div role="heading" aria-label="Foo bar">Bar</div>
    HTML

    expect(page).to have_heading "Foo", exact: true, count: 1
  end

  it "finds an aria heading by exact aria-labelledby" do
    render <<~HTML
      <div role="heading" aria-labelledby="id1">Bar</div>
      <div id="id1">Foo</div>
      <div role="heading" aria-labelledby="id2">Bar</div>
      <div id="id2">Foo bar</div>
    HTML

    expect(page).to have_heading "Foo", exact: true, count: 1
  end

  (1..6).each do |level|
    it "finds a h#{level} with no locator" do
      render <<~HTML
        <h#{level}>Heading</h#{level}>
      HTML
      expect(page).to have_heading
    end

    it "does not find an absence of a h#{level} with no locator" do
      render <<~HTML
        <div>Heading</div>
      HTML
      expect(page).to have_no_heading
    end

    it "finds a h#{level} by text" do
      render <<~HTML
        <h#{level}>Heading #{level}</h#{level}>
        <h#{level}>Heading #{level + 1}</h#{level}>
      HTML
      expect(page).to have_heading "Heading #{level}", count: 1
    end
  end

  context "with level filter" do
    it "does not find an absence of the level" do
      render <<~HTML
        <div role="heading" aria-level="3">Heading 3</div>
        <h1>Heading 1</h1>
      HTML

      expect(page).to have_no_heading level: 2
    end

    it "filters for an aria heading level to with no aria-level" do
      render <<~HTML
        <div role="heading">Heading</div>
      HTML

      expect(page).to have_heading level: 2
    end

    (1..6).each do |level|
      it "filters for an aria heading level #{level}" do
        render <<~HTML
          <div role="heading" aria-level=#{level}>Heading</div>
          <div role="heading" aria-level=#{level + 1}>Heading</div>
        HTML

        expect(page).to have_heading level:, count: 1
      end

      it "filters for an h#{level}" do
        render <<~HTML
          <h#{level}>Heading</div>
          <h#{level + 1}>Heading</div>
        HTML

        expect(page).to have_heading level:, count: 1
      end

      it "filters for a native heading with overridden aria-level" do
        wrong_level = level == 6 ? 1 : level + 1
        render <<~HTML
          <h#{wrong_level} aria-level=#{level}>Heading</h#{wrong_level}>
          <h#{wrong_level}>Heading</h#{wrong_level}>
        HTML

        expect(page).to have_heading level:, count: 1
      end
    end
  end
end
