mkdir test_remote1 test_remote2 test_repo
cd test_remote1 && git init --bare && cd ..
cd test_remote2 && git init --bare && cd ..

cd test_repo
git init
git remote add origin ../test_remote1
git remote add myremote ../test_remote2
git commit --allow-empty -m "init"
git branch -M main
git -c push.autoSetupRemote=true push myremote
