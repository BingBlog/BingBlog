

rm -rf ../BingBlog.github.io/*

cp -rf public/* ../BingBlog.github.io/

cd ../BingBlog.github.io/
git add --all
git commit -a -m "提交代码"

git push

