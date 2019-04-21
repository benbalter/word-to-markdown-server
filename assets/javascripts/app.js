//= require jquery
//= require zeroclipboard

// Select text
// Source: http://stackoverflow.com/questions/985272/jquery-selecting-text-in-an-element-akin-to-highlighting-with-your-mouse
jQuery.fn.selectText = function() {
  var doc, element, range, selection;
  doc = document;
  element = this[0];
  range = void 0;
  selection = void 0;
  if (doc.body.createTextRange) {
    range = document.body.createTextRange();
    range.moveToElementText(element);
    return range.select();
  } else if (window.getSelection) {
    selection = window.getSelection();
    range = document.createRange();
    range.selectNodeContents(element);
    selection.removeAllRanges();
    return selection.addRange(range);
  }
};

$(function() {
  $("#doc").change(function() {
    return $("#submit").click();
  });
  return $(".md-preview").click(function() {
    return $(".md-preview").selectText();
  });
});
