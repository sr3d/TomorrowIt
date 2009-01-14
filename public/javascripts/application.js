// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Element.addMethods( {
  insertWithoutEval: function( element, insertions ) {
    element = $(element);

    if (Object.isString(insertions) || Object.isNumber(insertions) ||
        Object.isElement(insertions) || (insertions && (insertions.toElement || insertions.toHTML)))
          insertions = {bottom:insertions};

    var content, insert, tagName, childNodes;

    for (var position in insertions) {
      content  = insertions[position];
      position = position.toLowerCase();
      insert = Element._insertionTranslations[position];

      if (content && content.toElement) content = content.toElement();
      if (Object.isElement(content)) {
        insert(element, content);
        continue;
      }

      content = Object.toHTML(content);

      tagName = ((position == 'before' || position == 'after')
        ? element.parentNode : element).tagName.toUpperCase();

      childNodes = Element._getContentFromAnonymousElement(tagName, content);

      if (position == 'top' || position == 'after') childNodes.reverse();
      childNodes.each(insert.curry(element));
    }

    return element;
  }
  
  ,getContainerByClassName: function( element, cssClass ) {
    return element.hasClassName( cssClass ) ? element : element.up( '.' + cssClass );
  }
} );

Array.prototype.compareTo = function( array ) {
  if( !array || array.length != this.length ) return -1;
  for( var i = 0, len = this.length; i < len; i++ )
  {
    if( this[ i ] != array[ i ] )
      return -1;
  }
  return 0;
}