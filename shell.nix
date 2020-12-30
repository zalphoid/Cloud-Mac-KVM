let
  nixpkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f9bf6cef541542a3b02885e6d28dbacd5b8b8450.tar.gz") {};
in
  with nixpkgs;
  mkShell {
    buildInputs = [
      terraform
      terraform-providers.google
    ];
  }

