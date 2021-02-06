unit frMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Objects,
  FMX.ListBox, FMX.Effects, System.ImageList, FMX.ImgList;

type
  TFMenu = class(TFrame)
    loMain: TLayout;
    imgHeader: TImage;
    Label15: TLabel;
    lbMenu: TListBox;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnMore: TCornerButton;
    background: TRectangle;
    img: TImageList;
    seHeaderImg: TShadowEffect;
    btnBackToFeed: TCornerButton;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure lbMenuItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnBackToFeedClick(Sender: TObject);
  private
    statF : Boolean;
    procedure addMenu(menu : String; gl : Integer);
    procedure fnCekPermission;
    procedure setFrame;
    procedure fnReload(Sender : TObject);
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FMenu : TFMenu;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFMenu.addMenu(menu: String; gl: Integer);
var
  lb : TListBoxItem;
begin
  lb := TListBoxItem.Create(lbMenu);
  lb.Parent := lbMenu;
  lb.Height := 130;//175;
  lb.Width := lbMenu.Width;

  lb.Tag := gl;

  lb.Selectable := False;

  lb.Text := menu;

  lb.FontColor := $00000000;
  lb.StyledSettings := [];

  lb.StyleLookup := 'lbMenu';
  lb.StylesData['lblMenu'] := menu;
  lb.StylesData['glMenu.Images'] := img;
  lb.StylesData['glMenu.ImageIndex'] := gl;
end;

procedure TFMenu.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFMenu.btnBackToFeedClick(Sender: TObject);
begin
  fnGoFrame(MENUADMIN, FEED);
end;

procedure TFMenu.FirstShow;
begin
  setFrame;

  if lbMenu.Items.Count > 0 then
    Exit;

  lbMenu.Items.Clear;
  TTask.Run(procedure () begin
    fnCekPermission;
  end).Start;
end;

procedure TFMenu.fnCekPermission;
var
  arr : TStringArray;
  req, str : String;
  i, idx: Integer;
  sl : TStringList;
begin
  fnLoadLoading(True);
  req :=  'loadPermission';
  try
    sl := TStringList.Create;
    try
      sl.AddPair('id', aIDUser);
      arr := fnPostJSON(DM.nHTTP, req, sl);
    finally
      sl.DisposeOf;
    end;

    if arr[0,0] = 'null' then begin
      fnShowE(arr[1, 0]);
      fnShowReload(fnReload);
      Exit;
    end;

    for i := 0 to Length(arr[0]) - 1 do begin
      if arr[2, i] = '1' then begin
        idx := 0;

        if arr[1, i] = 'DATA JAMAAH' then
          idx := 0
        else if arr[1, i] = 'JADWAL IMAM' then
          idx := 1
        else if arr[1, i] = 'KEGIATAN TPQ' then
          idx := 8//2
        else if arr[1, i] = 'JADWAL KAJIAN' then
          idx := 3
        else if arr[1, i] = 'LAPORAN KEUANGAN' then
          idx := 8//4
        else if arr[1, i] = 'PENGUMUMAN' then
          idx := 5
        else if arr[1, i] = 'AKUN' then
          idx := 6
        else if arr[1, i] = 'PROSES JADWAL' then
          idx := 8{7}
        else if arr[1, i] = 'MANAJEMEN FEED' then
          idx := 9{7};

        TThread.Synchronize(nil, procedure begin
          addMenu(arr[1, i], idx);
        end);

      end;
    end;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFMenu.fnGoBack;
begin
  fnGoFrame(goFrame, fromFrame);
end;

procedure TFMenu.fnReload(Sender: TObject);
begin
  fnShowReload(False);
  lbMenu.Items.Clear;
  TTask.Run(procedure () begin
    fnCekPermission;
  end).Start;
end;

procedure TFMenu.lbMenuItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if Item.Tag = 8 then begin
    fnShowE('FITUR AKAN SEGERA HADIR');
    Exit;
  end;
  fnGoFrame(MENUADMIN, Item.Text);
end;

procedure TFMenu.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFMenu.setFrame;
begin
  if statF then
    Exit;

  statF := True;

end;

end.
