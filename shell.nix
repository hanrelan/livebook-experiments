{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let basePackages = [
  elixir
  erlang
];
in
mkShell {
  buildInputs = basePackages;
  shellHook = ''
    # elixir config
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$NIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
    export ERL_AFLAGS="-kernel shell_history enabled"

    # livebook config
    mix do local.rebar --if-missing --force, local.hex --if-missing --force
    [ -f .nix-mix/escripts/livebook ] || mix escript.install --force hex livebook
    export PATH=$PWD/.nix-mix/escripts:$PATH

  '';
}
