unit frTemp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading;

type
  TFTemp = class(TFrame)
    loMain: TLayout;
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
  FTemp : TFTemp;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFTemp.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFTemp.FirstShow;
begin
  setFrame;
end;

procedure TFTemp.fnGoBack;
begin
  fnGoFrame(goFrame, fromFrame);
end;

procedure TFTemp.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFTemp.setFrame;
begin
  fnGetClient(FMain, FTemp);

  if statF then
    Exit;

  statF := True;

end;

end.
