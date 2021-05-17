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

gitbook serve

