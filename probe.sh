#!/bin/sh
# Usage: ./probe.sh <instance-hostname> [port]
# Run from a network that allows outbound port 25; many home ISPs block it.
host=$1
port=${2:-25}
[ -n "$host" ] || { echo "usage: $0 <instance-hostname> [port]" >&2; exit 2; }

echo "control: can this network reach any mail server on 25?"
if nc -z -G 5 gmail-smtp-in.l.google.com 25; then
  echo "  yes"
else
  echo "  NO: this network blocks outbound 25, so the result below means nothing"
fi

echo "dns:"
dig +short "$host" | sed 's/^/  /'

echo "shim health:"
curl -sS -m 10 "https://$host/health" | sed 's/^/  /'

echo "port $port banner:"
banner=$(nc -G 5 -w 5 "$host" "$port" </dev/null)
if [ -n "$banner" ]; then
  echo "  $banner"
  echo "result: reachable. Compare peer= with your public IP to see if the source IP survives."
else
  echo "  none"
  echo "result: not reachable on $port"
fi
