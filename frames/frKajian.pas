unit frKajian;

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
  TFKajian = class(TFrame)
    loMain: TLayout;
    loHeader: TLayout;
    reHeader: TRectangle;
    seHeader: TShadowEffect;
    btnBack: TCornerButton;
    btnHapus: TCornerButton;
    lbData: TListBox;
    SearchBox1: TSearchBox;
    tiRollUp: TTimer;
    loDisable: TLayout;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure tiRollUpTimer(Sender: TObject);
  private
    statF, isLoadData : Boolean;
    procedure setFrame;
    procedure addItem(idx: Integer; tema, ustadz, tgl, waktu, capt, nmImg, isFeed: String);
    procedure fnLoadData;
  public
    { Public declarations }
    procedure fnClickMenu;
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FKajian : TFKajian;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest, frMKajian;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFKajian.addItem(idx: Integer; tema, ustadz, tgl, waktu, capt, nmImg,
  isFeed: String);
var
  lo : TLayout;
  lb : TListBoxItem;
  ABitmap : TBitmap;
  R : TRectangle;
  LCapt, LTgl : TLabel;
begin
  capt := fnReplaceStr(capt, '\r', '');
  capt := fnReplaceStr(capt, '\n', ''#13);

  FMKajian.lblCaption.AutoSize := True;

  FMKajian.lblTgl.Text := 'Pada Tanggal ' + tgl;
  FMKajian.lblTema.Text := tema;
  FMKajian.lblWaktu.Text := 'Dimulai Pukul ' + waktu;
  FMKajian.lblUstadz.Text := 'Oleh ' + ustadz;
  FMKajian.lblCaption.Text := capt;
  //lblSelengkapnya.Tag := idx;

  if isFeed = '1' then begin
    FMKajian.glFeed.ImageIndex := 15;
    isFeed := 'Feed';
  end else begin
    FMKajian.glFeed.ImageIndex := -1;
    isFeed := 'Non Feed';
  end;

  FMKajian.loTemp.Height := fnGetPosYDown(FMKajian.lblCaption, 16);
  if FMKajian.loTemp.Height < 175 then
    FMKajian.loTemp.Height := 175;

  {if FMKajian.lblCaption.Height > 49 then
    FMKajian.lblSelengkapnya.Visible := True
  else
    FMKajian.lblSelengkapnya.Visible := False;


  FMKajian.lblCaption.AutoSize := False;
  FMKajian.lblCaption.Height := 49;}

  FMKajian.lblSelengkapnya.Visible := False;

  lb := TListBoxItem.Create(nil);
  lb.Height := FMKajian.loTemp.Height + 10;
  lb.Width := lbData.Width;
  lb.Selectable := False;
  lb.Tag := idx;
  lb.ItemData.Detail := nmImg;

  lb.FontColor := $00FFFFFF;
  lb.Text := Format('%s %s %s %s %s %s %s',
                      [tema, ustadz, tgl, waktu, capt, nmImg, isFeed]);

  lb.StyledSettings := [];

  lo := TLayout(FMKajian.loTemp.Clone(lb));
  lo.Parent := lb;
  lo.Width := lbData.Width - 20;//lbMain.Width;

  lo.Position.X := 10;
  lo.Position.Y := 0;

  lo.StyleName := 'loTemp';
  lo.Tag := idx;

  lo.Visible := True;

  //TLabel(lo.FindStyleResource('lblSelengkapnya')).OnClick := lblSelengkapnyaClick;   //reTempBackground
  R := TRectangle(lo.FindStyleResource('reTempBackground'));
  R := TRectangle(R.FindStyleResource('reTempImg'));

  ABitmap := TBitmap.Create;
  try
    ABitmap.LoadFromFile(fnLoadFile(nmImg));
    ABitmap := fnSetImgSize(ABitmap, 129);
    R.Fill.Bitmap.Bitmap.LoadFromFile(fnLoadFile(nmImg));

    R.Width := ABitmap.Width;
    R.Height := ABitmap.Height;

    TRectangle(R.Parent).Fill.Bitmap.Bitmap.LoadFromFile(fnLoadFile(nmImg));

    {LCapt := TLabel(lo.FindStyleResource('lblCaption'));
    //LExp := TLabel(lo.FindStyleResource('lblSelengkapnya'));
    LTgl := TLabel(lo.FindStyleResource('lblTanggal'));

    LCapt.Position.Y := fnGetPosYDown(R, 8);
    //LExp.Position.Y := fnGetPosYDown(LCapt, 8);
    LTgl.Position.Y := fnGetPosYDown(Lcapt, 8);

    lb.Height := fnGetPosYDown(LTgl, 16);

    if lb.Height < 175 then
      lb.Height := 175;}
  finally
    ABitmap.DisposeOf;
  end;

  lbData.AddObject(lb);
end;

procedure TFKajian.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFKajian.FirstShow;
begin
  setFrame;

  if isLoadData then
    Exit;

  lbData.Items.Clear;
  TTask.Run(procedure begin
    Sleep(Idle);
    fnLoadData;
  end).Start;
end;

procedure TFKajian.fnGoBack;
begin
  fnGoFrame(goFrame, FEED);
end;

procedure TFKajian.fnLoadData;
var
  arr : TStringArray;
  req : String;
  i: Integer;
begin
  isLoadData := False;
  fnLoadLoading(True);
  req :=  'loadKajian';
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
        fnDownloadFile(arr[6, i]);

      TThread.Synchronize(nil, procedure begin
        addItem(
          arr[0, i].ToInteger,
          arr[1, i],
          arr[2, i],
          arr[3, i],
          arr[4, i],
          arr[5, i],
          arr[6, i],
          arr[7, i]);
      end);

      Sleep(5);
    end;
    isLoadData := True;
  finally
    fnLoadLoading(False);
  end;
end;

procedure TFKajian.fnClickMenu;
begin
  if lbData.ViewportPosition.Y > 0 then begin
    tiRollUp.Enabled := True;
    loDisable.Visible := True;
  end else if lbData.ViewportPosition.Y = 0 then begin
    lbData.Items.Clear;
    TTask.Run(procedure begin
      fnLoadData;
    end).Start;
  end;
end;

procedure TFKajian.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFKajian.setFrame;
begin
  loDisable.Visible := False;

  fnClickBtn(FMain.btnKajian);
  if statF then
    Exit;

  statF := True;

end;

procedure TFKajian.tiRollUpTimer(Sender: TObject);
begin
  if lbData.ViewportPosition.Y > 0 then begin
    lbData.ViewportPosition := TPointF.Create(0, lbData.ViewportPosition.Y - 150);
  end else if lbData.ViewportPosition.Y = 0 then begin
    tiRollUp.Enabled := False;
    loDisable.Visible := False;
  end;
end;

end.
