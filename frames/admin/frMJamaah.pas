unit frMJamaah;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects, FMX.ListBox, FMX.Edit, FMX.SearchBox, FMX.Effects, FMX.TabControl,
  FMX.ImgList;

type
  TFMJamaah = class(TFrame)
    loTemp: TLayout;
    reTemp: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblPengeluaran: TLabel;
    lblJmlKeluarga: TLabel;
    lblPekerjaan: TLabel;
    lblPendidikan: TLabel;
    lblEmail: TLabel;
    lblNoHp: TLabel;
    lblRTRW: TLabel;
    lblAlamat: TLabel;
    lblNama: TLabel;
    lbMain: TListBox;
    SearchBox1: TSearchBox;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnHapus: TCornerButton;
    tcMain: TTabControl;
    tiData: TTabItem;
    tiProses: TTabItem;
    btnAdd: TCornerButton;
    edNama: TEdit;
    lbProses: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    edAlamat: TEdit;
    ListBoxItem3: TListBoxItem;
    edRT: TEdit;
    ListBoxItem4: TListBoxItem;
    edNoHp: TEdit;
    ListBoxItem5: TListBoxItem;
    edEmail: TEdit;
    ListBoxItem6: TListBoxItem;
    edPendidikan: TEdit;
    ListBoxItem7: TListBoxItem;
    edPekerjaan: TEdit;
    ListBoxItem8: TListBoxItem;
    edJmlKeluarga: TEdit;
    ListBoxItem9: TListBoxItem;
    edPengeluaran: TEdit;
    ListBoxItem10: TListBoxItem;
    edRW: TEdit;
    swImam: TSwitch;
    Label10: TLabel;
    ListBoxItem11: TListBoxItem;
    btnProses: TCornerButton;
    btnClear: TCornerButton;
    Glyph1: TGlyph;
    loFind: TLayout;
    Rectangle1: TRectangle;
    lbFind: TListBox;
    edFind: TSearchBox;
    lblIsImam: TLabel;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure lbMainItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnAddClick(Sender: TObject);
    procedure edNamaTyping(Sender: TObject);
    procedure btnProsesClick(Sender: TObject);
    procedure lbProsesItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FrameClick(Sender: TObject);
    procedure lbFindItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbProsesViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure btnClearClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure edPendidikanChange(Sender: TObject);
  private
    statF : Boolean;
    sProses : String;
    tempEdit : TEdit;
    transID : String;
    procedure setFrame;
    procedure addItem(idx : Integer; nm, alamat, rtrw, nohp, email, pendidikan, pekerjaan, jml_keluarga, pengeluaran, isImam : String);
    procedure fnLoadData;
    procedure fnSetHeightLB;
    procedure fnClear;
    procedure fnProses;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FMJamaah : TFMJamaah;

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

procedure TFMJamaah.addItem(idx : Integer; nm, alamat, rtrw, nohp, email, pendidikan,
  pekerjaan, jml_keluarga, pengeluaran, isImam: String);
var
  lo : TLayout;
  lb : TListBoxItem;
begin
  lblNama.Text := ': ' + nm;
  lblAlamat.Text := ': ' + alamat;
  lblRTRW.Text := ': ' + rtrw;
  lblNoHp.Text := ': ' + nohp;
  lblEmail.Text := ': ' + email;
  lblPendidikan.Text := ': ' + pendidikan;
  lblPekerjaan.Text := ': ' + pekerjaan;
  lblJmlKeluarga.Text := ': ' + jml_keluarga;
  lblPengeluaran.Text := ': ' + pengeluaran;
  lblIsImam.Text := isImam;

  if isImam = '1' then begin
    reTemp.Fill.Color := $FFB3CECB;
    isImam := 'imam';
  end else begin
    reTemp.Fill.Color := $FFFFFFFF;
    isImam := 'jamaah';
  end;

  lb := TListBoxItem.Create(nil);
  lb.Height := loTemp.Height + 10;
  lb.Width := lbMain.Width;
  lb.Selectable := False;
  lb.Tag := idx;

  lb.FontColor := $00FFFFFF;
  lb.Text := Format('%s %s %s %s %s %s %s %s %s %s',
                      [nm, alamat, rtrw, nohp, email, pendidikan,
                       pekerjaan, jml_keluarga, pengeluaran, isImam]);

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

procedure TFMJamaah.btnAddClick(Sender: TObject);
begin
  fnClear;
  sProses := TAMBAH;

  btnHapus.Visible := False;

  tcMain.Next;
end;

procedure TFMJamaah.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFMJamaah.btnClearClick(Sender: TObject);
begin
  fnClear;
end;

procedure TFMJamaah.btnHapusClick(Sender: TObject);
begin
  sProses := HAPUS;
  TTask.Run(procedure begin
    fnProses;
  end).Start;
end;

procedure TFMJamaah.btnProsesClick(Sender: TObject);
begin
  FrameClick(Sender);
  if (edNama.Text = '') or (edAlamat.Text = '') or (edRT.Text = '') or (edNoHp.Text = '') or (edEmail.Text = '')
   or (edPendidikan.Text = '') or (edPekerjaan.Text = '') or (edJmlKeluarga.Text = '') or (edPengeluaran.Text = '')
   or (edRW.Text = '') then begin

   fnShowE('FIELD TIDAK DIISI DENGAN BENAR');
   Exit;
  end;

  TTask.Run(procedure begin
    fnProses;
  end).Start;
end;

procedure TFMJamaah.edNamaTyping(Sender: TObject);
var
  E : TEdit;
  L : TListBoxItem;
begin
  E := TEdit(Sender);
  setEdit(E);

  if E.Tag = 0 then begin
    loFind.Visible := False;
    Exit;
  end;

  tempEdit := E;

  if E.Text = '' then begin
    loFind.Visible := False;
  end else begin
    L := TListBoxItem(E.Parent);
    loFind.Visible := True;
    if E.Hint <> lbFind.Hint then begin
      addFindItem(lbFind, edFind, E.Hint);
      lbFind.Hint := E.Hint;
    end;

    edFind.Text := E.Text;

    if lbFind.Items.Count > 0 then
      fnSetHeightLB
    else
      loFind.Visible := False;

    //loFind.Position.Y := L.Position.Y + L.Height - lbProses.ViewportPosition.Y;
    loFind.Position.Y := L.Position.Y - lbProses.ViewportPosition.Y - loFind.Height;
    if (loFind.Position.Y + loFind.Height) > tcMain.Height then begin
      loFind.Position.Y := L.Position.Y - lbProses.ViewportPosition.Y - loFind.Height;
    end;
  end;
end;

procedure TFMJamaah.edPendidikanChange(Sender: TObject);
var
  E : TEdit;
  L : TListBoxItem;
begin
  E := TEdit(Sender);
  setEdit(E);
end;

procedure TFMJamaah.fnSetHeightLB;
begin
  loFind.Height := (lbFind.Items.Count) * 25 + 14;
end;

procedure TFMJamaah.FirstShow;
begin
  setFrame;
  lbMain.Items.Clear;
  TTask.Run(procedure begin
    Sleep(Idle);
    fnLoadData;
  end).Start;
end;

procedure TFMJamaah.fnClear;
begin
  edNama.Text := '';
  edAlamat.Text := '';
  edRT.Text := '';
  edNoHp.Text := '';
  edEmail.Text := '';
  edPendidikan.Text := '';
  edPekerjaan.Text := '';
  edJmlKeluarga.Text := '';
  edPengeluaran.Text := '';
  edRW.Text := '';

  swImam.IsChecked := False;
end;

procedure TFMJamaah.fnGoBack;
begin
  if tcMain.TabIndex = 0 then begin
    fnGoFrame(goFrame, fromFrame);
  end else begin
    lbProses.ViewportPosition := TPointF.Zero;

    tcMain.Previous;
    loFind.Visible := False;
    btnHapus.Visible := False;
    tempEdit := nil;

    fnClear;
  end;
end;

procedure TFMJamaah.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  fnLoadLoading(True);
  req :=  'loadJamaah';
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
          arr[11, i].ToInteger,
          arr[0, i],
          arr[1, i],
          arr[2, i] + '/' + arr[3, i],
          arr[4, i],
          arr[5, i],
          arr[6, i],
          arr[7, i],
          arr[8, i],
          arr[9, i],
          arr[10, i]);
      end);

      Sleep(5);
    end;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFMJamaah.fnProses;
var
  arr : TStringArray;
  req, str : String;
  i, idx: Integer;
  sl : TStringList;
begin
  fnLoadLoading(True);
  req :=  sProses + 'Jamaah';
  try
    sl := TStringList.Create;
    try
      if (sProses = HAPUS) or (sProses = UBAH) then
        sl.AddPair('id', transID);

      if (sProses = TAMBAH) or (sProses = UBAH) then begin
        sl.AddPair('nm_jamaah', edNama.Text);
        sl.AddPair('alamat', edAlamat.Text);
        sl.AddPair('rt', edRT.Text);
        sl.AddPair('rw', edRW.Text);
        sl.AddPair('nohp', edNoHp.Text);
        sl.AddPair('email', edEmail.Text);
        sl.AddPair('pendidikan', edPendidikan.Text);
        sl.AddPair('pekerjaan', edPekerjaan.Text);
        sl.AddPair('jml_keluarga', edJmlKeluarga.Text);
        sl.AddPair('pengeluaran_rumah_tangga', edPengeluaran.Text);
        if swImam.IsChecked then
          sl.AddPair('isImam', '1')
        else
          sl.AddPair('isImam', '0')
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

procedure TFMJamaah.FrameClick(Sender: TObject);
begin
  if loFind.Visible then
    loFind.Visible := False;
end;

procedure TFMJamaah.lbFindItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if tempEdit = nil then
    Exit;

  tempEdit.Text := Item.Text;
  tempEdit := nil;

  loFind.Visible := False;
end;

procedure TFMJamaah.lbMainItemClick(const Sender: TCustomListBox;
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

  edNama.Text := getText(lo, lblNama.Name);
  edAlamat.Text := getText(lo, lblAlamat.Name);

  s := getText(lo, lblRTRW.Name);
  SetLength(s,pos('/',s)-1);
  edRT.Text := s;

  s := getText(lo, lblRTRW.Name);
  Delete(s,1,pos('/',s));
  edRW.Text := s;

  edNoHp.Text := getText(lo, lblNoHp.Name);
  edEmail.Text := getText(lo, lblEmail.Name);
  edPendidikan.Text := getText(lo, lblPendidikan.Name);
  edPekerjaan.Text := getText(lo, lblPekerjaan.Name);
  edJmlKeluarga.Text := getText(lo, lblJmlKeluarga.Name);
  edPengeluaran.Text := getText(lo, lblPengeluaran.Name);

  if getText(lo, lblIsImam.Name) = '1' then
    swImam.IsChecked := True
  else
    swImam.IsChecked := False;

  btnHapus.Visible := True;

  sProses := UBAH;
  tcMain.Next;
end;

procedure TFMJamaah.lbProsesItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  {loFind.Position.Y := Item.Position.Y + Item.Height - lbProses.ViewportPosition.Y;
  if (loFind.Position.Y + loFind.Height) > tcMain.Height then begin
    loFind.Position.Y := Item.Position.Y - lbProses.ViewportPosition.Y - loFind.Height;
  end;}
end;

procedure TFMJamaah.lbProsesViewportPositionChange(Sender: TObject;
  const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
var
  L : TListBoxItem;
begin
  if tempEdit = nil then
    Exit;

  L := TListBoxItem(tempEdit.Parent);

  //loFind.Position.Y := L.Position.Y + L.Height - lbProses.ViewportPosition.Y;
  loFind.Position.Y := L.Position.Y - lbProses.ViewportPosition.Y - loFind.Height;
  if (loFind.Position.Y + loFind.Height) > tcMain.Height then begin
    loFind.Position.Y := L.Position.Y - lbProses.ViewportPosition.Y - loFind.Height;
  end;
end;

procedure TFMJamaah.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFMJamaah.setFrame;
begin
  tcMain.TabIndex := 0;
  btnHapus.Visible := False;
  loFind.Visible := False;
  tempEdit := nil;

  if statF then
    Exit;

  statF := True;

  loTemp.Visible := False;
  loTemp.Position.X := 10;
  loTemp.Position.Y := 0;
  loTemp.Width := FMJamaah.Width - 100;

end;

end.
