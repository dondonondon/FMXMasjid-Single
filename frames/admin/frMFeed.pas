unit frMFeed;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Effects,
  FMX.Objects, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, System.Permissions, FMX.DialogService, FMX.ListBox,
  FMX.TabControl, FMX.ImgList, FMX.ScrollBox, FMX.Memo, System.Net.Mime,
  FMX.Edit, FMX.SearchBox, FMX.Memo.Types;

type
  TFMFeed = class(TFrame)
    loMain: TLayout;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnClear: TCornerButton;
    Label1: TLabel;
    reImg: TRectangle;
    reBackground: TRectangle;
    getCR: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    OD: TOpenDialog;
    btnProses: TCornerButton;
    seImg: TShadowEffect;
    lbMain: TListBox;
    ListBoxItem1: TListBoxItem;
    tcMain: TTabControl;
    tiMain: TTabItem;
    tiProses: TTabItem;
    lbData: TListBox;
    btnAdd: TCornerButton;
    btnHapus: TCornerButton;
    ListBoxItem2: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    btnProsesUpload: TCornerButton;
    btnClearCaption: TCornerButton;
    Glyph1: TGlyph;
    loCaption: TLayout;
    reCaption: TRectangle;
    memCaption: TMemo;
    loTemp: TLayout;
    reTempImg: TRectangle;
    lblTgl: TLabel;
    lblCaption: TLabel;
    lblSelengkapnya: TLabel;
    reTempBackground: TRectangle;
    SearchBox1: TSearchBox;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure btnProsesClick(Sender: TObject);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure btnClearClick(Sender: TObject);
    procedure memCaptionClick(Sender: TObject);
    procedure btnClearCaptionClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    procedure btnProsesUploadClick(Sender: TObject);
    procedure lblSelengkapnyaClick(Sender: TObject);
    procedure lbDataItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnHapusClick(Sender: TObject);
  private
    statF : Boolean;
    sProses, transID : String;
    procedure setFrame;
    procedure fnClear;
    procedure fnClearCaption;
    procedure fnProses;
    procedure fnLoadData;
    procedure addItem(idx: Integer; tgl, capt, nmImg: String);


    {PERMISSION}
    procedure fnGetAkses;
    procedure DisplayRationale(Sender: TObject; const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure RequestPermissionsResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
    {PERMISSION}
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FMFeed : TFMFeed;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest;

{ TFTemp }

const
  spc = 10;
  pad = 8;
  TAMBAH  = 'insert';
  UBAH    = 'update';
  HAPUS   = 'delete';

procedure TFMFeed.addItem(idx: Integer; tgl, capt, nmImg: String);
var
  lo : TLayout;
  lb : TListBoxItem;  
  ABitmap : TBitmap;
  R : TRectangle;
begin
  capt := fnReplaceStr(capt, '\r', '');
  capt := fnReplaceStr(capt, '\n', ''#13);

  lblCaption.AutoSize := True;
  
  lblTgl.Text := tgl;
  lblCaption.Text := capt;
  lblSelengkapnya.Tag := idx;

  if lblCaption.Height > 49 then
    lblSelengkapnya.Visible := True
  else
    lblSelengkapnya.Visible := False;

  lblCaption.AutoSize := False;
  lblCaption.Height := 49;
  
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

  TLabel(lo.FindStyleResource('lblSelengkapnya')).OnClick := lblSelengkapnyaClick;   //reTempBackground
  R := TRectangle(lo.FindStyleResource('reTempBackground'));
  R := TRectangle(R.FindStyleResource('reTempImg'));

  ABitmap := TBitmap.Create;
  try
    ABitmap.LoadFromFile(fnLoadFile(nmImg));
    ABitmap := fnSetImgSize(ABitmap, 89);
    R.Fill.Bitmap.Bitmap.LoadFromFile(fnLoadFile(nmImg));

    R.Width := ABitmap.Width;
    R.Height := ABitmap.Height;
  finally
    ABitmap.DisposeOf;
  end;

  lbData.AddObject(lb);
end;

procedure TFMFeed.btnAddClick(Sender: TObject);
begin
  sProses := TAMBAH;
  fnClear;
  fnClearCaption;

  btnHapus.Visible := False;

  tcMain.Next;
end;

procedure TFMFeed.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFMFeed.btnClearCaptionClick(Sender: TObject);
begin
  fnClear;
  fnClearCaption;
end;

procedure TFMFeed.btnClearClick(Sender: TObject);
begin
  fnClear;
end;

procedure TFMFeed.btnHapusClick(Sender: TObject);
begin
  sProses := HAPUS;
  TTask.Run(procedure begin
    fnProses;
  end).Start;
end;

procedure TFMFeed.btnProsesClick(Sender: TObject);
var
  lokasi : String;
  ABitmap : TBitmap;
begin
  FrameClick(Sender);
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    fnGetAkses;
  {$ELSE}
    OD.Execute;
    lokasi := OD.FileName;

    if lokasi = '' then
      Exit;

    ABitmap := TBitmap.Create;
    try
      ABitmap.LoadFromFile(lokasi);
      ABitmap := fnSetImgSize(ABitmap, Round(reBackground.Width - 24));
      reImg.Fill.Bitmap.Bitmap := ABitmap;

      reImg.Width := ABitmap.Width;
      reImg.Height := ABitmap.Height;
    finally
      ABitmap.DisposeOf;
    end;

    btnProses.Visible := False;

  {$ENDIF}
end;

procedure TFMFeed.btnProsesUploadClick(Sender: TObject);
begin
  FrameClick(Sender);

  if (memCaption.Text = 'Tulis Caption...') or (memCaption.Text = '') then begin
    fnShowE('CAPTION TIDAK BOLEH KOSONG');
    Exit;
  end;
  
  TTask.Run(procedure begin 
    fnProses;
  end).Start;
end;

procedure TFMFeed.DisplayRationale(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
var
  I: Integer;
  RationaleMsg: string;
begin
  for I := 0 to High(APermissions) do begin
    if APermissions[I] = FPermissionReadExternalStorage then
      RationaleMsg := RationaleMsg + 'Aplikasi meminta ijin untuk membaca storage' + SLineBreak + SLineBreak
    else if APermissions[I] = FPermissionWriteExternalStorage then
      RationaleMsg := RationaleMsg + 'Aplikasi meminta ijin untuk menulis storage';
  end;
  TDialogService.ShowMessage(RationaleMsg,
  procedure(const AResult: TModalResult) begin
    APostRationaleProc;
  end)
end;

procedure TFMFeed.FirstShow;
begin
  setFrame;   
  lbData.Items.Clear;
  TTask.Run(procedure begin
    Sleep(Idle);
    fnLoadData;
  end).Start;
end;

procedure TFMFeed.fnGetAkses;
begin
  PermissionsService.RequestPermissions(
    [FPermissionReadExternalStorage, FPermissionWriteExternalStorage],
    RequestPermissionsResult,
    DisplayRationale);
end;

procedure TFMFeed.fnGoBack;
begin
  if tcMain.TabIndex = 0 then begin
    fnGoFrame(goFrame, fromFrame);
  end else begin
    tcMain.Previous;
    btnHapus.Visible := False;
    btnProses.Visible := True;
    btnClear.Visible := True;
    fnClear;
    fnClearCaption;
  end;
end;

procedure TFMFeed.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  fnLoadLoading(True);
  req :=  'loadFeed&isFeed=Y';
  try
    TThread.Synchronize(nil, procedure begin
      lbData.Items.Clear;
    end);

    arr := fnGetJSON(DM.nHTTP, req);

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      Exit;
    end;

    for i := 0 to Length(arr[0]) - 1 do begin
      if not FileExists(fnLoadFile(arr[5, i])) then
        fnDownloadFile(arr[5, i]);


      TThread.Synchronize(nil, procedure begin
        addItem(
          arr[0, i].ToInteger,
          arr[2, i],
          arr[3, i],
          arr[5, i]);
      end);

      Sleep(5);
    end;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFMFeed.fnProses;
var
  arr : TStringArray;
  req, str, nmFile : String;
  i, idx: Integer;
  sl : TStringList;
  Stream: TStringStream;
  par : TMultipartFormData;
begin
  fnLoadLoading(True);
  req :=  sProses + 'Feed';
  try
    par := TMultipartFormData.Create;
    try
      if (sProses = TAMBAH) then begin
        nmFile := fnCreateID + '.jpg';
        TThread.Synchronize(nil, procedure begin 
          reImg.Fill.Bitmap.Bitmap.SaveToFile(fnLoadFile(nmFile));
        end);

        par.AddFile('fileToUpload', fnLoadFile(nmFile));
        par.AddField('nmFile', nmFile);
        par.AddField('id_user', aIDUser);   
        par.AddField('caption', memCaption.Text);

        Stream := TStringStream.Create('');
        try
          arr := fnPostJSON(DM.nHTTP, req, par, Stream);

          if arr[0, 0] = 'null' then begin
            fnShowE(arr[1, 0]);
            Exit;
          end;
        finally
          Stream.DisposeOf;
        end;
      end else if (sProses = HAPUS) or (sProses = UBAH) then begin
        sl := TStringList.Create;
        try
          if sProses = HAPUS then begin
            req := 'deleteItem';
            sl.AddPair('nmTable', 'tbl_feed');
          end else if sProses = UBAH then
            sl.AddPair('capt', memCaption.Text);
          
          sl.AddPair('id', transID);
            
          arr := fnPostJSON(DM.nHTTP, req, sl);
        finally
          sl.DisposeOf;
        end;
      end;
      
    finally
      par.DisposeOf;
    end;

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      Exit;
    end;

    fnLoadData;

    TThread.Synchronize(nil, procedure begin
      fnClear;
      fnClearCaption;
      tcMain.Previous;
    end);

  finally
    fnLoadLoading(False);
  end;
end;

procedure TFMFeed.FrameClick(Sender: TObject);
begin
  if memCaption.Text = '' then
    fnClearCaption;
end;

procedure TFMFeed.lbDataItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
function getText(lo : TLayout; s : String) : String;
begin
  Result := fnReplaceStr(TLabel(lo.FindStyleResource(s)).Text, ': ', '');
end;
var
  i: Integer;
  lo : TLayout;
  s : String;
begin
  for i := 0 to Item.ControlsCount - 1 do begin
    if Item.Controls[i] is TLayout then
      if TLayout(Item.Controls[i]).StyleName = 'loTemp' then begin
        lo := TLayout(Item.Controls[i]);
        Break;
      end;
  end;

  reImg.Fill.Bitmap.Bitmap.LoadFromFile(fnLoadFile(Item.ItemData.Detail));
  reImg.Fill.Bitmap.Bitmap := fnSetImgSize(reImg.Fill.Bitmap.Bitmap, Round(reBackground.Width - 24));
  reImg.Width := reImg.Fill.Bitmap.Bitmap.Width;
  reImg.Height := reImg.Fill.Bitmap.Bitmap.Height;

  btnProses.Visible := False;
  btnClear.Visible := False;
  
  transID := Item.Tag.ToString;
  memCaption.Text := getText(lo, 'lblCaption');
  memCaption.FontColor := TAlphaColorRec.Black;
  memCaption.Font.Style := [];
  memCaption.StyledSettings := [];

  btnHapus.Visible := True;
  sProses := UBAH;
  tcMain.Next;
end;

procedure TFMFeed.lblSelengkapnyaClick(Sender: TObject);
var
  L, LCapt : TLabel;
  lo : TLayout;
  idx : Integer;
begin
  L := TLabel(Sender);
  LCapt := TLabel(TLayout(L.Parent).FindStyleResource('lblCaption'));

  idx := TListBoxItem(TLayout(L.Parent).Parent).Index;
  
  if L.Text = 'Selengkapnya...' then begin
    L.Text := 'Sembunyikan...';
    LCapt.AutoSize := True;
  end else begin
    L.Text := 'Selengkapnya...';
    LCapt.AutoSize := False;
    LCapt.Height := 49;
  end;

  L.Position.Y := fnGetPosYDown(LCapt, 16);
  lbData.ItemByIndex(idx).Height := fnGetPosYDown(L, 18);
end;

procedure TFMFeed.memCaptionClick(Sender: TObject);
begin
  if memCaption.Text = 'Tulis Caption...' then begin
    memCaption.Lines.Clear;
    memCaption.FontColor := TAlphaColorRec.Black;
    memCaption.Font.Style := [];
    memCaption.StyledSettings := [];
  end;
end;

procedure TFMFeed.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFMFeed.RequestPermissionsResult(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  if (Length(AGrantResults) = 2) and (AGrantResults[0] = TPermissionStatus.Granted) and (AGrantResults[1] = TPermissionStatus.Granted) then
  begin
    TakePhotoFromLibraryAction1.Execute;
  end
  else
  begin
    TDialogService.ShowMessage('Gagal mendapatkan akses storage');
  end;
end;

procedure TFMFeed.fnClear;
begin
  if sProses = TAMBAH then begin  
    btnProses.Visible := True;
    reImg.Fill.Bitmap.Bitmap := nil;

    lbMain.ItemByIndex(0).Height := lbMain.Width;
    lbMain.ItemByIndex(0).Width := lbMain.Width;

    reBackground.Width := lbMain.Width;
    reBackground.Height := reBackground.Width;
      reImg.Width := reBackground.Width - 24;
      reImg.Height := reImg.Width;
  end;
end;

procedure TFMFeed.fnClearCaption;
begin
  memCaption.Lines.Clear;
  memCaption.Lines.Add('Tulis Caption...');
  memCaption.FontColor := $FFA0A0A0;
  memCaption.Font.Style := [TFontStyle.fsItalic];
  memCaption.StyledSettings := [];
end;

procedure TFMFeed.setFrame;
begin
  fnClear;
  fnClearCaption;
  loTemp.Visible := False;
  tcMain.TabIndex := 0;
  btnHapus.Visible := False;

  lbMain.ItemByIndex(1).Width := lbMain.Height - (lbMain.ItemByIndex(0).Height + lbMain.ItemByIndex(2).Height + 20);

  if statF then
    Exit;

  statF := True;

end;

procedure TFMFeed.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  Image := fnSetImgSize(Image, Round(reBackground.Width - 24));
  reImg.Fill.Bitmap.Bitmap := Image;

  reImg.Width := Image.Width;
  reImg.Height := Image.Height;

  btnProses.Visible := False;
end;

end.
