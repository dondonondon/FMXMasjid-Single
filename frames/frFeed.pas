unit frFeed;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.ListBox,
  FMX.Objects, FMX.Effects, System.ImageList, FMX.ImgList, System.IOUtils,
  FMX.MultiView, FMX.Edit, FMX.SearchBox
  {$IF DEFINED (ANDROID)}
  , Androidapi.Helpers
  {$ELSEIF DEFINED (MSWINDOWS)}
  , IWSystem
  {$ENDIF}
  ;

type
  TFFeed = class(TFrame)
    lbMain: TListBox;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnMore: TCornerButton;
    loJadwal: TLayout;
    reJadwal: TRectangle;
    seJadwal: TShadowEffect;
    btnLonceng: TCornerButton;
    lblJam: TLabel;
    lblKeterangan: TLabel;
    lblTgl: TLabel;
    loShowJadwal: TLayout;
    btnShowLonceng: TCornerButton;
    lblShowKeterangan: TLabel;
    lblShowTgl: TLabel;
    lblShowJam: TLabel;
    loTemp: TLayout;
    imgFeedProfile: TCircle;
    Label2: TLabel;
    reTempBackground: TRectangle;
    ShadowEffect1: TShadowEffect;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    Label3: TLabel;
    lblCaption: TLabel;
    CornerButton4: TCornerButton;
    imgComment: TCircle;
    Label5: TLabel;
    lblSelengkapnya: TLabel;
    lblTanggal: TLabel;
    img: TImageList;
    reTempImg: TRectangle;
    ShadowEffect2: TShadowEffect;
    tiRollUp: TTimer;
    mvKota: TMultiView;
    lbKota: TListBox;
    SearchBox1: TSearchBox;
    lblKota: TLabel;
    loDisable: TLayout;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure lbMainViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure btnMoreClick(Sender: TObject);
    procedure btnLoncengClick(Sender: TObject);
    procedure tiRollUpTimer(Sender: TObject);
    procedure lbKotaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    tSizeAwal, tSizeStop, tSizeMax : Single;
    statF, isExpand, isLoadKota, isLoadData : Boolean;
    procedure setFrame;
    procedure addSpace;
    procedure addItem; overload;
    procedure addItemFeed(idx: Integer; tgl, capt, nmImg: String);
    procedure addItemInfo(idx : Integer; tgl, capt, isFeed : String);
    procedure addItemKajian(idx: Integer; tema, ustadz, tgl, waktu, capt, nmImg, isFeed: String);
    procedure fnLoadData;
    procedure fnLoadKota;
    procedure fnLoadJadwal(kota : String);


    procedure fnClickTemp(Sender: TObject);

    procedure lblSelengkapnyaFeed(Sender: TObject);
    procedure lblSelengkapnyaInfo(Sender: TObject);
    procedure lblSelengkapnyaKajian(Sender: TObject);
    procedure fnReloadData(Sender : TObject);
  public
    { Public declarations }
    procedure fnClickFeed;
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FFeed : TFFeed;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest, frMInformasi;

{ TFTemp }

const
  spc = 10;
  pad = 8;
  iFeedProfil = 102;
  iFeed = 101;
  iComment = 100;

procedure TFFeed.addItem;
var
  lb : TListBoxItem;
  lo : TLayout;
  i: Integer;
  loc : String;
begin
  lb := TListBoxItem.Create(lbMain);
  lb.Height := loTemp.Height + 16;
  lb.Width := lbMain.Width - 6;
  lb.Selectable := False;

  lo := TLayout(loTemp.Clone(lb));
  lo.Parent := lb;
  lo.Position.X := 5;
  lo.Position.Y := 5;
  lo.Width := lbMain.Width - 16;

  lo.Visible := True;

  lo.Repaint;

  {$IF DEFINED (ANDROID)}
  loc := TPath.GetDocumentsPath + PathDelim;
  {$ELSEIF DEFINED (MSWINDOWS)}
  loc := gsAppPath + 'assets/';
  {$ENDIF}

  for i := 0 to lo.ControlsCount - 1 do begin
    if lo.Controls[i] is TCornerButton then begin
      if TCornerButton(lo.Controls[i]).Hint = 'temp' then
        TCornerButton(lo.Controls[i]).OnClick := fnClickTemp;
    end else if lo.Controls[i] is TRectangle then begin
      if TRectangle(lo.Controls[i]).Tag = iFeed then
        TRectangle(lo.Controls[i]).Fill.Bitmap.Bitmap.LoadFromFile(loc + 'feed.jpg');
    end else if lo.Controls[i] is TCircle then begin
      if TCircle(lo.Controls[i]).Tag = iFeedProfil then
        TCircle(lo.Controls[i]).Fill.Bitmap.Bitmap.LoadFromFile(loc + '9.png')
      else if TCircle(lo.Controls[i]).Tag = iComment then
        TCircle(lo.Controls[i]).Fill.Bitmap.Bitmap.LoadFromFile(loc + 'profil.png');
    end;
  end;

  lbMain.AddObject(lb);

  //Application.ProcessMessages;
end;

procedure TFFeed.addItemFeed(idx: Integer; tgl, capt, nmImg: String);
var
  lo : TLayout;
  lb : TListBoxItem;
  ABitmap : TBitmap;
  R : TRectangle;
  LCapt, LExp, LTgl : TLabel;
begin
  capt := fnReplaceStr(capt, '\r', '');
  capt := fnReplaceStr(capt, '\n', ''#13);
  capt := fnReplaceStr(capt, '\', '"');

  lblCaption.AutoSize := True;

  lblTanggal.Text := tgl;
  lblCaption.Text := capt;

  //{$IF DEFINED (ANDROID)}
    {if lblCaption.Height > 46 then
      lblSelengkapnya.Visible := True
    else
      lblSelengkapnya.Visible := False;

    lblCaption.AutoSize := False;
    lblCaption.Height := 46;}

  //{$ELSEIF DEFINED (MSWINDOWS)}
    lblSelengkapnya.Visible := False;
  //{$ENDIF}

  lb := TListBoxItem.Create(nil);
  lb.Height := loTemp.Height + 10;
  lb.Width := lbMain.Width;
  lb.Selectable := False;
  lb.Tag := idx;
  lb.ItemData.Detail := nmImg;

  lb.FontColor := $00FFFFFF;
  lb.Text := Format('%s %s %s',
                      [tgl, capt, nmImg]);

  lb.StyledSettings := [];

  lo := TLayout(loTemp.Clone(lb));
  lo.Parent := lb;
  lo.Width := lbMain.Width - 20;//lbMain.Width;

  lo.Position.X := 10;
  lo.Position.Y := 0;

  lo.StyleName := 'loTemp';
  lo.Tag := idx;

  lo.Visible := True;

  TLabel(lo.FindStyleResource('lblSelengkapnya')).OnClick := lblSelengkapnyaFeed;   //reTempBackground
  R := TRectangle(lo.FindStyleResource('reTempBackground'));
  //R := TRectangle(R.FindStyleResource('reTempImg'));

  ABitmap := TBitmap.Create;
  try
    ABitmap.LoadFromFile(fnLoadFile(nmImg));
    ABitmap := fnSetImgSize(ABitmap, 305);
    R.Fill.Bitmap.Bitmap.LoadFromFile(fnLoadFile(nmImg));

    R.Width := ABitmap.Width;
    R.Height := ABitmap.Height;

    R.Position.X := (lo.Width - R.Width) / 2;

    LCapt := TLabel(lo.FindStyleResource('lblCaption'));
    LExp := TLabel(lo.FindStyleResource('lblSelengkapnya'));
    LTgl := TLabel(lo.FindStyleResource('lblTanggal'));

    LCapt.Position.Y := fnGetPosYDown(R, 8);
    LExp.Position.Y := fnGetPosYDown(LCapt, 8);
    LTgl.Position.Y := fnGetPosYDown(LExp, 8);

    lb.Height := fnGetPosYDown(LTgl, 16);

  finally
    ABitmap.DisposeOf;
  end;

  lbMain.AddObject(lb);
end;

procedure TFFeed.addItemInfo(idx: Integer; tgl, capt, isFeed: String);
var
  lo : TLayout;
  lb : TListBoxItem;
  R : TRectangle;
  L : TLabel;
begin
  TThread.Synchronize(nil, procedure begin
    capt := fnReplaceStr(capt, '\r', '');
    capt := fnReplaceStr(capt, '\n', ''#13);
    capt := fnReplaceStr(capt, '\', '"');

    FMInformasi.glFeed.ImageIndex := 0;

    FMInformasi.lblCaption.AutoSize := True;

    FMInformasi.lblTanggal.Text := tgl;
    FMInformasi.lblCaption.Text := capt;

    //{$IF DEFINED (ANDROID)}
      {if FMInformasi.lblCaption.Height > 58 then begin
        FMInformasi.lblSelengkapnya.Visible := True;
        FMInformasi.loTemp.Height := 113;
        FMInformasi.lblSelengkapnya.Position.Y := 88;
      end else begin
        FMInformasi.lblSelengkapnya.Visible := False;
        FMInformasi.loTemp.Height := fnGetPosYDown(FMInformasi.lblCaption, 6);
      end;

      FMInformasi.lblCaption.AutoSize := False;
      FMInformasi.lblCaption.Height := 49;}

    //{$ELSEIF DEFINED (MSWINDOWS)}
      FMInformasi.loTemp.Height := fnGetPosYDown(FMInformasi.lblCaption, 6);
      FMInformasi.lblSelengkapnya.Visible := False;
    //{$ENDIF}

    lb := TListBoxItem.Create(nil);
    lb.Height := FMInformasi.loTemp.Height + 10 + 30;
    lb.Width := lbMain.Width;
    lb.Selectable := False;
    lb.Tag := idx;

    lb.FontColor := $00FFFFFF;
    lb.Text := Format('%s %s %s',
                        [tgl, capt, isFeed]);

    lb.StyledSettings := [];

    lo := TLayout(FMInformasi.loTemp.Clone(lb));
    lo.Parent := lb;
    lo.Width := lbMain.Width - 20;//lbMain.Width;

    lo.Position.X := 10;
    lo.Position.Y := 30;

    lo.StyleName := 'loTemp';
    lo.Tag := idx;

    L := TLabel.Create(nil);
    L.Parent := lb;
    L.Width := lb.Width;
    L.Height := 20;
    L.Text := '[INFORMASI]';
    L.Font.Style := [TFontStyle.fsBold];
    L.Font.Size := 13;
    L.StyledSettings := [];

    L.Position.X := 10;
    L.Position.Y := 10;

    lo.Visible := True;

    //TLabel(lo.FindStyleResource('lblSelengkapnya')).OnClick := lblSelengkapnyaClick;   //reTempBackground

    lbMain.AddObject(lb);
  end);
end;

procedure TFFeed.addItemKajian(idx: Integer; tema, ustadz, tgl, waktu, capt,
  nmImg, isFeed: String);
begin

end;

procedure TFFeed.fnClickFeed;
begin
  if lbMain.ViewportPosition.Y > 0 then begin
    tiRollUp.Enabled := True;
    loDisable.Visible := True;
  end else if lbMain.ViewportPosition.Y = 0 then begin
    lbMain.Items.Clear;
    TTask.Run(procedure begin
      lbMain.OnViewportPositionChange := nil;
      try
        fnLoadJadwal(LoadSettingString('config', 'kota', ''));
        fnLoadData;
      finally
        lbMain.OnViewportPositionChange := lbMainViewportPositionChange;
      end;
    end).Start;
  end;
end;

procedure TFFeed.fnClickTemp(Sender: TObject);
var
  B : TCornerButton;
begin
  B := TCornerButton(Sender);

  if B.ImageIndex <> B.Tag then
    B.ImageIndex := B.Tag
  else
    B.ImageIndex := B.Tag + 1;
end;

procedure TFFeed.addSpace;
var
  lb : TListBoxItem;
begin
  TThread.Synchronize(nil, procedure begin
    lb := TListBoxItem.Create(nil);
    lb.Height := tSizeAwal;
    lb.Width := lbMain.Width - 6;
    lb.Selectable := False;

    lbMain.AddObject(lb);
  end);
end;

procedure TFFeed.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFFeed.btnLoncengClick(Sender: TObject);
begin
  mvKota.ShowMaster;

  if isLoadKota then
    Exit;

  TTask.Run(procedure begin
    fnLoadKota;
  end).Start;
end;

procedure TFFeed.btnMoreClick(Sender: TObject);
begin
  fnShowSetting;
end;

procedure TFFeed.FirstShow;
begin
  setFrame;

  if isLoadData then
    Exit;

  lbMain.Items.Clear;
  TTask.Run(procedure begin
    Sleep(Idle);
    lbMain.OnViewportPositionChange := nil;
    try
      fnLoadJadwal(LoadSettingString('config', 'kota', ''));
      fnLoadData;
    finally
      lbMain.OnViewportPositionChange := lbMainViewportPositionChange;
    end;
  end).Start;

  Exit;

  lbMain.Items.Clear;

  TTask.Run(procedure var i : integer; begin
    Sleep(250);
    lbMain.OnViewportPositionChange := nil;
    addSpace;
    try
      for i := 0 to 15 do begin
        TThread.Synchronize(nil, procedure begin
          addItem;
        end);
        Sleep(25);
      end;
    finally
      lbMain.OnViewportPositionChange := lbMainViewportPositionChange;
    end;
  end).Start;
end;

procedure TFFeed.fnGoBack;
begin
  fnGoFrame(goFrame, fromFrame);
end;

procedure TFFeed.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  fnLoadLoading(True);
  req :=  'loadFeed&isFeed=';
  isLoadData := False;
  try
    TThread.Synchronize(nil, procedure begin
      lbMain.Items.Clear;
    end);

    addSpace;

    arr := fnGetJSON(DM.nHTTP, req);

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      fnShowReload(fnReloadData);
      isLoadData := False;
      Exit;
    end;

    for i := 0 to Length(arr[0]) - 1 do begin
      if (arr[6, i] = 'KAJIAN') or (arr[6, i] = 'FEED') then begin

        if not FileExists(fnLoadFile(arr[5, i])) then
          fnDownloadFile(arr[5, i]);

        TThread.Synchronize(nil, procedure begin
          addItemFeed(
            arr[0, i].ToInteger,
            arr[2, i],
            arr[3, i],
            arr[5, i]);
        end);

      end else begin
        //TThread.Synchronize(nil, procedure begin
          addItemInfo(
            arr[0, i].ToInteger,
            arr[2, i],
            arr[3, i],
            arr[5, i]);
        //end);
      end;

      Sleep(5);
    end;
    isLoadData := True;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFFeed.fnLoadJadwal(kota : String);
function fnFormatTime(str : String) : TTime;
begin
  {$IF DEFINED (ANDROID)}
    //str := fnReplaceStr(str, )
  {$ELSE}

  {$ENDIF}
end;
var
  arr : TStringArray;
  req : String;
  tiNow, tiWaktu : TDateTime;
  i: Integer;
begin
  fnLoadLoading(True);

  if kota = '' then
    kota := 'sleman';

  req :=  'getToday&kota='+kota;
  try
    arr := fnGetJSON(DM.nHTTP, req);

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      Exit;
    end;

    tiNow := Now;

    {fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), FormatDateTime('yyyy-mm-dd hh:nn', StrToDateTimeDef(arr[0, 0] + ' ' + arr[2, 0], Now)));
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), FormatDateTime('yyyy-mm-dd hh:nn', StrToDateTimeDef(arr[0, 0] + ' ' + arr[4, 0], Now)));
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), FormatDateTime('yyyy-mm-dd hh:nn', StrToDateTimeDef(arr[0, 0] + ' ' + arr[5, 0], Now)));
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), FormatDateTime('yyyy-mm-dd hh:nn', StrToDateTimeDef(arr[0, 0] + ' ' + arr[6, 0], Now)));
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), FormatDateTime('yyyy-mm-dd hh:nn', StrToDateTimeDef(arr[0, 0] + ' ' + arr[7, 0], Now)));


    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), arr[0, 0] + ' ' + arr[2, 0]);
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), arr[0, 0] + ' ' + arr[4, 0]);
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), arr[0, 0] + ' ' + arr[5, 0]);
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), arr[0, 0] + ' ' + arr[6, 0]);
    fnGetE(FormatDateTime('yyyy-mm-dd hh:nn', tiNow), arr[0, 0] + ' ' + arr[7, 0]);}

    if tiNow < StrToDateTimeDef(arr[0, 0] + ' ' + arr[2, 0], Now) then begin
      lblKeterangan.Text := 'Subuh';
      lblJam.Text := arr[2, 0];
    end else if tiNow < StrToDateTimeDef(arr[0, 0] + ' ' + arr[4, 0], Now) then begin
      lblKeterangan.Text := 'Dzuhur';
      lblJam.Text := arr[4, 0];
    end else if tiNow < StrToDateTimeDef(arr[0, 0] + ' ' + arr[5, 0], Now) then begin
      lblKeterangan.Text := 'Ashr';
      lblJam.Text := arr[5, 0];
    end else if tiNow < StrToDateTimeDef(arr[0, 0] + ' ' + arr[6, 0], Now) then begin
      lblKeterangan.Text := 'Maghrib';
      lblJam.Text := arr[6, 0];
    end else if tiNow < StrToDateTimeDef(arr[0, 0] + ' ' + arr[7, 0], Now) then begin
      lblKeterangan.Text := 'Isya';
      lblJam.Text := arr[7, 0];
    end else begin
      lblKeterangan.Text := 'Isya';
      lblJam.Text := arr[7, 0];
    end;

    lblShowKeterangan.Text := lblKeterangan.Text;
    lblShowJam.Text := lblJam.Text;


    TThread.Synchronize(nil, procedure begin
      lblKota.Text := UpperCaseFirstLetter(kota);
      lblTgl.Text := fnDateENTOID(StrToDateTimeDef(arr[0, 0], Now));
      lblShowTgl.Text := lblTgl.Text;
    end);
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFFeed.fnLoadKota;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  fnLoadLoading(True);
  req :=  'loadKota';
  isLoadKota := False;
  try
    TThread.Synchronize(nil, procedure begin
      lbKota.Items.Clear;
    end);

    arr := fnGetJSON(DM.nHTTP, req);

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      fnShowReload(btnLoncengClick);
      isLoadKota := False;
      Exit;
    end;

    for i := 0 to Length(arr[0]) - 1 do begin
      TThread.Synchronize(nil, procedure begin
        lbKota.Items.Add(arr[0, i]);
      end);

      Sleep(5);
    end;

    isLoadKota := True;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFFeed.fnReloadData(Sender: TObject);
begin
  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFFeed.lbKotaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  TTask.Run(procedure begin
    fnLoadJadwal(Item.Text);
  end).Start;

  SaveSettingString('config', 'kota', UpperCaseFirstLetter(Item.Text));

  mvKota.HideMaster;
end;

procedure TFFeed.lblSelengkapnyaFeed(Sender: TObject);
var
  L, LCapt, LExp, LTgl : TLabel;
  lo : TLayout;
  idx : Integer;
begin
  //lbMain.BeginUpdate;
  try
    L := TLabel(Sender);
    LCapt := TLabel(TLayout(L.Parent).FindStyleResource('lblCaption'));
    LExp := TLabel(TLayout(L.Parent).FindStyleResource('lblSelengkapnya'));
    LTgl := TLabel(TLayout(L.Parent).FindStyleResource('lblTanggal'));

    idx := TListBoxItem(TLayout(L.Parent).Parent).Index;

    if L.Text = 'Selengkapnya...' then begin
      L.Text := 'Sembunyikan...';
      LCapt.AutoSize := True;
    end else begin
      L.Text := 'Selengkapnya...';
      LCapt.AutoSize := False;
      LCapt.Height := 46;
    end;

    L.Position.Y := fnGetPosYDown(LCapt, 8);
    LTgl.Position.Y := fnGetPosYDown(L, 8);

    lbMain.ItemByIndex(idx).Height := fnGetPosYDown(LTgl, 18);

  finally
    //lbMain.EndUpdate;
    //lbMain.InvalidateContentSize;
  end;
end;

procedure TFFeed.lblSelengkapnyaInfo(Sender: TObject);
begin

end;

procedure TFFeed.lblSelengkapnyaKajian(Sender: TObject);
begin

end;

procedure TFFeed.lbMainViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin
  if lbMain.Items.Count = 0 then
    Exit;

  if NewViewportPosition.Y < tSizeMax then begin
      loHeader.Height := tSizeAwal - NewViewportPosition.Y;
      lbMain.ItemByIndex(0).Height := loHeader.Height;
      loJadwal.Opacity := (tSizeMax - NewViewportPosition.Y) / tSizeMax;
      loShowJadwal.Opacity := 1 - loJadwal.Opacity;

      if NewViewportPosition.Y < 20 then
        loShowJadwal.Opacity := 0;

    Application.ProcessMessages;
  end else begin
    if loHeader.Height <> tSizeStop then begin
      loHeader.Height := tSizeStop;
      lbMain.ItemByIndex(0).Height := tSizeStop;//FFeed.Height - loHeader.Height;
      loJadwal.Opacity := 0;
      loShowJadwal.Opacity := 1;

      Application.ProcessMessages;

    end;
  end;

  {$IF DEFINED (ANDROID)}
    //lbMain.InvalidateContentSize;
  {$ENDIF}
end;

procedure TFFeed.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFFeed.setFrame;
begin
  loTemp.Visible := False;
  loDisable.Visible := False;

  fnClickBtn(FMain.btnFeed);

  if statF then
    Exit;

  statF := True;

  tSizeAwal := 178;
  tSizeStop := 108;
  tSizeMax := tSizeAwal - tSizeStop;

end;

procedure TFFeed.tiRollUpTimer(Sender: TObject);
begin
  if lbMain.ViewportPosition.Y > 0 then begin
    lbMain.ViewportPosition := TPointF.Create(0, lbMain.ViewportPosition.Y - 150);
  end else if lbMain.ViewportPosition.Y = 0 then begin
    tiRollUp.Enabled := False;
    loDisable.Visible := False;
  end;
end;

end.
