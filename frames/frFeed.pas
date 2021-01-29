unit frFeed;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.ListBox,
  FMX.Objects, FMX.Effects, System.ImageList, FMX.ImgList, System.IOUtils
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
    imgFeed: TRectangle;
    ShadowEffect1: TShadowEffect;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    Label3: TLabel;
    lblCaption: TLabel;
    CornerButton4: TCornerButton;
    imgComment: TCircle;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    img: TImageList;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure lbMainViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure btnMoreClick(Sender: TObject);
  private
    tSizeAwal, tSizeStop, tSizeMax : Single;
    statF : Boolean;
    procedure setFrame;
    procedure addSpace;
    procedure addItem;
    procedure fnClickTemp(Sender: TObject);
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FFeed : TFFeed;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest;

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
    lb := TListBoxItem.Create(lbMain);
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

procedure TFFeed.btnMoreClick(Sender: TObject);
begin
  lbMain.ItemByIndex(1).Height := 20;
end;

procedure TFFeed.FirstShow;
begin
  setFrame;

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

    if NewViewportPosition.Y < 10 then
      loShowJadwal.Opacity := 0;

    Application.ProcessMessages;
  end else begin
    if loHeader.Height <> tSizeStop then begin
      loHeader.Height := tSizeStop;
      lbMain.ItemByIndex(0).Height := FFeed.Height - loHeader.Height;
      loJadwal.Opacity := 0;
      loShowJadwal.Opacity := 1;

      Application.ProcessMessages;

    end;
  end;
end;

procedure TFFeed.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFFeed.setFrame;
begin
  if statF then
    Exit;

  statF := True;

  tSizeAwal := 178;
  tSizeStop := 108;
  tSizeMax := tSizeAwal - tSizeStop;

end;

end.
