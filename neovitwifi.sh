#!/bin/bash
# Function to handle wifi login
handle_wifi_login() {
    local username="$1"
    local password="$2"
    local DEBUG=${3:-false}  # Add debug flag with default value false
    
    if [[ "$DEBUG" == "true" ]]; then
        echo "Debug mode enabled"
    fi

    echo "Logging in with:"
    echo "Username: $username"
    echo "Password: $password"

    nmcli radio wifi on
    # Get the wireless device name
    device=$(iw dev | awk '$1=="Interface"{print $2}')
    SSID=$(iw dev "$device" link | grep -o 'SSID: .*' | awk '{print $2}')

    if [[ -n "$SSID" && "$SSID" =~ ^VIT ]]; then
        echo "Current SSID: $SSID"
        login_request "$username" "$password" "$DEBUG"
    else
        echo "Current SSID: none or not VIT network"
        echo "VIT Network not found, changing connection..."
        echo "Trying to connect to VIT 2.4G WiFi"
        Y=$(nmcli device wifi connect "VIT2.4G" 2>&1)
        if [[ "$Y" =~ 'successfully' ]]; then
            echo "Connected to VIT2.4G WiFi"
            login_request "$username" "$password" "$DEBUG"
        else
            echo "Failed to connect to VIT2.4G WiFi, trying VIT5G"
            Y=$(nmcli device wifi connect "VIT5G" 2>&1)
            if [[ "$Y" =~ "successfully" ]]; then
                echo "Connected to VIT5G WiFi"
                login_request "$username" "$password" "$DEBUG"
            else
                echo "Connection attempts failed. Please try manually."
            fi
        fi
    fi
}

login_request() {
    local username="$1"
    local password="$2"
    local debug="$3"
    local retries="${4:-0}"
    local max_retries=3

    echo "Attempting to log in as $username..."

    # Step 1: Initial CURL request
    initial_response=$(curl -s 'http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://phc.prontonetworks.com/' \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:132.0) Gecko/20100101 Firefox/132.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
        -H 'Accept-Language: en-US,en;q=0.5' \
        -H 'Accept-Encoding: gzip, deflate' \
        -H 'DNT: 1' \
        -H 'Connection: keep-alive' \
        -H 'Referer: http://phc.prontonetworks.com/redirect.html?URI=http://phc.prontonetworks.com/' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Priority: u=0, i' \
        2>&1)
    curl_exit_code=$?

    # Determine error reason based on exit code
    case $curl_exit_code in
        6) curl_error_message="Couldn't resolve host. Check the URL or network connection." ;;
        7) curl_error_message="Failed to connect to host. Verify network or firewall settings." ;;
        28) curl_error_message="Operation timed out. Check network stability." ;;
        *) curl_error_message="Unknown error occurred." ;;
    esac

    # Debug option to print detailed error information
    if [[ "$debug" == "true" ]]; then
        echo "Curl Exit Code: $curl_exit_code"
        echo "Curl Error Message: $curl_error_message"
        echo "Initial Response:"
        echo "$initial_response"
    fi
    
    # Check for server error
    if echo "$initial_response" | grep -q "SERVER ERROR"; then
        echo "Already connected."
        return 0
    fi

    # Step 2: Login CURL request with credentials
    # Capture headers and body separately
    response_headers=$(mktemp)
    login_response=$(curl -s -D "$response_headers" \
        --connect-timeout 10 \
        --max-time 30 \
        'http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://captive.apple.com/hotspot-detect.html' \
        -X POST \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/109.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
        -H 'Accept-Language: en-US,en;q=0.5' \
        -H 'Accept-Encoding: gzip, deflate' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Origin: http://phc.prontonetworks.com' \
        -H 'DNT: 1' \
        -H 'Connection: keep-alive' \
        -H 'Upgrade-Insecure-Requests: 1' \
        --data-raw "userId=$username&password=$password&serviceName=ProntoAuthentication&Submit22=Login" \
        2>&1)
    curl_exit_status=$?

    # Check if curl command was successful
    if [[ $curl_exit_status -ne 0 ]]; then
        echo "Curl command failed with exit status $curl_exit_status"
        [[ "$debug" == "true" ]] && echo "Curl output: $login_response"
        rm "$response_headers"
        return 1
    fi

    # Debug option to print the login response
    if [[ "$debug" == "true" ]]; then
        echo "Login Response Headers:"
        cat "$response_headers"
        echo "Login Response Body:"
        echo "$login_response"
    fi

    # Get the HTTP status code
    http_code=$(grep -oP '(?<=HTTP/1.[01] )\d+' "$response_headers" | tail -1)

    # Check for redirects in headers
    redirect_url=$(grep -i '^Location:' "$response_headers" | awk '{print $2}' | tr -d '\r')

    # Step 3: Analyze the login response
    if echo "$login_response" | grep -q "<title>Successful Pronto Authentication</title>"; then
        echo "Successfully logged in as $username."
        echo "Testing network connectivity..."
        if ping -c 3 www.google.com > /dev/null 2>&1; then
            echo "Network is up!"
            rm "$response_headers"
            return 0
        else
            echo "Network is down after successful login."
            rm "$response_headers"
            return 1
        fi
    elif echo "$login_response" | grep -q "<title>Pronto Authentication</title>"; then
        # Retry logic
        if [[ "$retries" -lt "$max_retries" ]]; then
            echo "Login attempt failed. Retrying... ($((retries + 1))/$max_retries)"
            sleep 1
            rm "$response_headers"
            login_request "$username" "$password" "$debug" "$((retries + 1))"
        else
            echo "Maximum retries reached. Login failed."
            rm "$response_headers"
            return 1
        fi
    elif echo "$login_response" | grep -q '<meta http-equiv="refresh"'; then
        # Check for meta refresh redirects
        meta_url=$(echo "$login_response" | grep -oP '(?<=url=)[^"]+')
        echo "Received meta refresh redirect to $meta_url"
        echo "Login was successful."
        echo "Testing network connectivity..."
        if ping -c 3 www.google.com > /dev/null 2>&1; then
            echo "Network is up!"
            rm "$response_headers"
            return 0
        else
            echo "Network is down after meta refresh."
            rm "$response_headers"
            return 1
        fi
    elif [[ "$http_code" -ge 300 && "$http_code" -lt 400 && -n "$redirect_url" ]]; then
        echo "Received HTTP redirect to $redirect_url"
        echo "Assuming login was successful."
        echo "Testing network connectivity..."
        if ping -c 3 www.google.com > /dev/null 2>&1; then
            echo "Network is up!"
            rm "$response_headers"
            return 0
        else
            echo "Network is down after HTTP redirect."
            rm "$response_headers"
            return 1
        fi
    elif [[ "$http_code" -ge 400 ]]; then
        echo "HTTP error code $http_code received."
        [[ "$debug" == "true" ]] && {
            echo "Response Headers:"
            cat "$response_headers"
            echo "Response Body:"
            echo "$login_response"
        }
        rm "$response_headers"
        return 1
    else
        echo "Unexpected response received."
        [[ "$debug" == "true" ]] && {
            echo "HTTP Status Code: $http_code"
            echo "Response Headers:"
            cat "$response_headers"
            echo "Response Body:"
            echo "$login_response"
        }
        rm "$response_headers"
        return 1
    fi
}

# Check if arguments were provided
if [[ $# -eq 2 || $# -eq 3 ]]; then
    # If 2 or 3 arguments provided, use them directly
    handle_wifi_login "$1" "$2" "${3:-false}"
elif [ $# -eq 0 ]; then
    # If no arguments, ask for interactive input
    echo "Please enter your WiFi credentials"
    read -p "Username: " username
    read -sp "Password: " password
    echo  # Add a newline after password input
    read -p "Enable debug mode? (y/N): " debug
    debug_flag=$([ "${debug,,}" = "y" ] && echo "true" || echo "false")
    handle_wifi_login "$username" "$password" "$debug_flag"
else
    # Wrong number of arguments
    echo "Usage: $0 [username password [debug]]"
    echo "Or run without arguments for interactive mode"
    exit 1
fi
