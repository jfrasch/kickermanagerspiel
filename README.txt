Optimierungsprogramm fuer das Kicker Manager Spiel
==================================================

von Janick Frasch, Dennis Janka, Robert Kircheis und Sebastian Sager

Interdisziplinäres Zentrum für Wissenschaftliches Rechnen
Universität Heidelberg 
INF 368, 69120 Heidelberg


Installation
============
Windows:
Zunaechst muss das Programm GLPK (GNU Linear Programming Kit), unter "c:\Programme\GnuWin32\" installiert werden. 
Dazu fuehrt man die mitgelieferte Datei glpk-4.34-setup.exe aus und 
uebernimmt bei der Installation die vorgegebenen Standardeinstellungen.
Nun kann das Programm mittels Doppelklick auf kickermanager.exe gestartet werden.

Linux:
Unter Linux muss man die entsprechende Version des GLPK unter http://www.gnu.org/s/glpk/ herunterladen, 
installieren und sicherstellen, dass der Befehl "glpsol" global ausfuehrbar ist.
Dann wechselt man in der Konsole in den Ordner, in der sich die entpackten Dateien befinden und fuehrt dort
"python kickermanager.py" aus, um das Programm zu starten.


Bedienung
=========
Die Ein- und Ausgabe erfolgt ueber Textdateien. 
Diese sind im .csv (Comma Separated Value) Format abgespeichert und koennen sowohl mit einem Texteditor 
als auch mit einer Tabellenkalkulationssoftware wie Microsoft Excel oder OpenOffice Calc bearbeitet werden.
Wichtig: Bei der Bearbeitung mit (z.B.) Excel muss darauf geachtet werden, 
dass als Trennungszeichen der Tabulator angegeben wird!
Im Unterordner \data befinden sich die Listen mit allen verfuegbaren Spielern:
    
    goalie.csv - Torhueter
    defender.csv - Verteidiger
    midfielder.csv - Mittelfeldspieler
    striker.csv - Stuermer

Zur Modifikation bestimmt ist nur die letzte Spalte (Gewichtung Spieler): 
Hier kann man die vermutete Veraenderung der Punktzahl eines Spielers im Vergleich zum Vorjahr angeben,
z.B. bedeutet 1,5, man vermutet, der Spieler erhaelt in dieser Saison 50% mehr Punkte als im vorigen Jahr.
0,5 hingegen bedeutet, dass man einem Spieler nur die Haelfte der Punkte zutraut, die er in der Saison
2010/2011 geholt hat.
Des weiteren gibt es die folgenden Dateien:

    teamweights.csv - Gewichtungsfaktoren fuer die Teams
    divisionScaling.csv - Gewichtungsfaktoren fuer die Ligen

In teamweights.csv kann man - ebenso wie in den Spielerlisten - Faktoren fuer ALLE Spieler einer Mannschaft angeben.
In divisionScaling.csv koennen Gewichtungsfaktoren fuer andere Ligen festgelegt werden. 
Bei Spielern, die im vergangenen Jahr in der zweiten Liga gespielt haben, sind in den Listen die Punkte 
fuer das Zweitligamanagerspiel des letzten Jahres angegeben. Naturgemaess erwartet man von den meisten
dieser Spieler, dass sie in der ersten Bundesliga weniger Punkte sammeln werden, was durch den entsprechenden
Gewichtungsfaktor ausgedrueckt wird.
Besondere Beachtung verdient hierbei der Auslandsfaktor: 
Fuer Spieler, die dieses Jahr aus dem Ausland in die Bundesliga gewechselt sind (z.B. Jerome Boateng)
sind keine Punkte aus dem vergangenen Jahr verfuegbar. Wir haben uns deshalb dafuer entschieden, 
ihnen virtuell Punkte zuzuweisen, die dem Durchschnitt der Punkte von Spielern mit vergleichbarem 
Preis im Kicker Manager Spiel entsprechen.

Hat man nun in den csv Dateien seine bevorzugte Gewichtung der Spieler und Teams vorgenommen, 
kann man per Doppelklick auf kickermanager.exe (Linux: "python kickermanager.py") die Optimierung starten.
Die Ergebnisse sind dann hinterher im Unterordner \results einsehbar.
In den Dateien best11.txt, best14.txt und best22.txt 
sind jeweils die Kaderzusammenstellungen fuer die besten 11, 14 beziehungsweise 22 Spieler aufgelistet.

