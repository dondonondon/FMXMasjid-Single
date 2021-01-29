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
    Edit1: TEdit;
    ListBoxItem3: TListBoxItem;
    Edit2: TEdit;
    ListBoxItem4: TListBoxItem;
    Edit3: TEdit;
    ListBoxItem5: TListBoxItem;
    Edit4: TEdit;
    ListBoxItem6: TListBoxItem;
    Edit5: TEdit;
    ListBoxItem7: TListBoxItem;
    Edit6: TEdit;
    ListBoxItem8: TListBoxItem;
    Edit7: TEdit;
    ListBoxItem9: TListBoxItem;
    Edit8: TEdit;
    ListBoxItem10: TListBoxItem;
    Edit10: TEdit;
    gsr1: TSwitch;
    Label10: TLabel;
    ListBoxItem11: TListBoxItem;
    btnProses: TCornerButton;
    btnClear: TCornerButton;
    Glyph1: TGlyph;
    loFind: TLayout;
    Rectangle1: TRectangle;
    lbFind: TListBox;
    edFind: TSearchBox;
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
  private
    statF : Boolean;
    sProses : Integer;
    tempEdit : TEdit;
    procedure setFrame;
    procedure addItem(idx : Integer; nm, alamat, rtrw, nohp, email, pendidikan, pekerjaan, jml_keluarga, pengeluaran, isImam : String);
    procedure fnLoadData;
    procedure fnSetHeightLB;
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
  TAMBAH  = 0;
  UBAH    = 1;
  HAPUS   = 2;

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
  sProses := TAMBAH;
  tcMain.Next;
end;

procedure TFMJamaah.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFMJamaah.btnProsesClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to lbProses.Items.Count - 1 do begin
    fnGetE(lbProses.ItemByIndex(i).Position.Y.ToString, '');
  end;
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

procedure TFMJamaah.fnSetHeightLB;
begin
  loFind.Height := (lbFind.Items.Count) * 25 + 14;
end;

procedure TFMJamaah.FirstShow;
begin
  setFrame;
  TTask.Run(procedure begin
    fnLoadData;
  end).Start;
end;

procedure TFMJamaah.fnGoBack;
begin
  if tcMain.TabIndex = 0 then begin
    fnGoFrame(goFrame, fromFrame);
  end else begin
    tcMain.Previous;
    loFind.Visible := False;
    btnHapus.Visible := False;
    tempEdit := nil;
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
    end;
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
begin
  //ShowMessage(TLayout(Item.FindStyleResource('lbMenu')).Tag.ToString);
  for i := 0 to Item.ControlsCount - 1 do begin
    if Item.Controls[i] is TLayout then
      if TLayout(Item.Controls[i]).StyleName = 'loTemp' then begin
        lo := TLayout(Item.Controls[i]);
        Break;
      end;
  end;
  ShowMessage(getText(lo, 'lblAlamat'));
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
