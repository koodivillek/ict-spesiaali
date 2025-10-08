# Asennusohjeet

## Ympäristöt
- **Isäntäkone:** Windows 11  
- **Virtualisointi:** Oracle VirtualBox  
- **NixOS ISO:** https://nixos.org/download/

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
4. Avaa VirtualBoxissa porttiohjaus SSH:lle:  
   - Settings → Network → Port Forwarding  
   - **Host Port:** 2222  
   - **Guest Port:** 22
   - **Protocol:** TCP
5. Testaa yhteys Windowsin PowerShellistä:  
   ```powershell
   ssh -p 2222 käyttäjä@127.0.0.1
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

## Jellyfin-mediapalvelimen asennus
1. Lisää konfiguraatioon:  
   ```nix
   services.jellyfin.enable = true;
   networking.firewall.allowedTCPPorts = [ 8096 ];
   ```
2. ota käyttöön:  
   ```bash
   sudo nixos-rebuild switch
   ```

3. Port Forwarding Virtual Boxiin Jellyfiniä varten
    - Settings → Network → Port Forwarding  
   - **Host Port:** 8096  
   - **Guest Port:** 8096
   - **Type:** TCP
   
5. Avaa selaimessa:  
   ```
   http://127.0.0.1:8096
   ```
6. Luo Jellyfinissä admin-käyttäjä ja salasana.

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
   sudo chown -R mikim:jellyfin /media/movies
   sudo chmod -R 775 /media/movies
   ```

---

## 7. Videon siirtäminen ja Jellyfinin liittäminen ZFS-pooliin
1. Siirrä tiedosto Windowsista:  
   ```powershell
   scp -P 2222 C:\Users\mikim\Downloads\esimerkki.mp4 käyttäjä@127.0.0.1:/media/movies/
   ```
2. Jellyfinissä:  
   - Dashboard → Libraries → Add Library  
   - Type: *Movies*  
   - Path: `/media/movies`  
   - Tallenna
3. Testaa toisto selaimessa.  

---
   
