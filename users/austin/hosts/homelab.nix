{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    dnsutils
    jq
  ];
}
