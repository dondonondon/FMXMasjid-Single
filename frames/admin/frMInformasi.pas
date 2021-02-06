unit frMInformasi;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Effects,
  FMX.Objects, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, System.Permissions, FMX.DialogService, FMX.ListBox,
  FMX.TabControl, FMX.ImgList, FMX.ScrollBox, FMX.Memo, System.Net.Mime,
  FMX.Edit, FMX.SearchBox;


type
  TFMInformasi = class(TFrame)
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnHapus: TCornerButton;
    tcMain: TTabControl;
    tiData: TTabItem;
    lbMain: TListBox;
    SearchBox1: TSearchBox;
    btnAdd: TCornerButton;
    tiProses: TTabItem;
    lbProses: TListBox;
    ListBoxItem2: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    swIsFeed: TSwitch;
    Label10: TLabel;
    ListBoxItem11: TListBoxItem;
    btnProses: TCornerButton;
    btnClear: TCornerButton;
    Glyph1: TGlyph;
    loFind: TLayout;
    Rectangle1: TRectangle;
    lbFind: TListBox;
    edFind: TSearchBox;
    loTemp: TLayout;
    reTemp: TRectangle;
    reTanggal: TRectangle;
    ShadowEffect1: TShadowEffect;
    lblTanggal: TLabel;
    glFeed: TGlyph;
    lblSelengkapnya: TLabel;
    lblCaption: TLabel;
    loCaption: TLayout;
    reCaption: TRectangle;
    memCaption: TMemo;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure lblSelengkapnyaClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure memCaptionClick(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    procedure btnProsesClick(Sender: TObject);
    procedure lbMainItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnHapusClick(Sender: TObject);
  private
    statF : Boolean;
    sProses, transID : String;
    procedure setFrame;
    procedure fnProses;
    procedure fnLoadData;
    procedure addItem(idx : Integer; tgl, capt, isFeed : String);
    procedure fnClearCaption;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FMInformasi : TFMInformasi;

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

procedure TFMInformasi.addItem(idx: Integer; tgl, capt, isFeed: String);
var
  lo : TLayout;
  lb : TListBoxItem;
  R : TRectangle;
begin
  capt := fnReplaceStr(capt, '\r', '');
  capt := fnReplaceStr(capt, '\n', ''#13);

  lblCaption.AutoSize := True;

  lblTanggal.Text := tgl;
  lblCaption.Text := capt;

  if lblCaption.Height > 58 then begin
    lblSelengkapnya.Visible := True;
    loTemp.Height := 113;
    lblSelengkapnya.Position.Y := 88;
  end else begin
    lblSelengkapnya.Visible := False;
    loTemp.Height := fnGetPosYDown(lblCaption, 6);
  end;

  if isFeed = '1' then begin
    glFeed.ImageIndex := 0;
    isFeed := 'Feed';
  end else begin
    glFeed.ImageIndex := -1;
    isFeed := 'Non Feed';
  end;


  lblCaption.AutoSize := False;
  lblCaption.Height := 49;

  lb := TListBoxItem.Create(nil);
  lb.Height := loTemp.Height + 10;
  lb.Width := lbMain.Width;
  lb.Selectable := False;
  lb.Tag := idx;

  lb.FontColor := $00FFFFFF;
  lb.Text := Format('%s %s %s',
                      [tgl, capt, isFeed]);

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

  lbMain.AddObject(lb);
end;
procedure TFMInformasi.btnAddClick(Sender: TObject);
begin
  lbMain.ViewportPosition := TPointF.Zero;
  sProses := TAMBAH;
  fnClearCaption;

  btnHapus.Visible := False;

  tcMain.Next;
end;

procedure TFMInformasi.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFMInformasi.btnHapusClick(Sender: TObject);
begin
  sProses := HAPUS;
  TTask.Run(procedure begin
    fnProses;
  end).Start;
end;

procedure TFMInformasi.btnProsesClick(Sender: TObject);
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

procedure TFMInformasi.FirstShow;
begin
  setFrame;
  lbMain.Items.Clear;
  TTask.Run(procedure begin
    Sleep(Idle);
    fnLoadData;
  end).Start;
end;

procedure TFMInformasi.fnClearCaption;
begin
  memCaption.Lines.Clear;
  memCaption.Lines.Add('Tulis Caption...');
  memCaption.FontColor := $FFA0A0A0;
  memCaption.Font.Style := [TFontStyle.fsItalic];
  memCaption.StyledSettings := [];
end;

procedure TFMInformasi.fnGoBack;
begin
  if tcMain.TabIndex = 0 then begin
    fnGoFrame(goFrame, fromFrame);
  end else begin
    tcMain.Previous;
    btnHapus.Visible := False;
    btnProses.Visible := True;
    btnClear.Visible := True;
    fnClearCaption;
  end;
end;

procedure TFMInformasi.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  fnLoadLoading(True);
  req :=  'loadInformasi';
  try
    TThread.Synchronize(nil, procedure begin
      lbMain.Items.Clear;
    end);

    arr := fnGetJSON(DM.nHTTP, req);

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      Exit;
    end;

    for i := 0 to Length(arr[0]) - 1 do begin
      TThread.Synchronize(nil, procedure begin
        addItem(
          arr[0, i].ToInteger,
          arr[1, i],
          arr[2, i],
          arr[3, i]);
      end);

      Sleep(5);
    end;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFMInformasi.fnProses;
var
  arr : TStringArray;
  req, str : String;
  i, idx: Integer;
  sl : TStringList;
begin
  fnLoadLoading(True);
  req :=  sProses + 'Informasi';
  try
    sl := TStringList.Create;
    try
      if (sProses = HAPUS) or (sProses = UBAH) then
        sl.AddPair('id', transID);

      if (sProses = TAMBAH) or (sProses = UBAH) then begin
        sl.AddPair('id_user', aIDUser);
        sl.AddPair('caption', memCaption.Text);
        if swIsFeed.IsChecked then
          sl.AddPair('isFeed', '1')
        else
          sl.AddPair('isFeed', '0');
      end else begin
        req := 'deleteItem';
        sl.AddPair('nmTable', 'tbl_informasi');
      end;

      arr := fnPostJSON(DM.nHTTP, req, sl);
    finally
      sl.DisposeOf;
    end;

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      Exit;
    end;

    fnLoadData;

    TThread.Synchronize(nil, procedure begin
      fnClearCaption;
      tcMain.Previous;
    end);

  finally
    fnLoadLoading(False);
  end;
end;

procedure TFMInformasi.FrameClick(Sender: TObject);
begin
  if memCaption.Text = '' then
    fnClearCaption;
end;

procedure TFMInformasi.lblSelengkapnyaClick(Sender: TObject);
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

  L.Position.Y := fnGetPosYDown(LCapt, 6);
  lbMain.ItemByIndex(idx).Height := fnGetPosYDown(L, 18);
end;

procedure TFMInformasi.lbMainItemClick(const Sender: TCustomListBox;
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

  transID := Item.Tag.ToString;

  if TGlyph(lo.FindStyleResource('glFeed')).Visible then
    swIsFeed.IsChecked := True
  else
    swIsFeed.IsChecked := False;

  memCaption.Lines.Clear;
  memCaption.Text := getText(lo, 'lblCaption');
  memCaption.FontColor := TAlphaColorRec.Black;
  memCaption.Font.Style := [];
  memCaption.StyledSettings := [];

  btnHapus.Visible := True;

  sProses := UBAH;
  tcMain.Next;
end;

procedure TFMInformasi.memCaptionClick(Sender: TObject);
begin
  if memCaption.Text = 'Tulis Caption...' then begin
    memCaption.Lines.Clear;
    memCaption.FontColor := TAlphaColorRec.Black;
    memCaption.Font.Style := [];
    memCaption.StyledSettings := [];
  end;
end;

procedure TFMInformasi.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFMInformasi.setFrame;
begin
  loTemp.Visible := False;
  tcMain.TabIndex := 0;
  btnHapus.Visible := False;

  if statF then
    Exit;

  statF := True;

  lbProses.ItemByIndex(2).Width := lbProses.Height - (lbProses.ItemByIndex(0).Height + lbProses.ItemByIndex(1).Height + 20);

end;

end.
