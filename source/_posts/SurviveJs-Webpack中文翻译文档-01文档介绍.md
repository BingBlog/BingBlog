title: SurviveJs-Webpack中文翻译文档-01文档介绍
author: Bing
tags:
  - 学习
  - SurviveJs
  - Webpack
  - javascript
categories: []
date: 2016-10-13 14:53:00
---
# Introduction

对于Web开发来说，Webpack 解决了一个最基本的问题－应用打包，进而简化了开发过程。Webpack可以对各类资源进行处理，例如JavaScript,CSS和HTML，将它们转化成浏览器可以低消耗处理的格式。解决了这个问题，也就让Web开发不在那么痛苦。。。

但是由于它复杂的配置驱动方法，Webpack并不是容易掌握的工具。本教程的目的就是帮助你开始学习Webpack，并且超越基础！

## Webpack是个啥玩意儿？

Web浏览器可以处理HTML,JavaScript和CSS。最简单的开发方式就是编写出浏览器直接处理的文件。但问题是，开发的应用最终变得笨重。在进行Web应用开发的时候我们也总会遇到这个问题。

最原始的方式是将JavaScript代码都打包成一个文件然后浏览器仅加载一次。但是这还不够。你将会再次将文件拆分以便利于缓存。你甚至需要根据需求通过动态的依赖来加载各个模块儿。作为一个程序员，处理这个问题变得越来越复杂。

Webpack就是用来解决这个问题的。它解决了前面所描述的所有问题。当然你也可以使用其它的工具，也可以达到相同的结果，很多情况下，也完全满足需要。任务管理，例如Grunt和Gulp，但是需要你手写很多配置文件。


### Webpack如何解决了这些问题咧？
Webpack采用了另外一种方式。它让你将你的项目视为一个依赖关系图。你可以在项目中的index.js文件中通过使用标准的`import`语法来加载所有依赖，这些依赖包括样式文件和其它资源。

Webpack完成了所有的预处理然后生成了打包后的文件，当然，需要你来配置如何进行预处理。这些配置的声明方式很强大，但是也有一点儿难学。不过，只要你理解了Webpack的工作原理，它便会成为一个不可却少的工具。这本书就是让你越过最开始的那个小山坡。

## 我能学到啥子？
这本书是对*[Webpack的官方文档](https://webpack.github.io/docs/)*的补充。尽管官方文档包含了很多资料，对于刚开始学习这个工具的开发者来说，它可能不是最简单的起步点。俗话说，“万事开头难”，这本书也许可以让你开始学习时不那么痛苦，如果你是有一定基础的使用者，本书也会让你温故而知新。

您将学会开发一个基本的Webpack配置工具，可以分别达到开发和生产的目的。你也会学习很多先进的技术，是你从Webpack强大的功能中获益匪浅。

## 这本书咋组织的？
本书的前两章分别想你介绍了Webpack的基本概念。你将会根据你的特定需求开发一个基本的可扩展的配置工具。接下来的章节都是以任务为主线的，如果你忘了具体的Webpack实现方法，你可以参考这些内容。

剩下的部分是一些先进技术的讨论。你将会学习：加载特定类型的资源，你也可以根据自己对Webpack分块机制的理解，学习利用这些进行包创作，编写自己的加载器。

## 这书写给那个看的撒？

希望你对JavaScrpt和Node.js有基本的掌握。对npm的使用水平也到了初级阶段。如果你对Webpack有一些了解，那就太棒了。读完此书，将会加强你对这些工具的理解。

如果你是Webpack老手，你也能学到一些东西。浏览本书，你也会找到一些技术。我竭尽全力to cover even some of the knottier parts of the tool.

如果你仍然有困惑，可以尝试从本书的社区中寻找帮助。如果你卡住了或者有些地方理解不了，我们可以提供帮助。你的任评价都将会使本书的质量得到提升。

## 这本书咋读？
如果你不是很了解Webpack,建议仔细阅读前两章。后面的可以浏览下，先看感兴趣的部分。如果你已经对Webpack有一定了解，涉猎并选择你觉得有价值的技术点进行学习。

## 咋这多版本？
由于本书不断创新的步伐，并经过很多修补和改进，所以有很多个版本。我通过本书[官方博客](http://survivejs.com/blog/)对新老版本信息进行发布，版本信心会告诉你各个版本的差异。通过Githun仓库检测也是一个很好的方法。推荐使用Github对比工具。例如：
```
https://github.com/survivejs/webpack/compare/v1.2.0...v1.3.3
```
在浏览器中输入改地址，页面会向你展示两个版本的提交信息。虽然包含了私有章节，但是也足以让你了解本书主要的改动。

本书当前的本书是1.3.3

本书是一项持续性的工作，非常欢迎通过各种渠道进行反馈。我将会基于需求来扩展本教程，使其可以更好的惠及你我他。你也可以为本书贡献出你的更改和源代码。

本书的部分利润将会用于工具自身的开发。

## 得到支持
“人无完人”，对于书中内容，你可能会有一些问题。可以通过下面的方式进行反馈：
－通过  *[GitHub Issue Tracker](https://github.com/survivejs/webpack/issues)*联系原作者
－关注推特官方账号 *[@survivejs](https://twitter.com/survivejs)*或者直接联系作者*[@bebraw](https://twitter.com/survivejs)*
－给原作者发邮件*[info@survivejs.com](http://info@survivejs.com)*
－直接向作者提关于Webpack和React的问题：*[SurviveJS AmA](https://github.com/survivejs/ama/issues)*

在Stack Overflow上提问请用survivejs标记，我将会注意到。推特上，也可用#survivejs。


## 信息发布
我将通过一下频道发布SurviveJs的信息
－*[Mailing list](http://eepurl.com/bth1v5)*
－*[Twitter](https://twitter.com/survivejs)*
－*[Blog RSS](http://survivejs.com/atom.xml)*

欢迎订阅






























