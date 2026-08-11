{
  environment.persistence."/persist/" = {
    hideMounts = true;
    files = [
      "/etc/machine-id"
    ];
    directories = [
      {
        directory = "/etc/NetworkManager/system-connections";
        mode = "0700";
      }
    ];
  };
}
