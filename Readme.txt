g++ test.cpp -o test

g++ demo.c sqlite3.o -lpthread -ldl -o demo

swiftc -g -import-objc-header sqltest-Bridging-Header.h main.swift sqlite3.o -lpthread -ldl -o sqltest