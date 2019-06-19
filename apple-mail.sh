#!/bin/bash

load_signature_file() {
	echo "searching signature file..."

	local SIGNATURES_PATH_ICLOUD_V6="$HOME/Library/Mobile Documents/com~apple~mail/Data/V6/Signatures/"
	local SIGNATURES_PATH_ICLOUD_V5="$HOME/Library/Mobile Documents/com~apple~mail/Data/V5/Signatures/"
	local SIGNATURES_PATH_ICLOUD_V4="$HOME/Library/Mobile Documents/com~apple~mail/Data/V4/Signatures/"
	local SIGNATURES_PATH_ICLOUD_V3="$HOME/Library/Mobile Documents/com~apple~mail/Data/V3/Signatures/"
	local SIGNATURES_PATH_ICLOUD_V2="$HOME/Library/Mobile Documents/com~apple~mail/Data/V2/Signatures/"
	local SIGNATURES_PATH_NON_ICLOUD_V6="$HOME/Library/Mail/V6/MailData/Signatures/"
	local SIGNATURES_PATH_NON_ICLOUD_V5="$HOME/Library/Mail/V5/MailData/Signatures/"
	local SIGNATURES_PATH_NON_ICLOUD_V4="$HOME/Library/Mail/V4/MailData/Signatures/"
	local SIGNATURES_PATH_NON_ICLOUD_V3="$HOME/Library/Mail/V3/MailData/Signatures/"
	local SIGNATURES_PATH_NON_ICLOUD_V2="$HOME/Library/Mail/V2/MailData/Signatures/"

	if [ -d "$SIGNATURES_PATH_ICLOUD_V6" ]; then
		echo "found iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_ICLOUD_V6"
	elif [ -d "$SIGNATURES_PATH_ICLOUD_V5" ]; then
		echo "found iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_ICLOUD_V5"
	elif [ -d "$SIGNATURES_PATH_ICLOUD_V4" ]; then
		echo "found iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_ICLOUD_V4"
	elif [ -d "$SIGNATURES_PATH_ICLOUD_V3" ]; then
		echo "found iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_ICLOUD_V3"
	elif [ -d "$SIGNATURES_PATH_ICLOUD_V2" ]; then
		echo "found iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_ICLOUD_V2"
	elif [ -d "$SIGNATURES_PATH_NON_ICLOUD_V6" ]; then
		echo "found non-iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_NON_ICLOUD_V6"
	elif [ -d "$SIGNATURES_PATH_NON_ICLOUD_V5" ]; then
		echo "found non-iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_NON_ICLOUD_V5"
	elif [ -d "$SIGNATURES_PATH_NON_ICLOUD_V4" ]; then
		echo "found non-iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_NON_ICLOUD_V4"
	elif [ -d "$SIGNATURES_PATH_NON_ICLOUD_V3" ]; then
		echo "found non-iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_NON_ICLOUD_V3"
	elif [ -d "$SIGNATURES_PATH_NON_ICLOUD_V2" ]; then
		echo "found non-iCloud signature directory"
		local SIGNATURE_PATH="$SIGNATURES_PATH_NON_ICLOUD_V2"
	else
		echo "signature directory not found"
		exit 1
	fi

	SIGNATURE_FILE=`ls -1t "$SIGNATURE_PATH"*.mailsignature | head -n 1`

	if [[ $? -ne 0 ]] || [[ -z "$SIGNATURE_FILE" ]]; then
		echo "listing error, create a signature"
		exit 1
	fi
}

download_signature() {
	echo "downloading signature..."

	echo "enter url:"
	exec 3<>/dev/tty
	read -u 3 SIGNATURE_URL

	if [[ -z "$SIGNATURE_URL" ]]; then
		echo "missing url"
		exit 1
	fi

	SIGNATURE_HTML=`curl -s "$SIGNATURE_URL"`

	if [[ -z "$SIGNATURE_HTML" ]]; then
		echo "empty signature url response"
		exit 1
	fi

	echo "done."
}

setup_signature() {
	echo "setting up signature..."

	i=0;
	SIGNATURE=""
	while read line; do
		if [[ -z "$line" ]]; then
			break
		fi

		if [[ "$i" -eq 0 ]]; then
			SIGNATURE="$line"
		else
			SIGNATURE="$SIGNATURE\n$line"
		fi

		i=$((i + 1))
	done < "$SIGNATURE_FILE"

	SIGNATURE="$SIGNATURE\n\n$SIGNATURE_HTML"

	chflags nouchg "$SIGNATURE_FILE"
	echo -e "$SIGNATURE" > "$SIGNATURE_FILE"
	chflags uchg "$SIGNATURE_FILE"

	echo "done."
}


load_signature_file
download_signature
setup_signature
