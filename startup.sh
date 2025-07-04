#!/bin/bash

echo "🟡 Starting setup..."

# Create required folders
mkdir -p models/checkpoints models/vae models/clip models/controlnet models/loras models/upscale workflows outputs

# Download Flux Kontext models only if they don't already exist
download_if_missing() {
  FILE=$1
  URL=$2
  if [ ! -f "$FILE" ]; then
    echo "⬇️ Downloading $(basename "$FILE")..."
    wget -O "$FILE" "$URL"
  else
    echo "✅ Found $(basename "$FILE") – skipping download."
  fi
}

# Flux VAE (Lumina)
download_if_missing models/vae/ae.safetensors \
  https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors

# CLIP Text Encoder (Flux)
download_if_missing models/clip/clip_l.safetensors \
  https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors

# T5 XXL Text Encoder (Flux)
download_if_missing models/clip/t5xxl_fp16.safetensors \
  https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors

# Flux1 Kontext Diffusion Model
download_if_missing models/checkpoints/flux1-dev-kontext_fp8_scaled.safetensors \
  https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors

echo "🟢 All models ready. Launching ComfyUI..."

# Start ComfyUI in background
python main.py --listen 0.0.0.0 --port 8188 &

# Start lightweight HTTP status endpoint (on port 9999)
echo "🟢 Starting status endpoint on port 9999..."
while true; do { echo -e 'HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{"status":"ready"}'; } | nc -l -p 9999 -q 1; done
