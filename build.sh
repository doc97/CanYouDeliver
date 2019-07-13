#!/bin/sh

echo "Clean output directory..."
[ ! -d build/output ] && mkdir -p build/output
rm -R build/output/* 2>/dev/null

echo "Copying files..."
cp -R assets build/output/
cp -R game/ build/output/
cp -R lib/ build/output/
cp main.lua build/output/

echo "Done."
