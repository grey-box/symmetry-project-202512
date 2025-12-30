#!/bin/bash
# Start script for Symmetry Unified Backend

# Change to backend directory
cd "$(dirname "$0")/symmetry-unified-backend"

# Virtual environment setup
VENV_DIR="venv"

# Check if virtual environment exists, create if not
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    echo "Virtual environment created."
fi

# Activate virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip -q

echo "Starting Symmetry Unified Backend..."
echo "Installing dependencies if needed..."
pip install -q -r requirements.txt

echo "Checking spaCy language models..."
models=("en_core_web_sm" "fr_core_news_sm" "de_core_news_sm" "es_core_news_sm" "it_core_news_sm" "pt_core_news_sm" "nl_core_news_sm")
for model in "${models[@]}"; do
    if ! python -c "import spacy; spacy.load('$model')" 2>/dev/null; then
        echo "  Installing $model..."
        python -m spacy download "$model" -q
    else
        echo "  $model already installed"
    fi
done

echo "Starting FastAPI server..."
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
