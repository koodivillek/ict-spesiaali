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
<img width="765" height="740" alt="kuva" src="https://github.com/user-attachments/assets/c3b2f97a-bc26-47d9-8ff2-fcfb7ed7334e" />

## Tekijät
- **Miki Meklin**
- **Ville Käsmä**
