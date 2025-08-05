#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o noclobber
set -o nounset
#set -o xtrace #debug

# This script creates the necessary directory structure for LaTeX auxiliary files.
# It reads the auxiliary directory from latexmkrc or defaults to the current directory.
# It finds all directories containing .tex files and recreates them in the specified AUX_DIR.
# If AUX_DIR is empty or ".", it exits without creating any directories.
#
# This script works around an issue with latexmk when $emulate_aux=1, $aux_dir and $out_dir are
# set to different directories, and the main .tex file uses `include` to include other .tex files
# that live in a subdirectory. See: https://tex.stackexchange.com/a/323821/108670
#
#     ./dissertation.tex:32: I can't write on file `src/0000-title.aux'.
#     \@include ...mmediate \openout \@partaux "#1.aux" 
#                                                   \immediate \write \@partau...
#     l.32   \include{src/0000-title}
#
# Usage: ./create-build-dirs.sh
# or invoke the Makefile

# Get the AUX directory from latexmkrc or use default
AUX_DIR="."
if [ -f "latexmkrc" ]; then
    AUX_DIR=$(grep -o '\$aux_dir = "[^"]*"' latexmkrc | sed 's/\$aux_dir = "\(.*\)"/\1/')
fi

# If AUX_DIR is empty or ".", exit
if [ -z "$AUX_DIR" ] || [ "$AUX_DIR" = "." ]; then
    exit 1
fi

created_any=false

# Find directories containing .tex files and recreate them in AUX_DIR
find . -not -path '*/.*' -name "*.tex" -print0 | xargs -0 -I {} dirname {} | sort -u | while read -r dir; do
    # Skip if directory is current directory
    if [ "$dir" != "." ]; then
        target_dir="$AUX_DIR/$dir"
        if [ ! -d "$target_dir" ]; then
            if [ "$created_any" = false ]; then
                echo "Creating directory structure in: $AUX_DIR"
                # NOTE: created_any is set in the subprocess of the while loop
                #   so it won't affect the outer script's created_any variable.
                created_any=true
            fi
            echo "Creating: $target_dir"
            mkdir -p "$target_dir"
        fi
    fi
done
