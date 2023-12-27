# dev-shell

A development shell for biobricks.

## Usage

Place the following in flake.nix and make sure to run `git add flake.nix`.

Create .envrc with the contents `use flake` to support auto-loading of the
dev shell by direnv.

### Default

```nix
{
  description = "MedGen BioBrick";

  inputs = { dev-shell.url = "github:biobricks-ai/dev-shell"; };

  outputs = { self, dev-shell }: { devShells = dev-shell.devShells; };
}
```

### With additional packages

This example adds librdf_raptor2 and python with pandas and pyarrow.

```nix
{
  description = "ChemBL RDF BioBrick";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    dev-shell.url = "github:biobricks-ai/dev-shell";
  };

  outputs = { self, nixpkgs, flake-utils, dev-shell }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = dev-shell.devShells.${system}.default.overrideAttrs
          (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++ [
              librdf_raptor2
              (python3.withPackages (ps: with ps; [ pandas pyarrow ]))
            ];
          });
      });

}
```
