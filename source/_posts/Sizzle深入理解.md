title: Sizzle深入理解
author: Bing
tags:
  - jQuery
  - JavaScript
  - Sizzle
  - 获取Dom元素
categories: []
date: 2017-06-14 22:41:00
---

> 本文内容主要“抄袭”与高云所著的《jQuery技术内幕》，算是我学习完Sizzle源码后的一点总结。本文依赖于jQuery-1.7.2，本文将忽略掉很多细节，着重从整体结构和思路讲解sizzle根据一个选择器进行dom元素匹配。

如何获取Dom元素？在不同的阶段，对其认识，理解都是完全不同的，它一直困扰着我，也一直提醒着我。它是前端开发的起点，也是前端开发的梦魇。虽然如今新框架让我们可以从中解放出来，但是能更高的理解它，仍对我意义重大。jQuery如何实现兼容各种浏览器的Dom元素查找器是我在前端开发的学习和工作中一直都在思考的问题。本文将简述jQuery的Sizzle，这个纯JavaScript实现的CSS选择器引擎。

在jQuery中，我们可以通过`$('#main')`、`$('#main .main-box')`、`$('#main .main-box p')`甚至于`$('#main .main-box p ul li:eq(2)')`、`$('#main .main-box p ul li:eq(2) input[name="key"]')`来查找Dom元素。Sizzle如何实现这些功能，而我们又将如何高效的使用这些功能，都需要我们深入源码，思考其工作原理。

# 先看入口
如下是jQuery的初始化方法：

```
jQuery.fn = jQuery.prototype = {
		constructor: jQuery,
		init: function( selector, context, rootjQuery ) {
      ...
      // The body element only exists once, optimize finding it
			if ( selector === "body" && !context && document.body ) {
				...
			}
      ...
			// Handle HTML strings
			if ( typeof selector === "string" ) {
				// Are we dealing with HTML string or an ID?
				if ( selector.charAt(0) === "<" && selector.charAt( selector.length - 1 ) === ">" && selector.length >= 3 ) {
          ...
				} else {
					match = quickExpr.exec( selector );
				}
				// Verify a match, and that no context was specified for #id
				if ( match && (match[1] || !context) ) {

					// HANDLE: $(html) -> $(array)
					if ( match[1] ) {
            ...
					// HANDLE: $("#id")
					} else {
						elem = document.getElementById( match[2] );

						// Check parentNode to catch when Blackberry 4.6 returns
						// nodes that are no longer in the document #6963
						if ( elem && elem.parentNode ) {
							// Handle the case where IE and Opera return items
							// by name instead of ID
							if ( elem.id !== match[2] ) {
								return rootjQuery.find( selector );
							}

							// Otherwise, we inject the element directly into the jQuery object
							this.length = 1;
							this[0] = elem;
						}

						this.context = document;
						this.selector = selector;
						return this;
					}
				// HANDLE: $(expr, $(...))
				} else if ( !context || context.jquery ) {
          ...
				// HANDLE: $(expr, context)
				// (which is just equivalent to: $(context).find(expr)
				} else {
					return this.constructor( context ).find( selector );
				}
			// HANDLE: $(function)
			// Shortcut for document ready
			} else if ( jQuery.isFunction( selector ) ) {
				...
			}

			if ( selector.selector !== undefined ) {
				this.selector = selector.selector;
				this.context = selector.context;
			}

			return jQuery.makeArray( selector, this );
		},
```
在jQuery的init方法中，根据输入参数的类型，来进行不同的处理。其中有几个地方是和Dom查找相关的。

## `selector === "body" && !context && document.body`
输入选择器为body时，且没有上下文时，直接获取body元素
```
if ( selector === "body" && !context && document.body ) {
  this.context = document; // 返回jQuery对象的上下文是document
  this[0] = document.body; // 返回jQuery对象的第一个元素是document.body
  this.selector = selector; // 返回jQuery对象的的选择器为入参selector，即'body'
  this.length = 1; // 返回jQuery对象的长度为1
  return this; // 返回jQuery对象
}
```

## typeof selector === "string"
如果输入选择器为非'body'的字符串，将首先看选择器是否是HTML代码或者为'#id'这样的ID选择器。这部分的关键地方在于用`quickExpr = /^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/`正则去匹配selector。它匹配一个类似HTML片段的字符串或者一个以#开头的字符串,请看如下例子：
```
|selector               | quickExpr.exec(selector)           |
|:----------------------|:-----------------------------------|
|'#target'              | ["#target", undefined, target]     |
|'<div>'                | ["<div>", "<div>", undefined]      |
|'div'                  | null                               |
|'<div><img></div>'     | ["<div><img></div>", "<div><img></div>", undefined]  |
```

需要考虑的是其中的'#target'这种情况。此时直接使用getElementById获取元素。

如果匹配失败则认为selector是选择器，调用jQuery的find方法来处理。
```
  // HANDLE: $(expr, $(...))
  } else if ( !context || context.jquery ) {
    ...
  // HANDLE: $(expr, context)
  // (which is just equivalent to: $(context).find(expr)
  } else {
    return this.constructor( context ).find( selector );
  }
```
而jQuery的find方法，就是sizzle。

## 先窥探一下Sizzle
首先看下sizzle这个函数:
```
var Sizzle = function( selector, context, results, seed ) {
	...
	return results;
};
```
省略调所有的函数内容，sizzle函数结构就变得很简单了。它接受选择器，上下文对象，结果集，过滤元素集合。都是对传入结果集的进一步筛选。

当sizzle接受到一个字符串后，将会对其进行类似如下的处理：
```
  var selector = '#main .head > p ul li:eq(3) , #main .head > p ul li:eq(5)';
  var chunker = /((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^\[\]]*\]|['"][^'"]*['"]|[^\[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?((?:.|\r|\n)*)/g;
  var m, set, extra,
  parts = [],
  soFar = selector;

  // Reset the position of the chunker regexp (start from head)
  do {
    chunker.exec( "" );
    m = chunker.exec( soFar );

    if ( m ) {
      soFar = m[3];

      parts.push( m[1] );

      if ( m[2] ) {
        extra = m[3];
        break;
      }
    }
  } while ( m );
  parts);
  extra);
```
如上代码执行完后，我们得到的parts和extra如下：
```
parts = ["#main", ".head", ">", "p", "ul", "li:eq(3)"];
extra = '#main .head > p ul li:eq(5)';
```

现在我明白sizzle的一个基本原理了，就是化繁为简。通过chunker这个复杂的正则表达式，将选择器拆分成数组。如果有extra，只需要在对其调用一次sizzle就可以了。

关于chunker这个正则表达式，后面再专门写一篇文章总结吧。

后面的篇幅重点分析，sizzle如何对这个包含各种单一选择器信息的数组进行处理，从而精确匹配到dom元素。在这个过程中，sizzle对性能、代码结构组织的考虑让我犹如进了大观园，惊奇巧妙可谓无处不在啊！

但是在进入这个过程前，我们还需要看一下sizzle的加速器。

# 利用浏览器原生API对查找过程进行加速








