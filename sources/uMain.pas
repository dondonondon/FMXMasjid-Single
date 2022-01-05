unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  System.ImageList, FMX.ImgList, System.Rtti, FMX.Grid.Style, FMX.ScrollBox,
  FMX.Grid,FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListBox, FMX.Ani, System.Threading,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Memo, FMX.Edit, FMX.SearchBox,
  {$IFDEF ANDROID}
    Androidapi.Helpers, FMX.Platform.Android, System.Android.Service, System.IOUtils,
    FMX.Helpers.Android, Androidapi.JNI.PlayServices, Androidapi.JNI.Os,
  {$ELSEIF Defined(MSWINDOWS)}

  {$ENDIF}
  System.Generics.Collections, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

const
  //FRAME
  AKUN          = 'AKUN';
  LOADING       = 'LOADING';
  HOME          = 'HOME';
  LOGIN         = 'LOGIN';
  FEED          = 'FEED';
  INFORMASI     = 'INFORMASI';
  KAJIAN        = 'KAJIAN';
  IMAM          = 'IMAM';
  MFEED         = 'MANAJEMEN FEED';
  MENUADMIN     = 'MENUADMIN';
  MJAMAAH       = 'DATA JAMAAH';
  MJADWALIMAM   = 'JADWAL IMAM';
  MTPQ          = 'KEGIATAN TPQ';
  MJADWALKAJIAN = 'JADWAL KAJIAN';
  MKEUANGAN     = 'LAPORAN KEUANGAN';
  MPENGUMUMAN   = 'PENGUMUMAN';
  MAKUN         = 'AKUN';
  MPROSESJADWAL = 'PROSES JADWAL';

  //Proses
  PBack = 'go Back';
  pGo = 'go Go';

  idle = 400;
  FontS = 11;

procedure fnTransitionFrame(from, go : TControl; faFrom, faGo : TFloatAnimation; prs : String);

procedure fnGoFrame(from, go : String; stat : Boolean = False);
procedure fnHideFrame(from : String);
procedure fnBack;
procedure fnSetFooter;

procedure fnLoadLoading(lo : TLayout; ani : TAniIndicator; stat : Boolean); overload;  //ganti ini
procedure fnLoadLoading(stat : Boolean); overload;
procedure fnLoadLoadingAds(stat : Boolean);
procedure fnLoadIndicator(ani : TAniIndicator; isActive : Boolean);

procedure fnGetE(Msg, Cls : String); overload;
procedure fnGetE(mem : TMemo; str : String); overload;
procedure fnShowE(str : String);

procedure fnThreadSyncGoFrame(from, go : String);
procedure setSearch(lv : TListView);

procedure setEdit(E : TEdit);
procedure fnSimpanUserINI(usr, pass : String);
procedure fnLoadUserINI;
procedure fnClearUserINI;
procedure fnClickBtn(B : TCornerButton);
procedure addFindItem(lb : TListBox; ASearch : TSearchBox; args : String);
function fnExplodeString(SourceStr: string; Delimiter: char): TStringList;
procedure fnShowReload(AEvent : TNotifyEvent); overload;
procedure fnShowReload(isVisible : Boolean); overload;
procedure fnDownloadFile(nmFile : String);
procedure fnShowSetting;

var
  FCorner : TList<TCornerButton>;
  goFrame, fromFrame, tempFrom, VInfo : String;
  //statTransition : Boolean;
  tabCount : Integer;
  tempTitle : array of String;

  aIDUser, aUsername, aPassword : String;

  //PERMISSION
  FPermissionReadExternalStorage, FAccess_Coarse_Location, FAccess_Fine_Location,
  FPermissionWriteExternalStorage: string;

implementation

uses frMain, uFunc, uGoFrame, uOpenUrl, uRest, frFeed, frHome, frImam,
  frInformasi, frJadwalImamSholat, frKajian, frLoading, frLogin, frMenu,
  frMFeed, frMInformasi, frMJamaah, frMKajian;

procedure fnTransitionFrame(from, go : TControl; faFrom, faGo : TFloatAnimation; prs : String);
var
  i : Integer;
begin
  //statTransition := True;

  tabCount := 0;

  with FMain do begin
    loDisable.Visible := True;

    if fromFrame <> '' then
      from.Visible := False;

    go.Visible := True;
    go.BringToFront;

    faGo.Parent := go;
    faFrom.Parent := go;

    faGo.PropertyName := 'Position.Y';
    faFrom.PropertyName := 'Opacity';

    faGo.StartValue := 50;
    faGo.StopValue := 0;

    faFrom.StartValue := 0.65;
    faFrom.StopValue := 1;

    faGo.Duration := 0.25;
    faFrom.Duration := 0.2;

    faFrom.Interpolation := TInterpolationType.Quadratic;
    faGo.Interpolation := TInterpolationType.Quadratic;

    //fnChangeFrame(goFrame, True);
    //fnGetClient(FMain.loFrame, go);
    fnShowFrame;

    Sleep(100);

    faGo.Enabled := True;

    if fromFrame <> '' then
      faFrom.Enabled := True;
  end;
end;

procedure fnGoFrame(from, go : String; stat : Boolean = False);
var
  proses : String;
  i: Integer;
begin
  if stat = False then
    proses := pGo
  else
    proses := pBack;

  //fnGetFromFrame(from);
  //fnChangeFrame(go);
  fnGetFrame(sFrom, from);
  fnGetFrame(sGo, go);

  if not Assigned(frGo) then begin
    fnShowE('MOHON MAAF, TERJADI KESALAHAN');
    Exit;
  end;

  fromFrame := from;
  goFrame := go;

  tabCount := 0;

  fnSetFooter;
  fnGetClient(FMain.loFrame, frGo);

  fnTransitionFrame(frFrom, frGo, FMain.faFromX, FMain.faGoX, proses);
end;

procedure fnSetFooter;
begin
  if (goFrame = LOADING) OR (goFrame = LOGIN) OR (goFrame = MENUADMIN) OR (goFrame = MJAMAAH) OR (goFrame = MJADWALIMAM)
   OR (goFrame = MTPQ) OR (goFrame = MJADWALKAJIAN) OR (goFrame = MKEUANGAN) OR (goFrame = MPENGUMUMAN) OR (goFrame = MAKUN)
   OR (goFrame = MPROSESJADWAL) OR (goFrame = MFEED) then begin
    FMain.loFooter.Visible := False;
  end else begin
    FMain.loFooter.Visible := True;
    FMain.loFooter.BringToFront;

    {$IF DEFINED(IOS) or DEFINED(ANDROID)}
      //TAndroidHelper.Activity.getWindow.setStatusBarColor($FF1D6E63);
      //TAndroidHelper.Activity.getWindow.setNavigationBarColor($FF1D6E63);
    {$ENDIF}
  end;

  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    if goFrame <> LOADING then begin
      TAndroidHelper.Activity.getWindow.setStatusBarColor($FF1D6E63);
      TAndroidHelper.Activity.getWindow.setNavigationBarColor($FF1D6E63);
    end;
  {$ENDIF}
end;

procedure fnHideFrame(from : String);
begin
  if fromFrame <> '' then
    if Assigned(frFrom) then
      frFrom.Visible := False;

  frFrom := nil;
  frGo := nil;
end;

procedure fnBack;
begin
  if (goFrame = FEED) then begin

  end else if (goFrame = INFORMASI) or (goFrame = KAJIAN) or (goFrame = IMAM) then begin
    fnGoFrame(goFrame, FEED);
  end else if (goFrame = MJAMAAH) then begin
    FMJamaah.fnGoBack;
  end else if (goFrame = MJADWALIMAM) then begin
    FJadwalImam.fnGoBack;
  end else if (goFrame = MJADWALKAJIAN) then begin
    FMKajian.fnGoBack;
  end else if (goFrame = MFEED) then begin
    FMFeed.fnGoBack;
  end else if (goFrame = MPENGUMUMAN) then begin
    FMInformasi.fnGoBack;
  end else if (goFrame = MFEED) then begin
    FMFeed.fnGoBack;
  end;
end;


procedure fnLoadLoading(lo : TLayout; ani : TAniIndicator; stat : Boolean);
begin
  TThread.Synchronize(nil, procedure
  begin
    if stat = True then
      lo.BringToFront;
    lo.Visible := stat;
    //ani.Kind := TLoadingIndicatorKind.Wave;
    ani.Enabled := stat;
  end);
end;

procedure fnLoadLoading(stat : Boolean);
begin
  with FMain do begin
    fnLoadLoading(loLoad, aniLoad, stat);
  end;
end;

procedure fnLoadLoadingAds(stat : Boolean);
begin
  with FMain do begin
    //fnLoadLoading(loLoadAds, aniLoadAds, stat);
  end;
end;

procedure fnLoadIndicator(ani : TAniIndicator; isActive : Boolean);
begin
  TThread.Synchronize(nil, procedure begin
    ani.Enabled := isActive;
    ani.Visible := isActive;
  end);
end;

procedure fnGetE(Msg, Cls : String); overload;
begin
  TThread.Synchronize(nil, procedure
  begin
    FMain.memLog.Lines.Add('Message : ' + Msg);
    FMain.memLog.Lines.Add('Class E : ' + Cls);
  end);
end;

procedure fnGetE(mem : TMemo; str : String);
begin
  TThread.Synchronize(nil, procedure
  begin
    mem.BeginUpdate;
    try
      mem.Lines.Add(str);
    finally
      mem.EndUpdate;
    end;
  end);
end;

procedure fnShowE(str : String);
begin
  with FMain do begin
    TThread.Synchronize(nil, procedure
    begin
      TM.Toast(UpperCase(str));
    end);
  end;
end;

procedure fnThreadSyncGoFrame(from, go : String);
begin
  TThread.Synchronize(nil, procedure begin
    fnGoFrame(from, go);
  end);
end;

procedure setSearch(lv : TListView);
var
  i: Integer;
  edSearch: TEdit;
begin
  for i := 0 to lv.ControlsCount - 1 do
  begin
    if lv.Controls[i] is TEdit then
    begin
      edSearch := TEdit(lv.Controls[i]);
      edSearch.Text := '';
      edSearch.TextPrompt := 'pencarian...';
      edSearch.Font.Size := 11;
      edSearch.StyleLookup := 'edLV';
      edSearch.Height := 40;

      Break;
    end;
  end;
end;

procedure setEdit(E : TEdit);
var
  L : TLabel;
  T : TFloatAnimation;
  i: Integer;
begin
  L := nil;

  for i := 0 to E.ControlsCount - 1 do begin
    if E.Controls[i] is TLabel then
      L := TLabel(E.Controls[i]);
  end;

  if not Assigned(L) then begin
    L := TLabel.Create(E);
    L.Parent := E;
    L.Width := E.Width;
    L.Text := E.TextPrompt;
    fnGetCenter(E, L);
    L.Position.X := 0;
    L.Font.Size := 13;
    L.FontColor := $FF1D6E63;//E.FontColor;
    L.Font.Style := [TFontStyle.fsBold];
    L.StyledSettings := [];

    L.Visible := False;

    T := TFloatAnimation.Create(L);
    T.Parent := L;
    T.Interpolation := TInterpolationType.Quadratic;
    T.PropertyName := 'Position.Y';
    T.Duration := 0.15;
    T.StartValue := L.Position.Y;
    T.StopValue := -17;

    T.Trigger := 'IsVisible=true';
    T.TriggerInverse := 'IsVisible=false';
  end;

  if E.Text <> '' then begin
    L.Visible := True;
  end else begin
    L.Visible := False;
  end;
end;

procedure addFindItem(lb : TListBox; ASearch : TSearchBox; args : String);
var
  i: Integer;
  L : TListBoxItem;
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    while Length(args) > 0 do begin
      i := Pos(',', args);
      if (i > 0) then begin
        sl.Add(Copy(args, 1, i - 1));
        args := Copy(args, i + 1, Length(args) - i);
      end else if Length(args) > 0 then begin
        sl.Add(args);
        args := '';
      end;
    end;

    ASearch.Text := '';
    lb.Items.Clear;

    for i := 0 to sl.Count - 1 do begin
      L := TListBoxItem.Create(lb);
      L.Selectable := False;
      L.Height := 25;
      L.Text := sl[i];
      L.Font.Size := 11;
      L.StyledSettings := [];
      lb.AddObject(L);

      Application.ProcessMessages;
    end;
  finally
    sl.DisposeOf;
  end;
end;

function fnExplodeString(SourceStr: string; Delimiter: char): TStringList;
var
  i: integer;
begin
  Result := TStringList.Create;
  while Length(SourceStr) > 0 do
  begin
    i := Pos(Delimiter, SourceStr);
    if (i > 0) then
    begin
      Result.Add(Copy(SourceStr, 1, i - 1));
      SourceStr := Copy(SourceStr, i + 1, Length(SourceStr) - i);
    end // if (i > 0) then
    else if Length(SourceStr) > 0 then
    begin
      Result.Add(SourceStr);
      SourceStr := '';
    end // if Length(SourceStr) > 0 then
  end; //while Length(SourceStr) > 0 do
  //Result.DisposeOf;
end;

procedure fnShowReload(AEvent : TNotifyEvent);
begin
  TThread.Synchronize(nil, procedure begin
    FMain.loReload.Visible := True;
    FMain.btnUlang.OnClick := AEvent
  end);
end;

procedure fnShowReload(isVisible : Boolean);
begin
  TThread.Synchronize(nil, procedure begin
    FMain.loReload.Visible := isVisible;
    FMain.btnUlang := nil;
  end);
end;

procedure fnDownloadFile(nmFile : String);
var
  HTTP : TNetHTTPClient;
  Stream : TMemoryStream;
begin
  HTTP := TNetHTTPClient.Create(nil);
  try
    Stream := TMemoryStream.Create;
    try
      HTTP.Get(imgURL + nmFile, Stream);
      TThread.Synchronize(nil, procedure begin
        Stream.SaveToFile(fnLoadFile(nmFile));
      end);

    finally
      Stream.DisposeOf;
    end;
  finally
    HTTP.DisposeOf;
  end;
end;

procedure fnShowSetting;
begin
  with FMain do begin
    if not loSetting.Visible then begin
      loSetting.Position.X := FMain.Width + 100;
      faPosX.StartValue := loSetting.Position.X;
      faPosX.StopValue := FMain.Width - (loSetting.Width + 12);

      loSetting.Visible := True;

      faPosX.Enabled := True;
    end else begin
      loSetting.Visible := False;
    end;
  end;
end;


procedure fnClickBtn(B : TCornerButton);
var
  i: Integer;
begin
  with FMain do begin
    for i := 0 to gplFooter.ControlsCount - 1 do begin
      if gplFooter.Controls[i] is TCornerButton then begin
        TCornerButton(gplFooter.Controls[i]).ImageIndex := TCornerButton(gplFooter.Controls[i]).Tag + 1;
        TCornerButton(gplFooter.Controls[i]).FontColor := $FF8A8A8A;
        TCornerButton(gplFooter.Controls[i]).Font.Size := 10;
        TCornerButton(gplFooter.Controls[i]).StyledSettings := [];
      end;
    end;
  end;

  B.ImageIndex := B.Tag;
  B.FontColor := $FF1D6E63;
  B.Font.Size := 11.5;
  B.StyledSettings := [];
end;

procedure fnSimpanUserINI(usr, pass : String);
begin
  SaveSettingString('user', 'usr', usr);
  SaveSettingString('user', 'password', pass);
end;

procedure fnClearUserINI;
begin
  SaveSettingString('user', 'usr', '');
  SaveSettingString('user', 'password', '');
end;

procedure fnLoadUserINI;
begin
  aUsername := LoadSettingString('user', 'usr','');
  aPassword := LoadSettingString('user', 'password','');
end;

end.
