#!/bin/bash
echo "#!/bin/bash" > plugin.sh
echo "(cd $(pwd) && export \$(cat .env) && $(which bundle) exec $(which ruby) app.rb)" >> plugin.sh
chmod +x plugin.sh
ln -s $(pwd)/plugin.sh ~/Library/Application\ Support/xbar/plugins/binance.10m.sh
