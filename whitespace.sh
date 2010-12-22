#!/bin/bash

find \( -name \*.as -o -name \*.mxml \) -print0 | xargs -0 sed -i -r -e 's/\t/    /g' -e 's/\s+$//'
