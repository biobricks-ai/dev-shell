{
  description = "Development shell for biobricks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    biobricks-R = {
      url = "github:biobricks-ai/biobricks-R";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hdt-cpp = {
      url = "github:insilica/nix-hdt";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    morph-kgc = {
      url = "github:insilica/nix-morph-kgc";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, biobricks-R, hdt-cpp, morph-kgc }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; };
      let
        # tmducken requires duckdb 0.8.1 or later, and nixos-23.05 only had 0.7
        duckdb-version = "1.0.0";
        duckdb-rev     = "1f98600c2cf8722a6d2f2d805bb4af5e701319fc";
        duckdb-hash    = "sha256-bzFxWv8+Ac8vZLd2OWJyu4T0/0dc7wykdOORMpx92Ic=";
        duckdb = (pkgs.duckdb.overrideAttrs (oldAttrs: rec {
          version = duckdb-version;
          src = fetchFromGitHub {
            owner = "duckdb";
            repo = "duckdb";
            rev = "refs/tags/v${duckdb-version}";
            sha256 = "${duckdb-hash}";
          };
          patches = null;
          postPatch = null;
          doInstallCheck = false;
          cmakeFlags = oldAttrs.cmakeFlags ++ [
            "-DOVERRIDE_GIT_DESCRIBE=v${duckdb-version}-0-g${duckdb-rev}"
          ];
        }));
      in {
        devShells.default = mkShell {
          buildInputs = [
            biobricks-R.packages.${system}.rEnv
            clojure
            csv2parquet
            duckdb
            hdt-cpp.packages.${system}.default
            jdk
            morph-kgc.packages.${system}.default
            (lib.hiPrio pkgs.parallel-full) # prefer GNU Parallel over `moreutils`
            moreutils
          ];
          env = { DUCKDB_HOME = "${duckdb}/lib"; };
        };
      });
}
