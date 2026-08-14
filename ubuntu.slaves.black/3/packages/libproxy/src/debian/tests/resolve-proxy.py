#!/usr/bin/python3
# Copyright 2020 Simon McVittie
# SPDX-License-Identifier: LGPL-2.1+

import libproxy
import sys

if __name__ == '__main__':
    factory = libproxy.ProxyFactory()

    for url in sys.argv[1:]:
        print(' '.join(factory.getProxies(url)))
