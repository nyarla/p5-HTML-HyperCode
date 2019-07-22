{ nixpkgs ? import <nixpkgs> { } }:

with nixpkgs;

mkShell rec {
  buildInputs = [
    perl530
  ] ++ (with perl530Packages; [
    Appcpanminus
    NetSSLeay
  ]);

  shellHook = ''
    eval "$(perl -I$HOME/.config/perl5 -Mlocal::lib=extlib)"
    PERL_CPANM_OPT="-l extlib"
    PATH=extlib:''$PATH
  '';
}
