#!/bin/sh

unset ZONE KTAG ALGO DTYPE DIGEST EXPIRES BEGINS

export IFS="="
xml2 | while read -r KEY VAL; do
    case "$KEY" in
	"/TrustAnchor/Zone") ZONE="$VAL";;
	"/TrustAnchor/KeyDigest/KeyTag") KTAG="$VAL";;
	"/TrustAnchor/KeyDigest/Algorithm") ALGO="$VAL";;
	"/TrustAnchor/KeyDigest/DigestType") DTYPE="$VAL";;
	"/TrustAnchor/KeyDigest/@validUntil") EXPIRES="$VAL";;
	"/TrustAnchor/KeyDigest/@validFrom") BEGINS="$VAL";;
	"/TrustAnchor/KeyDigest/Digest")
	    DIGEST="$(echo "$VAL" | tr "[:upper:]" "[:lower:]")"
	    if [ -z "$ZONE" ] || [ -z "$KTAG" ] || [ -z "$ALGO" ] || [ -z "$DTYPE" ]; then
		echo "Missing some KeyDigest parameter"
		exit 1
	    fi
            if [ -n "$EXPIRES" ] && [ "$(date +%s -d "$EXPIRES")" -lt "$(date +%s)" ]; then
                printf 'Digest %s expired on %s\n' "$DIGEST" "$EXPIRES" >&2
            elif [ -n "$BEGINS" ] && [ "$(date +%s -d "$BEGINS")" -gt "$(date +%s)" ]; then
                printf 'Digest %s will not be valid until %s\n' "$DIGEST" "$BEGINS" >&2
            else
	        printf "%s IN DS %s %s %s %s\n" "$ZONE" "$KTAG" "$ALGO" "$DTYPE" "$DIGEST"
            fi
	    unset KTAG ALGO DTYPE DIGEST EXPIRES BEGINS
	    ;;
    esac
done
exit 0
