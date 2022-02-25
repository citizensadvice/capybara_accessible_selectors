# frozen_string_literal: true

module CapybaraAccessibleSelectors
  OBSERVE_SCRIPT = <<~OBSERVE
    const key = Symbol.for('capybara-live-message-tracking');
    const map = window[key] = window[key] || new WeakMap();
    const el = this;
    const messages = [];
    const handler = (mutations) => {
      mutations.forEach((mutation) => {
        let node = mutation.target;
        if (node.nodeType === Node.TEXT_NODE) {
          node = node.parentNode;
        }
        const atomic = node.closest('[aria-atomic=true],[role=status]:not([aria-atomic=false]),[role=alert]:not([aria-atomic=false])');
        if (atomic && node.contains(atomic)) {
          node = atomic;
        }
        messages.push(node.textContent);
      });
    };
    const observer = new MutationObserver(handler);
    observer.observe(this, { childList: true, subtree: true, characterData: true });
    map.set(this, { observer, messages, handler })
  OBSERVE

  COLLECT_SCRIPT = <<~COLLECT
    const key = Symbol.for('capybara-live-message-tracking');
    const map = window[key];
    if (!map || !map.has(this)) {
      return [];
    }
    const { observer, messages, handler } = map.get(this);
    handler(observer.takeRecords());
    observer.disconnect();
    return messages;
  COLLECT

  Capybara.add_selector(:live_region) do
    xpath do |*|
      XPath.descendant[[
        *%w[log status alert progressbar marquee timer].map { |role| XPath.attribute(:role) == role },
        XPath.attribute(:"aria-live") == "passive",
        XPath.attribute(:"aria-live") == "assertive"
      ].reduce(:|)]
    end

    expression_filter(:live_type, valid_values: [String, Symbol]) do |xpath, value|
      conditions = [XPath.attribute(:"aria-live") == value.to_s]
      role = { "assertive" => "alert", "polite" => "status" }[value]
      conditions << ((!XPath.attribute(:"aria-live")) & XPath.attribute(:role) == role) if role
      xpath[conditions.reduce(:&)]
    end
  end

  module Actions
    def live_messages(visible: :all, **options)
      find_all(:live_message, visible:, **options).each { |el| el.execute_script(OBSERVE_SCRIPT) }
      yield
      find_all(:live_message, visible:, **options).flat_map { |el| el.execute_script(COLLECT_SCRIPT) }
    end
  end
end
