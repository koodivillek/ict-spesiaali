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
- VirtualBoxissa Settings -> Network -> Port Forwarding: Protocol: TCP, Host Port: 2222, Guest Port: 22
- SSH yhdistäminen onnistui windowsin komentokehotteessa:
  ssh -p 2222 käyttäjä@127.0.0.1

## Jellyfin asennus
- Jellyfin otettiin käyttöön muokkaamalla `configuration.nix`-tiedostoa ja sallimalla tarvittavat palomuuriportit.
- Konfiguraatio rakennettiin uudelleen ja Jellyfin-palvelu käynnistettiin.
- Jellyfinin hallintapaneeli avattiin selaimessa osoitteessa `http://127.0.0.1:8096`.
- Ensimmäisellä kirjautumiskerralla luotiin admin-käyttäjä ja salasana.

## Media files
- Luotiin erillinen hakemisto Jellyfinin mediatiedostoja varten, koska kotihakemistoon ei ollut riittäviä käyttöoikeuksia.
- Kopioitiin testielokuva Windows-hostilta virtuaalikoneeseen ja siirrettiin se Jellyfinin käyttämään hakemistoon.
- Jellyfinin web-käyttöliittymässä lisättiin uusi *Elokuvat*-kirjasto ja testielokuva saatiin näkyviin sekä toistettua.
- Tämä ratkaisu tehtiin vain kokeilua varten. Myöhemmin mediakirjasto tullaan toteuttamaan hyödyntämällä ZFS-pohjaista levyjärjestelmää.

### VirtualBox-porttiohjaus Jellyfinille
- VirtualBoxin asetuksia muokattiin siten, että Jellyfinin portti ohjattiin hostille.
- Tämä mahdollisti Jellyfinin käytön myös Windows-hostin selaimesta osoitteessa `http://127.0.0.1:8096`.

