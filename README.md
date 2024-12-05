# ByeBye - Logout Utility

## Overview

ByeBye is a simple GTK-based logout utility written in Haskell. It provides a graphical interface for various system actions like logout, shutdown, reboot, suspend, and hibernate.

## Prerequisites

- Nix with Flakes enabled
- A Linux system (curntly only x86_64-linux is supported)

## Installation

### NixOS System-wide Installation

Add the flake to your NixOS configuration (`/etc/nixos/configuration.nix`):

```nix
{
  inputs = {
    # Your existing inputs
    byebye.url = "github:christhepanda28/byebye";
  };

  outputs = { self, nixpkgs, byebye, ... }@inputs: {
    nixosConfigurations.yourhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Your existing modules
        byebye.nixosModules.byebye
        {
          # Enable the ByeBye utility
          programs.byebye.enable = true;
        }
      ];
    };
  };
}
```

### Using Nix Flakes

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/byebye.git
   cd byebye
   ```

2. Build and run the application:
   ```bash
   nix run 
   ```

### Building from Source


1. Build the executable:
   ```bash
   nix build 
   ```

## Development

### Enter Development Shell

To enter a development shell with all dependencies:

```bash
nix develop
```

## License

MIT License - See LICENSE file for details


