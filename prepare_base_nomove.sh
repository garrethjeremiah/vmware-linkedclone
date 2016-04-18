#!/bin/sh

# we will take a VM you have built 
# move it to the BASE folder
# create a _TEMPL_ folder for the link_clone.sh

BASE=/vmfs/volumes/vm/BASE
SRC="$1"
N=$(basename "${SRC}")

if [ "x${1}x" == "xx" ]; then
  echo Usage: $0 /path/to/source/image
  exit 1
fi

CT=$(find "$SRC" | grep 000001\.vmdk >/dev/null 2>&1 && echo 1 || echo 0)
if [ $CT -eq 0 ]; then
  echo "No Snapshot taken...cancelling"
  exit 0
fi

mkdir "${BASE}/${N}" 2>/dev/null

TEMPL="${BASE}/${N}/_TMPL_"
rm -rf "${TEMPL}"
mkdir "${TEMPL}"

# VMDK-Delta
VMDKD=$(ls -1 "${SRC}" |grep "\-000[0-9]\+\-delta.vmdk" | tail -n 1)
cp "${SRC}/${VMDKD}" "${TEMPL}/"

# VMDK
VMDK=$(ls -1 "${SRC}" |grep "\-000[0-9]\+.vmdk" | tail -n 1)
cp "${SRC}/${VMDK}" "${TEMPL}/"
F=$(grep "^parentFileNameHint=" "${TEMPL}/${VMDK}" |awk -F\" '{print $2}')
sed -i '/parentFileNameHint=/d' "${TEMPL}/${VMDK}"
echo parentFileNameHint=\"${SRC}/${F}\" >> "${TEMPL}/${VMDK}"

# VMX
VMX=$(ls -1 "${SRC}" |grep ".vmx$" | tail -n 1)
cp "${SRC}/${VMX}" "${TEMPL}/"
sed -i '/sched.swap.derivedName/d' "${TEMPL}/${VMX}"

exit 0;


