default: build

compile:
	haxe build.hxml
	sed '1d' -i temp/main.js
	sed '1d' -i temp/main.js
	sed '1d' -i temp/main.js
	sed '1d' -i temp/main.js
	sed '$$d' -i temp/main.js
	sed '$$d' -i temp/main.js

build: compile
	mkdir -p build
	cat src/before.html > build/index.html
	cat temp/main.js >> build/index.html
	cat src/after.html >> build/index.html

retail: compile
	mkdir -p retail
	terser --compress unsafe_arrows=true,unsafe=true,toplevel=true,passes=8 --mangle --mangle-props --toplevel --ecma 6 -O ascii_only=true -- temp/main.js > temp/main.min.js
	regpack temp/main.min.js > temp/main.min.regpack.js
	cat src/before.html > retail/index.html
	cat temp/main.min.regpack.js >> retail/index.html
	cat src/after.html >> retail/index.html
	stat temp/main.min.regpack.js | grep Size

.PHONY: build retail
