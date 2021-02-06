unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects, FMX.StdCtrls,
  FMX.DialogService, IdHashMessageDigest, idHash, IdGlobal, System.Threading;

procedure fnRegister(user, mail, notelp, password, level : String);
procedure fnUpdateUser(user, mail, notelp, password, level : String);
procedure fnLogin(str, password : String);
procedure fnCekLogin;

implementation

uses uDM, uFunc, uMain, uOpenUrl, uRest, frMain;
    
procedure fnLogin(str, password : String);
var
  arr : TStringArray;
  req : String;
begin
  try
    req := 'signin&user='+str+'&password='+password;
    arr := fnGetJSON(DM.nHTTP, req);

    if arr[0, 0] = 'null' then begin
      fnShowE(arr[1, 0]);
      if goFrame = LOADING then
        fnThreadSyncGoFrame(goFrame, FEED);

      Exit;
    end;

    aIDUser := arr[0, 0];
    aUsername := arr[1, 0];
    aPassword := arr[5, 0];

    fnSimpanUserINI(aUsername, aPassword);

    TThread.Synchronize(nil, procedure begin
      FMain.lbSetting.ItemByIndex(0).Text := 'Masuk ke Menu';
      FMain.lbSetting.ItemByIndex(0).ItemData.Detail := MENUADMIN;

      if fromFrame = FEED then
        fnGoFrame(goFrame, MENUADMIN)
      else
        fnGoFrame(goFrame, FEED);
    end);

  finally

  end;
end;

procedure fnRegister(user, mail, notelp, password, level : String);
begin

end;

procedure fnUpdateUser(user, mail, notelp, password, level : String);
begin

end;

procedure fnCekLogin;
var
  pass : String;
begin
  try
    fnLoadUserINI;

    if (aUsername <> '') or (aPassword <> '') then begin
      TTask.Run(procedure begin
        fnLogin(aUsername, aPassword);
      end).Start;
    end else begin
      fnGoFrame(goFrame, FEED);
    end;
  except
    fnGoFrame(goFrame, FEED);
  end;
end;

end.
