# Credits: https://github.com/srid/flake-root/blob/master/flake-module.nix
# This function is used to find the flake root and set it as a env varible.
findUp() {
	ancestors=()
	while true; do
		if [[ -f $1 ]]; then
			echo "$PWD"
			exit 0
		fi
		ancestors+=("$PWD")
		if [[ $PWD == / ]] || [[ $PWD == // ]]; then
			echo "Unable to locate ${1}"
			exit 1
		fi
		cd ..
	done
}

getFileMd5Hash() {
	if [ -f "$1" ]; then
		echo $(echo "$1") | md5sum | cut -d' ' -f1
		return 0
	else
		return 1
	fi
}
