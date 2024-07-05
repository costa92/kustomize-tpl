#!/usr/bin/env bash

get_os(){
    opsys=windows
    if [[ "$OSTYPE" == linux* ]]; then
    opsys=linux
    elif [[ "$OSTYPE" == darwin* ]]; then
    opsys=darwin
    fi
    case $(uname -m) in
    x86_64)
        arch=amd64
        ;;
    arm64|aarch64)
        arch=arm64
        ;;
    ppc64le)
        arch=ppc64le
        ;;
    s390x)
        arch=s390x
        ;;
    *)
        arch=amd64
        ;;
    esac
    return ${opsys}-${arch}
}

eval $1