# gaming.just — Custom ujust recipes for the Budgie Gaming image
#
# Usage: ujust <recipe-name>
# These provide convenient shortcuts for common gaming setup tasks.

# Install Proton-GE (latest) via ProtonUp-Qt
install-protonge:
    #!/usr/bin/env bash
    echo "Launching ProtonUp-Qt to install Proton-GE..."
    flatpak run net.davidotek.pupgui2

# Set up Waydroid (Android on Linux)
setup-waydroid:
    #!/usr/bin/env bash
    echo "Setting up Waydroid..."
    sudo waydroid init -s GAPPS
    echo "Waydroid initialized. Start with: waydroid session start"

# Install MangoHud config for nice defaults
configure-mangohud:
    #!/usr/bin/env bash
    mkdir -p ~/.config/MangoHud
    cat > ~/.config/MangoHud/MangoHud.conf << 'EOF'
    fps
    frametime
    cpu_temp
    gpu_temp
    ram
    vram
    position=top-left
    font_size=20
    background_alpha=0.3
    EOF
    echo "MangoHud configured. Press F12 in supported games to toggle."

# Enable GameMode for a specific game (shows instructions)
gamemode-info:
    #!/usr/bin/env bash
    echo "GameMode is installed and ready."
    echo ""
    echo "To use with Steam:"
    echo "  Set launch options to: gamemoderun %command%"
    echo ""
    echo "To use with Lutris:"
    echo "  Enable 'Feral GameMode' in Lutris game settings."
    echo ""
    echo "To combine with MangoHud:"
    echo "  gamemoderun mangohud %command%"

# Install OpenRazer for Razer peripherals
install-openrazer:
    #!/usr/bin/env bash
    echo "Installing OpenRazer..."
    sudo dnf5 -y install openrazer-meta
    echo "Install Polychromatic for GUI control:"
    flatpak install -y flathub org.polychromatic.polychromatic

# Show system gaming info
gaming-info:
    #!/usr/bin/env bash
    echo "=== GPU Info ==="
    lspci | grep -i vga
    echo ""
    echo "=== Vulkan ==="
    vulkaninfo --summary 2>/dev/null | head -20 || echo "vulkaninfo not available"
    echo ""
    echo "=== Mesa Version ==="
    glxinfo | grep "OpenGL version" 2>/dev/null || echo "glxinfo not available"
    echo ""
    echo "=== Kernel ==="
    uname -r
