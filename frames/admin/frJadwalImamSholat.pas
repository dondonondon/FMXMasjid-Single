unit frJadwalImamSholat;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Effects,
  FMX.Objects, FMX.TabControl, FMX.ListBox, FMX.Edit, FMX.SearchBox, FMX.ImgList,
  FMX.DateTimeCtrls;

type
  TFJadwalImam = class(TFrame)
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnHapus: TCornerButton;
    tcMain: TTabControl;
    tiData: TTabItem;
    tiProses: TTabItem;
    lbMain: TListBox;
    SearchBox1: TSearchBox;
    loTemp: TLayout;
    reTemp: TRectangle;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblCadanganCalonImam: TLabel;
    lblCalonImam: TLabel;
    lblWaktuSholat: TLabel;
    lblIsImam: TLabel;
    reTanggal: TRectangle;
    ShadowEffect1: TShadowEffect;
    lblTanggal: TLabel;
    btnAdd: TCornerButton;
    lbProses: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    lbiProses: TListBoxItem;
    btnProses: TCornerButton;
    btnClear: TCornerButton;
    Glyph1: TGlyph;
    dtSholat: TDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnWaktuSholat: TCornerButton;
    loFind: TLayout;
    Rectangle1: TRectangle;
    lbFind: TListBox;
    edFind: TSearchBox;
    btnCalonImam: TCornerButton;
    Label6: TLabel;
    btnCalonCadanganImam: TCornerButton;
    Label7: TLabel;
    aniLoad: TAniIndicator;
    lblTgl: TLabel;
    lblCI: TLabel;
    lblCCI: TLabel;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    procedure btnWaktuSholatClick(Sender: TObject);
    procedure lbFindItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbMainItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnProsesClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
  private
    statF : Boolean;
    sProses, transID : String;
    tempBtn : TCornerButton;
    procedure fnClear;
    procedure setFrame;
    procedure addItem(idx : Integer; tgl, wkt_sholat, c_imam, c_cadangan_imam : String);
    procedure fnSetHeightLB;
    procedure fnLoadListImam;
    procedure fnLoadData;
    procedure fnProses;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FJadwalImam : TFJadwalImam;

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

procedure TFJadwalImam.addItem(idx: Integer; tgl, wkt_sholat, c_imam,
  c_cadangan_imam: String);
var
  stgl : String;
  lo : TLayout;
  lb : TListBoxItem;
begin
  stgl := fnDateENTOID(StrToDateTimeDef(tgl, Now));
  lblWaktuSholat.Text := ': ' + UpperCaseFirstLetter(wkt_sholat);
  lblCalonImam.Text := ': ' + c_imam;
  lblCadanganCalonImam.Text := ': ' + c_cadangan_imam;
  lblTanggal.Text := stgl;

  lb := TListBoxItem.Create(nil);
  lb.Height := loTemp.Height + 10;
  lb.Width := lbMain.Width;
  lb.Selectable := False;
  lb.Tag := idx;

  lb.FontColor := $00FFFFFF;
  lb.Text := Format('%s %s %s %s %s',
                      [stgl, tgl, wkt_sholat, c_imam, c_cadangan_imam]);
  lb.StyledSettings := [];

  lo := TLayout(loTemp.Clone(lb));
  lo.Parent := lb;
  lo.Width := lbMain.Width - 20;//lbMain.Width;

  lo.Position.X := 10;
  lo.Position.Y := 0;

  lo.StyleName := 'loTemp';
  lo.Tag := idx;

  lo.Visible := True;

  lbMain.AddObject(lb);
end;

procedure TFJadwalImam.btnAddClick(Sender: TObject);
begin
  fnClear;
  sProses := TAMBAH;

  btnHapus.Visible := False;

  tcMain.Next;
end;

procedure TFJadwalImam.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFJadwalImam.btnHapusClick(Sender: TObject);
begin
  sProses := HAPUS;
  TTask.Run(procedure begin
    fnProses;
  end).Start;
end;

procedure TFJadwalImam.btnProsesClick(Sender: TObject);
begin
  FrameClick(Sender);
  if (btnWaktuSholat.Text = 'Pilih Waktu Sholat') or (btnCalonImam.Text = 'Pilih Calon Imam') or (btnCalonCadanganImam.Text = 'Pilih Calon Cadangan Imam') then begin
   fnShowE('FIELD TIDAK DIISI DENGAN BENAR');
   Exit;
  end;

  TTask.Run(procedure begin
    fnProses;
  end).Start;
end;

procedure TFJadwalImam.btnWaktuSholatClick(Sender: TObject);
var
  B : TCornerButton;
  L : TListBoxItem;
begin
  B := TCornerButton(Sender);

  if tempBtn <> nil then
    if tempBtn = B then begin
      loFind.Visible := False;
      tempBtn := nil;
      Exit;
    end;

  tempBtn := B;

  L := TListBoxItem(B.Parent);

  loFind.Visible := True;
  if B.Tag = 1 then begin
    addFindItem(lbFind, edFind, 'Subuh,Dzuhur,Ashr,Maghrib,Isya');
  end else begin
    lbFind.Items.Clear;
    TTask.Run(procedure begin
      fnLoadListImam;
    end).Start;
  end;

  if lbFind.Items.Count > 0 then
    fnSetHeightLB;

  loFind.Position.Y := L.Position.Y + L.Height;
end;

procedure TFJadwalImam.fnSetHeightLB;
begin
  loFind.Height := (lbFind.Items.Count) * 25 + 54;
end;

procedure TFJadwalImam.FirstShow;
begin
  setFrame;

  lbMain.Items.Clear;
  TTask.Run(procedure begin
    Sleep(Idle);
    fnLoadData;
  end).Start;
end;

procedure TFJadwalImam.fnClear;
begin
  btnCalonImam.Text := 'Pilih Calon Imam';
  btnCalonCadanganImam.Text := 'Pilih Calon Cadangan Imam';
  btnWaktuSholat.Text := 'Pilih Waktu Sholat';
  btnHapus.Visible := False;
end;

procedure TFJadwalImam.fnGoBack;
begin
  if tcMain.TabIndex = 0 then begin
    fnGoFrame(goFrame, fromFrame);
  end else begin
    lbProses.ViewportPosition := TPointF.Zero;
    tcMain.Previous;
    btnHapus.Visible := False;

    fnClear;
  end;
end;

procedure TFJadwalImam.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  fnLoadLoading(True);
  req :=  'loadJadwalImam';
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
        lblTgl.Text := arr[1,i];
        lblCI.Text := arr[5,i];
        lblCCI.Text := arr[6,i];

        addItem(
          arr[0, i].ToInteger,
          arr[1, i],
          arr[2, i],
          arr[3, i],
          arr[4, i]);
      end);
    end;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFJadwalImam.fnLoadListImam;
var
  arr : TStringArray;
  req, str : String;
  //i: Integer;
  sl : TStringList;
  L : TListBoxItem;
begin
  fnLoadIndicator(aniLoad, True);
  req :=  'loadListImam';
  try
    sl := TStringList.Create;
    try
      str := '';

      if tempBtn <> nil then begin
        if tempBtn.Hint = 'cadangan' then begin
          if btnCalonImam.Text <> 'Pilih Calon Imam' then
            str := btnCalonImam.Tag.ToString;
        end else begin
          if btnCalonCadanganImam.Text <> 'Pilih Calon Cadangan Imam' then
            str := btnCalonCadanganImam.Tag.ToString;
        end;
      end;

      sl.AddPair('id', str);
      arr := fnPostJSON(DM.nHTTP, req, sl);
    finally
      sl.DisposeOf;
    end;

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      Exit;
    end;

    TThread.Synchronize(nil, procedure var i : Integer; begin
      for i := 0 to Length(arr[0]) - 1 do begin
        L := TListBoxItem.Create(nil);
        L.Selectable := False;
        L.Height := 25;
        L.Text := arr[1, i];
        L.Tag := arr[0, i].ToInteger;
        L.Font.Size := 11;
        L.StyledSettings := [];
        lbFind.AddObject(L);
      end;
    end);
  finally
    fnLoadIndicator(aniLoad, False);
  end;
end;

procedure TFJadwalImam.fnProses;
var
  arr : TStringArray;
  req, str : String;
  i, idx: Integer;
  sl : TStringList;
begin
  fnLoadLoading(True);
  req :=  sProses + 'ImamSholat';
  try
    sl := TStringList.Create;
    try
      if (sProses = HAPUS) or (sProses = UBAH) then
        sl.AddPair('id', transID);

      if (sProses = TAMBAH) or (sProses = UBAH) then begin
        sl.AddPair('id_user', aIDUser);
        sl.AddPair('id_imam', btnCalonImam.Tag.ToString);
        sl.AddPair('id_imam_cadangan', btnCalonCadanganImam.Tag.ToString);
        sl.AddPair('waktu_sholat', LowerCase(btnWaktuSholat.Text));
        sl.AddPair('tgl_sholat', dtSholat.Text);
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
      fnClear;
      tcMain.Previous;
    end);

  finally
    fnLoadLoading(False);
  end;
end;

procedure TFJadwalImam.FrameClick(Sender: TObject);
begin
  if loFind.Visible then
    loFind.Visible := False;

  tempBtn := nil;
end;

procedure TFJadwalImam.lbFindItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if tempBtn = nil then
    Exit;

  tempBtn.Text := Item.Text;
  if tempBtn.Hint <> 'waktusholat' then
    tempBtn.Tag := Item.Tag;

  loFind.Visible := False;
end;

procedure TFJadwalImam.lbMainItemClick(const Sender: TCustomListBox;
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

  dtSholat.Text := getText(lo, lblTgl.Name);
  btnCalonImam.Text := getText(lo, lblCalonImam.Name);
  btnCalonCadanganImam.Text := getText(lo, lblCadanganCalonImam.Name);
  btnWaktuSholat.Text := getText(lo, lblWaktuSholat.Name);

  btnCalonImam.Tag := getText(lo, lblCI.Name).ToInteger;
  btnCalonCadanganImam.Tag := getText(lo, lblCCI.Name).ToInteger;

  btnHapus.Visible := True;

  sProses := UBAH;
  tcMain.Next;
end;

procedure TFJadwalImam.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFJadwalImam.setFrame;
begin
  tcMain.TabIndex := 0;
  btnHapus.Visible := False;
  loFind.Visible := False;

  if statF then
    Exit;

  statF := True;

  dtSholat.Date := Now;

  lbiProses.Height := lbProses.Height - (65 * 4 + 25);

  loTemp.Visible := False;
  loTemp.Position.X := 10;
  loTemp.Position.Y := 0;
  //loTemp.Width := FJadwalImam.Width - 100;

end;

end.
