# Pomodoro Timer Recording Server

This project is a pomodoro-style timer recording server with a command line interface.

## Command Line Interface

- `pomo_start`: Start a new pomodoro timer.
- `pomo_pause`: Pause the current timer.
- `pomo_stop`: Stop the current timer.

## Installation

### Linux

To set up the development environment using `venv` and install the required packages, follow these steps:

> **Note**: Consider using [pyenv](https://github.com/pyenv/pyenv) to manage Python interpreters. This project targets
> Python 3.12 and 3.13.

1. **Create a virtual environment**:

    ```bash
    python -m venv venv
    ```

2. **Activate the virtual environment**:

    ```bash
    source venv/bin/activate
    ```

3. **Install the development requirements**:

    ```bash
    pip install -r requirements-dev.txt
    ```

4. **setup configuration**

5. **run unit tests to verfiy setup**

## Usage

Examples of how to use the command line interface.

- Start a new timer:
    ```bash
    pomo_start
    ```
- Pause the current timer:
    ```bash
    pomo_pause
    ```
- Stop the current timer:
    ```bash
    pomo_stop
    ```

## License

This project is licensed under the Apache 2 license.