function doCreateTouchFile() {
	local filePath="$1"
	# Evaluate the path with variables
	filePath=$(eval echo "$filePath")

	# Check if the path is not already within the project root
	if [[ $filePath != "$SB_PROJECT_ROOT"* ]]; then
		filePath="${SB_PROJECT_ROOT}/${filePath}"
	fi

	# Create parent directory if it doesn't exist
	mkdir -p "$(dirname "$filePath")"

	# Touch the file to create it empty
	touch "$filePath"
	_iOk "Created touch file" "$filePath"
}

function doCreateDirectory() {
	local dirPath="$1"
	# Evaluate the path with variables
	dirPath=$(eval echo "$dirPath")

	# Check if the path is not already within the project root
	if [[ $dirPath != "$SB_PROJECT_ROOT"* ]]; then
		dirPath="${SB_PROJECT_ROOT}/${dirPath}"
	fi

	mkdir -p "$dirPath"
	_iOk "Created directory" "$dirPath"
}
