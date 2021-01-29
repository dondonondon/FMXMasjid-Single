unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    QTemp1: TFDQuery;
    QTemp2: TFDQuery;
    QTemp3: TFDQuery;
    QTemp4: TFDQuery;
    RClient: TRESTClient;
    RReq: TRESTRequest;
    RResp: TRESTResponse;
    bgRClient: TRESTClient;
    bgRReq: TRESTRequest;
    bgRResp: TRESTResponse;
    nHTTP: TNetHTTPClient;
    img: TImageList;
    procedure ConnBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    System.IOUtils;
  {$ELSEIF Defined(MSWINDOWS)}
    System.IOUtils, IWSystem;
  {$ELSE}
    System.IOUtils;
  {$ENDIF}

{$R *.dfm}

procedure TDM.ConnBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    {Conn.Params.Values['Database'] :=
      TPath.GetDocumentsPath + PathDelim + 'dbRAB.db';}
  {$ELSE}
    //Conn.Params.Values['Database'] := gsAppPath + 'dbRAB.db';
  {$ENDIF}
end;

end.
