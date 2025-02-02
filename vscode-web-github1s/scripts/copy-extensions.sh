#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${0}")/.."
APP_ROOT=$(pwd)
function ensureBuiltinExtensitions() {
	cd "${APP_ROOT}/lib/vscode"
	EXTENSIONS_DIRTY=0 && git diff --exit-code --name-only extensions || EXTENSIONS_DIRTY=$?
	if [ $EXTENSIONS_DIRTY != 0 ] || [ ! -e "extensions/emmet/dist/browser" ]
	then
		echo "compile vscode builtin extensions..."
		yarn gulp compile-web
		yarn gulp compile-extension-media
	else
		echo "vscode builtin extensions is up-to-date, skip compiling."
	fi
}

function main() {
	ensureBuiltinExtensitions
	cd ${APP_ROOT}
	mkdir -p "dist/extensions"
	node scripts/copy-extensions.js

	echo "copy vscode builtin extensions done!"
}

main "$@"

