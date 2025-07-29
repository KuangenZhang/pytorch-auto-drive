if [ $# -ne 1 ]; then
    echo "Usage: $0 /absolute/path/to/project"
    exit 1
fi

PROJECT_PATH="$1"

if [ ! -d "$PROJECT_PATH" ]; then
    echo "Error: $PROJECT_PATH is not a directory."
    exit 1
fi

# Get the basename for the .pth filename
BASENAME=$(basename "$PROJECT_PATH")
PTH_FILE="$BASENAME.pth"

# Find the Python site-packages directory for the current conda env
SITE_PACKAGES=$(python -c "import site; print([p for p in site.getsitepackages() if 'site-packages' in p][0])" 2>/dev/null)

if [[ -z "$SITE_PACKAGES" ]]; then
    SITE_PACKAGES=$(python -c "import sysconfig; print(sysconfig.get_paths()['purelib'])")
fi

if [[ -z "$SITE_PACKAGES" ]]; then
    echo "Could not find site-packages directory."
    exit 1
fi

# Add the project path as a .pth file in site-packages
echo "$PROJECT_PATH" > "$SITE_PACKAGES/$PTH_FILE"

echo "Added $PROJECT_PATH as $PTH_FILE in $SITE_PACKAGES"