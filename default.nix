
# Option (1): Use the user's default environment
# with import <nixpkgs> { inherit system; };

# Option (2): Pinned, strategy:
with import (fetchTarball "https://github.com/NixOS/nixpkgs-channels/archive/nixos-19.03.tar.gz") {};

# A manually-packaged dependency:
let libelfin = import ./deps/libelfin {
      inherit (pkgs) stdenv fetchurl python3 git;
   };
in 

stdenv.mkDerivation {
  name = "dettrace";
  buildInputs = [
    clang
    libseccomp
    python3
    libarchive
    cpio
    pkgconfig
    openssl
    libelf
    libelfin # Custom dependency
  ];

  # Substract repo files that we don't actually need for the build:
  src = nix-gitignore.gitignoreSourcePure [ ./.nixignores ./.gitignore ] ./. ;  
  
  buildPhase = ''
    make
  '';  
  installPhase = ''
    echo Copying dettrace binary;
    mkdir -p "$out/bin";
    cp bin/dettrace "$out/bin/";
  '';  
}
