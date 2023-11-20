nix run github:numtide/nixos-anywhere -- --flake . root@192.168.0.108
nixos-rebuild switch --flake .

nix-shell '<home-manager>' -A install
home-manager switch --flake .#user@nixos

nix run github:numtide/nixos-anywhere -- --disk-encryption-keys /tmp/disk.key /tmp/disk.key --extra-files "$temp" --flake .#nixos root@192.168.0.100

nix run github:numtide/nixos-anywhere -- --extra-files "$temp" --flake .#nixos root@192.168.0.100


ssh-keygen -t ed25519 -f ssh_ed25519.key

ssh-to-age -i /etc/ssh/ssh_host_ed25519.key.pub

sops --encrypt --in-place --age <age_pub_key> secrets/example.yaml