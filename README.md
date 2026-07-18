# ☤ Hermes Hybrid Compute Bridge

![Hermes](https://img.shields.io/badge/Hermes-Compatible-orange) ![Compute](https://img.shields.io/badge/Infrastructure-Hybrid-blueviolet) ![License](https://img.shields.io/badge/License-MIT-green) ![Platform](https://img.shields.io/badge/Apple--Silicon-M1%2FM2%2FM3%2FM4-blue)

A secure, production-grade blueprint to slash your daily AI API spend by up to 80%. This repository layout allows developers to isolate their Hermes Agent on a remote VPS while routing routine, high-frequency tasks (formatting, summaries, basic code tasks) to a zero-marginal-cost local Apple Silicon Mac container, reserving premium cloud models exclusively for frontier-level reasoning.

```
                  ┌──────────────────────┐
                  │  Remote VPS (Brain)  │
                  └──────────┬───────────┘
                             │
                    [ Is routine task? ]
                    ───┬────────────┬───
                       │            │
                     (Yes)         (No)
                       │            │
                       ▼            ▼
             ┌───────────┐        ┌───────────────┐
             │ Local Mac │        │  Claude Cloud │
             │ (Ollama)  │        │     (Opus)    │
             └───────────┘        └───────────────┘
```

## 🛡️ Security First Principles
- **No Global System Pollution:** Local compute runs entirely within an isolated Docker container on the Mac. No native binaries, no root/sudo privileges required.
- **Isolated Execution:** The Hermes agent daemon remains completely sandboxed inside your remote VPS, far away from your local machine's sensitive documents and native environment.

---

## 📋 Hardware Prerequisites & Model Targets

Select your local model allocation based on your Mac's Unified Memory pool to ensure smooth parallel execution alongside your daily tasks:

| Hardware Tier | Available Unified Memory | Optimal Local Model Targets |
| :--- | :--- | :--- |
| **Base M-Series** | 8GB – 16GB | Lightweight 4B/8B models (e.g., Phi-4 Mini, Llama 3.2 8B) |
| **M-Series Pro / Max** | 32GB – 64GB | Dense 12B/14B utility models (e.g., Gemma 3 12B, Qwen 2.5 Coder 14B) |
| **M-Series Ultra** | 64GB – 128GB+ | Full-scale 70B frontier models (e.g., Llama 3.3 70B) |

---

## 💻 1. Local Mac Setup (The Compute Engine)

For machines running Apple Silicon (M1/M2/M3/M4) with a Unified Memory Pool:

1. Create a dedicated project directory anywhere in your standard user folder:
```bash

mkdir -p ~/Developer/hermes-bridge
cd ~/Developer/hermes-bridge
```

2. Copy the compose.yaml file from the mac-config/ directory of this repo into that folder.

3. Launch the containerized engine:
```bash

docker compose up -d
```

*Note: Docker will automatically leverage Apple Silicon's GPU acceleration (OLLAMA_METAL=1) safely within the container sandbox.*

---

## ☁️ 2. Remote VPS Setup (The Custom Router)

1. On your remote VPS hosting the Hermes Agent, install the required lightweight dependencies:
```bash
pip install fastapi uvicorn httpx
```

2. Deploy the `simple-router.py` configuration from this repo's `vps-config/` directory onto your server.

3. Establish a secure connection from your local Mac using an SSH Remote Reverse Tunnel to map your local engine straight to the VPS loopback interface (no complex overlay networks or public port exposures required):
```bash
ssh -R 11434:localhost:11434 hermes@YOUR_VPS_IP
```

4. Boot the proxy gateway on the VPS:
```bash
python3 ./vps-config/simple-router.py
```

---

## 🎯 3. Connect Hermes Agent

Point your active Hermes Agent environment variables on the VPS to the local proxy gateway instead of raw third-party endpoints:

```bash

export ANTHROPIC_API_KEY="sk-vps-secure-key"
export ANTHROPIC_BASE_URL="http://localhost:4000"
```

Your agent will now execute exactly as before, but your monthly API bill will drop drastically as everyday background micro-tasks shift entirely to your local desk.

---

## ⚡ 4. Verification & Diagnostics

To guarantee that your remote VPS can seamlessly communicate with the containerized compute engine on your local Mac through your secure network tunnel, execute the automated diagnostic script:

```bash

chmod +x ./vps-config/verify-bridge.sh
./vps-config/verify-bridge.sh
```

The script will instantly test the availability of the custom FastAPI proxy router and verify the end-to-end data link to your local hardware.


---

## 📊 Benchmarks & Telemetry Math
Want to see the raw hardware data and cost breakdowns? Check out our complete [Performance Benchmarks Guide](./benchmarks.md).
