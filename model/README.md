# Model Node (Local GPU) / 模型节点

Purpose: host generation capabilities decoupled from server; accessed via HTTP (FastAPI) and optionally exposed through FRP.
目的：承载生成能力，与服务端解耦，通过 FastAPI/HTTP 暴露，必要时用 FRP 打通。

## Suggested components / 推荐组件
- LLM: Qwen2.5-0.5B via Ollama → story structure / storyboard JSON / narration draft. 文本生成分镜 JSON/旁白。
- T2I: Stable Diffusion Turbo (diffusers) → keyframes. / 关键帧生图
- I2V (optional): Stable-Video-Diffusion-Img2Vid → short clips. / 图生视频（可选）
- TTS: CosyVoice-mini → narration audio. / 旁白语音

## Minimal FastAPI skeleton (pseudo) / 最小示例
```python
from fastapi import FastAPI
app = FastAPI()

@app.post("/llm/storyboard")
async def storyboard(req: dict):
    return {"shots": [...]}

@app.post("/sd_generate")
async def sd_generate(req: dict):
    return {"url": "https://.../image.png"}
```

## GPU Dockerized model node (RTX 4060 Laptop, CUDA 12.4)
针对截图中的 Windows 11 + RTX 4060 Laptop + 最新 NVIDIA 驱动（550+），新增了一个可直接构建的 GPU 模型容器。容器默认暴露 FastAPI 模型桩服务，并附带一个 GPU 版 Ollama 服务用来拉取 Qwen2.5-0.5B。

### 1) Host prerequisites / 主机前置
- Windows 11 + WSL2 + Docker Desktop；NVIDIA 550+ 驱动（支持 CUDA 12.4）。
- 安装 `nvidia-container-toolkit`，确保 `nvidia-smi` 在 WSL 中可用：
  ```bash
  # inside WSL
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
  curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
  sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
  ```

### 2) Build & run / 构建与运行
```bash
cd model
# 构建 CUDA12.4 + PyTorch 2.4.0 的模型服务镜像
docker compose -f docker-compose.gpu.yml build
# 启动模型节点（FastAPI）和 GPU 版 Ollama
docker compose -f docker-compose.gpu.yml up -d
```
- FastAPI 模型桩：`http://localhost:8000`（健康检查 `/health`，业务接口 `/llm/storyboard`、`/sd_generate`、`/img2vid`、`/tts`）。
- Ollama：`http://localhost:11434`。

### 3) Pull Qwen 模型（在容器内执行）
```bash
# 进入 ollama 容器，拉取 Qwen2.5 0.5B
docker compose -f docker-compose.gpu.yml exec ollama ollama pull qwen2.5:0.5b
```

### 4) 挂载与缓存
- `./weights` 挂载到容器 `/models`，用于 HF/SD/SVD/CosyVoice 等权重缓存。
- Ollama 权重持久化到 compose 中的 `ollama` 卷，可跨重启保留。

### 5) 接入提示
- 将真实推理逻辑接到 `model/main.py` 中的 TODO（Qwen/Ollama、SD Turbo、SVD、CosyVoice）。
- 如果需要对外暴露端口到公网，复用仓库 `frp/` 下的示例配置。

## Deployment / 部署
- Run on local GPU; package models separately from server. / 本地 GPU 运行，独立包模型。
- Expose ports via `frpc` to cloud `frps`. / 用 frpc 将端口暴露给公网 frps。
- Upload outputs to OSS/TOS and return URLs. / 产物上传 OSS/TOS 并返回 URL。
