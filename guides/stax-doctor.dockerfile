FROM taras0mazepa/stax-guide-base:0.10.13

RUN <<EOF
git config --global --unset user.name
git config --global --unset user.email
git config --global --unset push.autoSetupRemote
EOF
