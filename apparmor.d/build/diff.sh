#!/bin/bash
# SPDX-License-Identifier: 0BSD

set -e
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
while IFS='' read -r -d '' filename; do
	SOURCE=$filename
	INSTALLED="/etc/apparmor.d/${filename:2}"
	set +e
	diff "$SOURCE" "$INSTALLED" > /dev/null 2>&1
	[ 0 -eq $? ] || echo "$INSTALLED"; diff "$INSTALLED" "$SOURCE"; echo
	set -e
done < <(find . -type f ! -path './build/*' ! -path './debian/*' ! -name '*.swp' -print0)
