#! /usr/bin/env python
#-*- coding: utf8 -*-

m = {"0":"0000","1":"0001","2":"0010","3":"0011","4":"0100",
    "5":"0101","6":"0110","7":"0111","8":"1000","9":"1001",
    "A":"1010","B":"1011","C":"1100","D":"1101","E":"1110",
    "F":"1111"}

f = open("output_real.dat")
for i in range (0, 16):
    n = f.readline()
    tmp = ""
    for j in range (2, 6):
        tmp += m[n[j]]
    # print tmp
    d = 0.0
    g = 0.5
    for j in range(1, 16):
        if tmp[j] == "1":
            d += g
        g /= 2
    if tmp[0] == "1":
        d -= 1
    print d
