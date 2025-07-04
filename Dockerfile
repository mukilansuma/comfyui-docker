# CUDA 12.4.1 + cuDNN runtime base image
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

# Install required system packages
RUN apt update && apt install -y \
    git python3 python3-pip ffmpeg wget unzip netcat && \
    ln -s /usr/bin/python3 /usr/bin/python

# Set working directory for ComfyUI
WORKDIR /ComfyUI

# Clone ComfyUI repo
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Install PyTorch 2.3.0 with CUDA 12.4 support
RUN pip install --upgrade pip && \
    pip install torch==2.6.0+cu124 torchvision --extra-index-url https://download.pytorch.org/whl/cu124 && \
    pip install -r requirements.txt

# Install ComfyUI custom nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git custom_nodes/ComfyUI-Advanced-ControlNet

# Copy startup script that handles model download + status endpoint
COPY startup.sh /ComfyUI/startup.sh
RUN chmod +x /ComfyUI/startup.sh

# Expose ComfyUI UI and status ports
EXPOSE 8188 9999

# Start everything via runtime script
CMD ["bash", "startup.sh"]
