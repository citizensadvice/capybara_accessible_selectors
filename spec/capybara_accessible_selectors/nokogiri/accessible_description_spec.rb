# frozen_string_literal: true

RSpec.describe CapybaraAccessibleSelectors::Nokogiri::AccessibleDescription, driver: :rack_test do
  describe "aria-describedby" do
    it "returns an accessible name from aria-describedby" do
      render <<~HTML
        <div role="group" aria-describedby="id2 id1" data-test-id="test">Contents</div>
        <span id="id1">description</span>
        <span id="id2">Accessible</span>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible description"
    end

    it "does not use aria-description and title within" do
      render <<~HTML
        <div role="group" aria-describedby="id" data-test-id="test">Contents</div>
        <div id="id">
          description
          <div aria-description="foo" aria-label="zzz">xxx</div>
          <div title="bar">yyy<div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "description zzz yyy"
    end

    it "excludes hidden text if description block is not hidden"
    it "includes hidden text if description block is hidden"
    it "excludes inert text"
    it "excludes inert text in the description block"

    it "handles missing ids" do
      render <<~HTML
        <div role="group" aria-describedby="id2 id1" data-test-id="test">Contents</div>
        <span id="id2">Accessible</span>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible"
    end

    it "only follows id-refs once" do
      render <<~HTML
        <div role="button" data-test-id="test" aria-describedby="id">Press me</div>
        <div id="id">
          foo
          <div aria-describedby="id1">
            bar
          </div>
          <div id="id1">fee</div>
        </div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "foo bar fee"
    end
  end

  describe "aria-description" do
    it "returns an accessible description from aria-description" do
      render <<~HTML
        <div role="group" aria-description="Accessible description" data-test-id="test" title="title">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq "Accessible description"
    end

    it "does not return an accessible description from aria-description if an empty aria-describedby is supplied" do
      render <<~HTML
        <div role="group" aria-describedby="" aria-description="Accessible description" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end
  end

  describe "native" do
    %w[button submit reset].each do |type|
      context "with an <input> type #{type}" do
        it "calculates from value" do
          render <<~HTML
            <label for="id1">label</label>
            <input type="#{type}" id="id1" value="value" title="foo">
          HTML

          expect(find(:element, "input").accessible_description).to eq "value"
        end

        it "does not use if matching the accessible name"
      end
    end

    context "with an <table>" do
      it "uses the caption"
      it "does not use the caption if empty"
      it "does not use the caption if the accessible name"
    end
  end

  describe "tooltip" do
    it "calculates from title" do
      render <<~HTML
        <article aria-label="xxx" title="title">
          Contents
        </article>
      HTML

      expect(find(:element, "article").accessible_description).to eq "title"
    end

    it "does not return an accessible description from tooltip if an empty aria-description is supplied" do
      render <<~HTML
        <div aria-label="xxx" role="group" aria-description="" title="title" data-test-id="test">Contents</div>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end
  end

  describe "name disallowed" do
    it "returns no description for an unknown element" do
      render <<~HTML
        <foo data-test-id="test" aria-desription="xxx">Contents</foo>
      HTML

      expect(find(:test_id, "test").accessible_description).to eq ""
    end

    describe "for a element with a role allowing a name" do
      it "returns no description for a hidden element" do
        render <<~HTML
          <div role="button" data-test-id="test" hidden aria-description="xxx">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a element with a hidden ancestor" do
        render <<~HTML
          <div hidden>
            <div role="button" data-test-id="test" aria-description="xxx">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for an aria-hidden element" do
        render <<~HTML
          <div role="button" data-test-id="test" aria-hidden="true" aria-description="xxx">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a element with an aria-hidden ancestor" do
        render <<~HTML
          <div aria-hidden="true">
            <div role="button" data-test-id="test" aria-description="xxx">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for an inert element" do
        render <<~HTML
          <div role="button" data-test-id="test" inert" aria-description="xxx">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a element with an inert ancestor" do
        render <<~HTML
          <div inert>
            <div role="button" data-test-id="test" aria-description="xxx">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a display none element" do
        render <<~HTML
          <div role="button" data-test-id="test" style="display:none" aria-description="xxx">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a element with a display none ancestor" do
        render <<~HTML
          <div style="display:none">
            <div role="button" data-test-id="test" aria-description="xxx">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a visibility hidden element" do
        render <<~HTML
          <div role="button" data-test-id="test" style="visibility:hidden" aria-description="xxx">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a element with a visibility hidden ancestor" do
        render <<~HTML
          <div style="visibility: hidden">
            <div role="button" data-test-id="test" aria-description="xxx">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a visibility collapse element" do
        render <<~HTML
          <div role="button" data-test-id="test" style="visibility:collapse" aria-description="xxx">Contents</button>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns no description for a element with a visibility collapse ancestor" do
        render <<~HTML
          <div style="visibility: collapse">
            <div role="button" data-test-id="test" aria-description="xxx">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
      end

      it "returns a description for a element with visibility visible" do
        render <<~HTML
          <div style="visibility: collapse">
            <div role="button" data-test-id="test" style="visibility:visible" aria-description="Description">Contents</button>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq "Description"
      end

      it "returns a description for a element with visibility visible ancestor" do
        render <<~HTML
          <div style="visibility: collapse">
            <div style="visibility: visible">
              <div role="button" data-test-id="test" aria-description="Description">Contents</button>
            </div>
          </div>
        HTML

        expect(find(:test_id, "test", visible: :all).accessible_description).to eq "Description"
      end
    end

    describe "roles with name disallowed" do
      %w[caption code definition deletion emphasis insertion mark generic none
         paragraph strong subscript suggestion superscript term time presentation].each do |role|
        it "returns nothing for the explict role #{role}" do
          render <<~HTML
            <div role="#{role}" aria-labelledby="id2 id1" data-test-id="test" aria-label="label" title="title" aria-description="description">Contents</div>
            <span id="id1">name</span>
            <span id="id2">Accessible</span>
          HTML

          expect(find(:test_id, "test").accessible_description).to eq ""
        end
      end
    end

    describe "elements with implicit roles with name disallowed" do
      %w[abbr b bdi bdo br cite code dfn em i kbd mark q rp rt ruby s samp small strong sub sup time u var wbr
         div span p pre address dl form a audio canvas meta link template slot style script].each do |name|
        it "returns no name for <#{name}>" do
          render <<~HTML
            <#{name} data-test-id="test" aria-description="description">Contents</#{name}>
          HTML

          expect(find(:test_id, "test", visible: :all).accessible_description).to eq ""
        end
      end
    end
  end
end
