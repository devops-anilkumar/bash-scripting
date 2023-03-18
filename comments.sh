#!/bin/bash

echo "demonstrate multi line commands"
<<comment
a=10
echo $a
echo "i am printing a value"
comment 