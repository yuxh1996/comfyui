#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

# Use this layer to add nodes and models

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)
# Packages are installed after nodes so we can fix them...
PIP_PACKAGES=(
    "opencv-python==4.7.0.72"
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/pythongosssss/ComfyUI-WD14-Tagger"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/cubiq/ComfyUI_InstantID"
    "https://github.com/crystian/ComfyUI-Crystools"
    "https://github.com/rgthree/rgthree-comfy"
)

CHECKPOINT_MODELS=(
    #"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"
)

UNET_MODELS=(

)

LORA_MODELS=(
    #"https://civitai.com/api/download/models/16576"
)

VAE_MODELS=(
    #"https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

ESRGAN_MODELS=(
    #"https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    #"https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    #"https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
)

CONTROLNET_MODELS=(
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_depth-fp16.safetensors"
    #"https://huggingface.co/kohya-ss/ControlNet-diff-modules/resolve/main/diff_control_sd15_depth_fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_hed-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_mlsd-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_normal-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_scribble-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_color-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_depth-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_keypose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_seg-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_sketch-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_style-fp16.safetensors"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function build_extra_start() {
    build_extra_get_apt_packages
    build_extra_get_nodes
    build_extra_get_pip_packages
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/ckpt" \
        "${CHECKPOINT_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/unet" \
        "${UNET_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/lora" \
        "${LORA_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/vae" \
        "${VAE_MODELS[@]}"
    build_extra_get_models \
        "/opt/storage/stable_diffusion/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    build_extra_get_custom_models
     
    cd /opt/ComfyUI
    source "$COMFYUI_VENV/bin/activate"
    LD_PRELOAD=libtcmalloc.so python main.py \
        --cpu \
        --listen 127.0.0.1 \
        --port 11404 \
        --disable-auto-launch \
        --quick-test-for-ci
    deactivate
}

function build_extra_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                    "$COMFYUI_VENV_PIP" install --no-cache-dir \
                        -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                "$COMFYUI_VENV_PIP" install --no-cache-dir \
                    -r "${requirements}"
            fi
        fi
    done
}

function build_extra_get_apt_packages() {
    if [ ${#APT_PACKAGES[@]} -gt 0 ]; then
        $APT_INSTALL ${APT_PACKAGES[*]}
    fi
}
function build_extra_get_pip_packages() {
    if [ ${#PIP_PACKAGES[@]} -gt 0 ]; then
        "$COMFYUI_VENV_PIP" install --no-cache-dir \
            ${PIP_PACKAGES[*]}
    fi
}

function build_extra_get_models() {
    if [[ -n $2 ]]; then
        dir="$1"
        mkdir -p "$dir"
        shift
        arr=("$@")
        
        printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
        for url in "${arr[@]}"; do
            printf "Downloading: %s\n" "${url}"
            build_extra_download "${url}" "${dir}"
            printf "\n"
        done
    fi
}

function build_extra_get_custom_models() {
    local target_dir="/opt/storage/stable_diffusion/models"
    
    mkdir -p "$target_dir/instantid"
    build_extra_download "https://hf-mirror.com/InstantX/InstantID/resolve/main/ip-adapter.bin" "$target_dir/instantid"

    mkdir -p "$target_dir/controlnet"
    build_extra_download "https://hf-mirror.com/InstantX/InstantID/resolve/main/ControlNetModel/diffusion_pytorch_model.safetensors" "$target_dir/controlnet/ControlNet_For_InstantID.safetensors"
    build_extra_download "https://hf-mirror.com/lllyasviel/sd_control_collection/resolve/main/thibaud_xl_openpose.safetensors" "$target_dir/controlnet/thibaud_xl_openpose.safetensors"
    build_extra_download "https://hf-mirror.com/TencentARC/t2i-adapter-depth-zoe-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors" "$target_dir/controlnet/TencentARCt2i-adapter-depth-zoe-sdxl.safetensors"

    build_extra_download "https://civitai.com/api/download/models/239306?type=Model&format=SafeTensor&size=full&fp=bf16" "$target_dir/checkpoints/disneyrealcartoonmix_v10.safetensors"

    git clone https://hf-mirror.com/aigchacker/clay_insightface "$target_dir/insightface"

    mkdir -p "$target_dir/loras"
    build_extra_download "https://hf-mirror.com/aigchacker/clay_lora/resolve/main/CLAYMATE_V2.03_.safetensors" "$target_dir/loras/CLAYMATE_V2.03_.safetensors"
    build_extra_download "https://hf-mirror.com/aigchacker/clay_lora/resolve/main/DD-made-of-clay-XL-v2.safetensors" "$target_dir/loras/DD-made-of-clay-XL-v2.safetensors"
}

# Download from $1 URL to $2 file path
function build_extra_download() {
    wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
}

umask 002

build_extra_start
fix-permissions.sh -o container