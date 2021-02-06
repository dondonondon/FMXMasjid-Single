unit frImam;

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
  TFImam = class(TFrame)
    loMain: TLayout;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnHapus: TCornerButton;
    lbMain: TListBox;
    SearchBox1: TSearchBox;
    loDisable: TLayout;
    tiRollUp: TTimer;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure tiRollUpTimer(Sender: TObject);
  private
    statF, isLoadData : Boolean;
    procedure setFrame;
    procedure addItem(idx : Integer; tgl, wkt_sholat, c_imam, c_cadangan_imam : String);
    procedure fnLoadData;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
    procedure fnClickMenu;
  end;

var
  FImam : TFImam;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest, frJadwalImamSholat;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFImam.addItem(idx: Integer; tgl, wkt_sholat, c_imam,
  c_cadangan_imam: String);
var
  stgl : String;
  lo : TLayout;
  lb : TListBoxItem;
begin
  stgl := fnDateENTOID(StrToDateTimeDef(tgl, Now));
  FJadwalImam.lblWaktuSholat.Text := ': ' + UpperCaseFirstLetter(wkt_sholat);
  FJadwalImam.lblCalonImam.Text := ': ' + c_imam;
  FJadwalImam.lblCadanganCalonImam.Text := ': ' + c_cadangan_imam;
  FJadwalImam.lblTanggal.Text := stgl;

  lb := TListBoxItem.Create(nil);
  lb.Height := FJadwalImam.loTemp.Height + 10;
  lb.Width := lbMain.Width;
  lb.Selectable := False;
  lb.Tag := idx;

  lb.FontColor := $00FFFFFF;
  lb.Text := Format('%s %s %s %s %s',
                      [stgl, tgl, wkt_sholat, c_imam, c_cadangan_imam]);
  lb.StyledSettings := [];

  lo := TLayout(FJadwalImam.loTemp.Clone(lb));
  lo.Parent := lb;
  lo.Width := lbMain.Width - 20;//lbMain.Width;

  lo.Position.X := 10;
  lo.Position.Y := 0;

  lo.StyleName := 'loTemp';
  lo.Tag := idx;

  lo.Visible := True;

  lbMain.AddObject(lb);
end;

procedure TFImam.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFImam.FirstShow;
begin
  setFrame;

  if isLoadData then
    Exit;

  lbMain.Items.Clear;
  TTask.Run(procedure begin
    Sleep(Idle);
    fnLoadData;
  end).Start;
end;

procedure TFImam.fnGoBack;
begin
  fnGoFrame(goFrame, FEED);
end;

procedure TFImam.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  isLoadData := False;
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
        //lblTgl.Text := arr[1,i];
        //lblCI.Text := arr[5,i];
        //lblCCI.Text := arr[6,i];

        addItem(
          arr[0, i].ToInteger,
          arr[1, i],
          arr[2, i],
          arr[3, i],
          arr[4, i]);
      end);
    end;
    isLoadData := True;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFImam.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFImam.fnClickMenu;
begin
  if lbMain.ViewportPosition.Y > 0 then begin
    tiRollUp.Enabled := True;
    loDisable.Visible := True;
  end else if lbMain.ViewportPosition.Y = 0 then begin
    lbMain.Items.Clear;
    TTask.Run(procedure begin
      fnLoadData;
    end).Start;
  end;
end;

procedure TFImam.setFrame;
begin
  loDisable.Visible := False;

  fnClickBtn(FMain.btnImam);
  if statF then
    Exit;

  statF := True;

end;
procedure TFImam.tiRollUpTimer(Sender: TObject);
begin
  if lbMain.ViewportPosition.Y > 0 then begin
    lbMain.ViewportPosition := TPointF.Create(0, lbMain.ViewportPosition.Y - 150);
  end else if lbMain.ViewportPosition.Y = 0 then begin
    tiRollUp.Enabled := False;
    loDisable.Visible := False;
  end;
end;


end.
