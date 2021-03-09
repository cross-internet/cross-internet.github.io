#!/bin/bash

set -e

[ -d template ] || git clone -n https://github.com/sveltejs/template.git
cd template

git switch -C web -f 8b23b3ff1879ca0442775a0ebf1defab72bbb79f
git clean -df

[ ! -f ../web.patch ] || git -c user.name='null' -c user.email='null@example.com' am --signoff ../web.patch

save() {
  git add -A
  ! git diff --cached --exit-code --stat || return 0
  git reset --soft 8b23b3ff1879ca0442775a0ebf1defab72bbb79f
  git commit -m 'UPDATE'
  git format-patch HEAD^ --stdout > ../web.patch
}

( while kill -0 $$ >/dev/null 2>&1; do save; sleep 1; done ) &

yarn install
yarn "$@"

save
