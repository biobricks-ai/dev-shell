{ lib, fetchFromGitHub, duckdb }:

let
  duckdb-version = "1.3.0";
  duckdb-rev = "71c5c07cdd295e9409c0505885033ae9eb6b5ddd";
  duckdb-hash = "sha256-Io3BKsFxV6Lis917TYKTxJ6+v832A21Zqpq65qQOdXM=";
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
