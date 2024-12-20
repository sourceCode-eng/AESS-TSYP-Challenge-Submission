#!/bin/bash

CURDIR="${BASH_SOURCE[0]}";RL="readlink";([[ `uname -s`=='Darwin' ]] || RL="$RL -f")
while([ -h "${CURDIR}" ]) do CURDIR=`$RL "${CURDIR}"`; done
N="/dev/null";pushd .>$N;cd `dirname ${CURDIR}`>$N;CURDIR=`pwd`;popd>$N

# Python version to use needs to be provided by our caller
PY_BINARY=$1
INSTALL_PYTHON=${2:-y}
echo "*** Zato RHEL/CentOS installation using $PY_BINARY ***"

INSTALL_CMD="yum"

if [ "$(type -p dnf)" ]
then
    INSTALL_CMD="dnf"
    sudo ${INSTALL_CMD} update -y

    if [ ! "$(type -p lsb_release)" ]
    then
        sudo ${INSTALL_CMD} install -y redhat-lsb-core > /dev/null 2>&1 || true
    fi
fi

if [[ "$INSTALL_PYTHON" == "y" ]]; then
    PYTHON_DEPENDENCIES="python3-devel"
fi

os_version=`lsb_release -sir > /dev/null 2>&1 || true`

if [[ $os_version == CentOS\ 8* ]]
then
    sudo yum install dnf-plugins-core
    sudo yum config-manager --set-enabled powertools
elif [[ $os_version == RedHatEnterprise\ 8* ]]
then
    sudo dnf config-manager --set-enabled codeready-builder-for-rhel-8-rhui-rpms
fi

sudo ${INSTALL_CMD} install -y \
    bzip2 bzip2-devel curl cyrus-sasl-devel gcc-c++ git haproxy \
    keyutils-libs-devel libev libev-devel libevent-devel libffi libffi-devel \
    libxml2-devel libxslt-devel libyaml-devel openldap-devel openssl \
    openssl-devel patch postgresql-devel suitesparse swig uuid \
    uuid-devel wget ${PYTHON_DEPENDENCIES}

curl https://bootstrap.pypa.io/get-pip.py | $(type -p $PY_BINARY)
$PY_BINARY -m pip install -U virtualenv==20.4.3

echo Installing virtualenv in $CURDIR
$PY_BINARY -m venv .

echo Activating virtualenv in $CURDIR
source $CURDIR/bin/activate

echo Setting up environment in $CURDIR
PIP_DISABLE_PIP_VERSION_CHECK=1 $CURDIR/bin/python $CURDIR/util/zato_environment.py install

echo ⭐ Successfully installed `zato --version`
