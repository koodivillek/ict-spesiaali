# ICT-spesiaali

Kurssiprojekti avoimen lähdekoodin ohjelmistokehityksestä ja Linux-ympäristöstä.  
Tavoitteena oli rakentaa **toimiva palvelinympäristö NixOS:in päälle**, joka sisältää:
- **Jellyfin-mediapalvelimen** elokuvien ja videoiden suoratoistoon selaimen kautta  
- **Samba-tiedostopalvelimen** tiedostojen jakamiseen Windows-verkossa  
- **ZFS-levyjärjestelmän** datan redundanssilla ja snapshot-tuesta  
- Kaikki tämä toteutettuna **VirtualBox-virtuaalikoneessa**, jossa Windows hostina

## Sisältö
- `docs/installation.md` – asennusohjeet vaiheittain
- `nix/configuration.nix` - Konfiguraatiotiedosto

## Käytetyt teknologiat
- [NixOS](https://nixos.org/) – Linux-distro konfiguraatiopohjaisella hallinnalla  
- [Jellyfin](https://jellyfin.org/) – avoimen lähdekoodin mediapalvelin  
- [ZFS](https://openzfs.org/) – redundantti levyjärjestelmä ja tiedostojärjestelmä  
- [VirtualBox](https://www.virtualbox.org/) – virtualisointialusta NixOS:n ajamiseen Windowsissa  
- [Git & GitHub](https://github.com/) – versionhallinta
- [Samba](https://www.samba.org/) - tiedostojen jakopalvelu Windows-verkkoon
- SSH - etäyhteys NixOS:iin

## Arkkitehtuuri
<img width="885" height="729" alt="kuva" src="https://github.com/user-attachments/assets/8c9c0f5d-13d5-4689-abad-74e4f9d984f4" />

## Tekijät
- **Miki Meklin**
- **Ville Käsmä**
