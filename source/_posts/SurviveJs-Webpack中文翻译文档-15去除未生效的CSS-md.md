---
title: SurviveJs-Webpack中文翻译文档-15去除未生效的CSS.md
date: 2016-10-13 16:40:11
author: Bing
tags:
  - Webpack
  - 学习
  - SurviveJs
  - javascript
categories: []
---
# Eliminating Unused CSS

像Bootstrap这样的框架有很多的CSS。通常情况下你仅仅用到了其中的一部分，但却将其全部打包了，包括很多没有用到的CSS。我们可以去掉哪些我们没有用到的CSS。一个叫做 purifycss 的工具就可以很好的通过分析代码来帮助我们实现这个目的。

## 使用Purufycss
使用purifycss可以实现很大程度的精简。在实际中，有时甚至可以将Bootstrap从140kB减少40%到35kB。

```
npm i purefycss-webpack-plugin --save-dev
```
为了让我们的项目看起来更真实，我们将安装一个叫做Pure.css的库，并且在项目中使用它，以便我们可以看到purifycss的效果
```
npm i purrecss --save
```
配置文件中进行设置
```
...

const PATHS = {
  app: path.join(__dirname, 'app'),
leanpub-start-insert
  style: [
    path.join(__dirname, 'node_modules', 'purecss'),
    path.join(__dirname, 'app', 'main.css')
  ],
leanpub-end-insert
leanpub-start-delete
  style: path.join(__dirname, 'app', 'main.css'),
leanpub-end-delete
  build: path.join(__dirname, 'build')
};

...
```
由于我们路径的设置，我们并不需要太多的调整代码。现在当你执行`npm run build`，你将看到：
```
[webpack-validator] Config is valid.
clean-webpack-plugin: .../webpack-demo/build has been removed.
Hash: adc32c7f82a388002a6e
Version: webpack 1.13.0
Time: 3656ms
                               Asset       Size  Chunks             Chunk Names
     app.a51c1a5cde933b81dc3e.js.map    1.57 kB    0, 3  [emitted]  app
         app.a51c1a5cde933b81dc3e.js  252 bytes    0, 3  [emitted]  app
      vendor.6947db44af2e47a304eb.js    21.4 kB    2, 3  [emitted]  vendor
    manifest.86e8bb3f3a596746a1a6.js  846 bytes       3  [emitted]  manifest
      style.e6624bc802ded7753823.css    16.7 kB    1, 3  [emitted]  style
       style.e6624bc802ded7753823.js  156 bytes    1, 3  [emitted]  style
   style.e6624bc802ded7753823.js.map  834 bytes    1, 3  [emitted]  style
  style.e6624bc802ded7753823.css.map  107 bytes    1, 3  [emitted]  style
  vendor.6947db44af2e47a304eb.js.map     274 kB    2, 3  [emitted]  vendor
manifest.86e8bb3f3a596746a1a6.js.map    8.86 kB       3  [emitted]  manifest
                          index.html  402 bytes          [emitted]
   [0] ./app/index.js 100 bytes {0} [built]
   [0] multi vendor 28 bytes {2} [built]
   [0] multi style 40 bytes {1} [built]
  [32] ./app/component.js 136 bytes {0} [built]
    + 37 hidden modules
Child html-webpack-plugin for "index.html":
        + 3 hidden modules
Child extract-text-webpack-plugin:
        + 2 hidden modules
Child extract-text-webpack-plugin:
        + 2 hidden modules
```
我们发现，style.*************.css文件因为引入了新的库变大了，同时hash数也发生了更改。

为了让purifycss有更好的效果，但却不去掉整个pure.css库，我们需要在代码中使用pure.css，所以给component组件增加一个*className*:
**app/component.js**
```
module.exports = function () {
  var element = document.createElement('h1');

leanpub-start-insert
  element.className = 'pure-button';
leanpub-end-insert
  element.innerHTML = 'Hello world';

  return element;
};
```
现在启动项目*npm start*，之前的*hello world*就变成了一个按钮的样式。

我们现在需要对配置文件进行修改，使purifycss生效。先对*parts.js*进行扩展：
**libs/arts.js**
```
const webpack = require('webpack');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
leanpub-start-insert
const PurifyCSSPlugin = require('purifycss-webpack-plugin');
leanpub-end-insert

...

leanpub-start-insert
exports.purifyCSS = function(paths) {
  return {
    plugins: [
      new PurifyCSSPlugin({
        basePath: process.cwd(),
        // `paths` is used to point PurifyCSS to files not
        // visible to Webpack. You can pass glob patterns
        // to it.
        paths: paths
      }),
    ]
  }
}
leanpub-end-insert
```
然后在祝配置文件中引入这个配置函数。需要注意的是，这个插件需要放在*ExtractTextPlugin*，否则将不会生效：
**webpack.config.js**
```
...

// Detect how npm is run and branch based on that
switch(process.env.npm_lifecycle_event) {
  case 'build':
    config = merge(
      ...
      parts.minify(),
leanpub-start-insert
      parts.extractCSS(PATHS.style),
      parts.purifyCSS([PATHS.app])
leanpub-end-insert
leanpub-start-delete
      parts.extractCSS(PATHS.style)
leanpub-end-delete
    );
  default:
    ...

module.exports = validate(config);
```
Webpack能读懂*PATHS.app*,


























































