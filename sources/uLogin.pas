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

uses uDM, uFunc, uMain, uOpenUrl, uRest;
    
procedure fnLogin(str, password : String);
begin

end;

procedure fnRegister(user, mail, notelp, password, level : String);
begin

end;

procedure fnUpdateUser(user, mail, notelp, password, level : String);
begin

end;

procedure fnCekLogin;
begin

end;

end.
