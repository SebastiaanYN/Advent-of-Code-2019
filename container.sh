# ./container.sh
# ./container.sh ubuntu:18.04
# ./container.sh ubuntu:18.04 /bin/sh

docker run \
  -it \
  --rm \
  --name AOC \
  -w /usr/AOC \
  --volume $(pwd):/usr/AOC \
  --entrypoint "${2:-/bin/sh}" \
  "${1:-ubuntu:18.04}"
