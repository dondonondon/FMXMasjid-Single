unit frAkun;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, System.ImageList, FMX.ImgList, FMX.Edit,
  FMX.Objects, FMX.Layouts;

type
  TFAkun = class(TFrame)
    loHeader: TLayout;
    reHeader: TRectangle;
    img: TImage;
    loProfil: TLayout;
    edUser: TEdit;
    Glyph3: TGlyph;
    edMail: TEdit;
    Glyph1: TGlyph;
    Label1: TLabel;
    btnLogOut: TCornerButton;
    edNotelp: TEdit;
    Glyph4: TGlyph;
    imgL: TImageList;
    procedure btnLogOutClick(Sender: TObject);
  private
    { Private declarations }
    procedure setFrame;
  public
    { Public declarations }
    procedure FirstShow;
    procedure ReleaseFrame;
  end;

var
  FAkun : TFAkun;

implementation

{$R *.fmx}

uses uDM, uFunc, uMain, uRest;

{ TFAkun }

procedure TFAkun.btnLogOutClick(Sender: TObject);
begin
  fnClearUserINI;
  fnGoFrame(goFrame, FEED);
end;

procedure TFAkun.FirstShow;
begin
  setFrame;

  {edUser.Text := LoadSettingString(User, 'usr','');
  edMail.Text := email;
  edNotelp.Text := notelp;}
end;

procedure TFAkun.ReleaseFrame;
begin
  DisposeOf;
  FAkun := nil;
end;

procedure TFAkun.setFrame;
var
  wi, he, pad : Single;
begin
  wi := FAkun.Width;
  he := FAkun.Height;

  pad := 8;
end;

end.
