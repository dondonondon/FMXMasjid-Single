program prjMasjidFMX;



{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  System.SysUtils,
  System.Classes,
  {$IF DEFINED (ANDROID)}
  FMX.FontGlyphs.Android in 'sources\FMX.FontGlyphs.Android.pas',
  {$ENDIF }
  uFontSetting in 'sources\uFontSetting.pas',
  uFunc in 'sources\uFunc.pas',
  uGoFrame in 'sources\uGoFrame.pas',
  uMain in 'sources\uMain.pas',
  uOpenUrl in 'sources\uOpenUrl.pas',
  uRest in 'sources\uRest.pas',
  frLoading in 'frames\frLoading.pas' {FLoading: TFrame},
  uDM in 'uDM.pas' {DM: TDataModule},
  frMain in 'frMain.pas' {FMain},
  uLogin in 'sources\uLogin.pas',
  frLogin in 'frames\frLogin.pas' {FLogin: TFrame},
  frHome in 'frames\frHome.pas' {FHome: TFrame},
  frFeed in 'frames\frFeed.pas' {FFeed: TFrame},
  frMenu in 'frames\admin\frMenu.pas' {FMenu: TFrame},
  frMJamaah in 'frames\admin\frMJamaah.pas' {FMJamaah: TFrame},
  frJadwalImamSholat in 'frames\admin\frJadwalImamSholat.pas' {FJadwalImam: TFrame},
  frMFeed in 'frames\admin\frMFeed.pas' {FMFeed: TFrame},
  frMKajian in 'frames\admin\frMKajian.pas' {FMKajian: TFrame},
  frMInformasi in 'frames\admin\frMInformasi.pas' {FMInformasi: TFrame},
  frInformasi in 'frames\frInformasi.pas' {FInformasi: TFrame},
  frKajian in 'frames\frKajian.pas' {FKajian: TFrame},
  frImam in 'frames\frImam.pas' {FImam: TFrame},
  frAkun in 'frames\frAkun.pas' {FAkun: TFrame};

{$R *.res}
var
  FormatBr: TFormatSettings;

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFMKajian, FMKajian);
  try
    begin
      FormatBr                     := TFormatSettings.Create;
      FormatBr.DecimalSeparator    := '.';
      FormatBr.ThousandSeparator   := ',';
      FormatBr.DateSeparator       := '-';
      FormatBr.ShortDateFormat     := 'yyyy-mm-dd';
      FormatBr.LongDateFormat      := 'yyyy-mm-dd hh:nn:ss';
      FormatBr.ShortTimeFormat     := 'hh:nn';
      FormatBr.LongTimeFormat      := 'hh:nn:ss';

      System.SysUtils.FormatSettings := FormatBr;
    end;
  except
    Application.Terminate;
  end;
  Application.Run;
end.

