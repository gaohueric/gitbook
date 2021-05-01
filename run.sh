#!/bin/bash



# 增加到git
git commit --amend -m"fix"

# 安装插件，发布
gitbook init
gitbook build

#gitbook serve

# 推送到远程
git add .
git commit -m"first commit"
git push -f

# 准备发布

git branch -D gh-pages
git checkout -b gh-pages

git add .
git commit -m"first depoy"
git push -f  --set-upstream origin gh-pages

git checkout main
