unit frInformasi;

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
  TFInformasi = class(TFrame)
    loMain: TLayout;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnHapus: TCornerButton;
    lbMain: TListBox;
    SearchBox1: TSearchBox;
    tiRollUp: TTimer;
    loDisable: TLayout;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure tiRollUpTimer(Sender: TObject);
  private
    statF, isLoadData : Boolean;
    procedure setFrame;
    procedure addItem(idx : Integer; tgl, capt, isFeed : String);
    procedure fnLoadData;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
    procedure fnClickMenu;
  end;

var
  FInformasi : TFInformasi;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest, frMInformasi;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFInformasi.addItem(idx: Integer; tgl, capt, isFeed: String);
var
  lo : TLayout;
  lb : TListBoxItem;
  R : TRectangle;
  L : TLabel;
begin
  capt := fnReplaceStr(capt, '\r', '');
  capt := fnReplaceStr(capt, '\n', ''#13);
  capt := fnReplaceStr(capt, '\', '"');

  FMInformasi.glFeed.ImageIndex := 0;

  FMInformasi.lblCaption.AutoSize := True;

  FMInformasi.lblTanggal.Text := tgl;
  FMInformasi.lblCaption.Text := capt;

  FMInformasi.loTemp.Height := fnGetPosYDown(FMInformasi.lblCaption, 6);
  FMInformasi.lblSelengkapnya.Visible := False;

  lb := TListBoxItem.Create(nil);
  lb.Height := FMInformasi.loTemp.Height + 10;
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
  lo.Position.Y := 0;

  lo.StyleName := 'loTemp';
  lo.Tag := idx;

  {L := TLabel.Create(nil);
  L.Parent := lb;
  L.Width := lb.Width;
  L.Height := 20;
  L.Text := '[INFORMASI]';
  L.Font.Style := [TFontStyle.fsBold];
  L.Font.Size := 13;
  L.StyledSettings := [];

  L.Position.X := 10;
  L.Position.Y := 10;}

  lo.Visible := True;

  //TLabel(lo.FindStyleResource('lblSelengkapnya')).OnClick := lblSelengkapnyaClick;   //reTempBackground

  lbMain.AddObject(lb);
end;

procedure TFInformasi.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFInformasi.FirstShow;
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

procedure TFInformasi.fnClickMenu;
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

procedure TFInformasi.fnGoBack;
begin
  fnGoFrame(goFrame, FEED);
end;

procedure TFInformasi.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  isLoadData := False;
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

    isLoadData := True;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFInformasi.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFInformasi.setFrame;
begin
  loDisable.Visible := False;

  fnClickBtn(FMain.btnInformasi);

  if statF then
    Exit;

  statF := True;

end;

procedure TFInformasi.tiRollUpTimer(Sender: TObject);
begin
  if lbMain.ViewportPosition.Y > 0 then begin
    lbMain.ViewportPosition := TPointF.Create(0, lbMain.ViewportPosition.Y - 150);
  end else if lbMain.ViewportPosition.Y = 0 then begin
    tiRollUp.Enabled := False;
    loDisable.Visible := False;
  end;
end;

end.
