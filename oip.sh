#!/bin/sh

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

finish() {
  printf "%s\n" "$@" >&2
  exit 0
}

install_file() {
  wget https://github.com/OTLanguage/module/raw/main/"${1}" -P "${2}"
}

set_shell() {
  case $SHELL in
    "/bin/bash"|*bash*) ALIAS=~/.bashrc ;;
    "/bin/zsh"|*zsh*) ALIAS=~/.zshrc ;;
    *) abort "${SHELL} - 지원하지 않는 Shell 입니다." ;;
  esac
}

# shellcheck disable=SC2162 disable=SC2006 disable=SC2039
file_content() {
  FILE_CONTENT=""
  if [[ `cat "${OTL_HOME}/system.otls"` == *${1}:* ]]; then
    CHECK=""
    while read line || [ -n "$line" ] ; do
      if [ -z "$line" ]; then
        continue
      elif [[ "$line" == *: ]]; then
        if [[ "$line" == ${1}: ]]; then
          CHECK="1"
        else
          CHECK=""
          FILE_CONTENT+="${line}${IFS}"
        fi
      elif [ "${CHECK}" = "" ]; then
        FILE_CONTENT+="    ${line}${IFS}"
      fi
    done < "${OTL_HOME}/system.otls"
  else
    FILE_CONTENT=$(<"${OTL_HOME}/system.otls")
  fi
}

# shellcheck disable=SC2039 disable=SC2162 disable=SC2059 disable=SC2039 disable=SC2016
uninstall() {
  echo "주의! 모든 OTLanguage 파일이 제거됩니다."
  read -p "Are you sure you want to delete it? (y/n) : " DELETE_CHECK
  if [ "$DELETE_CHECK" != "y" ]; then
    finish "삭제를 취소합니다."
  fi
  set_shell
  case ${OSTYPE} in
    linux-gnu*)   # linux
      sed -i '/export PATH="${OTL_HOME}/d' $ALIAS
      sed -i '/export OTL_HOME/d' $ALIAS
      rm -rf "$OTL_HOME"
      echo "삭제가 완료되었습니다."
      ;;
    darwin*)      # mac
      sed -i '' '/export PATH="${OTL_HOME}/d' $ALIAS
      sed -i '' '/export OTL_HOME/d' $ALIAS
      rm -rf "$OTL_HOME"
      echo "삭제가 완료되었습니다."
      ;;
    *) abort "지원하지 않는 OS 입니다." ;;
  esac
  # shellcheck disable=SC1090
  source "${ALIAS}"
  echo "삭제를 완료하였습니다."
}

# shellcheck disable=SC2162 disable=SC2039
sub_uninstall() {
  DIR="${OTL_HOME}/analyzer/cos/${1}"
  if [ -d "${DIR}" ]; then
    echo "${1} 모듈을 제거합니다."
    read -p "Are you sure you want to delete it? (y/n) : " DELETE_CHECK
    if [ "$DELETE_CHECK" != "y" ]; then
      finish "삭제를 취소합니다."
    fi
    file_content "${1}"
    rm -rf "${OTL_HOME}/module/${1}"
    rm -rf "${OTL_HOME}/analyzer/cos/${1}"
    echo "${FILE_CONTENT}" > "${OTL_HOME}/system.otls"
    echo "삭제를 완료하였습니다."
  else
    abort "존재하지 않는 모듈입니다."
  fi
}

# 1 : module name, 2 : sub file name
add_uninstall() {
  DIR="${OTL_HOME}/module/${1}"
  if [ -d "${DIR}" ]; then
    FILE="${DIR}/${2}.*"
    if [ -f "${FILE}" ]; then
      rm "${FILE}"
    else
      abort "존재하지 않는 서브 모듈 입니다. ${2}"
    fi
  else
    abort "존재하지 않는 모듈 입니다. ${1}"
  fi
}

# shellcheck disable=SC2119 disable=SC2039
sub_download() {
  READ_HTTP="$(wget https://raw.githubusercontent.com/OTLanguage/module/main/"${1}"/system.otls -q -O -)"
  if [ -z "${READ_HTTP}" ]; then
    abort "${1}는 존재하지 않는 모듈입니다."
  fi

  TYPE=""
  file_content "${1}"

  rm -rf "${OTL_HOME}/analyzer/cos/${1}"
  rm -rf "${OTL_HOME}/module/${1}"
  FILE_CONTENT+="${IFS}${1}:${IFS}"
  for line in ${READ_HTTP}
  do
    if [[ "$line" == *: ]]; then
      TYPE="${line:0:${#line}-1}"
    elif [ -z "$TYPE" ] || [ -z "$line" ]; then
      continue
    else
      case "$TYPE" in
        "class")
          FILE_PATH="${OTL_HOME}"/analyzer/cos/$(echo "$line" | sed -e "s/~/\//g")
          FILE_NAME=$(basename "$FILE_PATH")
          DOWNLOAD_PATH="${FILE_PATH:0:${#FILE_PATH}-${#FILE_NAME}-1}"
          install_file "${1}"/"${FILE_NAME}" "${DOWNLOAD_PATH}"
          ;;

        "jar")
          FILE_PATH="${OTL_HOME}/module/${1}/${line}"
          FILE_NAME=$(basename "$FILE_PATH")
          DOWNLOAD_PATH="${FILE_PATH:0:${#FILE_PATH}-${#FILE_NAME}-1}"
          install_file "${1}"/"${FILE_NAME}" "${DOWNLOAD_PATH}"
          FILE_CONTENT+="    ${FILE_NAME}${IFS}"
          ;;

        "other")
          FILE_PATH="${OTL_HOME}/module/${1}/${line}"
          FILE_NAME=$(basename "$FILE_PATH")
          DOWNLOAD_PATH="${FILE_PATH:0:${#FILE_PATH}-${#FILE_NAME}-1}"
          install_file "${1}"/"${FILE_NAME}" "${DOWNLOAD_PATH}"
          ;;
      esac
    fi
  done
  echo "${FILE_CONTENT}" > "${OTL_HOME}/system.otls"
}

# 1 : 모듈 이름, 2 : 추가할 모듈
add_download() {
  EXT="$(wget https://raw.githubusercontent.com/OTLanguage/module/main/"${1}"/add.otls -q -O -)"
  if [ -z "${EXT}" ]; then
    abort "${1}는 존재하지 않는 모듈입니다."
  fi
  FILE_NAME="${2}${EXT}"
  rm "${OTL_HOME}/module/${1}/${FILE_NAME}"
  wget https://github.com/OTLanguage/module/raw/main/"${1}"/"${FILE_NAME}" -P "${OTL_HOME}/module/${1}"
}


# shellcheck disable=SC2039
case "${1}" in
  "install")
    case ${#@} in
      1) abort "다운받을 모듈 이름이 존재하지 않습니다." ;;
      2) sub_download "${2}" ;;
      3) add_download "${2}" "${3}" ;;
      *) abort "옵션이 유효하지 않습니다." ;;
    esac
    ;;
  "uninstall")
    case ${#@} in
      1) uninstall ;;
      2) sub_uninstall "${2}" ;;
      3) add_uninstall "${2}" "${3}" ;;
      *) abort "옵션이 유효하지 않습니다." ;;
    esac
    ;;
  *)
    echo "oip <option> [module names]"
    echo "    option : install, uninstall"
    abort "옵션이 유효하지 않습니다."
    ;;
esac