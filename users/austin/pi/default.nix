{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [

    inputs.pi.homeModules.default
  ];

  programs.pi.coding-agent = {
    enable = true;

    environment.PI_CODING_AGENT_DIR.value = "${config.home.homeDirectory}/.config/pi";
    settings = {
      defaultProvider = "openai";
      defaultModel = "gpt-6.1-sol";
      defaultThinkingLevel = "high";
      packages = [
        "npm:@benvargas/pi-openai-fast"
        "npm:@ff-labs/pi-fff"
      ];
    };
    skills = [
      "${pkgs.ketch.src}/skills/ketch"
    ];

  };
}
