#!/bin/sh

# copy the $BASE/$1/_TEMPL_ to the target folder and register it

BASE=/vmfs/volumes/vm/BASE
SRC="$1"
TGT="$2"
NAM="$3"

if [ "x${3}x" == "xx" ]; then
  echo Usage:
  echo $0 '<src vm name> <target directory> <new vm name>'
  exit 0
fi

if [ ! -d "${TGT}" ]; then
  echo "Invalid base destination"
  exit 0
fi
if [ ! -d "${BASE}/${SRC}" ]; then
  echo "Invalid source VM name"
  exit 0
fi
if [ -e "${TGT}/${NAM}" ]; then
  echo "Target VM already exists"
  exit 0
fi

cp -a "${BASE}/${SRC}/_TMPL_" "${TGT}/${NAM}"

VMX=$(ls -1 "${TGT}/${NAM}" |grep ".vmx$" | tail -n 1)
sed -i '/^displayName/d' "${TGT}/${NAM}/${VMX}"
sed -i '/^uuid.action/d' "${TGT}/${NAM}/${VMX}"
echo displayName = \"${NAM}\" >> "${TGT}/${NAM}/${VMX}"
echo uuid.action = \"create\" >> "${TGT}/${NAM}/${VMX}"

echo Registering $NAM
vim-cmd solo/registervm "${TGT}/${NAM}/${VMX}"


