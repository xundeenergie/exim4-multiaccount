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
* DKIM-Support für mehrere Mailprovider
* in /etc/exim4/conf.d/acl/00_exim4-config_header als erste Zeile 
	acl_smtp_dkim = acl_check_dkim
  einfügen
* Um DKIM für abgehende Emails zu aktivieren
	/usr/local/bin/mkexim4-dkim domain.tld
  ausführen. Es werden Zertifikat und Public-Key in /etc/exim4/dkim erzeugt. Die Ausgabe des Programms liefert bereits den korrekten TXT-Eintrag für den DNS-Server.

