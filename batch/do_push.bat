@echo off
git add kernels/ commit_msg.txt
git commit -F commit_msg.txt
git push
del commit_msg.txt
