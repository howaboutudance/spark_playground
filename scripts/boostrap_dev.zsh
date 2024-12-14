#!/usr/bin/env zsh
set -e

# Function to print error messages
error() {
    echo "Error: $1" >&2
    exit 1
}

# use `pyenv latest 3` to find latest Python 3.x version and if not at least
# 3.13 error to install at least 3.13
PYTHON_VERSION=$(pyenv latest 3)

# make sure the major version is 3 and the minor version is at least (>=) 13.
# split up the version string by '.' and assign the first and second elements to
# major and minor variables respectively.
major=$(echo $PYTHON_VERSION | cut -d '.' -f 1)
minor=$(echo $PYTHON_VERSION | cut -d '.' -f 2)

# if the major version is not 3 or the minor version is less than 13, error
if [ "$major" -ne 3 ] || [ "$minor" -lt 13 ]; then
    error "Python that is at least 3.13 is not installed. Please install it using pyenv."
fi

if [ -z "$PYTHON_VERSION" ]; then
    error "Python 3.13 is not installed. Please install it using pyenv."
elif [ ! -d ".python_version" ]; then
    echo "Local pyenv version file found. Skipping setting local Python version."
else
    echo "Setting local Python version to $PYTHON_VERSION"
    pyenv local $PYTHON_VERSION
fi

# if .env file does not exist, create it and set PYTHONPATH as src:$PYTHONPATH
if [ ! -f .env ]; then
    touch .env
    echo "Creating .env file."
    echo "PYTHONPATH=src:\$PYTHONPATH" >> .env
fi

# Set up a virtualenv under .venv if directory does not exist
if [ ! -d .venv ]; then
    python -m venv .venv
else
    echo "Virtualenv already exists. Skipping creation."
fi

# Check if Scala is installed
if ! command -v scala &> /dev/null; then
    error "Scala is not installed. Please install Scala."
fi

# Function to find the latest Spark 3.x installation
find_latest_spark() {
    local spark_dirs=("$1"/spark-3.*-bin-hadoop3*)
    local latest_spark=""
    for dir in "${spark_dirs[@]}"; do
        if [ -d "$dir" ]; then
            latest_spark="$dir"
        fi
    done
    echo "$latest_spark"
}

# Look for a spark installation either in /opt or ~/.local/opt
SPARK_HOME=$(find_latest_spark /opt)
if [ -z "$SPARK_HOME" ]; then
    SPARK_HOME=$(find_latest_spark "$HOME/.local/opt")
fi

if [ -z "$SPARK_HOME" ]; then
    error "Spark 3.x installation not found in /opt or ~/.local/opt."
fi

# Check if SPARK_HOME is set in .env and append if not present
if [ ! -f .env ]; then
    touch .env
fi

if ! grep -q "SPARK_HOME=" .env; then
    # append SPARK_HOME as variable in .env, quote the value (on a new line)
    echo "SPARK_HOME=\"$SPARK_HOME\"" >> .env
fi

# Install the requirements in ./requirements-dev.txt inside the virtualenv
source .venv/bin/activate

# Make sure the Python is the one in the virtualenv
if [[ $(which python) == "$(pwd)/.venv/bin/python" ]]; then
    echo "Python is running from the virtualenv."
    # upgrade pip
    pip install --upgrade pip
    # install the requirements
    pip install -r requirements-dev.txt
else
    error "Python is not running from the virtualenv."
fi

echo "Bootstrap script completed successfully."
