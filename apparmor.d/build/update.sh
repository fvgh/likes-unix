#!/bin/bash
# SPDX-License-Identifier: 0BSD

set -e
pushd "$(dirname "${BASH_SOURCE[0]}")/.." > /dev/null
while IFS='' read -r -d '' filename; do
	SOURCE=$filename
	INSTALLED="/etc/apparmor.d/${filename:2}"
	[ -f "$INSTALLED" ] && cp "$INSTALLED" "$SOURCE"
	set -e
done < <(find . -type f -print0)
