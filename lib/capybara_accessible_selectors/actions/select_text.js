function setSelection() {
  var selection = window.getSelection();
  var range = document.createRange();
  var nodeIterator = document.createNodeIterator(arguments[0], NodeFilter.SHOW_TEXT);
  var text = arguments[1];
  var node;
  var currentIndex = 0;
  var data;
  var intersection;
  var remaining;
  var backtrace;

  function getIntersection(text, from) {
    var startIndex = 0;
    var len;
    outer: for (len = text.length; len > 0; --len) {
      while (true) {
        startIndex = from.indexOf(text.slice(0, len), startIndex);
        if (startIndex === -1) {
          startIndex = 0;
          continue outer;
        }
        if (len < text.length && startIndex + len < from.length) {
          // Incomplete match
          startIndex = startIndex + 1;
          continue;
        }
        return {
          text: text.slice(0, len),
          start: startIndex,
          end: startIndex + len,
          length: len,
        };
      }
    }
    return null;
  }

  while((node = nodeIterator.nextNode())) {
    data = node.data;
    if (!data) {
      continue;
    }

    remaining = text.slice(currentIndex);
    intersection = getIntersection(remaining, node.data);

    if (!intersection) {
      continue;
    }

    if (currentIndex === 0) {
      if (intersection.text === text) {
        // Contained in first text node
        range.setStart(node, intersection.start);
        range.setEnd(node, intersection.end);
        break;
      }
      if (intersection.end !== data.length) {
        // Not valid
        continue;
      }
      // Contains first part
      range.setStart(node, intersection.start);
      currentIndex = intersection.end;
      backtrace = node;
      continue;
    }

    if (intersection.start !== 0) {
      // Not valid - retry from current node
      currentIndex = 0;
      range = new Range();
      if (backtrace) {
        do {
          node = nodeIterator.previousNode();
        } while (node !== backtrace);
      }
      backtrace = null;
      continue;
    }

    if (remaining === intersection.text) {
      range.setEnd(node, intersection.end);
      break;
    }

    currentIndex += data.length;
  }
  selection.removeAllRanges();
  selection.addRange(range);
}
