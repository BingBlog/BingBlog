title: CSS常用的经典布局
author: Bing
tags:
  - 学习
  - css
  - 布局
categories: []
date: 2017-02-04 22:41:00
---

# CSS常用的经典布局

CSS常用的经典布局包括:

 1. 水平、垂直、水平垂直居中
 2. 一列定宽一列自适应布局
 3. 两列定宽一列自适应布局
 4. 两侧定宽中间自适应三列布局

## 水平、垂直、水平垂直居中

### 水平居中
水平居中这个问题首先要搞清楚存在两个条件才能够称之为水平居中，即父元素必须是块级盒子容器，父元素宽度必须已经被设定好，在这两个前提下我们来看水平居中问题。

场景1：子元素是块级元素且宽度没有设定
在这种情况下，实际上也不存在水平居中一说，因为子元素是块级元素没有设定宽度，那么它会充满整个父级元素的宽度，即在水平位置上宽度和父元素一致

html代码:
```
<div class="wrap">
   <div class="non-child">
      non-child
   </div>
</div>
```

```
.wrap{
          width: 300px;
          height: 200px;
          border: 2px solid #ccc;
          box-sizing: border-box;

      }
        .non-child{
            border: 1px solid #000;
            background: green;

        }
```

场景2：子元素是行内元素，子元素宽度是由其内容撑开的

这种情况下解决方案是给父元素设定`text-align:center;`
html代码：
```
<div class="wrap center">
    <span class="span">1111</span>
</div>
```
css代码

```
.wrap{
        width: 300px;
        height: 200px;
        border: 2px solid #ccc;
        box-sizing: border-box;
}
.span{
        background: red;
}
.center{
        text-align: center;
}
```

场景3 子元素是块级元素且宽度已经设定

这种情形存在多种解法，下面一一来列举

解法1：给子元素添加`margin:0 auto;`

HTML代码
```
<div class="wrap">
    <div class="child auto">
        non-child
    </div>
</div>
```
css代码：
```
.child{
        width: 100px;
        height: 100px;
        background: green;
        box-sizing: border-box;
}
.auto{
        margin:0 auto;
}
.wrap{
        width: 300px;
        height: 200px;
        border: 2px solid #ccc;
        box-sizing: border-box;
  }
```


解法2：通过计算指定父元素的`padding-left`或`padding-right`

HTML代码
```
<div class="wrap padding">
    <div class="child ">
        non-child
    </div>
</div>
```
css代码：
```
.child{
        width: 100px;
        height: 100px;
        background: green;
        box-sizing: border-box;
}
.padding{
        padding-left: 100px;
}
.wrap{
        width: 300px;
        height: 200px;
        border: 2px solid #ccc;
        box-sizing: border-box;
}
```
结果同上，这里计算父元素`padding-left`或padding-right的方法为(父元素宽度-子元素宽度)/2,注意这里为了计算方便给父元素和子元素都设定了`box-sizing:border-box`,这样设定的宽度就是包含`border+padding+content`整个宽度来计算的，如果不设定`box-sizing:border-box`，浏览器默认是认为`content-box`,所以设定的宽度仅包含`content`的宽度，在这种情况下，计算父容器的`padding-left`或`padding-right`的方式就是[（父容器content宽度+左右border宽度）-(子容器content宽+水平padding宽+左右border宽)]/2,可以看到较为麻烦，所以这里建议让父元素和子元素都采取`border-box`.

解法3：计算得到子元素的`margin-left`或`margin-right`

html代码
```
<div class="wrap">
    <div class="child margin">
        non-child
    </div>
</div>
```
css代码
```
.child{
        width: 100px;
        height: 100px;
        background: green;
        box-sizing: border-box;
}
.margin{
        margin-left:100px;
}
.wrap{
        width: 300px;
        height: 200px;
        border: 2px solid #ccc;
        box-sizing: border-box;
}
```
这里计算子元素`margin-left`或`margin-right`的方法同上。

解法4：通过子元素相对父元素绝对定位

html代码
```
<div class="relative">
    <div class="child absolute">
        non-child
    </div>
</div>
```
css代码
```
.relative{
            width: 300px;
            height: 200px;
            border: 2px solid #ccc;
            box-sizing: border-box;
            position: relative;
        }
.absolute{
            position: absolute;
            left:50%;
            margin-left:-50px;
}
.child{
            width: 100px;
            height: 100px;
            background: green;
            box-sizing: border-box;
    }
```
结果同上，这里还要设定子元素`margin-top`为`-50`是需要消除父元素50%造成的偏移

解法5：利用flex-box
```
<div class="flex">
    <div class="child ">
        non-child
    </div>
</div>
```
css代码
```
.flex{
        width: 300px;
        height: 200px;
        border: 2px solid #ccc;
        box-sizing: border-box;
        display:flex;
        flex-direction: row;
        justify-content:center;
}
.child{
        width: 100px;
        height: 100px;
        background: green;
        box-sizing: border-box;
}
```

2.垂直居中

和水平居中一样，这里要讲垂直居中，首先设定两个条件即父元素是盒子容器且高度已经设定

场景1：子元素是行内元素，高度是由其内容撑开的

这种情况下，需要通过设定父元素的`line-height`为其高度来使得子元素垂直居中

html代码
```
<div class="wrap line-height">
    <span class="span">111111</span>
</div>
```
css代码
```
 .wrap{
        width:200px ;
        height: 300px;
        border: 2px solid #ccc;
        box-sizing: border-box;
    }
.span{
        background: red;
}
.line-height{
        line-height: 300px;
}
```

场景2：子元素是块级元素但是子元素高度没有设定，在这种情况下实际上是不知道子元素的高度的，无法通过计算得到`padding`或`margin`来调整，但是还是存在一些解法。

解法1：通过给父元素设定`display:table-cell;vertical-align:middle`来解决

html代码
```
<div class="wrap table-cell">
    <div class="non-height ">11111</div>
</div>
```
css代码
```
.table-cell{
            display: table-cell;
            vertical-align: middle;
        }
.non-height{
            background: green;
        }
.wrap{
            width:200px ;
            height: 300px;
            border: 2px solid #ccc;
            box-sizing: border-box;
        }
```

解法2：flexbox

html代码
```
<div class="wrap flex">
    <div class="non-height ">1111</div>
</div>
```
css代码
```
.wrap{
        width:200px ;
        height: 300px;
        border: 2px solid #ccc;
        box-sizing: border-box;
    }
.non-height{
        background: green;
    }
.flex{
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
```

场景3：子元素是块级元素且高度已经设定

解法1：

计算子元素的`margin-top`或`margin-bottom`，计算方法为父(元素高度-子元素高度)/2

html代码
```
<div class="wrap ">
    <div class="div1 margin">111111</div>
</div>
```
css代码
```
  .wrap{
            width:200px ;
            height: 300px;
            border: 2px solid #ccc;
            box-sizing: border-box;
        }
.div1{
            width:100px ;
            height: 100px;
            box-sizing: border-box;
            background: darkblue;
        }
        .margin{
          margin-top: 100px;
        }
```



解法2：计算父元素的`padding-top`或`padding-bottom`，计算方法为(父元素高度-子元素高度)/2

html代码
```
<div class="wrap  padding">
    <div class="div1 ">111111</div>
</div>
```
css代码
```
.wrap{
        width:200px ;
        height: 300px;
        border: 2px solid #ccc;
        box-sizing: border-box;
    }
.padding{
        padding-top: 100px;
    }
.div1{
        width:100px ;
        height: 100px;
        box-sizing: border-box;
        background: darkblue;
    }
```

解法3：利用绝对定位，让子元素相对于父元素绝对定位

html代码
```
<div class="wrap  relative">
    <div class="div1 absolute">111111</div>
</div>
```
css代码
```
.relative{
        position: relative;
    }
    .absolute{
        position: absolute;
        top:50%;
        margin-top: -50px;
    }
.wrap{
        width:200px ;
        height: 300px;
        border: 2px solid #ccc;
        box-sizing: border-box;
    }
.div1{
        width:100px ;
        height: 100px;
        box-sizing: border-box;
        background: darkblue;
    }
```

解法4：利用flexbox

html代码
```
<div class="wrap  flex">
    <div class="div1 ">111111</div>
</div>
```
css代码
```
.flex{
        display: flex;
        flex-direction: column;
        justify-content: center;
    }
.wrap{
        width:200px ;
        height: 300px;
        border: 2px solid #ccc;
        box-sizing: border-box;
    }
.div1{
        width:100px ;
        height: 100px;
        box-sizing: border-box;
        background: darkblue;
    }
```

即保证水平居中有保证垂直居中
情景一、如果元素宽高确定
```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSS水平垂直居中</title>
<style media="screen" type="text/css">
.box{
    position:absolute;
    top:50%;
    left:50%;
    margin:-100px 0 0 -100px;
    width:200px;
    height:200px;
    border:1px solid red;
}
</style>
</head>
<body>
    <div class="box">123412341241241234124</div>
</body>
</html>
```
情景二如果元素仅知道宽，不确定高
html代码
```
<div class="wrap table-cell">
    <div class="non-height ">11111</div>
</div>
```
css代码
```
.table-cell{
            display: table-cell;
            vertical-align: middle;
        }
.non-height{
            background: green;
        }
.wrap{
            width:200px ;
            height: 300px;
            border: 2px solid #ccc;
            box-sizing: border-box;
        }
```
## 两列布局
情景一、左列定宽，右列自适应
```
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	    <title>CSS布局</title>
        <style>
            body {
                background-color: #ffffff; 
                font-size:14px;
                }
            #hd, #ft {
                padding:20px 3px; 
                background-color: #cccccc; 
                text-align: center;
                border:solid 1px #e4e4e4;
                }
            /*对所有的类型都定义页面最小宽度为400px*/
            .bd-lft, .bd-rgt, .bd-3-lr, .bd-3-ll, .bd-3-rr {
                margin:10px 0; 
                min-width:400px;
                }
            .main {
                background-color: #03a9f4; 
                color:#ffffff;
                }
            .aside, .aside-1, .aside-2 {
                background-color: #00bcd4; 
                color:#ffffff;
                }
            p {
                margin:0; 
                padding:20px; 
                text-align: center;
                }
            /* 两列布局之 左侧栏固定宽度，右侧自适应 */
            .bd-lft{
                zoom:1;
                overflow:hidden;
                padding-left:210px;
            }
            .bd-lft .main{
                width:100%;
                float:left;
            }
            .bd-lft .aside{
                float:left;
                position:relative;
                left:-210px;
                margin-left:-100%;
                width:200px;
                _left: 0; /*IE6 hack*/
            }
            
        </style>
    </head>
    <body>
        <div id="hd">头部</div>
        <!--两列布局之 左侧栏固定宽度，右侧自适应-->
        <div class="bd-lft">
            <div class="main"><p>右边－自适应</p></div>
            <div class="aside"><p>左边固定宽度</p></div>
        </div>
        <div id="ft">底部</div>
    </body>
</html>
```

情景二、两列布局之左侧自适应，右侧固定宽度
```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>圣杯布局</title>
	<style type="text/css">
	body {
        background-color: #ffffff; 
        font-size:14px;
        }
	#hd, #ft {
        padding:20px 3px; 
        background-color: #cccccc; 
        text-align: center;
        }
	.bd-lft, .bd-rgt, .bd-3-lr, .bd-3-ll, .bd-3-rr {
        margin:10px 0; 
        min-width:400px;
        }
	.main {
        background-color: #03a9f4; 
        color:#ffffff;
        }
	.aside, .aside-1, .aside-2 {
        background-color: #00bcd4; 
        color:#ffffff;
        }
	p {
        margin:0; 
        padding:20px; 
        text-align: center;
        }
	/* 左侧栏固定宽度，右侧自适应 */
	.bd-lft {
	    zoom:1;
	    overflow:hidden;
	    padding-left:210px;
	}
	.bd-lft .aside {
	    float:left;
	    width:200px;
	    margin-left:-100%; /*= -100%*/
	    position:relative;
	    left:-210px; /* = -parantNode.paddingLeft */
	    _left: 0; /*IE6 hack*/
	}
	.bd-lft .main {
	    float:left;
	    width:100%;
	}


	/* 右侧栏固定宽度，左侧自适应 */
	.bd-rgt {
	    zoom:1;
	    overflow:hidden;
	    padding-right:210px;
	}
	.bd-rgt .aside {
	    float:left;
	    width:200px;
		margin-left:-200px; /* = -this.width */
	    position:relative;
	    right:-210px; /* = -parantNode.paddingRight */
	}
	.bd-rgt .main {
	    float:left;
	    width:100%;
	}


	/* 左中右 三栏自适应 */
	.bd-3-lr {
	    zoom:1;
	    overflow:hidden;
	    padding-left:210px;
	    padding-right:210px;
	}
	.bd-3-lr .main {
		float:left;
	    width:100%;
	}
	.bd-3-lr .aside-1 {
		float: left;
		width:200px;
		margin-left: -100%;

		position:relative;
		left: -210px;
		_left: 210px; /*IE6 hack*/
	}
	.bd-3-lr .aside-2 {
		float: left;
		width:200px;
		margin-left: -200px;

		position:relative;
		right: -210px;
	}

	/* 都在左边，右侧自适应 */
	.bd-3-ll {
	    zoom:1;
	    overflow:hidden;
	    padding-left:420px;
	}
	.bd-3-ll .main {
		float:left;
	    width:100%;
	}
	.bd-3-ll .aside-1 {
		float: left;
		width:200px;
		margin-left: -100%;

		position:relative;
		left: -420px;
		_left: 0px; /*IE6 hack*/
	}
	.bd-3-ll .aside-2 {
		float: left;
		width:200px;
		margin-left: -100%;

		position:relative;
		left: -210px;
		_left: 210px; /*IE6 hack*/
	}

	/* 都在右边，左侧自适应 */
	.bd-3-rr {
	    zoom:1;
	    overflow:hidden;
	    padding-right:420px;
	}
	.bd-3-rr .main {
		float:left;
	    width:100%;
	}
	.bd-3-rr .aside-1 {
		float: left;
		width:200px;
		margin-left: -200px;

		position:relative;
		right: -210px;
	}
	.bd-3-rr .aside-2 {
		float: left;
		width:200px;
		margin-left: -200px;

		position:relative;
		right: -420px;
	}
	</style>
</head>
<body>
	<div id="hd">头部</div>
	<div class="bd-lft">
		<div class="main">
			<p>主内容栏自适应宽度</p>
		</div>
		<div class="aside">
			<p>侧边栏固定宽度</p>
		</div>
	</div>


	<div class="bd-rgt">
		<div class="main">
			<p>主内容栏自适应宽度</p>
		</div>

		<div class="aside">
			<p>侧边栏固定宽度</p>
		</div>
	</div>

	<div class="bd-3-lr">
		<div class="main">
			<p>主内容栏自适应宽度</p>
		</div>

		<div class="aside-1">
			<p>侧边栏1固定宽度</p>
		</div>

		<div class="aside-2">
			<p>侧边栏2固定宽度</p>
		</div>
	</div>

	<div class="bd-3-ll">
		<div class="main">
			<p>主内容栏自适应宽度</p>
		</div>

		<div class="aside-1">
			<p>侧边栏1固定宽度</p>
		</div>

		<div class="aside-2">
			<p>侧边栏2固定宽度</p>
		</div>
	</div>

	<div class="bd-3-rr">
		<div class="main">
			<p>侧边栏2固定宽度侧边栏2固定宽度侧边栏2固定宽度</p>
		</div>

		<div class="aside-1">
			<p>侧边栏1固定宽度</p>
		</div>

		<div class="aside-2">
			<p>侧边栏2固定宽度</p>
		</div>
	</div>
	
	<div id="ft">底部</div>
</body>
</html>
```



##三列布局

见**圣杯布局详解（翻译）、双飞翼布局详解**
