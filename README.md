# exim4-multiaccount


__ACHTUNG !!!
Das Format und der Name der config-Datei für die Zuordnung von smarthost und credentials zu Absenderadressen hat sich geändert!!!
ACHTUNG!!!__

Exim ist in der Debian-Grundkonfiguration nur für mehrere User auf einem einzigen Smarthost eingerichtet.
Diese Konfiguration erweitert die Möglichkeiten von exim4, dass mehrere User auf unterschiedlichen Smarthosts mit unterschiedlichen smtp-servern und login-Daten abhängig von der Senderadresse die Mails über diesen Mailserver senden können. (Z.B. Mehrere Identitäten in Thunderbird/Icedove, aber nur ein einziger SMTP-Server localhost auf dem exim4 läuft)

## Installation
* Dateien in die entsprechenden Verzeichnisse kopieren.
* /etc/exim4/client.multismarthost_multiaccount.passwd.example als Vorlage verwenden und das .example am Ende des Dateinamens entfernen
* in /etc/exim4/client.multismarthost_multiaccount.passwd mit Doppelpunkt getrennt die Daten eintragen.
	absender.email@domain.tld:commaseparated,list,of,loginusers:smtp.server.tld:Portnummer:login.name@domain.tld:verysecretpassword
* im zweiten Feld muss eine kommaseparierte Liste der smtp-user angegeben werden, welche diese Absenderadresse verwenden dürfen. Normalerweise wird nur ein Username eingetragen sein.
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

## Lokale Kopie der gesendeten Emails
Damit von jedem gesendeten Email (egal über welchen Client) eine Kopie im "Gesendet"-Ordner am Imap-Server gespeichert wird, ist das Makro zu setzen
    
    LOCAL_SENT_COPY = true

Damit wird der Router "local_user_copy" aktiviert.
Dieser Router fügt automatisch eine Header-Zeile "X-Local-Sent-Copy: true" ein und redirected das Mail an den authentifizierten SMTP/IMAP-User.

Damit dieses Mail auch tatsächlich in den Gesendet-Ordner kommt, muss im Imap-Server auf diese Headerzeile gefiltert werden.

Für Sieve aus dovecot könnte diese Regel so aussehen (so soweit wie möglich am Beginn, am besten als allererste Regel stehen):

    if header :contains "X-Local-Sent-Copy" "true"
    {fileinto "INBOX/Sent"; setflag "\\seen"; addflag "$label3"; stop;}

Diese Regel setzt gleichzeitig das gesehen-Flag und das Label3 (persönlich) für Thunderbird. Diese beiden Direktiven funktionieren hier aber noch nicht korrekt. (Debugging ist notwendig!!!)

