# frozen_string_literal: true

describe "role selector" do
  let(:target) { find("[data-testid=target]", visible: :all) }

  describe "explicit roles" do
    it "finds explicit role with a symbol role" do
      render <<~HTML
        <span role="link" data-testid="target">Link</span>
      HTML

      expect(page.find(:role, :link)).to eq target
    end

    it "finds explicit role with a string role" do
      render <<~HTML
        <span role="link" data-testid="target">Link</span>
      HTML

      expect(page.find(:role, "link")).to eq target
    end

    it "finds explicit role with multiple roles as symbols" do
      render <<~HTML
        <span role="link" data-testid="target">Link</span>
      HTML

      expect(page.find(:role, %i[button link])).to eq target
    end

    it "finds explicit role with multiple roles as strings" do
      render <<~HTML
        <span role="link" data-testid="target">Link</span>
      HTML

      expect(page.find(:role, %w[button link])).to eq target
    end

    it "finds explicit valid fallback role" do
      render <<~HTML
        <span role="foo link" data-testid="target">Link</span>
      HTML

      expect(page.find(:role, :link)).to eq target
    end

    it "does not find invalid fallback role" do
      render <<~HTML
        <span role="button link">Link</span>
      HTML

      expect(page).to have_no_selector :role, :link
    end

    it "does not find implicit role when the role attribute is used" do
      render <<~HTML
        <a href="/foo" role="button">Link</a>
      HTML

      expect(page).to have_no_selector :role, :link
    end

    it "does not find a made up role" do
      render <<~HTML
        <div>foo</div>
      HTML

      expect(page).to have_no_selector :role, :foo
    end

    it "does not find an implicit role set to none" do
      render <<~HTML
        <aside role="none">foo</aside>
      HTML

      expect(page).to have_no_selector :role, :complementary
    end

    it "does not find an implicit role set to presentation" do
      render <<~HTML
        <aside role="presentation">foo</aside>
      HTML

      expect(page).to have_no_selector :role, :complementary
    end

    it "does find a focusable role set to none" do
      render <<~HTML
        <input role="none" data-testid="target" title="Foo">
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit role on custom element", skip_driver: :rack_test do
      visit "/element_internals.html"

      expect(page.find(:role, :textbox, custom_elements: "custom-role")).to eq page.find(:css, "custom-role[data-role=textbox]")
    end

    it "finds implicit role on custom element with an array", skip_driver: :rack_test do
      visit "/element_internals.html"

      expect(
        page.find(:role, :button, custom_elements: %w[custom-role custom-other])
      ).to eq page.find(:css, "custom-role[data-role=button]")
    end
  end

  describe "implicit roles" do
    it "finds implicit link on an <a>" do
      render <<~HTML
        <a>Not link</a>
        <a href="/foo" data-testid="target">Link</a>
      HTML

      expect(page.find(:role, :link)).to eq target
    end

    it "finds implicit group on an address" do
      render <<~HTML
        <address data-testid="target">29 Acacia Road</address>
      HTML

      expect(page.find(:role, :group)).to eq target
    end

    it "finds implicit link on an <area>", skip_driver: :safari do
      render <<~HTML
        <img usemap="#test" width="10" height="10" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
        <map name="test">
          <area href="/foo" alt="link" shape="rect" coords="1,1,5,5" data-testid="target" />
          <area alt="not link" coords="5,5,10,10" />
        </map>
      HTML

      expect(page.find(:role, :link)).to eq target
    end

    it "finds implicit article on an article" do
      render <<~HTML
        <article data-testid="target">Foo</article>
      HTML

      expect(page.find(:role, :article)).to eq target
    end

    it "finds implicit complementary on an aside" do
      render <<~HTML
        <aside data-testid="target">Foo</aside>
      HTML

      expect(page.find(:role, :complementary)).to eq target
    end

    it "finds implicit blockquote on a blockquote" do
      render <<~HTML
        <blockquote data-testid="target">Foo</blockquote>
      HTML

      expect(page.find(:role, :blockquote)).to eq target
    end

    it "finds implicit button on a button" do
      render <<~HTML
        <button data-testid="target">Foo</button>
      HTML

      expect(page.find(:role, :button)).to eq target
    end

    it "finds caption button on a caption" do
      render <<~HTML
        <table>
          <caption data-testid="target">Foo</caption>
          <tr>
            <th>One</th>
            <th>Two</th>
          </tr>
          <tr>
            <td>One</td>
            <td>Two</td>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :caption)).to eq target
    end

    it "finds implicit code on a code" do
      render <<~HTML
        <code data-testid="target">Foo</code>
      HTML

      expect(page.find(:role, :code)).to eq target
    end

    it "finds implicit deletion on a del" do
      render <<~HTML
        <del data-testid="target">Foo</del>
      HTML

      expect(page.find(:role, :deletion)).to eq target
    end

    it "finds implicit group on a details" do
      render <<~HTML
        <details data-testid="target">
          <summary>Heading</summary>
          Content
        </details>
      HTML

      expect(page.find(:role, :group)).to eq target
    end

    it "finds implicit term on a dfn" do
      render <<~HTML
        <dfn data-testid="target">Foo</dfn>
      HTML

      expect(page.find(:role, :term)).to eq target
    end

    it "finds implicit dialog on a dialog" do
      render <<~HTML
        <dialog data-testid="target" open>Foo</dialog>
      HTML

      expect(page.find(:role, :dialog)).to eq target
    end

    it "finds implicit emphasis on an em" do
      render <<~HTML
        <em data-testid="target">Foo</em>
      HTML

      expect(page.find(:role, :emphasis)).to eq target
    end

    it "finds implicit group on a fieldset" do
      render <<~HTML
        <fieldset data-testid="target">
          <caption>Foo</caption>
          Content
        </fieldset>
      HTML

      expect(page.find(:role, :group)).to eq target
    end

    it "finds implicit figure on a figure" do
      render <<~HTML
        <figure data-testid="target">Foo</figure>
      HTML

      expect(page.find(:role, :figure)).to eq target
    end

    it "finds implicit contentinfo on a footer" do
      render <<~HTML
        <footer data-testid="target">Foo</footer>
      HTML

      expect(page.find(:role, :contentinfo)).to eq target
    end

    it "does not find implicit contentinfo on a footer that is a child of a native sectioning element" do
      render <<~HTML
        <article>
          <footer>article</footer>
        </article>
        <aside>
          <footer>aside</footer>
        </aside>
        <main>
          <footer>main</footer>
        </main>
        <nav>
          <footer>nav</footer>
        </nav>
        <section>
          <footer>section</footer>
        </section>
      HTML

      expect(page).to have_no_selector :role, :contentinfo
    end

    it "does not find implicit contentinfo on a footer that is a child of a aria sectioning element" do
      render <<~HTML
        <div role="article">
          <footer>role article</footer>
        </div>
        <div role="complementary">
          <footer>role complementary</footer>
        </div>
        <div role="main">
          <footer>role main</footer>
        </div>
        <div role="navigation">
          <footer>role navigation</footer>
        </div>
        <div role="region">
          <footer>role region</footer>
        </div>
      HTML

      expect(page).to have_no_selector :role, :contentinfo
    end

    it "finds implicit form on a form" do
      render <<~HTML
        <form data-testid="target" aria-label="Label">Foo</form>
      HTML

      expect(page.find(:role, :form)).to eq target
    end

    it "finds implicit heading on a h1" do
      render <<~HTML
        <h1 data-testid="target" aria-label="Label">Foo</h1>
      HTML

      expect(page.find(:role, :heading)).to eq target
    end

    it "finds implicit heading on a h2" do
      render <<~HTML
        <h2 data-testid="target" aria-label="Label">Foo</h2>
      HTML

      expect(page.find(:role, :heading)).to eq target
    end

    it "finds implicit heading on a h3" do
      render <<~HTML
        <h3 data-testid="target" aria-label="Label">Foo</h3>
      HTML

      expect(page.find(:role, :heading)).to eq target
    end

    it "finds implicit heading on a h4" do
      render <<~HTML
        <h4 data-testid="target" aria-label="Label">Foo</h4>
      HTML

      expect(page.find(:role, :heading)).to eq target
    end

    it "finds implicit heading on a h5" do
      render <<~HTML
        <h5 data-testid="target" aria-label="Label">Foo</h5>
      HTML

      expect(page.find(:role, :heading)).to eq target
    end

    it "finds implicit heading on a h6" do
      render <<~HTML
        <h6 data-testid="target" aria-label="Label">Foo</h6>
      HTML

      expect(page.find(:role, :heading)).to eq target
    end

    it "finds implicit banner on a header" do
      render <<~HTML
        <header data-testid="target">Foo</header>
      HTML

      expect(page.find(:role, :banner)).to eq target
    end

    it "does not find implicit banner on a header that is a child of a native sectioning element" do
      render <<~HTML
        <article>
          <header>article</header>
        </article>
        <aside>
          <header>aside</header>
        </aside>
        <main>
          <header>main</header>
        </main>
        <nav>
          <header>nav</header>
        </nav>
        <section>
          <header>section</header>
        </section>
      HTML

      expect(page).to have_no_selector :role, :banner
    end

    it "does not find implicit banner on a header that is a child of a aria sectioning element" do
      render <<~HTML
        <div role="article">
          <header>role article</header>
        </div>
        <div role="complementary">
          <header>role complementary</header>
        </div>
        <div role="main">
          <header>role main</header>
        </div>
        <div role="navigation">
          <header>role navigation</header>
        </div>
        <div role="region">
          <header>role region</header>
        </div>
      HTML

      expect(page).to have_no_selector :role, :banner
    end

    it "finds implicit group on a hgroup" do
      render <<~HTML
        <hgroup data-testid="target">
          <h1>Main</h1>
          <h2>Sub</h2>
        </hgroup>
      HTML

      expect(page.find(:role, :group)).to eq target
    end

    it "finds implicit separator on a hr" do
      render <<~HTML
        <hr data-testid="target">
      HTML

      expect(page.find(:role, :separator)).to eq target
    end

    it "finds implicit img on an img" do
      render <<~HTML
        <img data-testid="target" width="10" height="10" alt="foo" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
      HTML

      expect(page.find(:role, :img)).to eq target
    end

    it "does not find implicit img on an img with an empty alt" do
      render <<~HTML
        <img data-testid="target" alt="" width="10" height="10" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
      HTML

      expect(page).to have_no_selector :role, :img
    end

    it "finds implicit image on an img" do
      render <<~HTML
        <img data-testid="target" width="10" height="10" alt="foo" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
      HTML

      expect(page.find(:role, :image)).to eq target
    end

    it "does not find implicit image on an img with an empty alt" do
      render <<~HTML
        <img data-testid="target" width="10" height="10" alt="" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
      HTML

      expect(page).to have_no_selector :role, :image
    end

    it "finds implicit textbox on an input with no type" do
      render <<~HTML
        <input data-testid="target" aria-label="foo">
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit combobox on an input with no type and a list", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" list="list" aria-label="foo">
        <datalist id="list">
          <option>One</option>
          <option>Two</option>
        </datalist>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit textbox on an input with an invalid type" do
      render <<~HTML
        <input data-testid="target" type="foo" aria-label="foo">
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit combobox on an input with an invalid type and a list", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" list="list" type="foo" aria-label="foo">
        <datalist id="list">
          <option>One</option>
          <option>Two</option>
        </datalist>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit button on an input type=button" do
      render <<~HTML
        <input data-testid="target" type="button" aria-label="foo">
      HTML

      expect(page.find(:role, :button)).to eq target
    end

    it "finds implicit checkbox on an input type=checkbox" do
      render <<~HTML
        <input data-testid="target" type="checkbox" aria-label="foo">
      HTML

      expect(page.find(:role, :checkbox)).to eq target
    end

    it "finds implicit textbox on an input type=email" do
      render <<~HTML
        <input data-testid="target" type="email" aria-label="foo">
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit combobox on an input type=email with a list", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" list="list" type="email" aria-label="foo">
        <datalist id="list">
          <option>One</option>
          <option>Two</option>
        </datalist>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit button on an input type=image" do
      render <<~HTML
        <input data-testid="target" type="image" aria-label="foo" width="10" height="10" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7">
      HTML

      expect(page.find(:role, :button)).to eq target
    end

    it "finds implicit spinbutton on an input type=number", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" type="number" aria-label="foo">
      HTML

      expect(page.find(:role, :spinbutton)).to eq target
    end

    it "finds implicit radio on an input type=radio" do
      render <<~HTML
        <input data-testid="target" type="radio" aria-label="foo">
      HTML

      expect(page.find(:role, :radio)).to eq target
    end

    it "finds implicit slider on an input type=range" do
      render <<~HTML
        <input data-testid="target" type="range" aria-label="foo">
      HTML

      expect(page.find(:role, :slider)).to eq target
    end

    it "finds implicit button on an input type=reset" do
      render <<~HTML
        <input data-testid="target" type="reset" aria-label="foo">
      HTML

      expect(page.find(:role, :button)).to eq target
    end

    it "finds implicit searchbox on an input type=search" do
      render <<~HTML
        <input data-testid="target" type="search" aria-label="foo">
      HTML

      expect(page.find(:role, :searchbox)).to eq target
    end

    it "finds implicit combobox on an input type=search with a list", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" list="list" type="search" aria-label="foo">
        <datalist id="list">
          <option>One</option>
          <option>Two</option>
        </datalist>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit button on an input type=submit" do
      render <<~HTML
        <input data-testid="target" type="submit" aria-label="foo">
      HTML

      expect(page.find(:role, :button)).to eq target
    end

    it "finds implicit textbox on an input type=tel" do
      render <<~HTML
        <input data-testid="target" type="tel" aria-label="foo">
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit combobox on an input type=tel with a list", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" list="list" type="tel" aria-label="foo">
        <datalist id="list">
          <option>One</option>
          <option>Two</option>
        </datalist>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit textbox on an input type=text" do
      render <<~HTML
        <input data-testid="target" type="text" aria-label="foo">
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit combobox on an input type=text with a list", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" list="list" type="text" aria-label="foo">
        <datalist id="list">
          <option>One</option>
          <option>Two</option>
        </datalist>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit textbox on an input type=url" do
      render <<~HTML
        <input data-testid="target" type="url" aria-label="foo">
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit combobox on an input type=url with a list", skip_driver: :safari do
      render <<~HTML
        <input data-testid="target" list="list" type="url" aria-label="foo">
        <datalist id="list">
          <option>One</option>
          <option>Two</option>
        </datalist>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit insertion on an ins" do
      render <<~HTML
        <ins data-testid="target">Foo</ins>
      HTML

      expect(page.find(:role, :insertion)).to eq target
    end

    it "finds implicit listitem on an li that is child of an ol" do
      render <<~HTML
        <ol>
          <li data-testid="target">Foo</li>
        </ol>
      HTML

      expect(page.find(:role, :listitem)).to eq target
    end

    it "finds implicit listitem on an li that is child of an ul" do
      render <<~HTML
        <ul>
          <li data-testid="target">Foo</li>
        </ul>
      HTML

      expect(page.find(:role, :listitem)).to eq target
    end

    it "finds implicit listitem on an li that is child of a menu" do
      render <<~HTML
        <menu>
          <li data-testid="target">Foo</li>
        </menu>
      HTML

      expect(page.find(:role, :listitem)).to eq target
    end

    it "does not find implicit listitem on an li that is not a child of a list" do
      render <<~HTML
        <li>Foo</li>
      HTML

      expect(page).to have_no_selector :role, :listitem
    end

    it "does not find implicit listitem on an li that is not an immediate child of a list" do
      render <<~HTML
        <ul>
          <div>
            <li>Foo</li>
          </div>
        </ul>
      HTML

      expect(page).to have_no_selector :role, :listitem
    end

    it "does not find implicit listitem on an li that is a child of a list with no role", skip_driver: :safari do
      render <<~HTML
        <ul role="none">
          <li>Foo</li>
        </ul>
      HTML

      expect(page).to have_no_selector :role, :listitem
    end

    it "finds implicit main on a main" do
      render <<~HTML
        <main data-testid="target">Foo</main>
      HTML

      expect(page.find(:role, :main)).to eq target
    end

    it "finds implicit math on a math" do
      render <<~HTML
        <math data-testid="target">
          <mfrac>
            <mn>1</mn>
            <msqrt>
              <mn>2</mn>
            </msqrt>
          </mfrac>
        </math>
      HTML

      expect(page.find(:role, :math)).to eq target
    end

    it "finds implicit list on a menu" do
      render <<~HTML
        <menu data-testid="target">Foo</menu>
      HTML

      expect(page.find(:role, :list)).to eq target
    end

    it "finds implicit meter on a meter" do
      render <<~HTML
        <meter data-testid="target">Foo</meter>
      HTML

      expect(page.find(:role, :meter)).to eq target
    end

    it "finds implicit nav on a navigation" do
      render <<~HTML
        <nav data-testid="target">Foo</nav>
      HTML

      expect(page.find(:role, :navigation)).to eq target
    end

    it "finds implicit list on an ol" do
      render <<~HTML
        <ol data-testid="target">Foo</ol>
      HTML

      expect(page.find(:role, :list)).to eq target
    end

    it "finds implicit group on an optgroup", skip_driver: :safari do
      render <<~HTML
        <select>
          <optgroup data-testid="target" label="Foo">
            <option>One</option>
            <option>Two</option>
          </optgroup>
        </select>
      HTML

      expect(page.find(:role, :group)).to eq target
    end

    it "finds implicit option on an option in a select" do
      render <<~HTML
        <select>
          <option data-testid="target">Foo</option>
        </select>
      HTML

      expect(page.find(:role, :option)).to eq target
    end

    it "finds implicit option on an option in a select and optgroup" do
      render <<~HTML
        <select>
          <optgroup label="Foo">
            <option data-testid="target">One</option>
          </optgroup>
        </select>
      HTML

      expect(page.find(:role, :option)).to eq target
    end

    it "finds implicit option on an option in a select with junk html" do
      render <<~HTML
        <select>
          <div>
            <option data-testid="target">One</option>
          </div>
        </select>
      HTML

      expect(page.find(:role, :option)).to eq target
    end

    it "does not find an implicit option not in a list" do
      render <<~HTML
        <option>One</option>
      HTML

      expect(page).to have_no_selector :role, :option
    end

    it "finds implicit status on an output" do
      render <<~HTML
        <output data-testid="target">Foo</output>
      HTML

      expect(page.find(:role, :status)).to eq target
    end

    it "finds implicit paragraph on a p" do
      render <<~HTML
        <p data-testid="target">Foo</p>
      HTML

      expect(page.find(:role, :paragraph)).to eq target
    end

    it "finds implicit progressbar on a progress" do
      render <<~HTML
        <progress data-testid="target">Foo</progress>
      HTML

      expect(page.find(:role, :progressbar)).to eq target
    end

    it "finds implicit deletion on a s" do
      render <<~HTML
        <s data-testid="target">Foo</s>
      HTML

      expect(page.find(:role, :deletion)).to eq target
    end

    it "finds implicit search on a search" do
      render <<~HTML
        <search data-testid="target">Foo</search>
      HTML

      expect(page.find(:role, :search)).to eq target
    end

    it "finds implicit region on a section with a name" do
      render <<~HTML
        <section data-testid="target" aria-label="Label">Foo</section>
      HTML

      expect(page.find(:role, :region)).to eq target
    end

    it "does not find an implicit region on a section with no name" do
      render <<~HTML
        <section data-testid="target">Foo</section>
      HTML

      expect(page).to have_no_selector :role, :region
    end

    it "finds implicit combobox on a select", skip_driver: :safari do
      render <<~HTML
        <select data-testid="target">
          <option>One</option>
          <option>Two</option>
        </select>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit combobox on a select with size=1", skip_driver: :safari do
      render <<~HTML
        <select data-testid="target" size=1>
          <option>One</option>
          <option>Two</option>
        </select>
      HTML

      expect(page.find(:role, :combobox)).to eq target
    end

    it "finds implicit listbox on a select with a multiple attribute" do
      render <<~HTML
        <select data-testid="target" multiple>
          <option>One</option>
          <option>Two</option>
        </select>
      HTML

      expect(page.find(:role, :listbox)).to eq target
    end

    it "finds implicit listbox on a select with a size attribute of 2" do
      render <<~HTML
        <select data-testid="target" size=2>
          <option>One</option>
          <option>Two</option>
        </select>
      HTML

      expect(page.find(:role, :listbox)).to eq target
    end

    it "finds implicit strong on a strong" do
      render <<~HTML
        <strong data-testid="target">Foo</strong>
      HTML

      expect(page.find(:role, :strong)).to eq target
    end

    it "finds implicit subscript on a sub" do
      render <<~HTML
        <sub data-testid="target">Foo</sub>
      HTML

      expect(page.find(:role, :subscript)).to eq target
    end

    it "finds implicit superscript on a sup" do
      render <<~HTML
        <sup data-testid="target">Foo</sup>
      HTML

      expect(page.find(:role, :superscript)).to eq target
    end

    it "finds implicit image on a svg" do
      render <<~HTML
        <svg data-testid="target"><title>Foo</title><rect width="100%" height="100%" fill="red" /></svg>
      HTML

      expect(page.find(:role, :image)).to eq target
    end

    it "finds implicit img on a svg" do
      render <<~HTML
        <svg data-testid="target"><title>Foo</title><rect width="100%" height="100%" fill="red" /></svg>
      HTML

      expect(page.find(:role, :img)).to eq target
    end

    it "finds implicit graphics-document on a svg" do
      render <<~HTML
        <svg data-testid="target"><title>Foo</title><rect width="100%" height="100%" fill="red" /></svg>
      HTML

      expect(page.find(:role, :"graphics-document")).to eq target
    end

    it "finds implicit table on a table" do
      render <<~HTML
        <table data-testid="target">
          <caption>Foo</caption>
          <thead>
            <tr>
              <th>One</th>
              <th>Two</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>One</td>
              <td>Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :table)).to eq target
    end

    it "finds implicit cell on a td" do
      render <<~HTML
        <table>
          <thead>
            <tr>
              <th>One</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td data-testid="target">Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :cell)).to eq target
    end

    it "does not find implicit cell on a td that is on an unexposed table" do
      render <<~HTML
        <table role="none">
          <thead>
            <tr>
              <th>One</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td data-testid="target">Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page).to have_no_selector :role, :cell
    end

    it "finds implicit gridcell on a td with a table with role grid" do
      render <<~HTML
        <table role="grid">
          <caption>Foo</caption>
          <thead>
            <tr>
              <th>One</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td data-testid="target">Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :gridcell)).to eq target
    end

    it "finds implicit gridcell on a td with a table with role treegrid", skip_driver: :selenium do
      render <<~HTML
        <table role="treegrid">
          <caption>Foo</caption>
          <thead>
            <tr>
              <th>One</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td data-testid="target">Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :gridcell)).to eq target
    end

    it "finds implicit textbox on a textarea" do
      render <<~HTML
        <textarea data-testid="target">Foo</textarea>
      HTML

      expect(page.find(:role, :textbox)).to eq target
    end

    it "finds implicit rowgroup on a tbody", skip_driver: :safari do
      render <<~HTML
        <table>
          <caption>Foo</caption>
          <tbody data-testid="target" aria-label="foo">
            <tr>
              <th>One</th>
              <th>Two</th>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :rowgroup)).to eq target
    end

    it "finds implicit rowgroup on a tfoot", skip_driver: :safari do
      render <<~HTML
        <table>
          <caption>Foo</caption>
          <tbody>
            <tr>
              <th>One</th>
              <th>Two</th>
            </tr>
          </tbody>
          <tfoot data-testid="target" aria-label="foo">
            <tr>
              <td>One</td>
              <td>Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :rowgroup)).to eq target
    end

    it "finds implicit columnheader on a th with a table" do
      render <<~HTML
        <table>
          <caption>Foo</caption>
          <thead>
            <tr>
              <th data-testid="target">One</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :columnheader)).to eq target
    end

    it "finds implicit columnheader on a th with a table with grid role" do
      render <<~HTML
        <table role="grid">
          <caption>Foo</caption>
          <thead>
            <tr>
              <th data-testid="target">One</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :columnheader)).to eq target
    end

    it "finds implicit columnheader on a th with a table with treegrid role" do
      render <<~HTML
        <table role="treegrid">
          <caption>Foo</caption>
          <thead>
            <tr>
              <th data-testid="target">One</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :columnheader)).to eq target
    end

    it "finds implicit rowheader on a th with scope row" do
      render <<~HTML
        <table>
          <caption>Foo</caption>
          <tr>
            <th scope="row" data-testid="target">One</th>
            <td>Two</th>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :rowheader)).to eq target
    end

    it "finds implicit rowheader on a th with scope row in a table with grid role" do
      render <<~HTML
        <table role="grid">
          <tr>
            <th scope="row" data-testid="target">One</th>
            <td>Two</th>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :rowheader)).to eq target
    end

    it "finds implicit rowheader on a th with scope row in a table with treegrid role" do
      render <<~HTML
        <table role="treegrid">
          <tr>
            <th scope="row" data-testid="target">One</th>
            <td>Two</th>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :rowheader)).to eq target
    end

    it "finds implicit rowheader on a th with scope rowgroup" do
      render <<~HTML
        <table>
          <caption>Foo</caption>
          <tr>
            <th scope="rowgroup" data-testid="target">One</th>
            <td>Two</th>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :rowheader)).to eq target
    end

    it "finds implicit rowheader on a th with scope rowgroup in a table with grid role" do
      render <<~HTML
        <table role="grid">
          <tr>
            <th scope="rowgroup" data-testid="target">One</th>
            <td>Two</th>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :rowheader)).to eq target
    end

    it "finds implicit rowheader on a th with scope rowgroup in a table with treegrid role" do
      render <<~HTML
        <table role="treegrid">
          <tr>
            <th scope="rowgroup" data-testid="target">One</th>
            <td>Two</th>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :rowheader)).to eq target
    end

    it "finds implicit rowgroup on a thead", skip_driver: :safari do
      render <<~HTML
        <table>
          <thead data-testid="target" aria-label="foo">
            <tr>
              <th>One</th>
              <th>Two</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>One</td>
              <td>Two</td>
            </tr>
          </tbody>
        </table>
      HTML

      expect(page.find(:role, :rowgroup)).to eq target
    end

    it "finds implicit time on a time" do
      render <<~HTML
        <time data-testid="target">xxx</time>
      HTML

      expect(page.find(:role, :time)).to eq target
    end

    it "finds implicit row on a tr" do
      render <<~HTML
        <table>
          <tr data-testid="target">
            <th>One</th>
            <th>Two</th>
          </tr>
          <tr>
            <td>One</td>
            <td>Two</td>
          </tr>
        </table>
      HTML

      expect(page.find(:role, :row, match: :first)).to eq target
    end

    it "finds implicit list on a ul" do
      render <<~HTML
        <ul data-testid="target">Foo</ul>
      HTML

      expect(page.find(:role, :list)).to eq target
    end
  end

  describe "within_role" do
    it "limits to within a role" do
      render <<~HTML
        <dialog data-testid="target" open>Foo</dialog>
      HTML

      within_role :dialog do
        expect(page).to have_text "Foo", exact: true
      end
    end
  end
end
