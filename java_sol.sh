#!/bin/bash

# Function to check Java version
check_java_version() {
    if ! command -v java &> /dev/null; then
        echo "Java is not installed on this system."
        return 1
    fi

    # Get the Java version
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    java_major_version=$(echo "$java_version" | awk -F. '{print $1}')

    if [[ "$java_major_version" -lt 11 ]]; then
        echo "An older Java version ($java_version) is installed. Please upgrade to Java 11 or higher."
        return 2
    else
        echo "Java version $java_version is installed and meets the requirement (11 or higher)."
        return 0
    fi
}

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Install the default Java version
echo "Installing Java..."
sudo apt install -y default-jdk

# Check Java installation and version
check_java_version_status=$(check_java_version)
check_java_version_result=$?

if [[ $check_java_version_result -eq 0 ]]; then
    echo "Java installation was successful."
elif [[ $check_java_version_result -eq 1 ]]; then
    echo "Java installation failed. Java is not installed."
else
    echo "Java installation completed, but the installed version is outdated."
fi
