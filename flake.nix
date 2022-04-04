{
  description = "A swaylock-effects flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packageName = "swaylock-effect-git";
        version = "1.6-3";
      in
        {
          defaultPackage = with pkgs; stdenv.mkDerivation {
            pname = packageName;
            version = version;
            src = ./.;
            postPatch = ''
    sed -iE "s/version: '1\.3',/version: '${version}',/" meson.build
  '';

            nativeBuildInputs = [ meson ninja pkg-config scdoc ];
            buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

            mesonFlags = [
              "-Dpam=enabled"
              "-Dgdk-pixbuf=enabled"
              "-Dman-pages=enabled"
            ];

            meta = with lib; {
              description = "Screen locker for Wayland";
              longDescription = ''
      Swaylock, with fancy effects
    '';
              inherit (src.meta) homepage;
              license = licenses.mit;
              platforms = platforms.linux;
              maintainers = with maintainers; [ gnxlxnxx ];
            };
          };
        }
    );
}
