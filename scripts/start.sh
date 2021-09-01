#!/bin/env bash

bash `pwd`/scripts/archive_images.sh "${KUBE_VERSION}"

echo "[download packages]"

declare -A OS_INFO=(
  ["centos"]="7 8"
  ["debian"]="9 10"
  ["ubuntu"]="20.04 21.04"
)

OS_LIST="${!OS_INFO[@]}"

for key in ${!OS_INFO[@]}; do
  for release in ${OS_INFO[${key}]}; do
    os_dir="${KUBE_VERSION}/${KUBE_VERSION}_${key}${release}"
    packages_dir="${os_dir}/packages"
    [ ! -d ${packages_dir} ] && mkdir -pv ${packages_dir} || sudo rm -rfv ${packages_dir}/*
    docker run --rm --privileged -v `pwd`/${packages_dir}:/data:rw -v `pwd`/scripts:/scripts:rw ${key}:${release} /bin/bash -c "bash /scripts/archive_${key}.sh ${KUBE_VERSION}"
    cp -rf "${KUBE_VERSION}/bins" "${os_dir}/"
    cp -rf "${KUBE_VERSION}/images" "${os_dir}/"
    cp -rf "${KUBE_VERSION}/manifests" "${os_dir}/"
    
    echo "[Package file]"
    file_desc_dir="file_list/${KUBE_VERSION}"
    [ ! -d $file_desc_dir ] && mkdir -pv $file_desc_dir || true
    file_list="$file_desc_dir/${KUBE_VERSION}_${key}${release}.txt"
    echo "[File]" > ${file_list}
    du -ah ${os_dir}* >> ${file_list}
    echo -e "\n[IMAGES]" >>  ${file_list}
    docker images --format '{{.Size}} {{.Repository}}:{{.Tag}}' | grep -Ev "${OS_LIST// /|}" | sort >>  ${file_list}
    cat ${file_list}
    tar zcvf ${KUBE_VERSION}/${KUBE_VERSION}_${key}${release}.tgz -C ${os_dir}/ .
  done
done

echo $PWD
mv ${KUBE_VERSION} /tmp/
ls -alhR /tmp/${KUBE_VERSION}/*
