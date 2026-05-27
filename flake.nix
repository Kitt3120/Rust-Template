{
  description = "Swarm Protocol development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustup
            git-cliff
          ];

          TEMPDIR = "/tmp/rust/shell";
          TMPDIR = "/tmp/rust/shell";
          TEMP = "/tmp/rust/shell";
          TMP = "/tmp/rust/shell";

          shellHook = ''
            PWD=$(pwd)
            DATA_DIR="/tmp/rust/$PWD"
            SHELL_DIR="$DATA_DIR/shell"
            export CARGO_HOME="$DATA_DIR/cargo"
            export RUSTUP_HOME="$DATA_DIR/rustup"
            export PATH=$CARGO_HOME/bin:$PATH

            mkdir -p "$SHELL_DIR"
            mkdir -p "$CARGO_HOME"
            mkdir -p "$RUSTUP_HOME"

            rustup default stable
            rustup toolchain install
            rustup update

            cargo install cargo-edit

            echo
            echo
            echo

            echo "Rustup installed at $RUSTUP_HOME"
            echo "Cargo installed at $CARGO_HOME"
            echo "git-cliff installed at $(which git-cliff)"
            echo "cargo-edit installed at $(which cargo-add)"
            echo "$(rustup --version)"
            echo "$(cargo --version)"
            echo "$(git-cliff --version)"
          '';
        };
      }
    );
}
