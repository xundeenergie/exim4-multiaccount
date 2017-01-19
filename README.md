# exim4-multiaccount

Exim ist in der Debian-Grundkonfiguration nur für mehrere User auf einem einzigen Smarthost eingerichtet.
Diese Konfiguration erweitert die Möglichkeiten von exim4, dass mehrere User auf unterschiedlichen Smarthosts mit unterschiedlichen smtp-servern und login-Daten abhängig von der Senderadresse die Mails über diesen Mailserver senden können. (Z.B. Mehrere Identitäten in Thunderbird/Icedove, aber nur ein einziger SMTP-Server localhost auf dem exim4 läuft)

## Installation
* Dateien in die entsprechenden Verzeichnisse kopieren.
* in /etc/exim4/sender.smarthost.passwd mit Doppelpunkt getrennt die Daten eintragen.
	absender.email@domain.tld:smtp.server.tld:login.name@domain.tld:verysecretpassword
* sudo systemctl restart exim4.service 
* /etc/email-addresses ergänzen
* /etc/exim4/conf.d/auth/30_exim4-config_examples - zur Gänze auskommentieren 


