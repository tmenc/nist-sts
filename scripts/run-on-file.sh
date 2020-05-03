#! /usr/bin/env bash

FILE="$1"

if [ -z "$STREAM_LEN" ]
then STREAM_LEN=$((50 * 1000))
fi

CHECKER=scripts/file-is-ascii.exe
OUT=$("$CHECKER" "$FILE")
OUT_TYPE=$(echo "$OUT" | head -n 1)
OUT_SIZE=$(echo "$OUT" | tail -n 1)
TYPE_SWITCH=dunno

case "$OUT_TYPE" in
	yes)
		echo "File recognized as ASCII with size = $OUT_SIZE"
		TYPE_SWITCH=0
		;;
	no)
		echo "File recognized as BINARY with size = $OUT_SIZE"
		TYPE_SWITCH=1
		;;
	*)
		echo "error file not recognized"
		echo "$OUT"
		exit 1
		;;
esac

if [ -z "$STREAM_COUNT" ]
then STREAM_COUNT=$((OUT_SIZE / STREAM_LEN))
fi

echo "STREAM LENGTH: $STREAM_LEN"
echo "STREAM COUNT:  $STREAM_COUNT"
echo "LEFT OUT:  $((OUT_SIZE - STREAM_COUNT * STREAM_LEN))"

printf "0\n$FILE\n1\n0\n$STREAM_COUNT\n$TYPE_SWITCH" | \
	./assess "$STREAM_LEN"

echo
echo "FAILS:"
scripts/show-fails.sh
echo

FAILS=$(scripts/number-of-fails.sh)
TOTAL=$(scripts/total-test-count.sh)
FRAC=$(echo "3k $FAILS $TOTAL / 100 * p" | dc)
echo "NUMBER OF FAILS: $FRAC%"

