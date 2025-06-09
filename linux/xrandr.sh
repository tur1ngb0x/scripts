function xrandr_data ()
{
    # Save the xrandr --verbose output to a temporary file
    command xrandr --verbose &> /tmp/xrandr.txt

    # Get all connected devices
    connected_devices=$(grep -w "connected" /tmp/xrandr.txt | awk '{print $1}')

	echo "${connected_devices}"

    # Clean up the temporary file
    rm -f /tmp/xrandr.txt
}

xrandr_data
