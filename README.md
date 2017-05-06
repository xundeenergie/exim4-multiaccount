# exim4-multiaccount


__ACHTUNG !!!
Das Format und der Name der config-Datei für die Zuordnung von smarthost und credentials zu Absenderadressen hat sich geändert!!!
ACHTUNG!!!__

Exim ist in der Debian-Grundkonfiguration nur für mehrere User auf einem einzigen Smarthost eingerichtet.
Diese Konfiguration erweitert die Möglichkeiten von exim4, dass mehrere User auf unterschiedlichen Smarthosts mit unterschiedlichen smtp-servern und login-Daten abhängig von der Senderadresse die Mails über diesen Mailserver senden können. (Z.B. Mehrere Identitäten in Thunderbird/Icedove, aber nur ein einziger SMTP-Server localhost auf dem exim4 läuft)

## Installation
* Dateien in die entsprechenden Verzeichnisse kopieren.
* in /etc/exim4/sender.multismarthost_multiaccount.passwd mit Doppelpunkt getrennt die Daten eintragen.
	absender.email@domain.tld:smtp.server.tld:login.name@domain.tld:verysecretpassword
* sudo systemctl restart exim4.service 
* /etc/email-addresses ergänzen
* ~~/etc/exim4/conf.d/auth/30_exim4-config_examples - zur Gänze auskommentieren ~~
* Die originale Konfiguration der auth-examples aus der Debian-Installation wird nun über die Makro-Variable MULTIACCOUNT ein/ausgeschaltet.

Damit die Multiaccount-Configuration aktiviert wird, in /etc/exim4/conf.d/main/002_localmacros_multiaccount
das Makro 

    MULTIACCOUNT = true 

setzen. Zum Deaktivieren (und wiederherstellen der originalen Debian-Konfiguration) MULTIACCOUNT löschen oder auskommentieren.

Diese Konfiguration funktioniert offenbar nur mit kleinen aufgeteilten Konfigurationsfiles und nicht mit einem großen.
Dazu muss exim neu konfiguriert werden mit 
    
    dpkg-reconfigure exim4-config

und die Frage ob die Konfiguration auf mehrere kleine Files aufgeteilt werden soll mit "ja" beantworten. (Thanx to @lazyadmin111)

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

