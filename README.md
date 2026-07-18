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

## ☁️ 2. Remote VPS Setup (The Intelligent Router)

1. On your remote VPS hosting the Hermes Agent, ensure litellm is installed:
```bash
pip install litellm
```

2. Deploy the litellm-router.yaml configuration from this repo's vps-config/ directory onto your server.

3. Replace YOUR_MAC_IP_ADDRESS in the configuration file with your Mac's secure network identifier (we highly recommend using an encrypted overlay network like Tailscale or WireGuard to bridge the VPS and Mac without exposing public ports).

4. Boot the proxy gateway on the VPS:
```bash
litellm --config ./litellm-router.yaml --port 4000
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

The script will instantly test the availability of the local LiteLLM proxy and verify the end-to-end data link to your local hardware.

---

## 📊 Benchmarks & Telemetry Math
Want to see the raw hardware data and cost breakdowns? Check out our complete [Performance Benchmarks Guide](./benchmarks.md).
