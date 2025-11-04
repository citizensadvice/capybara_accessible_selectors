# frozen_string_literal: true

RSpec.describe CapybaraAccessibleSelectors::Nokogiri::AccessibleRole, driver: :rack_test do
  describe "implicit roles" do
    context "with an <a>" do
      context "with a href" do
        it "returns link" do
          render %(<a href="http://example.com">contents</a>)
          expect(find(:element, "a").role).to eq "link"
        end
      end

      context "without a href" do
        it "returns link" do
          render "<a>contents</a>"
          expect(find(:element, "a").role).to be_nil
        end
      end
    end

    context "with an <area>" do
      context "with a href" do
        it "returns link" do
          render <<~HTML
            <img usemap="#map" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
            <map name="map">
              <area href="http://example.com" shape="circle" coords="5,5,5" alt="name">
            </map>
          HTML
          expect(find(:element, "area").role).to eq "link"
        end
      end

      context "without a href" do
        it "returns nil" do
          render <<~HTML
            <img usemap="#map" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
            <map name="map">
              <area shape="circle" coords="5,5,5" alt="name">
            </map>
          HTML
          expect(find(:element, "area").role).to be_nil
        end
      end
    end

    context "with an <article>" do
      it "returns article" do
        render "<article>Contents</article>"
        expect(find(:element, "article").role).to eq "article"
      end
    end

    context "with a <abbr>" do
      it "returns nil" do
        render "<abbr>contents</abbr>"
        expect(find(:element, "abbr").role).to be_nil
      end
    end

    context "with an <address>" do
      it "returns group" do
        render "<address>contents</address>"
        expect(find(:element, "address").role).to eq "group"
      end
    end

    context "with an <audio>" do
      it "returns nil" do
        render "<audio controls></audio>"
        expect(find(:element, "audio").role).to be_nil
      end
    end

    context "with an <aside>" do
      it "returns complementary" do
        render "<aside>Contents</aside>"
        expect(find(:element, "aside").role).to eq "complementary"
      end
    end

    context "with an <b>" do
      it "returns nil" do
        render "<b>contents</b>"
        expect(find(:element, "b").role).to be_nil
      end
    end

    context "with an <base>" do
      it "returns nil" do
        render_in_head %(<base href="")
        expect(find(:element, "base", visible: false).role).to be_nil
      end
    end

    context "with a <bdi>" do
      it "returns nil" do
        render "<bdi>contents</bdi>"
        expect(find(:element, "bdi").role).to be_nil
      end
    end

    context "with a <bdo>" do
      it "returns nil" do
        render "<bdo>contents</bdo>"
        expect(find(:element, "bdo").role).to be_nil
      end
    end

    context "with a <blockquote>" do
      it "returns blockquote" do
        render "<blockquote>contents</blockquote>"
        expect(find(:element, "blockquote").role).to eq "blockquote"
      end
    end

    context "with a <br>" do
      it "returns nil" do
        render "<br>"
        expect(find(:element, "br", visible: false).role).to be_nil
      end
    end

    context "with a <body>" do
      it "returns nil" do
        render ""
        expect(find(:element, "body").role).to be_nil
      end
    end

    context "with a <button>" do
      it "returns button" do
        render "<button>contents</button>"
        expect(find(:element, "button").role).to eq "button"
      end

      it "returns nil for a button in a select" do
        render "<select><button>contents</button><select>"
        expect(find(:element, "button").role).to eq nil
      end
    end

    context "with a <canvas>" do
      it "returns nil" do
        render "<canvas>contents</canvas>"
        expect(find(:element, "canvas").role).to be_nil
      end
    end

    context "with a <caption>" do
      it "returns caption" do
        render <<~HTML
          <table>
            <caption>Description</caption>
            <tbody>
              <tr><td>foo</td></r>
            </tbody>
          </table>
        HTML
        expect(find(:element, "caption").role).to eq "caption"
      end

      %w[table grid treegrid].each do |role|
        it "returns caption with a table with a role of #{role}" do
          render <<~HTML
            <table role="#{role}">
              <caption>Description</caption>
              <tbody>
                <tr><td>foo</td></r>
              </tbody>
            </table>
          HTML
          expect(find(:element, "caption").role).to eq "caption"
        end
      end

      %w[none presentation list].each do |role|
        it "returns nil in a table with role #{role}" do
          render <<~HTML
            <table role="#{role}">
              <caption>Description</caption>
              <tbody>
                <tr><td>foo</td></r>
              </tbody>
            </table>
          HTML
          expect(find(:element, "caption").role).to be_nil
        end
      end

      it "returns nil without a table" do
        # In browsers the caption element is not generated
        render <<~HTML
          <caption>Description</caption>
        HTML
        expect(find(:element, "caption").role).to be_nil
      end
    end

    context "with a <cite>" do
      it "returns nil" do
        render "<cite>contents</cite>"
        expect(find(:element, "cite").role).to be_nil
      end
    end

    context "with a <code>" do
      it "returns code" do
        render "<code>contents</code>"
        expect(find(:element, "code").role).to eq "code"
      end
    end

    context "with a <col>" do
      it "returns article" do
        render <<~HTML
          <table>
            <col>
            <tbody>
              <tr><td>x</td></r>
            </tbody>
          </table>
        HTML
        expect(find(:element, "col", visible: false).role).to be_nil
      end
    end

    context "with a <colgroup>" do
      it "returns article" do
        render <<~HTML
          <table>
            <colgroup>
              <col>
            </colgroup>
            <tr><td>x</td></r>
          </table>
        HTML
        expect(find(:element, "colgroup").role).to be_nil
      end
    end

    context "with a <data>" do
      it "returns nil" do
        render <<~HTML
          <data value="1">contents</data>
        HTML
        expect(find(:element, "data").role).to be_nil
      end
    end

    context "with a <datalist>" do
      it "returns listbox" do
        # In browsers the datalist is never included in the accessible tree
        render <<~HTML
          <datalist></datalist>
        HTML
        expect(find(:element, "datalist", visible: false).role).to eq "listbox"
      end
    end

    context "with a <dd>" do
      it "returns nil" do
        render "<dl><dt>Term</dt><dd>Defintion</dd></dl>"
        expect(find(:element, "dd").role).to eq "definition"
      end

      it "returns term outside of a dl" do
        render "<dd>Definition</dd>"
        expect(find(:element, "dd").role).to eq "definition"
      end

      it "returns term with a dl set to role none" do
        render "<dl role=none><dt>Term</dt><dd>Defintion</dd></dl>"
        expect(find(:element, "dd").role).to eq "definition"
      end
    end

    context "with a <del>" do
      it "returns deletion" do
        render "<del>contents</del>"
        expect(find(:element, "del").role).to eq "deletion"
      end
    end

    context "with an <details>" do
      it "returns group" do
        render "<details>contents</details>"
        expect(find(:element, "details").role).to eq "group"
      end
    end

    context "with an <dfn>" do
      it "returns term" do
        render "<dfn>contents</dfn>"
        expect(find(:element, "dfn").role).to eq "term"
      end
    end

    context "with a <dialog>" do
      it "returns listbox" do
        render <<~HTML
          <dialog open>Contents</dialog>
        HTML
        expect(find(:element, "dialog").role).to eq "dialog"
      end
    end

    context "with a <div>" do
      it "returns nil" do
        render "<div>contents</div>"
        expect(find(:element, "div").role).to be_nil
      end
    end

    context "with a <dl>" do
      it "returns nil" do
        render "<dl><dt>Term</dt><dd>Defintion</dd></dl>"
        expect(find(:element, "dl").role).to be_nil
      end
    end

    context "with a <dt>" do
      it "returns term" do
        render "<dl><dt>Term</dt><dd>Defintion</dd></dl>"
        expect(find(:element, "dt").role).to eq "term"
      end

      it "returns term outside of a dl" do
        render "<dt>Term</dt>"
        expect(find(:element, "dt").role).to eq "term"
      end

      it "returns term with a dl set to role none" do
        render "<dl role=none><dt>Term</dt><dd>Defintion</dd></dl>"
        expect(find(:element, "dt").role).to eq "term"
      end
    end

    context "with an <em>" do
      it "returns emphasis" do
        render "<em>contents</em>"
        expect(find(:element, "em").role).to eq "emphasis"
      end
    end

    context "with a <fieldset>" do
      it "returns group" do
        render <<~HTML
          <fieldset>
            <legend>Name</legend>
          </fieldset>
        HTML
        expect(find(:element, "fieldset").role).to eq "group"
      end
    end

    context "with a <figcaption>" do
      it "returns nil" do
        render <<~HTML
          <figure>
            <figcaption>Name</figcaption>
          </figure>
        HTML
        expect(find(:element, "figcaption").role).to be_nil
      end
    end

    context "with a <figure>" do
      it "returns figure" do
        render <<~HTML
          <figure>
            <figcaption>Name</figcaption>
          </figure>
        HTML
        expect(find(:element, "figure").role).to eq "figure"
      end
    end

    context "with a <footer>" do
      it "returns contentinfo without a sectioning ancestor" do
        render <<~HTML
          <div>
            <footer>Content</footer>
          </div>
        HTML
        expect(find(:element, "footer").role).to eq "contentinfo"
      end

      %w[main article complementary navigation].each do |role|
        it "returns sectionfooter with an ancestor with the role #{role}" do
          render <<~HTML
            <div role="#{role}">
              <footer>Content</footer>
            </div>
          HTML
          expect(find(:element, "footer").role).to eq "sectionfooter"
        end
      end

      %w[article aside main nav].each do |name|
        it "returns sectionfooter with an ancestor #{name}" do
          render <<~HTML
            <#{name}>
              <footer>Content</footer>
            </#{name}>
          HTML
          expect(find(:element, "footer").role).to eq "sectionfooter"
        end

        it "returns contentinfo with an ancestor #{name} with role none" do
          render <<~HTML
            <#{name} role="none">
              <footer>Content</footer>
            </#{name}>
          HTML
          expect(find(:element, "footer").role).to eq "contentinfo"
        end
      end

      it "returns sectionfooter with an ancestor section" do
        render <<~HTML
          <section>
            <footer>Content</footer>
          </section>
        HTML
        expect(find(:element, "footer").role).to eq "sectionfooter"
      end

      it "returns sectionfooter with an ancestor section explicitly mapped to region" do
        render <<~HTML
          <section role="region">
            <footer>Content</footer>
          </section>
        HTML
        expect(find(:element, "footer").role).to eq "sectionfooter"
      end

      it "returns contentinfo with an ancestor section remapped to a different role" do
        render <<~HTML
          <section role="list">
            <footer>Content</footer>
          </section>
        HTML
        expect(find(:element, "footer").role).to eq "contentinfo"
      end
    end

    context "with a <form>" do
      it "returns form with an accessible label" do
        render <<~HTML
          <form aria-label="foo"><input /></form>
        HTML
        expect(find(:element, "form").role).to eq "form"
      end

      it "returns nil without an accessible label" do
        render <<~HTML
          <form><input /></form>
        HTML
        expect(find(:element, "form").role).to be_nil
      end
    end

    context "with a <header>" do
      it "returns banner without a sectioning ancestor" do
        render <<~HTML
          <div>
            <header>Content</header>
          </div>
        HTML
        expect(find(:element, "header").role).to eq "banner"
      end

      %w[main article complementary navigation].each do |role|
        it "returns sectionheader with an ancestor with the role #{role}" do
          render <<~HTML
            <div role="#{role}">
              <header>Content</header>
            </div>
          HTML
          expect(find(:element, "header").role).to eq "sectionheader"
        end
      end

      %w[article aside main nav].each do |name|
        it "returns sectionheader with an ancestor #{name}" do
          render <<~HTML
            <#{name}>
              <header>Content</header>
            </#{name}>
          HTML
          expect(find(:element, "header").role).to eq "sectionheader"
        end

        it "returns banner with an ancestor #{name} with role none" do
          render <<~HTML
            <#{name} role="none">
              <header>Content</header>
            </#{name}>
          HTML
          expect(find(:element, "header").role).to eq "banner"
        end
      end

      it "returns sectionheader with an ancestor section" do
        render <<~HTML
          <section>
            <header>Content</header>
          </section>
        HTML
        expect(find(:element, "header").role).to eq "sectionheader"
      end

      it "returns sectionheader with an ancestor section explicitly mapped to region" do
        render <<~HTML
          <section role="region">
            <header>Content</header>
          </section>
        HTML
        expect(find(:element, "header").role).to eq "sectionheader"
      end

      it "returns banner with an ancestor section remapped to a different role" do
        render <<~HTML
          <section role="list">
            <header>Content</header>
          </section>
        HTML
        expect(find(:element, "header").role).to eq "banner"
      end
    end

    %w[h1 h2 h3 h4 h5 h6].each do |name|
      context "with a <#{name}>" do
        it "returns group" do
          render "<#{name}>contents</#{name}>"
          expect(find(:element, name).role).to eq "heading"
        end
      end
    end

    context "with a <head>" do
      it "returns article" do
        render ""
        expect(find(:element, "head", visible: false).role).to be_nil
      end
    end

    context "with a <hgroup>" do
      it "returns group" do
        render "<hgroup>contents</hgroup>"
        expect(find(:element, "hgroup").role).to eq "group"
      end
    end

    context "with a <hr>" do
      it "returns separator" do
        render "<hr>"
        expect(find(:element, "hr").role).to eq "separator"
      end
    end

    context "with a <html>" do
      it "returns nil" do
        render ""
        expect(find(:element, "html").role).to be_nil
      end
    end

    context "with an <i>" do
      it "returns nil" do
        render "<i>contents</i>"
        expect(find(:element, "i").role).to be_nil
      end
    end

    context "with an <iframe>" do
      it "returns nil" do
        render %(<iframe srcdoc="<!doctype html><p>Hello World!</p>"></iframe>)
        expect(find(:element, "iframe").role).to be_nil
      end
    end

    context "with an <img>" do
      it "returns image with with a none empty alt" do
        render <<~HTML
          <img alt="name" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
        HTML
        expect(find(:element, "img").role).to eq "image"
      end

      it "returns image with with an accessible name" do
        render <<~HTML
          <img alt="" aria-label="name" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
        HTML
        expect(find(:element, "img").role).to eq "image"
      end

      it "returns nil with with an empty accessible name" do
        render <<~HTML
          <img alt="" aria-label="" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
        HTML
        expect(find(:element, "img").role).to be_nil
      end

      it "returns image with no alt" do
        render <<~HTML
          <img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
        HTML
        expect(find(:element, "img").role).to eq "image"
      end

      it "returns nil with an empty alt" do
        render <<~HTML
          <img alt="" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
        HTML
        expect(find(:element, "img").role).to be_nil
      end
    end

    context "with an <input>" do
      %w[button image file reset submit].each do |type|
        it "returns button for type #{type}" do
          render <<~HTML
            <input type="#{type}">
          HTML
          expect(find(:element, "input").role).to eq "button"
        end
      end

      it "returns checkbox for type checkbox" do
        render <<~HTML
          <input type="checkbox">
        HTML
        expect(find(:element, "input").role).to eq "checkbox"
      end

      %w[color date datetime-local month time week].each do |type|
        it "returns nil for type #{type}" do
          render <<~HTML
            <input type="#{type}">
          HTML
          expect(find(:element, "input").role).to be_nil
        end
      end

      it "returns nil for type hidden" do
        render <<~HTML
          <input type="hidden">
        HTML
        expect(find(:element, "input", visible: false).role).to be_nil
      end

      it "returns spinbutton for type number" do
        render <<~HTML
          <input type="number">
        HTML
        expect(find(:element, "input").role).to eq "spinbutton"
      end

      it "returns radio for type radio" do
        render <<~HTML
          <input type="radio">
        HTML
        expect(find(:element, "input").role).to eq "radio"
      end

      it "returns slider for type range" do
        render <<~HTML
          <input type="range">
        HTML
        expect(find(:element, "input").role).to eq "slider"
      end

      it "returns searchbox for type search" do
        render <<~HTML
          <input type="search">
        HTML
        expect(find(:element, "input").role).to eq "searchbox"
      end

      it "returns combobox for type search with a list" do
        render <<~HTML
          <input type="search" list="id">
          <datalist id="list"></datalist>
        HTML
        expect(find(:element, "input").role).to eq "combobox"
      end

      %w[text email tel url].each do |type|
        it "returns textbox for type #{type}" do
          render <<~HTML
            <input type="#{type}">
          HTML
          expect(find(:element, "input").role).to eq "textbox"
        end

        it "returns combobox for type #{type} with a list" do
          render <<~HTML
            <input type="#{type}" list="list">
            <datalist id="list"></datalist>
          HTML
          expect(find(:element, "input").role).to eq "combobox"
        end
      end

      it "returns textbox for password" do
        render <<~HTML
          <input type="password">
        HTML
        expect(find(:element, "input").role).to eq "textbox"
      end

      it "returns textbox for no type" do
        render <<~HTML
          <input>
        HTML
        expect(find(:element, "input").role).to eq "textbox"
      end

      it "returns combobox for no type with a list" do
        render <<~HTML
          <input list="list">
          <datalist id="list"></datalist>
        HTML
        expect(find(:element, "input").role).to eq "combobox"
      end

      it "returns textbox for no type with a list and no datalist" do
        render <<~HTML
          <input list="list">
        HTML
        expect(find(:element, "input").role).to eq "textbox"
      end

      it "returns textbox for an unknown type" do
        render <<~HTML
          <input type="foo">
        HTML
        expect(find(:element, "input").role).to eq "textbox"
      end

      it "returns combobox for an unknown type with a list" do
        render <<~HTML
          <input type="foo" list="list">
          <datalist id="list"></datalist>
        HTML
        expect(find(:element, "input").role).to eq "combobox"
      end
    end

    context "with an <ins>" do
      it "returns insertion" do
        render "<ins>contents</ins>"
        expect(find(:element, "ins").role).to eq "insertion"
      end
    end

    context "with a <kbd>" do
      it "returns nil" do
        render "<kbd>contents</kbd>"
        expect(find(:element, "kbd").role).to be_nil
      end
    end

    context "with a <label>" do
      it "returns nil" do
        render "<label>contents</label>"
        expect(find(:element, "label").role).to be_nil
      end
    end

    context "with a <legend>" do
      it "returns nil" do
        render <<~HTML
          <fieldset>
            <legend>Name</legend>
          </fieldset>
        HTML
        expect(find(:element, "legend").role).to be_nil
      end
    end

    context "with an <li>" do
      %w[ul ol menu].each do |name|
        it "returns listitem if a child of a #{name}" do
          render <<~HTML
            <#{name}><li>Contents</li></#{name}>
          HTML
          expect(find(:element, "li").role).to eq "listitem"
        end

        it "returns listitem if a child of a #{name} with a role of list" do
          render <<~HTML
            <#{name} role="list"><li>Contents</li></#{name}>
          HTML
          expect(find(:element, "li").role).to eq "listitem"
        end

        it "returns nil if a child of a #{name} with a role of none" do
          render <<~HTML
            <#{name} role="none"><li>Contents</li></#{name}>
          HTML
          expect(find(:element, "li").role).to be_nil
        end

        it "returns nil if a child of a #{name} with a role of presentation" do
          render <<~HTML
            <#{name} role="presentation"><li>Contents</li></#{name}>
          HTML
          expect(find(:element, "li").role).to be_nil
        end

        it "returns nil if a child of a #{name} with a role of link" do
          render <<~HTML
            <#{name} role="link"><li>Contents</li></#{name}>
          HTML
          expect(find(:element, "li").role).to be_nil
        end
      end

      it "returns nil child of anything else" do
        render <<~HTML
          <li>Contents</li>
        HTML
        expect(find(:element, "li").role).to be_nil
      end
    end

    context "with a <link>" do
      it "returns nil" do
        render "<link>"
        expect(find(:element, "link", visible: false).role).to be_nil
      end
    end

    context "with a <main>" do
      it "returns main" do
        render "<main>contents</main>"
        expect(find(:element, "main").role).to eq "main"
      end
    end

    context "with a <math>" do
      it "returns math" do
        render <<~HTML
          <math>
            <mfrac>
              <mn>1</mn>
              <msqrt>
                <mn>2</mn>
              </msqrt>
            </mfrac>
          </math>
        HTML

        expect(find(:element, "math").role).to eq "math"
      end
    end

    context "with a <map>" do
      it "returns nil" do
        render <<~HTML
          <img usemap="#map" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
          <map name="map">
            <area href="http://example.com" shape="circle" coords="5,5,5" alt="name">
          </map>
        HTML
        expect(find(:element, "map").role).to be_nil
      end
    end

    context "with a <mark>" do
      it "returns mark" do
        render "<mark>contents</mark>"
        expect(find(:element, "mark").role).to eq "mark"
      end
    end

    context "with an <meta>" do
      it "returns article" do
        render ""
        expect(find(:element, "meta", visible: false).role).to be_nil
      end
    end

    context "with a <meter>" do
      it "returns meter" do
        render %(<meter value="0">contents</meter>)
        expect(find(:element, "meter").role).to eq "meter"
      end
    end

    context "with a <nav>" do
      it "returns navigation" do
        render "<nav>contents</nav>"
        expect(find(:element, "nav").role).to eq "navigation"
      end
    end

    context "with a <noscript>" do
      it "returns nil" do
        render <<~HTML
          <noscript>contents</noscript>
        HTML
        expect(find(:element, "noscript", visible: false).role).to be_nil
      end
    end

    context "with an <object>" do
      it "returns nil" do
        render <<~HTML
          <object
            type="application/pdf"
            data="data:application/pdf;base64,JVBERi0xLjIgCjkgMCBvYmoKPDwKPj4Kc3RyZWFtCkJULyA5IFRmKFRlc3QpJyBFVAplbmRzdHJlYW0KZW5kb2JqCjQgMCBvYmoKPDwKL1R5cGUgL1BhZ2UKL1BhcmVudCA1IDAgUgovQ29udGVudHMgOSAwIFIKPj4KZW5kb2JqCjUgMCBvYmoKPDwKL0tpZHMgWzQgMCBSIF0KL0NvdW50IDEKL1R5cGUgL1BhZ2VzCi9NZWRpYUJveCBbIDAgMCA5OSA5IF0KPj4KZW5kb2JqCjMgMCBvYmoKPDwKL1BhZ2VzIDUgMCBSCi9UeXBlIC9DYXRhbG9nCj4+CmVuZG9iagp0cmFpbGVyCjw8Ci9Sb290IDMgMCBSCj4+CiUlRU9G"
          >
            fallback
          </object>
        HTML
        render "<object>contents</object>"
        expect(find(:element, "object").role).to be_nil
      end
    end

    context "with an <optgroup>" do
      it "returns group with a parent select" do
        render <<~HTML
          <select><optgroup label="Group"><option>Name</option></optgroup></select>
        HTML
        expect(find(:element, "optgroup").role).to eq "group"
      end

      it "returns nil without a parent select" do
        render <<~HTML
          <optgroup label="Group"><option>Name</option></optgroup>
        HTML
        expect(find(:element, "optgroup", visible: false).role).to be_nil
      end
    end

    context "with an <option>" do
      it "returns option with a parent select" do
        render <<~HTML
          <select><option></select>
        HTML
        expect(find(:element, "option").role).to eq "option"
      end

      it "returns option with a parent select with a role of none" do
        render <<~HTML
          <select role="none"><option></select>
        HTML
        expect(find(:element, "option").role).to eq "option"
      end

      it "returns option with a parent select and optgroup" do
        render <<~HTML
          <select><optgroup label="Group"><option>Name</option></optgroup></select>
        HTML
        expect(find(:element, "option").role).to eq "option"
      end

      it "returns option with a parent datalist" do
        render <<~HTML
          <datalist id="list"><option>name</option></datalist>
        HTML
        expect(find(:element, "option", visible: false).role).to eq "option"
      end

      it "returns nil without a parent select or datalist" do
        render <<~HTML
          <option>name</option>
        HTML
        expect(find(:element, "option", visible: false).role).to be_nil
      end
    end

    context "with an <output>" do
      it "returns output" do
        render "<output>contents</output>"
        expect(find(:element, "output").role).to eq "status"
      end
    end

    context "with a <p>" do
      it "returns p" do
        render "<p>contents</p>"
        expect(find(:element, "p").role).to eq "paragraph"
      end
    end

    context "with a <picture>" do
      it "returns nil" do
        render <<~HTML
          <picture>
            <img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" width="10" height="10">
          </picture>
        HTML
        expect(find(:element, "picture").role).to be_nil
      end
    end

    context "with a <pre>" do
      it "returns nil" do
        render "<pre>contents</pre>"
        expect(find(:element, "pre").role).to be_nil
      end
    end

    context "with a <progress>" do
      it "returns progressbar" do
        render "<progress>contents</progress>"
        expect(find(:element, "progress").role).to eq "progressbar"
      end
    end

    context "with a <q>" do
      it "returns nil" do
        render "<q>contents</q>"
        expect(find(:element, "q").role).to be_nil
      end
    end

    context "with an <ruby>" do
      it "returns nil" do
        render <<~HTML
          <ruby>漢<rp>(</rp><rt>kan</rt></ruby>
        HTML
        expect(find(:element, "ruby").role).to be_nil
      end
    end

    context "with an <rt>" do
      it "returns nil" do
        render <<~HTML
          <ruby>漢<rp>(</rp><rt>kan</rt></ruby>
        HTML
        expect(find(:element, "rt").role).to be_nil
      end
    end

    context "with an <rp>" do
      it "returns nil" do
        render <<~HTML
          <ruby>漢<rp>(</rp><rt>kan</rt></ruby>
        HTML
        expect(find(:element, "rp", visible: false).role).to be_nil
      end
    end

    context "with an <s>" do
      it "returns deletion" do
        render "<s>contents</s>"
        expect(find(:element, "s").role).to eq "deletion"
      end
    end

    context "with a <samp>" do
      it "returns nil" do
        render "<samp>contents</samp>"
        expect(find(:element, "samp").role).to be_nil
      end
    end

    context "with an <script>" do
      it "returns nil" do
        render "<script>//comment</script>"
        expect(find(:element, "script", visible: false).role).to be_nil
      end
    end

    context "with a <search>" do
      it "returns search" do
        render "<search>contents</search>"
        expect(find(:element, "search").role).to eq "search"
      end
    end

    context "with a <section>" do
      it "returns nil with no accessible name" do
        render "<section>contents</section>"
        expect(find(:element, "section").role).to be_nil
      end

      it "returns nil with an empty accessible name" do
        render %(<section aria-label="">contents</section>)
        expect(find(:element, "section").role).to be_nil
      end

      it "returns region with an accessible name" do
        render %(<section aria-label="name">contents</section>)
        expect(find(:element, "section").role).to eq "region"
      end
    end

    context "with a <select>" do
      it "returns combobox" do
        render <<~HTML
          <select></select>
        HTML
        expect(find(:element, "select").role).to eq "combobox"
      end

      it "returns listbox with a multiple attribute" do
        render <<~HTML
          <select multiple></select>
        HTML
        expect(find(:element, "select").role).to eq "listbox"
      end

      it "returns combobox with a size of 1" do
        render <<~HTML
          <select size="1"></select>
        HTML
        expect(find(:element, "select").role).to eq "combobox"
      end

      it "returns listbox with a size of greater than 1" do
        render <<~HTML
          <select size="2"></select>
        HTML
        expect(find(:element, "select").role).to eq "listbox"
      end
    end

    context "with a <slot>" do
      it "returns nil" do
        render "<slot>Contents</slot>"
        expect(find(:element, "slot").role).to be_nil
      end
    end

    context "with a <small>" do
      it "returns nil" do
        render "<small>contents</small>"
        expect(find(:element, "small").role).to be_nil
      end
    end

    context "with a <source>" do
      it "returns nil" do
        render "<audio controls><source></audio>"
        expect(find(:element, "source", visible: false).role).to be_nil
      end
    end

    context "with a <span>" do
      it "returns nil" do
        render "<span>contents</span>"
        expect(find(:element, "span").role).to be_nil
      end
    end

    context "with a <summary>" do
      it "returns button with a parent details" do
        render "<details><summary>Name</summary></details>"
        expect(find(:element, "summary").role).to eq "button"
      end

      it "returns nil without a parent details" do
        render "<summary>Name</summary>"
        expect(find(:element, "summary").role).to be_nil
      end
    end

    context "with a <strong>" do
      it "returns strong" do
        render "<strong>contents</strong>"
        expect(find(:element, "strong").role).to eq "strong"
      end
    end

    context "with an <style>" do
      it "returns nil" do
        render "<style>/*comment*/</style>"
        expect(find(:element, "style", visible: false).role).to be_nil
      end
    end

    context "with a <sub>" do
      it "returns subscript" do
        render "<sub>contents</sub>"
        expect(find(:element, "sub").role).to eq "subscript"
      end
    end

    context "with an <svg>" do
      it "returns image" do
        render <<~HTML
          <svg height="500" width="500">
            <polygon points="250,60 100,400 400,400">
          </svg>
        HTML
        expect(find(:element, "svg").role).to eq "image"
      end
    end

    context "with a <table>" do
      it "returns table" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tbody>
              <tr><td>Cell</td></tr>
            </tbody>
          </table>
        HTML
        expect(find(:element, "table").role).to eq "table"
      end
    end

    context "with a <td>" do
      it "returns cell" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><td>Cell</td></tr>
          </table>
        HTML
        expect(first(:element, "td").role).to eq "cell"
      end

      it "returns gridcell a child a table with role grid" do
        render <<~HTML
          <table role="grid">
            <caption>name</caption>
            <tr><td>cell</td></tr>
          </table>
        HTML
        expect(find(:element, "td").role).to eq "gridcell"
      end

      it "returns gridcell a child a table with role treegrid" do
        render <<~HTML
          <table role="treegrid">
            <caption>name</caption>
            <tr><td>cell</td></tr>
          </table>
        HTML
        expect(find(:element, "td").role).to eq "gridcell"
      end

      it "returns gridcell a child a row with role row" do
        render <<~HTML
          <table>
            <caption>name</caption>
            <tr role="row"><td>cell</td></tr>
          </table>
        HTML
        expect(find(:element, "td").role).to eq "cell"
      end

      %w[none presentation list].each do |role|
        it "returns nil a child a row with role #{role}" do
          render <<~HTML
            <table>
              <caption>name</caption>
              <tr role="#{role}"><td>cell</td></tr>
            </table>
          HTML
          expect(find(:element, "td").role).to be_nil
        end
      end

      it "returns nil a child a table with role none" do
        render <<~HTML
          <table role="none">
            <caption>name</caption>
            <tr><td>cell</td></tr>
          </table>
        HTML
        expect(find(:element, "td").role).to be_nil
      end
    end

    context "with a <template>" do
      it "returns nil" do
        render "<template>contents</template>"
        expect(find(:element, "template", visible: false).role).to be_nil
      end
    end

    %w[tbody tfoot thead].each do |name|
      context "with a <#{name}>" do
        it "returns rowgroup" do
          render <<~HTML
            <table>
              <caption>Name</caption>
              <#{name}>
                <tr><td>Cell</td></tr>
              </#{name}>
            </table>
          HTML
          expect(find(:element, name).role).to eq "rowgroup"
        end

        %w[table grid treegrid].each do |role|
          it "returns rowgroup with a table with role #{role}" do
            render <<~HTML
              <table role="#{role}">
                <caption>Name</caption>
                <#{name}>
                  <tr><td>Cell</td></tr>
                </#{name}>
              </table>
            HTML
            expect(find(:element, name).role).to eq "rowgroup"
          end
        end

        %w[none presentation list].each do |role|
          it "returns nil with a table with role #{role}" do
            render <<~HTML
              <table role="#{role}">
                <caption>Name</caption>
                <#{name}>
                  <tr><td>Cell</td></tr>
                </#{name}>
              </table>
            HTML
            expect(find(:element, name).role).to be_nil
          end
        end
      end
    end

    context "with a <textarea>" do
      it "returns textbox" do
        render "<textarea>contents</textarea>"
        expect(find(:element, "textarea").role).to eq "textbox"
      end
    end

    context "with a <time>" do
      it "returns time" do
        render %(<time datetime="2018-07-07">July 7</time>)
        expect(find(:element, "time").role).to eq "time"
      end
    end

    context "with a <tr>" do
      it "returns row if child of table" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><td>Cell</td></tr>
          </table>
        HTML
        expect(find(:element, "tr").role).to eq "row"
      end

      %w[thead tbody tfoot].each do |name|
        it "returns row if child of #{name}" do
          render <<~HTML
            <table>
              <caption>Name</caption>
              <#{name}>
                <tr><td>Cell</td></tr>
              </#{name}>
            </table>
          HTML
          expect(find(:element, "tr").role).to eq "row"
        end

        it "returns row if child of #{name} with a role of rowgroup" do
          render <<~HTML
            <table>
              <caption>Name</caption>
              <#{name} role="rowgroup">
                <tr><td>Cell</td></tr>
              </#{name}>
            </table>
          HTML
          expect(find(:element, "tr").role).to eq "row"
        end

        %w[none presentation list].each do |role|
          it "returns nil if a child of #{name} with role #{role}" do
            render <<~HTML
              <table>
                <caption>Name</caption>
                <#{name} role="#{role}">
                  <tr><td>Cell</td></tr>
                </#{name}>
              </table>
            HTML
            expect(find(:element, "tr").role).to be_nil
          end
        end

        it "returns nil if a child of #{name} with table with a role of none" do
          render <<~HTML
            <table role="none">
              <caption>Name</caption>
              <#{name}>
                <tr><td>Cell</td></tr>
              </#{name}>
            </table>
          HTML
          expect(find(:element, "tr").role).to be_nil
        end
      end

      %w[table grid treegrid].each do |role|
        it "returns row with a table with role #{role}" do
          render <<~HTML
            <table role="#{role}">
              <caption>Name</caption>
              <tr><td>Cell</td></tr>
            </table>
          HTML
          expect(find(:element, "tr").role).to eq "row"
        end
      end

      %w[none presentation list].each do |role|
        it "returns nil with a table with role #{role}" do
          render <<~HTML
            <table role="#{role}">
              <caption>Name</caption>
              <tr><td>Cell</td></tr>
            </table>
          HTML
          expect(find(:element, "tr").role).to be_nil
        end
      end
    end

    context "with a <th>" do
      it "returns columnheader if all cells are th" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><th>Cell</th><th>Cell</th></tr>
          </table>
        HTML
        expect(first(:element, "th").role).to eq "columnheader"
      end

      it "returns columnheader if any cell is td and a col scope is set" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><th scope="col">Cell</th><td>Cell</td></tr>
          </table>
        HTML
        expect(find(:element, "th").role).to eq "columnheader"
      end

      it "returns columnheader if any cell is td and a colgroup scope is set" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><th scope="colgroup">Cell</th><td>Cell</td></tr>
          </table>
        HTML
        expect(find(:element, "th").role).to eq "columnheader"
      end

      it "returns rowheader if any cells are td" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><th>Cell</th><td>Cell</td></tr>
          </table>
        HTML
        expect(find(:element, "th").role).to eq "rowheader"
      end

      it "returns rowheader if all cells are th and a row scope is set" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><th scope="row">Cell</th><th>Cell</th></tr>
          </table>
        HTML
        expect(first(:element, "th").role).to eq "rowheader"
      end

      it "returns rowheader if all cells are th and a rowgroup scope is set" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr><th scope="rowgroup">Cell</th><th>Cell</th></tr>
          </table>
        HTML
        expect(first(:element, "th").role).to eq "rowheader"
      end

      it "returns column header with a row with a role of row" do
        render <<~HTML
          <table>
            <caption>Name</caption>
            <tr role="row"><th>Cell</th></tr>
          </table>
        HTML
        expect(first(:element, "th").role).to eq "columnheader"
      end

      %w[none presentation list].each do |role|
        it "returns nil header with a row with a role of #{role}" do
          render <<~HTML
            <table>
              <caption>Name</caption>
              <tr role="#{role}"><th>Cell</th></tr>
            </table>
          HTML
          expect(first(:element, "th").role).to be_nil
        end
      end

      %w[table grid treegrid].each do |role|
        it "returns columnheader with a table with a role of #{role}" do
          render <<~HTML
            <table role="#{role}">
              <caption>Name</caption>
              <tr><th>Cell</th></tr>
            </table>
          HTML
          expect(first(:element, "th").role).to eq "columnheader"
        end
      end

      it "returns nil header with a table with role of none" do
        render <<~HTML
          <table role="none">
            <caption>Name</caption>
            <tr><th>Cell</th></tr>
          </table>
        HTML
        expect(first(:element, "th").role).to be_nil
      end
    end

    context "with a <track>" do
      it "returns nil" do
        render "<audio controls><track></audio>"
        expect(find(:element, "track", visible: false).role).to be_nil
      end
    end

    context "with a <title>" do
      it "returns article" do
        render_in_head "<title>Title</title>"
        expect(find(:element, "title", visible: false).role).to be_nil
      end
    end

    context "with a <u>" do
      it "returns nil" do
        render "<u>contents</u>"
        expect(find(:element, "u").role).to be_nil
      end
    end

    context "with a <var>" do
      it "returns nil" do
        render "<var>Contents</var>"
        expect(find(:element, "var").role).to be_nil
      end
    end

    context "with a <video>" do
      it "returns nil" do
        render "<video></video>"
        expect(find(:element, "video").role).to be_nil
      end
    end

    context "with a <wbr>" do
      it "returns nil" do
        render "<wbr>"
        expect(find(:element, "wbr", visible: false).role).to be_nil
      end
    end

    context "with an unknown element" do
      it "returns article" do
        render "<foo>contents</foo>"
        expect(find(:element, "foo").role).to be_nil
      end
    end
  end

  describe "explicit roles" do
    it "uses the role attribute" do
      render %(<div role="list">contents</div>)
      expect(find(:element, "div").role).to eq "list"
    end

    it "overrides an implicit role" do
      render %(<a role="button" href="http://example.com">contents</a>)
      expect(find(:element, "a").role).to eq "button"
    end

    it "overrides with roles not allowed by the ARIA in HTML spec" do
      render %(<a role="textbox" href="http://example.com">contents</a>)
      expect(find(:element, "a").role).to eq "textbox"
    end

    it "allows a token list" do
      render %(<div role="list region">contents</foo>)
      expect(find(:element, "div").role).to eq "list"
    end

    it "ignores unknown roles" do
      render %(<div role="window foo list">contents</foo>)
      expect(find(:element, "div").role).to eq "list"
    end

    it "ignores none on a focusable element" do
      render %(<a role="none" href="http://example.com">contents</a>)
      expect(find(:element, "a").role).to eq "link"
    end

    it "ignores presentation on a focusable element" do
      render %(<a role="presentation" href="http://example.com">contents</a>)
      expect(find(:element, "a").role).to eq "link"
    end

    it "allows none on a non-focusable element" do
      render %(<ul role="none"><li>Contenst</li></ul>)
      expect(find(:element, "ul").role).to be_nil
    end

    it "allows presentation on a focusable element" do
      render %(<ul role="presentation"><li>Contenst</li></ul>)
      expect(find(:element, "ul").role).to be_nil
    end

    it "resolves presentation as nil" do
      render %(<div role="presentation" aria-label="Name">contents</div>)
      expect(find(:element, "div").role).to be_nil
    end

    it "resolves none as nil" do
      render %(<div role="none" aria-label="Name">contents</div>)
      expect(find(:element, "div").role).to be_nil
    end

    it "resolves generic as nil" do
      render %(<div role="generic" aria-label="Name">contents</div>)
      expect(find(:element, "div").role).to be_nil
    end

    %w[atomic braillelabel brailleroledescription busy controls current describedby description details dropeffect
       flowto grabbed keyshortcuts label labelledby live owns relevant roledescription].each do |attribute|
      it "ignores none if aria-#{attribute} is present" do
        render <<~HTML
          <ul role="none" aria-#{attribute}=""><li>item</li></ul>
        HTML
        expect(find(:element, "ul").role).to eq "list"
      end

      it "ignores presentation if aria-#{attribute} is present" do
        render <<~HTML
          <ul role="presentation" aria-#{attribute}=""><li>item</li></ul>
        HTML
        expect(find(:element, "ul").role).to eq "list"
      end
    end

    it "resolves img as image" do
      render %(<div role="img" aria-label="Name">contents</div>)
      expect(find(:element, "div").role).to eq "image"
    end

    it "resolves directory as list" do
      render %(<div role="directory" aria-label="Name">contents</div>)
      expect(find(:element, "div").role).to eq "list"
    end

    %w[button checkbox gridcell link menuitem menuitemcheckbox menuitemradio option progressbar radio scrollbar searchbox
       separator slider spinbutton switch tab tabpanel textbox treeitem combobox grid listbox menu menubar
       radiogroup tablist tree treegrid application article blockquote caption cell code columnheader
       comment definition deletion document emphasis feed figure group heading image insertion
       list listitem mark math meter note paragraph row rowgroup rowheader
       separator strong subscript suggestion superscript table term time toolbar tooltip banner complementary
       contentinfo form main navigation region search alert log marquee status timer alertdialog dialog].each do |role|
      it "supports role #{role}" do
        render %(<div role="#{role}" aria-label="Name">contents</div>)
        expect(find(:element, "div").role).to eq role
      end
    end
  end

  describe "hidden element" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <ul hidden><li>item</li></ul>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div role="list" hidden><div data-test-id="test" role="listitem">item</div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <input hidden>
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end
  end

  describe "hidden parent" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <div hidden><ul><li>item</li></ul></div>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div hidden><div role="list"><div data-test-id="test" role="listitem">item</div></div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <div hidden><input></div>
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end
  end

  describe "inert element" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <ul inert><li>item</li></ul>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div role="list" inert><div data-test-id="test" role="listitem">item</div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <input inert>
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end
  end

  describe "inert parent" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <div inert><ul><li>item</li></ul></div>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div inert><div role="list"><div data-test-id="test" role="listitem">item</div></div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <div inert><input></div>
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end
  end

  describe "accessible hidden elements" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <ul aria-hidden="true"><li>item</li></ul>
      HTML
      expect(find(:element, "ul").role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div role="list" aria-hidden="true"><div data-test-id="test" role="listitem">item</div></div>
      HTML
      expect(find(:test_id, "test").role).to be_nil
    end

    it "does not return nil for focusable elements" do
      render <<~HTML
        <input aria-hidden="true">
      HTML
      expect(find(:element, "input").role).to eq "textbox"
    end
  end

  describe "accessible hidden parent" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <div aria-hidden="true"><ul><li>item</li></ul></div>
      HTML
      expect(find(:element, "ul").role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div aria-hidden="true"><div role="list"><div data-test-id="test" role="listitem">item</div></div></div>
      HTML
      expect(find(:test_id, "test").role).to be_nil
    end

    it "does not return nil for focusable elements" do
      render <<~HTML
        <div aria-hidden="true"><input></div>
      HTML
      expect(find(:element, "input").role).to eq "textbox"
    end
  end

  describe "display none element" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <ul style="display: none"><li>item</li></ul>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div role="list" style="display: none"><div data-test-id="test" role="listitem">item</div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <input style="display: none">
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end
  end

  describe "display none parent" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <div style="display: none"><ul><li>item</li></ul></div>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div style="display: none"><div role="list"><div data-test-id="test" role="listitem">item</div></div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <div style="display: none"><input></div>
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end
  end

  describe "visibility hidden element" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <ul style="visibility: hidden"><li>item</li></ul>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div role="list" style="visibility: hidden"><div data-test-id="test" role="listitem">item</div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <input style="visibility: hidden">
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end
  end

  describe "visibility hidden parent" do
    it "returns nil for implicit roles" do
      render <<~HTML
        <div style="visibility: hidden"><ul><li>item</li></ul></div>
      HTML
      expect(find(:element, "ul", visible: false).role).to be_nil
    end

    it "returns nil for explicit roles" do
      render <<~HTML
        <div style="visibility: hidden"><div role="list"><div data-test-id="test" role="listitem">item</div></div></div>
      HTML
      expect(find(:test_id, "test", visible: false).role).to be_nil
    end

    it "returns nil for focusable elements" do
      render <<~HTML
        <div style="visibility: hidden"><input></div>
      HTML
      expect(find(:element, "input", visible: false).role).to be_nil
    end

    it "returns if visibility is overridden" do
      render <<~HTML
        <div style="visibility: hidden"><input style="visibility: visible"></div>
      HTML
      expect(find(:element, "input", visible: false).role).to eq "textbox"
    end

    it "returns if visibility is overridden on a parent" do
      render <<~HTML
        <div style="visibility: hidden"><div style="visibility: visible"><input></div></div>
      HTML
      expect(find(:element, "input", visible: false).role).to eq "textbox"
    end
  end

  describe "name from author" do
    context "with the region role" do
      it "returns region with an accessible name" do
        render <<~HTML
          <div role="region" aria-label="name">Contents</div>
        HTML
        expect(find(:element, "div").role).to eq "region"
      end

      it "returns nil without an accessible name" do
        render <<~HTML
          <div role="region">Contents</div>
        HTML
        expect(find(:element, "div").role).to be_nil
      end

      it "fallbacks to another role without an accessible name" do
        render <<~HTML
          <div role="region navigation">Contents</div>
        HTML
        expect(find(:element, "div").role).to eq "navigation"
      end

      it "fallbacks to an implicit role without an accessible name" do
        render <<~HTML
          <article role="region">Contents</article>
        HTML
        expect(find(:element, "article").role).to eq "article"
      end
    end

    context "with the form role" do
      it "returns region with an accessible name" do
        render <<~HTML
          <div role="form" aria-label="name">Contents</div>
        HTML
        expect(find(:element, "div").role).to eq "form"
      end

      it "returns nil without an accessible name" do
        render <<~HTML
          <div role="form">Contents</div>
        HTML
        expect(find(:element, "div").role).to be_nil
      end

      it "fallbacks to another role without an accessible name" do
        render <<~HTML
          <div role="form navigation">Contents</div>
        HTML
        expect(find(:element, "div").role).to eq "navigation"
      end

      it "fallbacks to an implicit role without an accessible name" do
        render <<~HTML
          <article role="form">Contents</article>
        HTML
        expect(find(:element, "article").role).to eq "article"
      end
    end
  end
end
