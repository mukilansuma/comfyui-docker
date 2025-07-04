# ✅ CUDA 12.4 base image with cuDNN 8
FROM nvidia/cuda:12.4.0-cudnn8-runtime-ubuntu22.04

# ✅ Install core tools
RUN apt update && apt install -y git python3 python3-pip ffmpeg wget unzip netcat && \
    ln -s /usr/bin/python3 /usr/bin/python

# ✅ Set working directory
WORKDIR /ComfyUI

# ✅ Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# ✅ Install PyTorch 2.3.0 (cu124 build)
RUN pip install --upgrade pip && \
    pip install torch==2.3.0 torchvision --index-url https://download.pytorch.org/whl/cu124 && \
    pip install -r requirements.txt

# ✅ Optional: Add extensions
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git custom_nodes/ComfyUI-Advanced-ControlNet

# ✅ Copy startup script for model download + status endpoint
COPY startup.sh /ComfyUI/startup.sh
RUN chmod +x /ComfyUI/startup.sh

# ✅ Expose ComfyUI UI + Status endpoint
EXPOSE 8188 9999

# ✅ Start everything via startup script
CMD ["bash", "startup.sh"]
