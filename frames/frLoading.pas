unit frLoading;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Ani, System.Threading, FMX.Controls.Presentation,
  FMX.Effects;

type
  TFLoading = class(TFrame)
    background: TRectangle;
    tiMove: TTimer;
    loMain: TLayout;
    faOpa: TFloatAnimation;
    Label1: TLabel;
    imgLogo: TImage;
    ShadowEffect1: TShadowEffect;
    procedure FirstShow;
    procedure faOpaFinish(Sender: TObject);
    procedure tiMoveTimer(Sender: TObject);
  private
    { Private declarations }
    procedure setFrame;
  public
    { Public declarations }
    procedure ReleaseFrame;
  end;

var
  FLoading : TFLoading;

implementation

{$R *.fmx}

uses frMain, uFunc, uMain, uDM, uOpenUrl, uRest, uLogin;

{ TFTemp }

procedure TFLoading.faOpaFinish(Sender: TObject);
begin
  faOpa.Enabled := False;

  //fnGoFrame(LOADING, FEED);
  tiMove.Enabled := True;
end;

procedure TFLoading.FirstShow;
begin
  setFrame;
end;

procedure TFLoading.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFLoading.setFrame;
var
  wi, he, pad : Single;
begin
  //fnGetClient(FMain, FLoading);
  loMain.Visible := False;

  //fnLoadImage(background, 'background.png');
  //fnLoadImage(imgLogo, 'RABLOGO.png');

  TTask.Run(procedure begin
    Sleep(Round(idle * 1.25));  //
    TThread.Synchronize(nil, procedure begin
      fnGetClient(FMain, FLoading);
      loMain.Opacity := 0;
      loMain.Visible := True;
      faOpa.Enabled := True;
    end);
  end).Start;

  wi := FLoading.Width;
  he := FLoading.Height;
end;

procedure TFLoading.tiMoveTimer(Sender: TObject);
begin
  tiMove.Enabled := False;
  fnCekLogin;
end;

end.
