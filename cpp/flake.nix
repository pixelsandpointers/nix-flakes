{
  description = "C++";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        project = "project";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        cmakeDeps = with pkgs; [
          cmake
          ninja
          pkg-config
        ];

        # A more robust CMAKE_PREFIX_PATH
        # We just join the root paths of the packages, and CMake will find
        # the 'lib/cmake' subdirectories itself.
        prefixPath = pkgs.lib.concatStringsSep ":" [
        ];
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = project;
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = with pkgs; [ cmake ninja pkg-config ];
          buildInputs = cmakeDeps;

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            #"-DCMAKE_PREFIX_PATH=${prefixPath}"
          ];

          installPhase = ''
            mkdir -p "$out/bin"
            cp project "$out/bin/"
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = cmakeDeps ++ [ pkgs.stdenv ];

          # Use the same complete prefix path
          CMAKE_PREFIX_PATH = prefixPath;

          shellHook = ''
            echo "C++ development shell activated."
            export CXXFLAGS="$NIX_CFLAGS_COMPILE"
          '';
        };
      }
    );
}
