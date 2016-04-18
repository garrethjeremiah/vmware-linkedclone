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
  exit 1
fi

echo "Moving \"${SRC}\" to \"${BASE}/${N}\""
#mkdir "${BASE}/${N}"
mv "${SRC}" "${BASE}/"

TEMPL="${BASE}/${N}/_TMPL_"
rm -rf "${TEMPL}"
mkdir "${TEMPL}"

# VMDK-Delta
VMDKD=$(ls -1 "${BASE}/${N}" |grep "\-000[0-9]\+\-delta.vmdk" | tail -n 1)
#echo cp "${BASE}/${N}/${VMDKD}" "${TEMPL}/"
cp "${BASE}/${N}/${VMDKD}" "${TEMPL}/"

# VMDK
VMDK=$(ls -1 "${BASE}/${N}" |grep "\-000[0-9]\+.vmdk" | tail -n 1)
#echo cp "${BASE}/${N}/${VMDK}" "${TEMPL}/"
cp "${BASE}/${N}/${VMDK}" "${TEMPL}/"
F=$(grep "^parentFileNameHint=" "${TEMPL}/${VMDK}" |awk -F\" '{print $2}')
sed -i '/parentFileNameHint=/d' "${TEMPL}/${VMDK}"
echo parentFileNameHint=\"${BASE}/${N}/${F}\" >> "${TEMPL}/${VMDK}"

# VMX
VMX=$(ls -1 "${BASE}/${N}" |grep ".vmx$" | tail -n 1)
#echo cp "${BASE}/${N}/${VMX}" "${TEMPL}/"
cp "${BASE}/${N}/${VMX}" "${TEMPL}/"
sed -i '/sched.swap.derivedName/d' "${TEMPL}/${VMX}"

exit 0;


