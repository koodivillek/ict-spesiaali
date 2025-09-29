# Installation Instructions

## VirtualBox
- Asennettiin Oracle VirtualBox Windows-hostille.
- Luotiin uusi virtuaalikone (4 GB RAM, 40 GB levy).
- Liitettiin NixOS-ISO käynnistysmediana.

## NixOS asennus
- Asennus sujui graafisella työkalulla.
- Luotiin käyttäjä.
- Ensimmäisen rebootin jälkeen piti poistaa ISO VirtualBoxin asetuksista, muuten installer käynnistyi uudelleen.
- Käynnistys onnistui levylle.

## SSH-yhteys
- SSH otettiin käyttöön lisäämällä `configuration.nix`-tiedostoon:
  services.openssh.enable = true;
- SSH yhdistäminen onnistui windowsin komentokehotteessa:
  ssh -p 2222 käyttäjä@127.0.0.1
