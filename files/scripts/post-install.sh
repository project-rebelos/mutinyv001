#!/usr/bin/env bash
# post-install.sh — Final system tweaks after all packages are installed
#
# This handles configuration that can't be done via files/systemd modules,
# such as enabling Flathub, setting kernel defaults, and general cleanup.
#
set -euo pipefail

echo ":: Running post-install tweaks..."

# ---- Enable full Flathub (replace Fedora's filtered version) ----
# Fedora ships a curated subset of Flathub. We want the full thing.
if flatpak remotes --system --columns=name | grep -Fxq fedora; then
  flatpak remote-delete --system fedora
fi

if flatpak remotes --system --columns=name | grep -Fxq fedora-testing; then
  flatpak remote-delete --system fedora-testing
fi


# ---- Set default kernel boot parameters ----
# BBR TCP congestion control — better network throughput for game downloads
# and streaming. This is a well-tested, safe optimization from Google.
if [ -d /usr/lib/sysctl.d ]; then
    echo ":: Kernel parameter files already placed via files module."
fi

# ---- Clean up RPM caches to reduce image size ----
dnf5 clean all
rm -rf /var/cache/dnf5/*

# ---- Set os-release branding ----
# Give the image its own identity
if [ -f /usr/lib/os-release ]; then
    sed -i 's/^PRETTY_NAME=.*/PRETTY_NAME="Budgie Gaming Desktop (Fedora 43)"/' /usr/lib/os-release
    sed -i 's/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME="budgie-gaming"/' /usr/lib/os-release
    # Add custom fields
    if ! grep -q "IMAGE_NAME" /usr/lib/os-release; then
        echo 'IMAGE_NAME="budgie-gaming"' >> /usr/lib/os-release
    fi
fi

echo ":: Post-install tweaks complete."
