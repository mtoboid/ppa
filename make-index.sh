#!/bin/bash
#
# Create an index for the ppa
#
# Show structure with tree
# Remove links from directories and files that are no packages

set -o errexit
set -o nounset

SCRIPT_DIR=$( cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
GITHUB_PAGES_ROOT='https://mtoboid.github.io/ppa'

# generate index
#
main() {
    cd "${SCRIPT_DIR}"
    tree -H "${GITHUB_PAGES_ROOT}" -T "PPA mtoboid" -I "*.html|_*|*.sh" --prune --noreport --charset utf-8 -o index.html

    # remove links
    #
    # 1) mask .deb packages
    sed -E -i 's/<a href=(".+\.deb")>(.*)<\/a>/<@@=\1@@\2>/g' index.html

    # 2) remove links
    sed -E -i 's/<a href=(".+")>(.*)<\/a>/\2/g' index.html

    # 3) re-instate .deb package links
    sed -E -i 's/<@@=(.*)@@([^>]*)>/<a href=\1>\2<\/a>/g' index.html

    echo "Created new index at $(pwd)/index.html."
    exit 0
}

main "$@"
