#!/usr/bin/env python3
# -*- coding:utf-8 -*-
# Author: davie
 """
 2 、元组
 只读列表，只有count，index 2个方法
 作用：如果一些数据不想被人修改，可以存成元组，比如身份证列表
 3、字典
 key-value对
    1、特性：
    2、无序性
    3、去重
    4、查询速度快，比列表快多了
    5、比list占用内存多
    为什么会查询速度快呢？因为他是hash类型的，那什么是hash呢？
    哈希算法将任意长度的二进制值映射为较短的固定长度的二进制值，
    这个小的二进制值称为哈希值。哈希值是一段数据唯一且及其紧凑
    的数值表示形式。如果散列一段明文而且哪怕只要更改该段落的
    一个字母，随后的哈希都将产生不同的值。要找到散列为同一个值
    的两个不同的输入，字计算机上是不可能的，所以数据的哈希值
    可以检验数据的完整性。一般用于快速查找和加密算法
    
    dict会把所有的key变成hash表，然后将这个表进行排序，这样，
    你通过data[key]去查data字典中的一个key的时候，python会先把
    这个key hash成一个数字，然后拿着这个数字到hash表中看没有没
    这个数字，如果有，拿到这个key在hash表中的索引，拿到这个索引
    去与此key对应的value的内存地址那取值就可以了。
 """