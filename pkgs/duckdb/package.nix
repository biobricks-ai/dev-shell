{ lib, fetchFromGitHub, duckdb }:

let
  duckdb-version = "1.2.2";
  duckdb-rev = "7c039464e452ddc3330e2691d3fa6d305521d09b";
  duckdb-hash = "sha256-cHQcEA9Gpza/edEVyXUYiINC/Q2b3bf+zEQbl/Otfr4=";
in
duckdb.overrideAttrs (oldAttrs: rec {
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
})
