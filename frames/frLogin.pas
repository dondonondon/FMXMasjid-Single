unit frLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Threading, FMX.Edit,
  FMX.ImgList, FMX.Objects;

type
  TFLogin = class(TFrame)
    loLogin: TLayout;
    edUsername: TEdit;
    edPassword: TEdit;
    PasswordEditButton1: TPasswordEditButton;
    Label3: TLabel;
    CornerButton1: TCornerButton;
    Rectangle1: TRectangle;
    procedure FirstShow;
    procedure btnBackClick(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
  private
    statF : Boolean;
    procedure setFrame;
  public
    { Public declarations }
    procedure ReleaseFrame;
    procedure fnGoBack;
  end;

var
  FLogin : TFLogin;

implementation

{$R *.fmx}

uses frMain, uFunc, uDM, uMain, uOpenUrl, uRest, uLogin;

{ TFTemp }

const
  spc = 10;
  pad = 8;

procedure TFLogin.btnBackClick(Sender: TObject);
begin
  fnGoBack;
end;

procedure TFLogin.CornerButton1Click(Sender: TObject);
begin
  if (edUsername.Text = '') or (edPassword.Text = '') then begin
    fnShowE('FIELD TIDAK BOLEH KOSONG');
    Exit;
  end;

  TTask.Run(procedure begin
    fnLogin(edUsername.Text, MD5(edPassword.Text));
  end).Start;
end;

procedure TFLogin.FirstShow;
begin
  setFrame;
end;

procedure TFLogin.fnGoBack;
begin
  fnGoFrame(goFrame, fromFrame);
end;

procedure TFLogin.ReleaseFrame;
begin
  DisposeOf;
end;

procedure TFLogin.setFrame;
var
  wi, he : Single;
begin
  //fnGetClient(FMain, FLogin);
  wi := FLogin.Width;
  he := FLogin.Height;

  if statF then
    Exit;

  statF := True;

end;

end.
