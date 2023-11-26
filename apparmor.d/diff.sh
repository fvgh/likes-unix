#!/bin/bash
# SPDX-License-Identifier: 0BSD
set -e
pushd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null
while IFS='' read -r -d '' filename; do
	SOURCE=$filename
	INSTALLED="/etc/apparmor.d/${filename:2}"
	if [ -f "$SOURCE" ] && [ -f "$INSTALLED" ]; then
		set +e
		diff -q "$SOURCE" "$INSTALLED" > /dev/null 2>&1
		if [ 0 -ne $? ]; then
			echo "$INSTALLED"
			diff "$INSTALLED" "$SOURCE"
			echo
		fi
		set -e
	fi
done < <(find . -type f -print0)
