#!/bin/bash

set -e
set -x

if [ "$#" -ne 1 ]
then
    echo "syntax:  note-genesis.sh filename.json"
    exit 1
fi

if [ ! -e "$1" ]
then
    echo "cannot find specified snapshot file"
    exit 1
fi

BASE_FN=$( python3 -c 'import os; import sys; print(os.path.splitext(sys.argv[1])[0])' "$1")
BASE_EXT=$(python3 -c 'import os; import sys; print(os.path.splitext(sys.argv[1])[1])' "$1")

S1="$BASE_FN-s1$BASE_EXT"
S2="$BASE_FN-s2$BASE_EXT"
S3="$BASE_FN-s3$BASE_EXT"
S4="$BASE_FN-s4$BASE_EXT"
S5="$BASE_FN-s5$BASE_EXT"
S6="$BASE_FN-s6$BASE_EXT"
S7="$BASE_FN-s7$BASE_EXT"
S8="$BASE_FN-s8$BASE_EXT"
S9="$BASE_FN-s9$BASE_EXT"

PREFIXED="$BASE_FN-100-prefixed$BASE_EXT"
PYF="$BASE_FN-150-pyf$BASE_EXT"
NONOTE="$BASE_FN-200-nonote$BASE_EXT"
NOBITS="$BASE_FN-250-nobits$BASE_EXT"
UPGRADED="$BASE_FN-300-upgraded$BASE_EXT"
INITPATCHED="$BASE_FN-350-init-patched$BASE_EXT"
PARAMPATCHED="$BASE_FN-400-param-patched$BASE_EXT"
FINAL="$BASE_FN-999-final$BASE_EXT"
programs/genesis_util/python_format.py "$BASE_FN$BASE_EXT" "$PYF"
ALLSYMS=$(echo "BTS" ; cat "$PYF" | grep '"symbol":' | grep -v '"NOTE"' | cut -d '"' -f 4 | tr '\n' ' ')
cat "$PYF" \
| programs/genesis_util/remove.py -p -a $ALLSYMS                                                        \
| tee "$S1" \
| programs/genesis_util/apply_patch.py -p -d libraries/note-genesis/no-accounts.json                    \
| tee "$S2" \
| programs/genesis_util/sort_objects.py -p                                                              \
| tee "$S3" \
| programs/genesis_util/apply_patch.py -p -d libraries/note-genesis/init-patch.json                     \
| tee "$S4" \
| programs/genesis_util/change_key_prefix.py -p -f "BTS" -t "MUSE"                                      \
| tee "$S5" \
| programs/genesis_util/change_asset_symbol.py -p -f "NOTE" -t "MUSE"                                   \
| tee "$S6" \
| programs/genesis_util/apply_patch.py -p -d libraries/note-genesis/genesis-accounts-patch.json         \
| tee "$S7" \
| programs/genesis_util/apply_patch.py -p -d libraries/note-genesis/genesis-balances-patch.json         \
| tee "$S8" \
| programs/genesis_util/apply_patch.py -p -d libraries/note-genesis/param-patch.json                    \
| tee "$S9" \
> "$PARAMPATCHED"
programs/genesis_util/canonical_format.py "$PARAMPATCHED" "$FINAL"
