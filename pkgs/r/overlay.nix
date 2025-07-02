final: prev: {
  rPackages = prev.rPackages // {
    duckdb = final.callPackage ./duckdb/package.nix {
      inherit (prev) rPackages;
    };
  };
}
