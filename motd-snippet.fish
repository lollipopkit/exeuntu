
# Print exe.dev message (only in interactive shells)
if status is-interactive
    echo ""
    echo "You are on "(hostname -f)". The disk is persistent. You have 'sudo'."
    echo ""
    echo 'For support and documentation, "ssh exe.dev" or visit https://exe.dev/'
    echo ""

    # Build exe.dev proxy URLs based on hostname
    function _exe_url
        set -l fqdn (hostname -f)
        if string match -q "*.*" -- "$fqdn"
            set -l prefix (string split -m 1 . -- "$fqdn")[1]
            set -l suffix (string split -m 1 . -- "$fqdn")[2]
            echo "https://$prefix.$argv[1].$suffix/"
        else
            echo "https://$fqdn.$argv[1].exe.xyz/"
        end
    end

    set -l hints \
        'Read exe.dev docs at https://exe.dev/docs' \
        'Docker is installed and works; try "docker run --rm alpine:latest echo hello world"' \
        "If you run an http webserver on port 4444, you can access it securely at https://"(hostname -f)":4444
Try it with \"python3 -m http.server 4444\"" \
        'ssh into exe.dev to manage the HTTP proxy and sharing for this VM' \
        "There is a web-based terminal at "(_exe_url xterm)
    functions -e _exe_url

    set -l hint_index (random 1 (count $hints))
    printf '%s\n' $hints[$hint_index]

    echo ""
end
