# make sure to run this script from trashcan directory
export GOOGLE_APPLICATION_CREDENTIALS="$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
python3 main.py "$2"
