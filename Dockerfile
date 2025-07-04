# ✅ Base CUDA image
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# ✅ Install system dependencies
RUN apt update && apt install -y git python3 python3-pip ffmpeg wget unzip && \
    ln -s /usr/bin/python3 /usr/bin/python

# ✅ Set working directory
WORKDIR /ComfyUI

# ✅ Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# ✅ Install Python packages
RUN pip install --upgrade pip && \
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118 && \
    pip install -r requirements.txt

# ✅ Install useful custom nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git custom_nodes/ComfyUI-Advanced-ControlNet

# ✅ Create all required model and data directories
RUN mkdir -p models/checkpoints \
    models/vae \
    models/clip \
    models/condition \
    models/loras \
    models/controlnet \
    models/upscale \
    workflows \
    outputs

# ✅ Download Flux Kontext & Lumina models into correct ComfyUI folders

# VAE model (Lumina VAE)
RUN wget -O models/vae/ae.safetensors https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors

# CLIP Text Encoder (Flux)
RUN wget -O models/clip/clip_l.safetensors https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors

# T5 XXL Text Encoder (Flux)
RUN wget -O models/clip/t5xxl_fp16.safetensors https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors

# Flux1 Kontext Diffusion Model
RUN wget -O models/checkpoints/flux1-dev-kontext_fp8_scaled.safetensors https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors

# ✅ Expose ComfyUI default port
EXPOSE 8188

# ✅ Launch ComfyUI on container start (publicly accessible)
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
