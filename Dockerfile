FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

RUN apt update && apt install -y git python3 python3-pip ffmpeg wget unzip && \
    ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /ComfyUI

RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

RUN pip install --upgrade pip && \
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118 && \
    pip install -r requirements.txt

# Optional ComfyUI Extensions
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git custom_nodes/ComfyUI-Advanced-ControlNet

# Copy the startup script into the container
COPY startup.sh /ComfyUI/startup.sh
RUN chmod +x /ComfyUI/startup.sh

EXPOSE 8188

# Run startup script on container start
CMD ["bash", "startup.sh"]
