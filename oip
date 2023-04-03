#!/bin/bash

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# check OS
OS="$(uname)"
if [[ "${OS}" == "Linux" ]]; then
    # On Linux
    OTL_REPOSITORY="/home/linuxotl/.linuxotl/OTLanguage"
elif [[ "${OS}" == "Darwin" ]]; then
  if [[ "$(/usr/bin/uname -m)" == "arm64" ]]; then
      # On ARM macOS
      OTL_REPOSITORY="/opt/OTLanguage"
    else
      # On Intel macOS
      OTL_REPOSITORY="/usr/local/OTLanguage"
    fi
else
  abort "해당 다운로드는 macOS, Linux 만을 지원합니다."
fi

# Set Shell
case $SHELL in
  "/bin/bash"|"bash") ALIAS=~/.bashrc ;;
  "/bin/zsh"|"zsh") ALIAS=~/.zshrc ;;
  *) abort "지원하지 않는 Shell 입니다." ;;
esac

# set OTL_HOME
# shellcheck disable=SC2006 disable=SC2016
if [ -z "${OTL_HOME}" ]; then
  OTL_HOME="${OTL_REPOSITORY}"
  if [[ `cat $ALIAS` != *'export OTL_HOME'* ]]; then
    export OTL_HOME="${OTL_REPOSITORY}"
    echo "export OTL_HOME=${OTL_HOME}" >> $ALIAS
  fi
fi

# shellcheck disable=SC2006 disable=SC2016
if [[ `cat $ALIAS` != *'export PATH="${OTL_HOME}/.otl:${PATH}"'* ]]; then
  export PATH="${OTL_HOME}/.otl:${PATH}"
  echo 'export PATH="${OTL_HOME}/.otl:${PATH}"' >> $ALIAS
fi

# shellcheck disable=SC1090
source "${ALIAS}"

# shellcheck disable=SC2164
run_tool_download() {
  if [ -d "${OTL_HOME}/run-tool" ]; then
    rm -rf "${OTL_HOME}/run-tool"
  fi
  wget https://github.com/OTLanguage/download-tool/raw/main/run-tool/run-tool.zip -P "${OTL_HOME}/run-tool"
  wget https://github.com/OTLanguage/download-tool/raw/main/run-tool/lib/lib.zip -P "${OTL_HOME}/run-tool/lib"
  wget https://github.com/OTLanguage/download-tool/raw/main/run-tool/lib/modules.zip -P "${OTL_HOME}/run-tool/lib"
  unzip "${OTL_HOME}/run-tool/run-tool.zip" -d "${OTL_HOME}"
  unzip "${OTL_HOME}/run-tool/lib/lib.zip" -d "${OTL_HOME}/run-tool/lib"
  unzip "${OTL_HOME}/run-tool/lib/modules.zip" -d "${OTL_HOME}/run-tool/lib"
  rm "${OTL_HOME}/run-tool/run-tool.zip"
  rm "${OTL_HOME}/run-tool/lib/lib.zip"
  rm "${OTL_HOME}/run-tool/lib/modules.zip"
}

run_tool_check() {
  if [ ! -e "${OTL_HOME}/run-tool" ]; then
    false
  else
    FILES=("man/man1/javap.1" "man/man1/jdeprscan.1" "man/man1/jpackage.1" "man/man1/serialver.1" "man/man1/jshell.1" "man/man1/jstatd.1" "man/man1/jdb.1" "man/man1/jabswitch.1" "man/man1/java.1" "man/man1/ktab.1" "man/man1/keytool.1" "man/man1/jmod.1" "man/man1/jaccesswalker.1" "man/man1/jstat.1" "man/man1/jcmd.1" "man/man1/jfr.1" "man/man1/jdeps.1" "man/man1/jhsdb.1" "man/man1/jconsole.1")
    FILES+=("man/man1/jar.1" "man/man1/jaccessinspector.1" "man/man1/javadoc.1" "man/man1/jstack.1" "man/man1/jrunscript.1" "man/man1/kinit.1" "man/man1/jmap.1" "man/man1/rmiregistry.1" "man/man1/jinfo.1" "man/man1/klist.1" "man/man1/jlink.1" "man/man1/javac.1" "man/man1/jps.1" "man/man1/jarsigner.1" "bin/jarsigner" "bin/jfr" "bin/otl" "bin/jdb" "bin/jstack")
    FILES+=("bin/rmiregistry" "bin/jar" "bin/jcmd" "bin/jrunscript" "bin/jps" "bin/java" "bin/jhsdb" "bin/javap" "bin/jdeprscan" "bin/javac" "bin/keytool" "bin/jmod" "bin/jmap" "bin/jshell" "bin/jstat" "bin/jlink" "bin/serialver" "bin/javadoc" "bin/jinfo" "bin/jstatd")
    FILES+=("bin/jdeps" "bin/jconsole" "bin/jpackage" "bin/jimage" "include/jawt.h" "include/classfile_constants.h" "include/jdwpTransport.h" "include/jvmti.h" "include/jni.h" "include/jvmticmlr.h" "include/darwin/jni_md.h" "include/darwin/jawt_md.h" "lib/libnet.dylib" "lib/libnio.dylib" "lib/libinstrument.dylib" "lib/libzip.dylib" "lib/psfontj2d.properties" "lib/fontconfig.properties.src" "lib/libfreetype.dylib" "lib/libjli.dylib")
    FILES+=("lib/security/blocked.certs" "lib/jfr/default.jfc" "lib/jfr/profile.jfc" "lib/shaders.metallib" "lib/libosxkrb5.dylib" "lib/libosxui.dylib" "lib/tzdb.dat" "lib/libmanagement_agent.dylib" "lib/librmi.dylib" "lib/libjdwp.dylib" "lib/libsplashscreen.dylib" "lib/libmanagement_ext.dylib" "lib/libdt_socket.dylib" "lib/libj2pkcs11.dylib" "lib/jvm.cfg" "lib/libjimage.dylib" "lib/security/public_suffix_list.dat" "lib/security/default.policy" "lib/security/cacerts")
    FILES+=("lib/libj2pcsc.dylib" "lib/libjsig.dylib" "lib/libprefs.dylib" "lib/libsyslookup.dylib" "lib/libjawt.dylib" "lib/libattach.dylib" "lib/jrt-fs.jar" "lib/libfontmanager.dylib" "lib/fontconfig.bfc" "lib/src.zip" "lib/libawt_lwawt.dylib" "lib/server/classes_nocoops.jsa" "lib/server/libjvm.dylib" "lib/server/classes.jsa" "lib/server/libjsig.dylib" "lib/libjavajpeg.dylib" "lib/libmlib_image.dylib" "lib/libmanagement.dylib" "lib/libjsound.dylib" "lib/ct.sym")
    FILES+=("lib/jspawnhelper" "lib/libosxsecurity.dylib" "lib/libextnet.dylib" "lib/libjaas.dylib" "lib/liblcms.dylib" "lib/libverify.dylib" "lib/psfont.properties.ja" "lib/libj2gss.dylib" "lib/libsaproc.dylib" "lib/modules" "lib/classlist" "lib/libjava.dylib" "lib/libawt.dylib" "lib/libosx.dylib" "lib/libosxapp.dylib" "conf/logging.properties" "conf/sound.properties" "conf/security/java.security" "conf/security/java.policy")
    FILES+=("conf/security/policy/unlimited/default_US_export.policy" "conf/security/policy/unlimited/default_local.policy" "conf/security/policy/README.txt" "conf/security/policy/limited/default_US_export.policy" "conf/security/policy/limited/exempt_local.policy" "conf/security/policy/limited/default_local.policy" "conf/net.properties" "conf/management/jmxremote.access" "conf/management/management.properties" "conf/management/jmxremote.password.template")
    FILES+=("jmods/java.security.sasl.jmod" "jmods/jdk.jartool.jmod" "jmods/java.se.jmod" "jmods/jdk.zipfs.jmod" "jmods/jdk.jdeps.jmod" "jmods/jdk.jstatd.jmod" "jmods/jdk.jdwp.agent.jmod" "jmods/java.sql.jmod" "jmods/jdk.incubator.foreign.jmod" "jmods/java.smartcardio.jmod")
    FILES+=("jmods/jdk.hotspot.agent.jmod" "jmods/jdk.internal.jvmstat.jmod" "jmods/java.compiler.jmod" "jmods/jdk.incubator.vector.jmod" "jmods/java.sql.rowset.jmod" "jmods/jdk.jfr.jmod" "jmods/jdk.jpackage.jmod" "jmods/jdk.crypto.cryptoki.jmod" "jmods/jdk.internal.vm.compiler.jmod" "jmods/jdk.unsupported.desktop.jmod")
    FILES+=("jmods/jdk.management.jmod" "jmods/java.rmi.jmod" "jmods/jdk.management.jfr.jmod" "jmods/jdk.sctp.jmod" "jmods/jdk.security.jgss.jmod" "jmods/jdk.internal.vm.compiler.management.jmod" "jmods/jdk.net.jmod" "jmods/java.prefs.jmod" "jmods/java.logging.jmod" "jmods/jdk.xml.dom.jmod")
    FILES+=("jmods/java.base.jmod" "jmods/java.xml.crypto.jmod" "jmods/java.naming.jmod" "jmods/jdk.internal.ed.jmod" "jmods/jdk.naming.dns.jmod" "jmods/java.datatransfer.jmod" "jmods/jdk.unsupported.jmod" "jmods/jdk.jlink.jmod" "jmods/jdk.charsets.jmod" "jmods/jdk.localedata.jmod")
    FILES+=("jmods/jdk.jcmd.jmod" "jmods/java.desktop.jmod" "jmods/jdk.accessibility.jmod" "jmods/jdk.attach.jmod" "jmods/java.management.rmi.jmod" "jmods/java.transaction.xa.jmod" "jmods/jdk.jshell.jmod" "jmods/java.xml.jmod" "jmods/java.management.jmod" "jmods/jdk.internal.opt.jmod")
    FILES+=("jmods/jdk.httpserver.jmod" "jmods/java.net.http.jmod" "jmods/jdk.random.jmod" "jmods/jdk.compiler.jmod" "jmods/jdk.internal.le.jmod" "jmods/java.instrument.jmod" "jmods/jdk.dynalink.jmod" "jmods/jdk.management.agent.jmod" "jmods/jdk.internal.vm.ci.jmod" "jmods/jdk.security.auth.jmod")
    FILES+=("jmods/java.scripting.jmod" "jmods/jdk.jdi.jmod" "jmods/jdk.crypto.ec.jmod" "jmods/jdk.naming.rmi.jmod" "jmods/jdk.jconsole.jmod" "jmods/jdk.javadoc.jmod" "jmods/jdk.editpad.jmod" "jmods/jdk.jsobject.jmod" "jmods/java.security.jgss.jmod" "jmods/jdk.nio.mapmode.jmod")
    VALUE=true
    for file in "${FILES[@]}"
    do
      if [ ! -e "${OTL_HOME}/run-tool/$file" ]; then
        VALUE=false
        break
      fi
    done
    $VALUE
  fi
}

# shellcheck disable=SC2164
analyzer_download() {
  rm -rf "${OTL_HOME}/analyzer"
  wget https://github.com/OTLanguage/download-tool/raw/main/analyzer.zip -P "${OTL_HOME}"
  unzip "${OTL_HOME}/analyzer.zip" -d "${OTL_HOME}/analyzer"
  rm "${OTL_HOME}/analyzer.zip"

  rm "${OTL_HOME}/.otl/otl"
  rm "${OTL_HOME}/.otl/oip"
  wget https://raw.githubusercontent.com/OTLanguage/.otl/main/otl -P "${OTL_HOME}/.otl"
  wget https://raw.githubusercontent.com/OTLanguage/.otl/main/oip -P "${OTL_HOME}/.otl"
  chmod +x "${OTL_HOME}/.otl/otl"
  chmod +x "${OTL_HOME}/.otl/oip"
  touch "${OTL_HOME}/system.otls"
  mkdir "${OTL_HOME}/module"
  mkdir "${OTL_HOME}/analyzer/cos"
}

if [ -d "${OTL_HOME}" ]; then
  if ! run_tool_check ; then
    echo "run_tool 이 유효하지 않으므로 재설치합니다."
    rm -rf "${OTL_HOME}/run-tool"
    run_tool_download
  fi
  analyzer_download
else
  run_tool_download
  analyzer_download
fi