{ rPackages, pkgs, fetchurl, lib }:

let
  name = "duckdb";
  version = "1.2.2";
  sha256 = "sha256-0fukzaRwj7PkIAN9Eozk54sa4iK7kCFa1ltrb1XsP5g=";
  depends = with pkgs.rPackages; [DBI];
in
pkgs.rPackages.buildRPackage {
  name = "${name}-${version}";
  inherit version;
  src = fetchurl {
    inherit sha256;
    urls = [
      "mirror://cran/${name}_${version}.tar.gz"
      "mirror://cran/Archive/${name}/${name}_${version}.tar.gz"
    ];
  };
  propagatedBuildInputs = depends;
  nativeBuildInputs = with pkgs; [ pkg-config cmake ] ++ depends;
}
