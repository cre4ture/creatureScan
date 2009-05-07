unit Languages;

interface

uses inifiles, Forms, windows, StdCtrls, Buttons, Menus, ComCtrls, SysUtils,
  VirtualTrees;

Type
  TLangAction = (laLoad, laSave, laNone);

const
  Aktion = laLoad;

  SaveCaptions = False;
  LoadCaptions = True;

var
  LangFile: String;

const
  //generell
  STR_Sprache: String = 'Deutsch_Muster';
  STR_Metall: string = 'Metall';
  STR_Kristall: string = 'Kristall';
  STR_Deuterium: string = 'Deuterium';
  STR_Energie: string = 'Energie';
  STR_Mond: string = 'Mond';
  STR_M_Mond: string = 'M';

  //ScanBericht
  STR_Z0: string = 'Rohstoffe auf ';
  STR_Z1: string = 'am ';

  //Sonnensystem
  STR_Sonnensystem: string = 'Sonnensystem ';

  //Main
  STR_Scanberichte: string = 'Scanberichte';
  STR_Systeme: string = 'Systeme';
  STR_Scans_gespeichert: string = 'Scans gespeichert!';
  STR_konnte_keine_Scans_suslesen: string = 'Fehler: Konnte keine Scans auslesen!';
  STR_SysImportFertig_loeschn: string = 'Der Import der alten Sonnensystemdaten ist abgeschlossen. Soll die alte Datei gelöscht werden? Sie wird normalerweise nichtmehr benötigt!';
  STR_ScanImportFertig_loeschn: string = 'Der Import der alten Spionagedaten ist abgeschlossen. Soll die alte Datei gelöscht werden? Sie wird normalerweise nichtmehr benötigt!';
  STR_MSG_Cant_ReadFlyTime: string = 'Fehler beim einlesen der Flugzeit!';

  STR_Neue_Version: string = 'Neue Version';
  STR_MSG_aktuellste_Version: string = 'Du verwendest die aktuellste Version!';
  STR_MSG_aktuellere_Version: string = 'Es gibt eine neuere Version: ';
  STR_ASK_Homepage_oeffnen: string = 'Soll die Homepage geöffnet werden?';
  STR_MSG_konnte_aktuellste_Version_nicht_ermitteln: string = 'Die aktuellste Version konnte nicht ermittelt werden!';
  STR_Scans_Loeschen_title: string = 'Scans Löschen?';
  STR_Scans_Loeschen_text: string = 'Soll(en) der/die Scan(s) wirklich gelöscht werden?';

  //Connections
  STR_Fertig: string = 'Fertig!';
  STR_Laed: string = 'Läd:';
  STR_Fehler: string = '<Fehler!>';  //auch in Group_Rights Verwendet
  STR_Nicht_verbunden: string = '<Nicht verbunden!>';
                                                                                   
  //Suche
  STR_Stopp: string = 'Stopp';
  STR_Ergebnisse: string = 'Ergebnisse: ';
  STR_Suchen: string = 'Suchen';
  STR_MSG_keine_Suchkriterien: string = 'Keine Suchkriterien eingegeben!';
  STR_stat_i: string = 'i';
  STR_stat_I_2: string = 'I';
  STR_stat_g: string = 'g';
  STR_Suche_Galaxien: string = ' Durchsuche folgende Galaxien: ';

  //Galaxie_Explorer
  STR_Datum: string = ' Datum: ';
  STR_normal: string = ' <normal>';
  STR_topmost: string = '<topmost>';
  STR_Ally_Suchen: string = 'Ally suchen bei ';
  STR_Player_Suchen: string = 'Player suchen bei ';
  STR_Punkte: string = 'Punkte: ';
  STR_Fleet: string = ' Flotte: ';
  STR_Ally: string = ' Allianz: ';
  STR_Truemmerfeld_frmt_explorer: string = '%.0n Metall %.0n Kristall ~ %.0n Recycler';

  //Prog_Unit
  STR_MSG_Initfiles_fehlen: string = 'Sorry, es fehlen Initfiles!';
  STR_MSG_ScanBerichtObjekte_Fehlen_IniDatei: String = 'Es sind zuwenig ScanberichtObjekte in der IniDatei! Bitte anderes PluginPaket wählen!';
  STR_MSG_SprachEinleseIniDatei_fehlerhaft: string = 'Sorry, die Spracheinleseinidatei ist fehlerhaft!';
  STR_MSG_Falsches_Universum: string = 'Die Datei ist aus einem falschen Universum!' + #13 + #10
                                      +'Trotzdem Laden?' + #13 + #10
                                      +'Uni: ';
  STR_Importiere_Scanberichte: string = ' Importiere Scanberichte... ';
  STR_Importiere_Sonnensysteme: string = ' Importiere Sonnensysteme... ';
  STR_MSG_keine_creatureScan_datei: string = 'Diese Datei ist entweder keine creatureScan-Datei, oder die Version wird nicht unterstützt!';
  STR_Datei_hat_falsches_Universum_wird_geloescht: string = 'Die Datei: "%s" hat ein anderes Universum als der aktuelle Benutzer und wird gelöscht!';
  STR_Scanberichtdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet: string = 'Die Scanberichtdatei konnte nicht geöffnet werden! Das Programm wird Beendet!';
  STR_Sonnensystemdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet: string = 'Die Sonnensystemdatei konnte nicht geöffnet werden! Das Programm wird Beendet!';
  STR_vllt_andere_Instanz: string = 'Womöglich ist schon eine Version des creatureScans geöffnet, die auf diese Datei zugreift!' + #13 + #10 +
                                    'Falls dies nicht der Fall ist, empfehle ich einen Neustart des Computers!';
  STR_MSG_Old_Dll: string = 'Die PluginDLL ist älter/neuer als für diese Version vorgesehen! Sie könnte nicht richtig funktionieren!';

  //Bericht_Frame
  STR_Last24Hours: string = 'Raid last 24h: ';
  STR_NextRaid: string = 'Raid in ';
  STR_ByPlayer: string = ' von ';
  STR_Spionageabwehr_kurz: string = ' s.a.';
  STR_Scanner: string = 'von: ';
  STR_Besitzer: string = ' Besitzer: ';
  STR_Not_Awailable: string = 'n/a';
  STR_Tage: string = ' Tage ';  //auch bei Favoriten verwendet!
  STR_Alter: string = 'Alter: ';
  STR_Produktion: string = 'Produktion/h';
  STR_Truemmerfeld_frmt: string = ' TF: %.0n Metall %.0n Kristall ~ %.0n Recycler';

  //Einstellungen
  STR_gibt_Basispunkte: string = ' gibt soviele Basispunkte:';
  STR_Erst_Nach_neustart_Wirksam: string = 'Diese Einstellung wird erst nach dem Neustart des Programms komplett wirksam!';
  STR_Scan_Raid_Rechte: string = ' Scan/Raid - Rechte für folgende Galaxien: ';
  STR_Sonnensystem_Rechte: string = ' Sonnensystem - Rechte für folgende Galaxien: ';
  STR_Farben_eigene_Punkte: string = 'eigene Punktzahl';
  STR_Farben_mehr_als: string = 'Mehr als ';
  STR_Farben_punkte_unterschied_rotgruen: string = ' Punkte Unterschied ist komplett rot/grün:';
  STR_Farben_Aelter_als: string = 'Älter als ';
  STR_Farben_Stunden_rot: string = ' Stunden wird komplett rot angezeigt:';

  //Export
  STR_MSG_Export_Help: string =
              'Eingabemöglichkeiten für die Bereiche:' +#13 +#10 +
              ' - einfache Eingabe der Nummer: zb: 1:489:12' +#13 +#10 +
              ' - Bereiche mit Bindestrichen: zb: 1-5:100-300:4-7  dabei muss immer die erste Zahl die kleinere sein!' +#13 +#10 +
              ' - Alle mit X: X:X:X -> steht dann quasi für 1-9:1-499:1-15' +#13 +#10 +#13 +#10 +
              'Sinnvoll wird das ganze natürlich nur durch Kombination:' +#13 +#10 +
              '   1:X:X -> alle Scans/Systeme in der 1. Galaxie' +#13 +#10 +
              '   1-5:X:X -> alle Scans/Systeme der 1., 2., 3., 4. und 5. Galaxie' +#13 +#10 +
              '   9:300-499:X -> alle Scans/Systeme in Galaxie 9 von System 300 bis 499';
  STR_Bereich_fehlerhaft: string = 'Die Bereichsangabe ist fehlerhaft! für Hilfe klicke auf den Knopf mit dem "?"';
  STR_Export_Erfolgreich: string = 'Export erfolgreich!';
  STR_Export_Fehlgeschlagen: string = 'Export fehlgeschlagen!';

  //Favoriten
  STR_Anzahl: string = 'Anzahl: ';
  STR_Hinzufuegen: string = 'Hinzufügen...';
  STR_Maximales_Alter: string = 'maximales Alter in Minuten:';
  STR_auf: string = ' auf ';
  STR_KEINFILTER: string = '<none>';

  //Group_Rights
  STR_neu: string = 'neu';

  //Notizen
  STR_Notiz: string = 'Notiz';
  STR_Allianz: String = 'Allianz:';
  STR_Spieler: string = 'Spieler:';
  STR_Planet: string = 'Planet:';
  STR_Bild_mit_Falscher_groesse: string = 'Das ausgewählte Bild hat nicht die erforderlichen Maße!';
  STR_Images_Name0: String = 'Allgemein';
  STR_Images_Name1: String = 'Farm';
  STR_Images_Name2: String = 'Eigene Allianz/Verbündet';
  STR_Images_Name3: String = 'Böse/Feind';
  STR_Images_Name4: String = 'Achtung! Sehr viele Punkte';
  STR_Images_Name5: String = 'Noob';
  STR_Images_Name6: String = 'Krieg';

  //Notizen_Images_Einstellungen
  STR_MSG_Alle_Bilder_Del: String = 'Alle Bilder/Typen löschen?';
  STR_MSG_Standart_Images: string = 'Alle Bilder/Typen löschen und standart Laden?';

  //suchen_ersetzen
  STR_alles_ausfuellen: string = 'Bitte alles ausfüllen!';

  //Marker
  STR_Marker_Eintrag_markieren: string = 'Wähle zuerst einen Eintrag in der Liste aus!';

  //Connect
  STR_MSG_kein_port_eingegeben: string = 'Es wurde kein Port eingegeben!';

  //Raid_List
  STR_RAID_editieren: string = 'Raid Bearbeiten';
  STR_ungueltige_eingabe: string = 'Ungültige Eingabe!';

  //SelectLanguage
  STR_MSG_Plugin_Help: String = 'Es gibt verschiedene Plugins zum Einlesen der Scanberichte und Galaxien. Standart ist "de_mozilla" das heist aber nicht, dass dieses Plugin nur mit Mozilla funktionert, sondern das ich es damit getestet habe!';

  //Delete_Scans
  STR_MSG_Del_Text: string = 'Löschvorgang starten?';
  STR_MSG_Del_Caption: String = 'Löschen...';

  //cS_XML
  STR_Import_XML: string = ' Importiere XML-Daten... ';

  //ChatFenster
  STR_ChatFenster_Caption: string = 'cS Chatfenster: %s - Uni %d';

procedure LanguageFile(IniFile: String);
function SelectLanguageDialog: Boolean;
procedure SaveAllCaptions(Form: TForm; Filename: string);
procedure LoadAllCaptions(Form: TForm; Filename: String);
function Entf_X(S: String): string;

implementation

uses SelectLanguage;

procedure LanguageFile(IniFile: String);
var ini: TMemIniFile;
    Section: string;
procedure EncodeStr(var s: string);
var p: integer;
begin
  p := pos(#13+#10,s);
  while p > 0 do
  begin
    s := copy(s,1,p-1) + '/ret' + copy(s,p+2,9999);
    p := pos(#13+#10,s);
  end;

  s := '"'+s+'"';
end;
procedure DecodeSTR(var s: string);
var p: integer;
begin
  p := pos('/ret',s);
  while p > 0 do
  begin
    s := copy(s,1,p-1) + #13+#10 + copy(s,p+4,9999);
    p := pos('/ret',s);
  end;
  
  if (s[1] = '"')and(s[length(s)] = '"') then
    s := copy(s,2,length(s)-2);
end;
procedure IniAction(Ident: string; var Value: string; Aktion: TLangAction);
var sv: string;
begin
  if Aktion = laLoad then
  begin
    Value := ini.ReadString(Section,Ident,Value);
    DecodeStr(Value);
  end
  else
  begin
    sv := Value;
    EncodeStr(sv);
    ini.WriteString(Section,Ident,sv);
  end;
end;
begin
  if aktion = laNone then exit;
  ini := TMemIniFile.Create(IniFile);

  Section := 'generell';
  IniAction('STR_Sprache', STR_Sprache,Aktion);
  IniAction('STR_Metall', STR_Metall,Aktion);
  IniAction('STR_Kristall', STR_Kristall,Aktion);
  IniAction('STR_Deuterium', STR_Deuterium,Aktion);
  IniAction('STR_Energie', STR_Energie,Aktion);
  IniAction('STR_Mond', STR_Mond,Aktion);
  IniAction('STR_M_Mond', STR_M_Mond,Aktion);

  Section := 'ScanBericht';
  IniAction('STR_Z0', STR_Z0,Aktion);
  IniAction('STR_Z1', STR_Z1,Aktion);

  Section := 'Sonnensystem';
  IniAction('STR_Sonnensystem', STR_Sonnensystem,Aktion);

  Section := 'Main';
  IniAction('STR_Scanberichte', STR_Scanberichte,Aktion);
  IniAction('STR_Systeme', STR_Systeme,Aktion);
  IniAction('STR_Scans_gespeichert', STR_Scans_gespeichert,Aktion);
  IniAction('STR_konnte_keine_Scans_suslesen', STR_konnte_keine_Scans_suslesen,Aktion);
  IniAction('STR_SysImportFertig_loeschn', STR_SysImportFertig_loeschn,Aktion);
  IniAction('STR_ScanImportFertig_loeschn', STR_ScanImportFertig_loeschn,Aktion);
  IniAction('STR_MSG_Cant_ReadFlyTime', STR_MSG_Cant_ReadFlyTime,Aktion);

  IniAction('STR_Neue_Version', STR_Neue_Version,Aktion);
  IniAction('STR_MSG_aktuellste_Version', STR_MSG_aktuellste_Version,Aktion);
  IniAction('STR_MSG_aktuellere_Version', STR_MSG_aktuellere_Version,Aktion);
  IniAction('STR_ASK_Homepage_oeffnen', STR_ASK_Homepage_oeffnen,Aktion);
  IniAction('STR_MSG_konnte_aktuellste_Version_nicht_ermitteln', STR_MSG_konnte_aktuellste_Version_nicht_ermitteln,Aktion);

  Section := 'Connections';
  IniAction('STR_Fertig', STR_Fertig,Aktion);
  IniAction('STR_Laed', STR_Laed,Aktion);
  IniAction('STR_Fehler', STR_Fehler,Aktion);
  IniAction('STR_Nicht_verbunden', STR_Nicht_verbunden,Aktion);
                                                                                   
  Section := 'Suche';
  IniAction('STR_Stopp', STR_Stopp,Aktion);
  IniAction('STR_Ergebnisse', STR_Ergebnisse,Aktion);
  IniAction('STR_Suchen', STR_Suchen,Aktion);
  IniAction('STR_MSG_keine_Suchkriterien', STR_MSG_keine_Suchkriterien,Aktion);
  IniAction('STR_stat_i', STR_stat_i,Aktion);
  IniAction('STR_stat_I_2', STR_stat_I_2,Aktion);
  IniAction('STR_stat_g', STR_stat_g,Aktion);
  IniAction('STR_Suche_Galaxien', STR_Suche_Galaxien,Aktion);

  Section := 'Galaxie_Explorer';
  IniAction('STR_Datum', STR_Datum,Aktion);
  IniAction('STR_normal', STR_normal,Aktion);
  IniAction('STR_topmost', STR_topmost,Aktion);
  IniAction('STR_Ally_Suchen', STR_Ally_Suchen,Aktion);
  IniAction('STR_Player_Suchen', STR_Player_Suchen,Aktion);
  IniAction('STR_Punkte', STR_Punkte,Aktion);
  IniAction('STR_Fleet', STR_Fleet,Aktion);
  IniAction('STR_Ally', STR_Ally,Aktion);
  IniAction('STR_Truemmerfeld_frmt_explorer', STR_Truemmerfeld_frmt_explorer,Aktion);

  Section := 'Prog_Unit';
  IniAction('STR_MSG_Initfiles_fehlen', STR_MSG_Initfiles_fehlen,Aktion);
  IniAction('STR_MSG_ScanBerichtObjekte_Fehlen_IniDatei', STR_MSG_ScanBerichtObjekte_Fehlen_IniDatei,Aktion);
  IniAction('STR_MSG_SprachEinleseIniDatei_fehlerhaft', STR_MSG_SprachEinleseIniDatei_fehlerhaft,Aktion);
  IniAction('STR_MSG_Falsches_Universum', STR_MSG_Falsches_Universum,Aktion);


  IniAction('STR_Importiere_Scanberichte', STR_Importiere_Scanberichte,Aktion);
  IniAction('STR_Importiere_Sonnensysteme', STR_Importiere_Sonnensysteme,Aktion);
  IniAction('STR_MSG_keine_creatureScan_datei', STR_MSG_keine_creatureScan_datei,Aktion);
  IniAction('STR_Datei_hat_falsches_Universum_wird_geloescht', STR_Datei_hat_falsches_Universum_wird_geloescht,Aktion);
  IniAction('STR_Scanberichtdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet', STR_Scanberichtdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet,Aktion);
  IniAction('STR_Sonnensystemdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet', STR_Sonnensystemdatei_konnte_nicht_geoeffnetwerden_Prog_wird_beendet,Aktion);
  IniAction('STR_vllt_andere_Instanz', STR_vllt_andere_Instanz,Aktion);

  IniAction('STR_MSG_Old_Dll', STR_MSG_Old_Dll,Aktion);

  Section := 'Bericht_Frame';
  IniAction('STR_Last24Hours', STR_Last24Hours,Aktion);
  IniAction('STR_NextRaid', STR_NextRaid,Aktion);
  IniAction('STR_ByPlayer', STR_ByPlayer,Aktion);
  IniAction('STR_Spionageabwehr_kurz', STR_Spionageabwehr_kurz,Aktion);
  IniAction('STR_Scanner', STR_Scanner,Aktion);
  IniAction('STR_Besitzer', STR_Besitzer,Aktion);
  IniAction('STR_Not_Awailable', STR_Not_Awailable,Aktion);
  IniAction('STR_Tage', STR_Tage,Aktion);
  IniAction('STR_Alter', STR_Alter,Aktion);
  IniAction('STR_Produktion', STR_Produktion,Aktion);
  IniAction('STR_Truemmerfeld_frmt', STR_Truemmerfeld_frmt,Aktion);

  Section := 'Einstellungen';
  IniAction('STR_gibt_Basispunkte', STR_gibt_Basispunkte,Aktion);
  IniAction('STR_Erst_Nach_neustart_Wirksam', STR_Erst_Nach_neustart_Wirksam,Aktion);
  IniAction('STR_Scan_Raid_Rechte', STR_Scan_Raid_Rechte,Aktion);
  IniAction('STR_Sonnensystem_Rechte', STR_Sonnensystem_Rechte,Aktion);
  IniAction('STR_Farben_eigene_Punkte', STR_Farben_eigene_Punkte,Aktion);
  IniAction('STR_Farben_mehr_als', STR_Farben_mehr_als,Aktion);
  IniAction('STR_Farben_punkte_unterschied_rotgruen', STR_Farben_punkte_unterschied_rotgruen,Aktion);
  IniAction('STR_Farben_Aelter_als', STR_Farben_Aelter_als,Aktion);
  IniAction('STR_Farben_Stunden_rot', STR_Farben_Stunden_rot,Aktion);

  Section := 'Export';
  IniAction('STR_MSG_Export_Help', STR_MSG_Export_Help,Aktion);

  IniAction('STR_Bereich_fehlerhaft', STR_Bereich_fehlerhaft,Aktion);
  IniAction('STR_Export_Erfolgreich', STR_Export_Erfolgreich,Aktion);
  IniAction('STR_Export_Fehlgeschlagen', STR_Export_Fehlgeschlagen,Aktion);

  Section := 'Favoriten';
  IniAction('STR_Anzahl', STR_Anzahl,Aktion);
  IniAction('STR_Hinzufuegen', STR_Hinzufuegen,Aktion);
  IniAction('STR_Maximales_Alter', STR_Maximales_Alter,Aktion);
  IniAction('STR_auf', STR_auf,Aktion);

  Section := 'Group_Rights';
  IniAction('STR_neu', STR_neu,Aktion);

  Section := 'Notizen';
  IniAction('STR_Notiz', STR_Notiz,Aktion);
  IniAction('STR_Allianz', STR_Allianz,Aktion);
  IniAction('STR_Spieler', STR_Spieler,Aktion);
  IniAction('STR_Planet', STR_Planet,Aktion);
  IniAction('STR_Bild_mit_Falscher_groesse', STR_Bild_mit_Falscher_groesse,Aktion);
  IniAction('STR_Images_Name0', STR_Images_Name0,Aktion);
  IniAction('STR_Images_Name1', STR_Images_Name1,Aktion);
  IniAction('STR_Images_Name2', STR_Images_Name2,Aktion);
  IniAction('STR_Images_Name3', STR_Images_Name3,Aktion);
  IniAction('STR_Images_Name4', STR_Images_Name4,Aktion);
  IniAction('STR_Images_Name5', STR_Images_Name5,Aktion);
  IniAction('STR_Images_Name6', STR_Images_Name6,Aktion);

  Section := 'Notizen_Images_Einstellungen';
  IniAction('STR_MSG_Alle_Bilder_Del', STR_MSG_Alle_Bilder_Del,Aktion);
  IniAction('STR_MSG_Standart_Images', STR_MSG_Standart_Images,Aktion);

  Section := 'suchen_ersetzen';
  IniAction('STR_alles_ausfuellen', STR_alles_ausfuellen,Aktion);

  Section := 'Marker';
  IniAction('STR_Marker_Eintrag_markieren', STR_Marker_Eintrag_markieren,Aktion);

  Section := 'Connect';
  IniAction('STR_MSG_kein_port_eingegeben', STR_MSG_kein_port_eingegeben,Aktion);

  Section := 'Raid_List';
  IniAction('STR_RAID_editieren', STR_RAID_editieren,Aktion);
  IniAction('STR_ungueltige_eingabe', STR_ungueltige_eingabe,Aktion);

  Section := 'SelectLanguage';
  IniAction('STR_MSG_Plugin_Help', STR_MSG_Plugin_Help,Aktion);

  Section := 'Delete_Scans';
  IniAction('STR_MSG_Del_Text', STR_MSG_Del_Text,Aktion);
  IniAction('STR_MSG_Del_Caption', STR_MSG_Del_Caption,Aktion);

  Section := 'cS_XML';
  IniAction('STR_Import_XML', STR_Import_XML,Aktion);

  Section := 'ChatFenster';
  IniAction('STR_ChatFenster_Caption', STR_ChatFenster_Caption,Aktion);


  if Aktion = laSave then Ini.UpdateFile;
  ini.free;
end;

function SelectLanguageDialog: Boolean;
var dialog: TFRM_SelectLanguage;
begin
  dialog := TFRM_SelectLanguage.Create(Application);
  dialog.LanguageFile := LangFile;
  Result := (dialog.ShowModal = idOK);
  LangFile := dialog.LanguageFile;
  dialog.free;
end;

function Entf_X(S: String): string; //Siehe SaveAllCaptions/LoadAllCaptions
var i: integer;
begin
  Result := S;
  for i := length(S) downto 0 do
  begin
    if not(s[i] in ['0'..'9','_']) then
      Break;
    if s[i] = '_' then
    begin
      Result := copy(s,1,i-1);
      Break;
    end;
  end;
end;

procedure SaveAllCaptions(Form: TForm; Filename: string);
var i,j: integer;
    ini: TMemIniFile;
    ParentName: String;
begin
 ChDir(ExtractFilePath(Application.ExeName));
 with Form do
 begin
  ParentName := Entf_X(Name);  // bei meheren formen der gleichen klasse (zb. beim explorer) wird immer ein "_1" dazugebaut (zb. "FRM_explorer_1") das muss entfernt werden!
  ini := TMemIniFile.Create(Filename);
  ini.WriteString(ParentName,ParentName+'.Caption',Caption);
  for i := 0 to ComponentCount-1 do
  begin
    try
      if (Components[i] is TLabel) then
        with Components[i] as TLabel do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TSpeedButton) then
        with Components[i] as TSpeedButton do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TButton) then
        with Components[i] as TButton do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TCheckBox) then
        with Components[i] as TCheckBox do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TMenuItem) then
        with Components[i] as TMenuItem do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TStatusBar) then
        with Components[i] as TStatusBar do
        begin
          for j := 0 to Panels.Count-1 do
            ini.WriteString(ParentName,Name+'.['+inttostr(j)+']Text',Panels[j].Text);
        end else
      if (Components[i] is TListView) then
        with Components[i] as TListView do
        begin
          for j := 0 to Columns.Count-1 do
            ini.WriteString(ParentName,Name+'.['+inttostr(j)+']Caption',Columns[j].Caption);
        end else
      if (Components[i] is TGroupBox) then
        with Components[i] as TGroupBox do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TTabSheet) then
        with Components[i] as TTabSheet do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TRadioButton) then
        with Components[i] as TRadioButton do
        begin
          ini.WriteString(ParentName,Name+'.Caption',Caption);
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
      if (Components[i] is TVirtualStringTree) then
        with Components[i] as TVirtualStringTree do
        begin
          for j := 0 to Header.Columns.Count-1 do
            ini.WriteString(ParentName,Name + '.[' + IntToStr(j) + ']Caption',Header.Columns[j].Text);
        end else
      if (Components[i] is TComboBox) then
        with Components[i] as TComboBox do
        begin
          ini.WriteString(ParentName,Name+'.Hint',Hint);
        end else
    except
    end;
  end;
  ini.UpdateFile;
  ini.free;
 end;
end;

procedure LoadAllCaptions(Form: TForm; Filename: String);
var i,j: integer;
    ini: TMemIniFile;
    ParentName: String;
begin
 ChDir(ExtractFilePath(Application.ExeName)); 
 with Form do
 begin
  ParentName := Entf_X(Name);
  ini := TMemIniFile.Create(Filename);
  Caption := ini.ReadString(ParentName,ParentName+'.Caption',Caption);
  for i := 0 to ComponentCount-1 do
  begin
    try
      if (Components[i] is TLabel) then
        with Components[i] as TLabel do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TSpeedButton) then
        with Components[i] as TSpeedButton do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TButton) then
        with Components[i] as TButton do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TCheckBox) then
        with Components[i] as TCheckBox do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TMenuItem) then
        with Components[i] as TMenuItem do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TStatusBar) then
        with Components[i] as TStatusBar do
        begin
          for j := 0 to Panels.Count-1 do
            Panels[j].Text := ini.ReadString(ParentName,Name+'.['+inttostr(j)+']Text',Panels[j].Text);
        end else
      if (Components[i] is TListView) then
        with Components[i] as TListView do
        begin
          for j := 0 to Columns.Count-1 do
            Columns[j].Caption := ini.ReadString(ParentName,Name+'.['+inttostr(j)+']Caption',Columns[j].Caption);
        end else
      if (Components[i] is TGroupBox) then
        with Components[i] as TGroupBox do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TTabSheet) then
        with Components[i] as TTabSheet do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TRadioButton) then
        with Components[i] as TRadioButton do
        begin
          Caption := ini.ReadString(ParentName,Name+'.Caption',Caption);
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
      if (Components[i] is TVirtualStringTree) then
        with Components[i] as TVirtualStringTree do
        begin
          for j := 0 to Header.Columns.Count-1 do
            Header.Columns[j].Text := ini.ReadString(ParentName,Name + '.[' + IntToStr(j) + ']Caption',Header.Columns[j].Text);
        end else
      if (Components[i] is TComboBox) then
        with Components[i] as TComboBox do
        begin
          Hint := ini.ReadString(ParentName,Name+'.Hint',Hint);
          ShowHint := Hint <> '';
        end else
    except
    end;
  end;
  ini.free;
 end;
end;

end.
