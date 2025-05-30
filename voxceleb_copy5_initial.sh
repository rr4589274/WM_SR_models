#!/bin/bash

# Define source and destination directories
SRC_DIR="VoxCeleb1"
DEST_DIR="VoxCeleb1_sm_clean"

# Create the base directory structure
mkdir -p "$DEST_DIR/dev/wav"
mkdir -p "$DEST_DIR/test/wav"

# Function to copy first 5 .wav files per subfolder
copy_dev_files() {
    local src_subdir="$1"
    local dest_subdir="$2"
    
    # Iterate over speaker ID folders
    for speaker in "$src_subdir"/*; do
        if [ -d "$speaker" ]; then
            speaker_id=$(basename "$speaker")
            mkdir -p "$dest_subdir/$speaker_id"
            
            # Iterate over subfolders inside each speaker folder
            for subfolder in "$speaker"/*; do
                if [ -d "$subfolder" ]; then
                    subfolder_id=$(basename "$subfolder")
                    mkdir -p "$dest_subdir/$speaker_id/$subfolder_id"
                    
                    # Copy only the first 5 .wav files from the subfolder
                    find "$subfolder" -maxdepth 1 -type f -name "*.wav" | sort | head -n 5 | while read file; do
                        cp "$file" "$dest_subdir/$speaker_id/$subfolder_id/"
                    done
                fi
            done
        fi
    done
}

# Function to copy test fully
copy_test_files() {
    cp -r "$SRC_DIR/test/wav"/* "$DEST_DIR/test/wav/"
}

# Copy for 'dev' and 'test'
copy_dev_files "$SRC_DIR/dev/wav" "$DEST_DIR/dev/wav"
copy_test_files

echo "Copying completed!"
