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
      let
        pkgs = import nixpkgs { inherit system; };
        # Import the DuckDB package using callPackage
        duckdb = pkgs.callPackage ./pkgs/duckdb/package.nix { };
        r-duckdb = pkgs.callPackage ./pkgs/r/duckdb/package.nix {
          rPackages = pkgs.rPackages;
        };
      in {
        # Export packages for other flakes to use
        packages = {
          duckdb = duckdb;
          r-duckdb = r-duckdb;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            biobricks-R.packages.${system}.rEnv
            pkgs.clojure
            pkgs.csv2parquet
            duckdb
            hdt-cpp.packages.${system}.default
            pkgs.jdk
            morph-kgc.packages.${system}.default
            (pkgs.lib.hiPrio pkgs.parallel-full) # prefer GNU Parallel over `moreutils`
            pkgs.moreutils
          ];
          env = { DUCKDB_HOME = "${duckdb}/lib"; };
        };
      });
}
