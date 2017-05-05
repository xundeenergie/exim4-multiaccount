# exim4-multiaccount

Exim ist in der Debian-Grundkonfiguration nur für mehrere User auf einem einzigen Smarthost eingerichtet.
Diese Konfiguration erweitert die Möglichkeiten von exim4, dass mehrere User auf unterschiedlichen Smarthosts mit unterschiedlichen smtp-servern und login-Daten abhängig von der Senderadresse die Mails über diesen Mailserver senden können. (Z.B. Mehrere Identitäten in Thunderbird/Icedove, aber nur ein einziger SMTP-Server localhost auf dem exim4 läuft)

## Installation
* Dateien in die entsprechenden Verzeichnisse kopieren.
* in /etc/exim4/sender.multismarthost_multiaccount.passwd mit Doppelpunkt getrennt die Daten eintragen.
	absender.email@domain.tld:smtp.server.tld:login.name@domain.tld:verysecretpassword
* sudo systemctl restart exim4.service 
* /etc/email-addresses ergänzen
* /etc/exim4/conf.d/auth/30_exim4-config_examples - zur Gänze auskommentieren 

Damit die Multiaccount-Configuration aktiviert wird, in /etc/exim4/conf.d/main/002_localmacros_multiaccount
das Makro 

    MULTIACCOUNT = true 

setzen. Zum Deaktivieren (und wiederherstellen der originalen Debian-Konfiguration) MULTIACCOUNT löschen oder auskommentieren.

* DKIM-Support für mehrere Mailprovider
* in /etc/exim4/conf.d/acl/00_exim4-config_header als erste Zeile 
	acl_smtp_dkim = acl_check_dkim
  einfügen
* Um DKIM für abgehende Emails zu aktivieren
	/usr/local/bin/mkexim4-dkim domain.tld
  ausführen. Es werden Zertifikat und Public-Key in /etc/exim4/dkim erzeugt. Die Ausgabe des Programms liefert bereits den korrekten TXT-Eintrag für den DNS-Server.

## Dovecot-Delivery
Dieses Paket liefert bereits einen vorkonfigurierten Transport für Dovecot-Delivery mit
in update-exim4.conf.conf 

    dc_localdelivery='dovecot_delivery'

setzen.
Dovecot ist dementsprechend zu konfigurieren.
Wird dc_localdelivery nicht geändert, so verbleibt die Funktion von exim in der Standardkonfiguration.

## Bogofilter
Wenn bogofilter verwendet werden soll, so ist dies noch zu installieren und konfigurieren.
In Betrieb genommen kann bogofilter mit dem hier mitgelieferten Router und Transport werden, indem in /etc/exim4/conf.d/main/000_localmacros
    USE_BOGOFILTER = true
gesetzt wird. Deaktiviert wird bogofilter durch löschen oder auskommentieren des Makros USE_BOGOFILTER.

