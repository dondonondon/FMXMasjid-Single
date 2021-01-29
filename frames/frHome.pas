unit frHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading;

type
  TFHome = class(TFrame)
    loMain: TLayout;
    Label1: TLabel;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
  private
    statF : Boolean;
    procedure setFrame;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FHome : TFHome;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFHome.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFHome.FirstShow;
begin
  setFrame;
end;

procedure TFHome.fnGoBack;
begin
  fnGoFrame(goFrame, fromFrame);
end;

procedure TFHome.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFHome.setFrame;
begin
  //fnGetClient(FMain, FHome);

  if statF then
    Exit;

  statF := True;

end;

end.
