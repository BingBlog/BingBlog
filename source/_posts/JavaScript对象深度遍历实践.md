title: JavaScript对象深度遍历实践
author: Bing
tags:
  - 学习
  - JavaScript
categories: []
date: 2017-01-09 22:41:00
---
# 需求场景
在JavaScript中经常对象(数组)进行遍历并操作。如何对对象或者数组进行深度遍历操作。例如对以下数据结构进行过滤，属性中含有id, 且id值不在所给定的数组中的都需要被过滤掉。

```
var obj = {
        id:10, 
        list:[
            {
                id:1,
                list:[
                    {
                        id:2,
                        list:[
                            {
                                id:3,
                                list:[
                                    {
                                        id:4
                                    }
                                ]
                            }
                        ]
                    }
                ]
            },
            {
                id:21,
                list:[
                    {
                        id:22,
                        list:[
                            {
                                id:23,
                                list:[
                                    {
                                        id:24
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        ]
    };

    var activeArray = [10, 1, 2, 21, 22];
```
需要根据activeArray中的数据对obj进行过滤，所有对象属性不在数组中的都要被去掉。

# 方法一 JSON.stringify 和 JSON.parse
我们先是有一个对象，可以对这个对象进行stringify操作，并传入操作函数作为第二个参数，对数据进行过滤。然后将过滤后的参数psrse得到新的对象。
```
    //过滤操作函数
    function resolve(key,value){
        if( Object.prototype.toString.call(value) === '[object Object]'){
            if( $.inArray(value.id, activeArray) > -1 ){
                return value;
            }else{
                return undefined;
            }
        }else{
            return value;
        }
    }
```
//方法一
```
    var str = JSON.stringify(obj, resolve, 4);
    console.log(str);
/**
{
    "id": 10,
    "list": [
        {
            "id": 1,
            "list": [
                {
                    "id": 2,
                    "list": [
                        null
                    ]
                }
            ]
        },
        {
            "id": 21,
            "list": [
                {
                    "id": 22,
                    "list": [
                        null
                    ]
                }
            ]
        }
    ]
}
**/
    console.log(JSON.parse(str));//得到object过滤后的object对象。
```

![](leanote://file/getImage?fileId=58b0154fab644107b2000e13)
但是仔细看数组的处理就有问题了，数组有长度但没有元素，我们拿到的数据是有问题的数据。

# 方法二 自定义递归函数

```
// 方法二
function ObjectEachDeep(object, reviver) {
            function walk(holder, key) {
                var k;
                var v;
                var value = holder[key];
                //对数组和对象进行遍历
                //对象
                if (value && Object.prototype.toString.call(value) === '[object Object]') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            //递归调用
                            v = walk(value, k);
                            if (v !== undefined) {
                                //写回值
                                value[k] = v;
                            } else {
                                //对象删除
                                delete value[k];
                            }
                        }
                    }
                //数组
                }else if(Object.prototype.toString.call(value) === '[object Array]'){
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            //递归调用
                            v = walk(value, k);
                            if (v !== undefined) {
                                //写回值
                                value[k] = v;
                            } else {
                                //数组删除
                                value.splice(k);
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }

            return (typeof reviver === "function")
                ? walk({"": object}, "")
                : object;
        };



    var  result = ObjectEachDeep(obj, resolve);

    console.log(JSON.stringify(result, null, 4));
/**
{
    "id": 10,
    "list": [
        {
            "id": 1,
            "list": [
                {
                    "id": 2,
                    "list": []
                }
            ]
        },
        {
            "id": 21,
            "list": [
                {
                    "id": 22,
                    "list": []
                }
            ]
        }
    ]
}
**/
    console.log(result);
![](leanote://file/getImage?fileId=58b01651ab644107b2000e21)
```

//函数结构优化
```
 //优化后
 function ObjectEachDeep(object, reviver) {
            function walk(holder, key) {
                var k;
                var v;
                var value = holder[key];
                if (value && typeof value == "object") {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                if(Object.prototype.toString.call(value) === '[object Object]'){
                                    delete value[k];
                                }else if(Object.prototype.toString.call(value) === '[object Array]'){
                                    value.splice(k);
                                }
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }

            return (typeof reviver === "function")
                ? walk({"": object}, "")
                : object;
        };
```





