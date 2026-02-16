# Budgie Gaming Image

A gaming-optimized Fedora Budgie Atomic (Onyx) image built with [BlueBuild](https://blue-build.org/), inspired by [Bazzite](https://bazzite.gg/)'s desktop gaming features — without handheld device support or Bazzite branding.

## What is this?

This is a **first-shot** BlueBuild recipe that takes the official Fedora Budgie Atomic image and layers on gaming-focused packages and optimizations drawn from Bazzite's feature set.

**Target:** AMD GPU desktop users who want a gaming-ready Budgie desktop.

## Base Image

`quay.io/fedora-ostree-desktops/onyx:43` — the official Fedora Budgie Atomic image.

We chose this over `ublue-os/budgie-atomic-main` because Universal Blue deprecated their Budgie base image in September 2025. If it comes back, switching to it would give us free codec/driver support from the uBlue layer.

## What's Included (Easy Wins)

| Category | What You Get |
|---|---|
| **Multimedia** | Full codec support via RPM Fusion + Terra (H264, H265, VP9, AV1) |
| **GPU** | Latest Mesa from Terra, Vulkan drivers, AMD Southern/Sea Islands support |
| **Gaming Tools** | Steam, Lutris, MangoHud, vkBasalt, LatencyFleX, GameMode, Gamescope |
| **Controllers** | game-devices-udev rules for common gamepads |
| **Networking** | BBR TCP congestion control, Tailscale VPN |
| **Containers** | Distrobox + Podman preinstalled |
| **Terminal** | Ptyxis (container-aware terminal) |
| **Flatpaks** | Full Flathub enabled; Discord, OBS, ProtonUp-Qt, Heroic preinstalled |
| **Utilities** | input-remapper, webapp-manager, topgrade auto-updater |
| **AMD** | ROCm OpenCL runtime, radeontop monitoring |
| **Fonts** | Noto, Liberation, Fira Code |

## What's NOT Included (Intentionally Skipped)

These are "medium-hard" items from Bazzite that were omitted from this first pass to keep things reliable:

| Feature | Why Skipped |
|---|---|
| **Bazzite/fsync custom kernel** | The COPR kernel swap is the riskiest single change — a bad kernel = unbootable system. The stock Fedora kernel works fine for most gaming. Can be added later. |
| **COPR repo priority dance** | Bazzite carefully tunes 5+ repo priorities to override Fedora's mesa/kernel packages. Getting this wrong causes dependency hell. We use Terra mesa only. |
| **duperemove service** | Needs careful systemd timer config + testing to avoid I/O storms. |
| **ZRAM tuning** | Fedora 43 already configures ZRAM by default. Custom tuning (4GB LZ4) needs testing. |
| **CPU scheduler (LAVD/BORE via sched-ext)** | Requires the bazzite/fsync kernel + scx-scheds package. Depends on kernel swap. |
| **Kyber I/O scheduler** | Requires kernel boot parameter changes + testing with Budgie's I/O patterns. |
| **Patched Switcheroo-Control** | For iGPU/dGPU switching on laptops — only relevant for hybrid GPU setups. |
| **xone driver (Xbox wireless)** | Requires akmod/DKMS build at image time — needs `akmods` module. |
| **DisplayLink support** | Requires special drivers from Synaptics — licensing and build complexity. |
| **OpenRGB kernel modules** | i2c-piix4/i2c-nct6775 need akmod builds. CLI install available via ujust. |
| **Valve's SteamOS themes** | KDE-specific. Not applicable to Budgie. |
| **All handheld/deck features** | HHD, gamescope-session, deck firmware, fan control — not applicable. |
| **Bazzite Portal** | Custom first-run wizard — would need to be rebuilt for Budgie. |
| **NTsync/Fastsync/Winesync** | Requires kernel patches present in the bazzite kernel. |

## Project Structure

```
budgie-gaming/
├── recipe.yml                          # Main BlueBuild recipe
├── recipes/
│   ├── gaming-packages.yml             # DNF packages to install/remove
│   ├── flatpaks.yml                    # Default Flatpak apps
│   └── systemd-config.yml             # Systemd service enable/disable
├── scripts/
│   ├── setup-repos.sh                  # Add COPR repos & third-party sources
│   └── post-install.sh                 # Final tweaks & cleanup
├── files/
│   └── system/
│       └── usr/
│           ├── etc/
│           │   ├── sysctl.d/
│           │   │   └── 90-gaming-network.conf   # BBR + network tuning
│           │   └── modprobe.d/
│           │       └── 90-amdgpu.conf           # AMD GPU driver options
│           └── share/
│               └── ublue-os/
│                   └── just/
│                       └── gaming.just           # ujust gaming commands
└── README.md
```

## Usage

### Building

1. Fork the [BlueBuild template](https://github.com/blue-build/template)
2. Replace the template's `recipe.yml` and add these files
3. Set up cosign signing keys per BlueBuild docs
4. Push — GitHub Actions will build your image

### Rebasing

From an existing Fedora Budgie Atomic (Onyx) installation:

```bash
# First rebase to unsigned (to get signing keys)
rpm-ostree rebase ostree-unverified-registry:ghcr.io/YOUR_USERNAME/budgie-gaming:latest

# After reboot, switch to signed
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/YOUR_USERNAME/budgie-gaming:latest
```

## Next Steps (Iteration Plan)

Once this base builds and boots successfully, consider adding in order of impact:

1. **fsync kernel swap** — biggest gaming improvement (NTsync, HDR, scheduler support)
2. **sched-ext CPU schedulers** — LAVD/BORE for smoother gaming under load
3. **ZRAM tuning** — 4GB LZ4 for better memory management during gaming
4. **duperemove timer** — reduce Wine prefix disk usage
5. **xone akmod** — Xbox wireless controller support
6. **Kyber I/O scheduler** — prevent I/O starvation during game installs

## License

Apache-2.0 (same as Bazzite)
