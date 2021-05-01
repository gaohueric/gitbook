#!/bin/bash
touch .gitignore

echo "
run.sh
# gitbook 相关文件 #
_book
# OS generated files #
######################
.DS_Store*
ehthumbs.db
Icon?
Thumbs.db
*.icloud

# Prerequisites
*.d

# Compiled Object files
*.slo
*.lo
*.o
*.obj

# Precompiled Headers
*.gch
*.pch

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Fortran module files
*.mod
*.smod

# Compiled Static libraries
*.lai
*.la
*.a
*.lib

# Executables
*.exe
*.out
*.app" > .gitignore


# 增加到git
git add .gitignore
git commit --amend -m"fox"

# 安装插件，发布
gitbook init
gitbook build

#gitbook serve

# 推送到远程
git add .
git commit -m"first commit"
git push -f

# 准备发布
mv ./_book /tmp/

git branch -D gh-pages
git checkout -b gh-pages
ls | xargs rm -rf
mv /tmp/_book ./
mv ./_book/* ./
rm -rf _book

git add .
git commit -m"first depoy"
git push -f  --set-upstream origin gh-pages

git checkout main
