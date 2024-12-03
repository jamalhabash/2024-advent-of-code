```
nix-instantiate --eval --strict --show-trace
ls | nix run nixpkgs#entr -- -c nix-instantiate --eval --strict
```
