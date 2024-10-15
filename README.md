# Transparent NvChad Setup on Fedora

This repository contains my configuration for a transparent NvChad setup on Fedora. It combines the power of NvChad with a sleek, translucent appearance inspired by Arch Linux configurations.

## Prerequisites

- Fedora (tested on Fedora 40)
- Neovim with NvChad installed
- A terminal emulator that supports transparency (e.g., Alacritty, Kitty, or GNOME Terminal)

## Setup Instructions

### 1. Install and Configure Picom

Picom is the compositor we use to enable transparency across the desktop.

a. Install Picom:
```bash
sudo dnf install picom
```

b. Create a Picom configuration file:
```bash
mkdir -p ~/.config/picom
```

c. Add the following content to `~/.config/picom/picom.conf`:
```
# Basic configuration
backend = "glx";
vsync = true;

# Opacity
active-opacity = 1.0;
inactive-opacity = 0.9;
frame-opacity = 0.9;

# Fading
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;

# Shadows
shadow = true;
shadow-radius = 5;
shadow-offset-x = -5;
shadow-offset-y = -5;
shadow-opacity = 0.5;

# Other
mark-wmwin-focused = true;
mark-ovredir-focused = true;
detect-rounded-corners = true;
detect-client-opacity = true;
```

d. Disable GNOME's built-in compositor:
```bash
gsettings set org.gnome.mutter compositing-manager false
```

e. Start Picom:
```bash
picom --config ~/.config/picom/picom.conf -b
```

### 2. Configure Your Terminal

Ensure your terminal emulator is set up for transparency. For example, if using Alacritty, add this to `~/.config/alacritty/alacritty.yml`:

```yaml
window:
  opacity: 0.9
```

### 3. Configure NvChad

a. Open your NvChad custom config:
```bash
nvim ~/.config/nvim/lua/custom/chadrc.lua
```

b. Add or modify the transparency settings:
```lua
local M = {}

M.ui = {
  transparency = true,
  theme = "onedark", -- or any theme you prefer
}

return M
```

### 4. Startup Script (Optional)

To automate the startup process, create a script that starts Picom and launches your terminal with Neovim:

a. Create a file named `start_env.sh` in your home directory:
```bash
#!/bin/bash
picom --config ~/.config/picom/picom.conf -b
alacritty -e nvim  # Replace 'alacritty' with your terminal if different
```

b. Make it executable:
```bash
chmod +x ~/start_env.sh
```

c. You can now start your transparent NvChad environment by running:
```bash
~/start_env.sh
```

## Customization

Feel free to adjust the Picom configuration, terminal opacity, or NvChad theme to suit your preferences. The `chadrc.lua` file is your main point of customization for NvChad.

## Troubleshooting

If you encounter issues:
- Ensure Picom is running (`pgrep picom`)
- Check Picom's log for errors
- Verify that your terminal supports transparency
- Make sure NvChad's transparency option is enabled

## Contributing

If you have suggestions for improving this setup, feel free to open an issue or submit a pull request!

## License

MIT

---

Enjoy your transparent NvChad setup!
