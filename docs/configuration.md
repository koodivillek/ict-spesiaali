# Configuration

Tähän mennessä olemme muokanneet NixOS:n `configuration.nix` -tiedostoa seuraavasti:

- **Kieliasetukset ja lokaalit**
```nix
time.timeZone = "Europe/Helsinki";

i18n.defaultLocale = "en_US.UTF-8";
i18n.extraLocaleSettings = {
  LC_ADDRESS = "fi_FI.UTF-8";
  LC_IDENTIFICATION = "fi_FI.UTF-8";
  LC_MEASUREMENT = "fi_FI.UTF-8";
  LC_MONETARY = "fi_FI.UTF-8";
  LC_NAME = "fi_FI.UTF-8";
  LC_NUMERIC = "fi_FI.UTF-8";
  LC_PAPER = "fi_FI.UTF-8";
  LC_TELEPHONE = "fi_FI.UTF-8";
  LC_TIME = "fi_FI.UTF-8";
};
```
**Asennetut työkalut**

environment.systemPackages = with pkgs; [
  git nano htop wget curl fish
];

**Palvelut**
OpenSSH-palvelin päälle →
```nix
services.openssh.enable = true;
```

## Jellyfin-palvelu
- Konfiguraatioon lisättiin:
  ```nix
  services.jellyfin.enable = true;
  networking.firewall.allowedTCPPorts = [ 8096 ];
  ```


