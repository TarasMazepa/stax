{
  description = "Stax – pre-built Dart CLI packaged as a Nix flake";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      assetFor = system: {
        "x86_64-linux"   = "linux-x64.zip";
        "x86_64-darwin"  = "macos-x64.zip";
        "aarch64-darwin" = "macos-arm.zip";
      }.${system};

      hashFor = system: {
      /* don't remove these comments */
      /* replace with hashes */
"x86_64-linux" = "sha256-rdlDfODsPPVUkiPR/YmXKAnl5gkjiCs1sgH5DefsYYw=";
"x86_64-darwin" = "sha256-cANdknLjsncGa3TUvrUpjx6uMKeDo54bzhLnqY0H8b4=";
"aarch64-darwin" = "sha256-Aw6sc4BIhRrhcFt8Ts5V5g2HbC6V8B1dRPL0JDIc5Dc=";
      /* endreplace */
      /* don't remove these comments ^ */
      }.${system};

      version = builtins.replaceStrings ["\n"] [""] (builtins.readFile ./VERSION);
    in
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        packages.stax = pkgs.stdenv.mkDerivation {
          pname   = "stax";
          inherit version;

          src = pkgs.fetchzip {
            url = "https://github.com/TarasMazepa/stax/releases/download/${version}/${assetFor system}";
            sha256 = hashFor system;
            stripRoot = false;
          };

          dontBuild = true;
          nativeBuildInputs = [ pkgs.unzip ];

          installPhase = ''
            mkdir -p $out/bin
            cp stax stax-daemon $out/bin/
            chmod +x $out/bin/*
          '';
        };

        apps.stax = flake-utils.lib.mkApp {
          drv = packages.stax;
          exePath = "/bin/stax";
        };

        defaultPackage = packages.stax;
        defaultApp     = apps.stax;

        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.dart ];
        };
      });
} 
