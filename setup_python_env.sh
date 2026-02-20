#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="${1:-.venv}"
PYTHON_BIN="${PYTHON_BIN:-python3}"

echo "Creating virtual environment at: ${VENV_DIR}"
"${PYTHON_BIN}" -m venv "${VENV_DIR}"

echo "Activating virtual environment"
# shellcheck source=/dev/null
source "${VENV_DIR}/bin/activate"

echo "Upgrading pip"
python -m pip install --upgrade pip

echo "Installing requirements"
pip install -r requirements.txt

echo "Environment ready."
echo "Activate later with: source ${VENV_DIR}/bin/activate"
