#!/bin/sh

FILE="$1"

if test -z "$STREAM_LEN"
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
		echo "error file not recognized: <$OUT>"
		exit 1
		;;
esac

if test -z "$STREAM_COUNT"
then STREAM_COUNT=$((OUT_SIZE / STREAM_LEN))
fi

if test -z "$OUTPUT_DIRECTORY"
then OUTPUT_DIRECTORY=.
else
	mkdir -p "$OUTPUT_DIRECTORY"
	cp -r $(ls) "$OUTPUT_DIRECTORY"
	cd "$OUTPUT_DIRECTORY"
	make directories --always-make --keep-going
fi

echo "STREAM_LEN: $STREAM_LEN"
echo "STREAM_COUNT:  $STREAM_COUNT"
echo "LEFT OUT:  $((OUT_SIZE - STREAM_COUNT * STREAM_LEN))"
echo "OUTPUT_DIRECTORY:  $OUTPUT_DIRECTORY"

printf "0\n$FILE\n1\n0\n$STREAM_COUNT\n$TYPE_SWITCH" | \
	./assess "$STREAM_LEN"

echo
echo "FAILS:"
scripts/show-fails.sh
echo

FAILS=$(scripts/number-of-fails.sh)
TOTAL=$(scripts/total-test-count.sh)
FRAC=$(echo | awk "{ print ($FAILS / $TOTAL) * 100 }")
echo "NUMBER OF FAILS: $FRAC%"

