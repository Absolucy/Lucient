#!/bin/bash
VERSION="1.0.0"
BUILD_ID=$(gdd if=/dev/urandom of=/dev/stdout bs=3 count=1 2>/dev/null | xxd -p -c 65535 | gtr -d '\n')

export VERSION
export BUILD_ID
cleanup() {
	echo "$(tput setaf 6)[::]$(tput sgr0) Build ID is $(tput setaf 2)$(tput bold)${BUILD_ID}$(tput sgr0)"
	unset VERSION
	unset BUILD_ID
}

trap cleanup EXIT
