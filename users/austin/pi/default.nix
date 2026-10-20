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
    jail.enable = true;

    environment.PI_CODING_AGENT_DIR.value = "${config.home.homeDirectory}/.config/pi";
    settings = {
      defaultProvider = "openai";
      defaultModel = "gpt-6.1-sol";
      defaultThinkingLevel = "high";
      packages = [
        "npm:@benvargas/pi-openai-fast"
        "npm:@ff-labs/pi-fff"
        "npm:@juicesharp/rpiv-ask-user-question"
        "npm:@juicesharp/rpiv-btw"
        "npm:@juicesharp/rpiv-todo"
        "npm:@juicesharp/rpiv-voice"
        "npm:pi-subagents"
        {
          source = "git:github.com/narumiruna/pi-extensions";
          extensions = [
            "packages/pi-caffeinate/src/index.ts"
            "packages/pi-plan-mode/src/index.ts"
            "packages/pi-starship/src/index.ts"
          ];
        }
      ];
      subagents = {
        defaultModel = "gpt-6-luna";
        defaultProvider = "openai";
        defaultThinking = "high";
      };
    };
    skills = [
      "${pkgs.ketch.src}/skills/ketch"
    ];

  };
}
