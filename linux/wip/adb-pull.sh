#!/usr/bin/env bash


declare -a AppPaths
declare -a AppNames

AppsList=$(adb shell cmd package list packages -3 -f); echo "${AppsList}"


# Initialize arrays to store full paths and app names
declare -a fullpaths
declare -a appnames

# Function to extract the filename (app name) from the full path
extract_app_name() {
  local full_path="$1"
  # Use basename to get the filename, then remove the .apk extension
  app_name=$(basename "$full_path" .apk)
  echo "$app_name"
}

# Loop through each line of the output
while IFS= read -r line; do
  # Use regular expression to extract the full path and the package name
  if [[ "$line" =~ package:(.*)=(.*) ]]; then
    full_path="${BASH_REMATCH[1]}"
    package_name="${BASH_REMATCH[2]}"
    # Add to the arrays
    fullpaths+=("$full_path")
    appnames+=("$package_name")
  fi
done <<< "$packages_output"

# Check if any packages were found
if [ ${#fullpaths[@]} -eq 0 ]; then
    echo "No packages found on the device."
    exit 0
fi

# Loop through the arrays and pull the APK files
for i in "${!fullpaths[@]}"; do
  fullpath="${fullpaths[$i]}"
  appname="${appnames[$i]}"
  echo "Pulling $appname.apk from $fullpath..."
  # Use adb pull to copy the APK to the current directory
  adb pull "$fullpath" "/tmp/$appname.apk"
  if [ $? -ne 0 ]; then
    echo "Failed to pull $appname.apk.  Check adb permissions and device connection."
    # Continue to the next iteration of the loop
    continue
  else
    echo "Successfully pulled $appname.apk"
  fi
done

echo "Finished pulling APK files."
