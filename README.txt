nix run github:numtide/nixos-anywhere -- --flake . root@192.168.0.108
nixos-rebuild switch --flake .

nix-shell -p home-manager
home-manager switch --flake .#user@nixos

nix run github:numtide/nixos-anywhere -- --disk-encryption-keys /tmp/disk.key /tmp/disk.key --extra-files "$temp" --flake .#nixos root@192.168.0.100

nix run github:numtide/nixos-anywhere -- --extra-files "$temp" --flake .#nixos root@192.168.0.100
