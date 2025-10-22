# Asennusohjeet

## Ympäristöt
- **Isäntäkone:** Windows 11  
- **Virtualisointi:** Oracle VirtualBox  
- **NixOS ISO:** https://nixos.org/download/
- **Verkkoasetukset** Bridged Adapter (suora yhteys paikallisverkkoon)

## VirtualBox-ympäristön luonti
  1. Avaa VirtualBox → **New**  
   - Name: NixOS  
   - Type: Linux  
   - Versio: Other Linux (64-bit)
   - ISO Image: valitse lataamasi NixOS ISO  
   - Memory: vähintään 2048 MB
   - Hard disk: esim 20-40gb virtual hard disk
2. Käynnistä virtuaalikone ja suorita NixOS:n asennus graafisen asennusohjelman kautta.  
   - Valitse **NoDesktop**-versio.  
   - Luo käyttäjä 
3. Asennuksen jälkeen irrota ISO (Storage → Optical Drive → Remove disk), jotta asennusikkuna ei avaudu uudelleen
4. Käynnistä virtuaalikone uudelleen.

## Peruskonfiguraatio ja SSH
1. Muokkaa tiedostoa `/etc/nixos/configuration.nix`:
```nix
   networking.networkmanager.enable = true;
   services.openssh.enable = true;
   time.timeZone = "Europe/Helsinki";

   environment.systemPackages = with pkgs; [
    git
    nano
    htop
    wget
    curl
    fish
   ];
   ```
3. Ota muutokset käyttöön:  
  ```bash
   sudo nixos-rebuild switch
   ```
4. VirtualBox → **Network → Adapter 1 → Bridged Adapter**
5. Selvitä virtuaalikoneen IP ajamalla NixOS:ssä:
   ```bash
   ip -4 addr show | grep inet
   ```
   Esimerkki: `192.168..`
6. Testaa SSH-yhteys Windowsin PowerShellistä:
   ```powershell
   ssh käyttäjä@192.168.1.244
   ```

## GitHub-yhteys
1. Luo GitHubissa projektille repositorio.  
2. Kloonaa se NixOS:iin:  
   ```bash
   git clone <repo-osoite>
   cd <repo>
   ```
3. Tee oma branch:  
   ```bash
   git checkout -b branchin-nimi
   ```
4. Tee muutoksia ja pushaa:  
   ```bash
   git add .
   git commit -m "Ensimmäinen commit"
   git push origin branchin-nimi
   ```

## Jellyfin-mediapalvelin

1. Lisää konfiguraatioon:
   ```nix
   services.jellyfin.enable = true;
   networking.firewall.allowedTCPPorts = [ 8096 ];
   ```
2. Ota käyttöön:
   ```bash
   sudo nixos-rebuild switch
   ```
3. Avaa selain (Windowsissa):
   ```
   http://192.168.x.x:8096
   ```
   ja luo admin-käyttäjä.


## ZFS:n käyttöönotto
1. Sammuta virtuaalikone ja lisää kaksi uutta levyä (esim. 20 GB + 20 GB).  
   - VirtualBox → Settings → Storage → Add Hard Disk
2. Käynnistä NixOS ja lisää `configuration.nix` tiedostoon:  
   ```nix
   boot.supportedFilesystems = [ "zfs" ];
   boot.kernelModules = [ "zfs" ];
   services.zfs.autoScrub.enable = true;
   environment.systemPackages = with pkgs; [
     zfs
   ];
   ```
3. Ota käyttöön:  
   ```bash
   sudo nixos-rebuild switch
   sudo modprobe zfs
   ```
4. Tarkista levyt:  
   ```bash
   lsblk
   ```
5. Luo ZFS-pooli nimeltä `media`:  
   ```bash
   sudo zpool create media mirror /dev/sdb /dev/sdc
   ```
6. Tarkista tila:  
   ```bash
   zpool status
   ```
7. Luo mediakansio ja oikeudet:  
   ```bash
   sudo mkdir -p /media/movies
   sudo chown -R käyttäjä:jellyfin /media/movies
   sudo chmod -R 775 /media/movies
   ```
8. lisää `configuration.nix` tiedostoon:
    ```nix
   boot.zfs.extraPools = [ "media" ];
   ```

### Snapshotien käyttöönotto
Lisää configuration.nix tiedostoon:
```nix
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8;  # 8 snapshottia 15 min välein
    hourly   = 24;
    daily    = 7;
    weekly   = 4;
    monthly  = 3;
  };
```


## 7. Samban käyttöönotto (tiedostopalvelin)

1. Lisää `configuration.nix`-tiedostoon:
   ```nix
   services.samba = {
     enable = true;
     openFirewall = true;
     settings = {
       "workgroup" = "WORKGROUP";
       "map to guest" = "Bad User";
       "security" = "user";
       shares = {
         "movies" = {
           "path" = "/media/movies";
           "browseable" = "yes";
           "read only" = "no";
           "guest ok" = "yes";
           "create mask" = "0664";
           "directory mask" = "0775";
           "force user" = "jellyfin";
           "force group" = "users";
         };
       };
     };
   };
   # Varmista, että Samba käynnistyy vasta kun ZFS on mountattu
    systemd.services."samba-smbd".after = [ "zfs-mount.service" ];
    systemd.services."samba-smbd".requires = [ "zfs-mount.service" ];
    systemd.services."samba-nmbd".after = [ "zfs-mount.service" ];
    systemd.services."samba-nmbd".requires = [ "zfs-mount.service" ];

   ```
2. Ota käyttöön:
   ```bash
   sudo nixos-rebuild switch
   ```
3. Tarkista, että palvelut ovat käynnissä:
   ```bash
   sudo systemctl list-units | grep samba
   ```
4. Tarkista:
   ```bash
   sudo smbclient -L localhost -U%
   ```
5. Testaa Windowsista:
   - Avaa resurssienhallinta
   - Kirjoita hakukenttään:  
     ```
     \192.168.x.x\movies
     ```
   - Kansio pitäisi näkyä johon voi tallentaa esim. mp4 tiedostoja
  
   ## 8. Jellyfinin integrointi Samban ja ZFS:n kanssa

1. Siirrä Windowsista elokuva:
   - Kopioi tiedosto `\\192.168.x.x\movies`-kansioon.
2. Jellyfinissä:
   - Avaa **Hallinta → Kirjastot → Lisää kirjasto**
   - **Type:** Movies  
   - **Path:** `/media/movies`
3. Päivitä kirjasto:
   - Klikkaa "kolme pistettä" ja päivitä metatiedot
    <img width="487" height="398" alt="kuva" src="https://github.com/user-attachments/assets/156afaad-ad2d-489a-812b-74a2bae3eae4" />

4. Tiedoston tulisi nyt näkyä Jellyfinin etusivulla kirjastossa ja olla toistettavissa.

   
