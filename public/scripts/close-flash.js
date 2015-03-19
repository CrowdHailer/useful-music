var $$ = document.querySelectorAll

  var flash = document.querySelectorAll('.flash')
  function getClosest(el, tag) {
    // this is necessary since nodeName is always in upper case
    tag = tag.toUpperCase();
    do {
      if (el.nodeName === tag) {
        // tag name is found! let's return it. :)
        return el;
      }
    } while (el = el.parentNode);

    // not found :(
    return null;
  }

  function slideUp(evt){
    getClosest(evt.target, 'div').classList.add('read');
  }
  flash[0].addEventListener("click", slideUp);
  flash[1].addEventListener("click", slideUp);
