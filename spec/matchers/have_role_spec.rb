# frozen_string_literal: true

describe "have_role" do
  it "matches" do
    render <<~HTML
      <dialog data-testid="target" open>Foo</dialog>
    HTML

    expect(page).to have_role :dialog
  end

  it "matches using a negated matcher" do
    expect(page).to have_no_role :dialog
  end
end
