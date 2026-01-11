#!/bin/bash

hugo 

git add *
git commit -m "add md file"

git push -u origin main 

