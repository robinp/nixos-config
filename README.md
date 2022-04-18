# nixos-config
NixOS configuration

## To update nix:

```
sudo nix-channel add https://nixos.org/channels/nixos-21.11 nixos
sudo nix-channel --update
# edit nix config, see changelog about changes
sudo nixos-rebuild --upgrade boot
# reboot
```
