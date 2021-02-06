unit frMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, System.Math,
  FMX.Ani, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.DialogService,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.Platform, FMX.ListView.Adapters.Base, FMX.VirtualKeyboard,
  System.ImageList, FMX.ImgList, FMX.ScrollBox, FMX.Memo, FMX.TabControl,
  FMX.Effects, UI.Toast, FMX.DateTimeCtrls, FMX.WebBrowser, FMX.Edit,
  FMX.ListBox
  {$IF Defined(ANDROID)}
    ,Androidapi.JNI.AdMob, Androidapi.Helpers, FMX.Platform.Android,
    FMX.Helpers.Android, Androidapi.JNI.PlayServices, Androidapi.JNI.Os,
    Androidapi.JNI.JavaTypes, Androidapi.JNIBridge, Androidapi.JNI.Embarcadero;
  {$ELSEIF Defined(MSWINDOWS)}
    ;
  {$ENDIF}

type
  TFMain = class(TForm)
    loMain: TLayout;
    tcMain: TTabControl;
    tiMain: TTabItem;
    tiLog: TTabItem;
    memLog: TMemo;
    vsMain: TVertScrollBox;
    loLoad: TLayout;
    faFromX: TFloatAnimation;
    faGoX: TFloatAnimation;
    loDisable: TLayout;
    loFrame: TLayout;
    SB: TStyleBook;
    img: TImageList;
    CornerButton1: TCornerButton;
    aniLoad: TAniIndicator;
    loFooter: TLayout;
    reFooter: TRectangle;
    seFooter: TShadowEffect;
    gplFooter: TGridPanelLayout;
    btnFeed: TCornerButton;
    btnInformasi: TCornerButton;
    btnTPQ: TCornerButton;
    btnImam: TCornerButton;
    btnKajian: TCornerButton;
    TM: TToastManager;
    loReload: TLayout;
    reReload: TRectangle;
    loReloadMain: TLayout;
    reImg: TRectangle;
    btnUlang: TCornerButton;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    loSetting: TLayout;
    reSetting: TRectangle;
    ShadowEffect3: TShadowEffect;
    lbSetting: TListBox;
    LOGIN: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    faPosX: TFloatAnimation;
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure faFromXFinish(Sender: TObject);
    procedure faFromXProcess(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure faGoXFinish(Sender: TObject);
    procedure fnCLickMenu(Sender : TObject);
    procedure faPosXFinish(Sender: TObject);
    procedure lbSettingItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    {Keyboard}
    FService1 : IFMXVirtualKeyboardToolbarService;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    {Keyboard}

    {Keyboard}
    procedure CalcContentBoundsProc(Sender: TObject;
                                    var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    {Keyboard}
    procedure setForm;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses uFunc, uMain, uGoFrame, uRest, uDM, frFeed, frInformasi, frKajian, frImam;

procedure TFMain.CalcContentBoundsProc(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                2 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TFMain.CornerButton1Click(Sender: TObject);
var
  sl : TStringList;
  i: Integer;
begin
  //sl := TStringList.Create;
  try
    sl := fnExplodeString('asdasd,asdasd,asd,asd,asd,asd,asd,f,fds,fs,df', ',');
    for i := 0 to sl.Count - 1 do begin
      memLog.Lines.Add(sl[i]);
    end;
  finally
    //sl.DisposeOf;
  end;
end;

procedure TFMain.faFromXFinish(Sender: TObject);
var
  F : TFloatAnimation;
  lo : TLayout;
begin
  F := TFloatAnimation(Sender);
  F.Enabled := False;
  fnHideFrame(fromFrame);

  loDisable.Visible := False;
end;

procedure TFMain.faFromXProcess(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TFMain.faGoXFinish(Sender: TObject);
var
  F : TFloatAnimation;
  lo : TLayout;
begin
  F := TFloatAnimation(Sender);
  F.Enabled := False;
end;

procedure TFMain.faPosXFinish(Sender: TObject);
begin
  faPosX.Enabled := False;
end;

procedure TFMain.fnCLickMenu(Sender: TObject);
var
  B : TCornerButton;
begin

  B := TCornerButton(Sender);

  if B.Hint = 'COMING SOON' then begin
    fnShowE('FITUR AKAN SEGERA TERSEDIA');
    Exit;
  end;
  fnClickBtn(B);

  if goFrame = B.Hint then begin
    if goFrame = FEED then begin
      FFeed.fnClickFeed;
    end else if goFrame = INFORMASI then begin
      FInformasi.fnClickMenu;
    end else if goFrame = KAJIAN then begin
      FKajian.fnClickMenu;
    end else if goFrame = IMAM then begin
      FImam.fnClickMenu;
    end;
  end else begin
    fnGoFrame(goFrame, B.Hint);
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardToolbarService, IInterface(FService1)) then
    begin
      FService1.SetToolbarEnabled(True);
      FService1.SetHideKeyboardButtonVisibility(True);
    end;

    FPermissionReadExternalStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);      //permission
    FPermissionWriteExternalStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);     //permission

    TAndroidHelper.Activity.getWindow.setStatusBarColor($FF31A293);
    TAndroidHelper.Activity.getWindow.setNavigationBarColor($FF31A293);

    tcMain.TabPosition := TTabPosition.None;
    tiLog.Visible := False;
  {$ELSE}
    BorderStyle := TFmxFormBorderStyle.Single;
    FullScreen := False;

    //tcMain.TabPosition := TTabPosition.Dots;


  {$ENDIF}

  vsMain.OnCalcContentBounds := CalcContentBoundsProc;
end;

procedure TFMain.FormFocusChanged(Sender: TObject);
begin
  if loSetting.Visible then
    fnShowSetting;

  UpdateKBBounds;
end;

procedure TFMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var
  FService: IFMXVirtualKeyboardService;
begin
  if Key = vkHardwareBack  then
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    begin
      FService.HideVirtualKeyboard;
    end
    else
    begin
      Key := 0;

      if goFrame = Loading then
        Exit;

      if (goFrame = HOME) or (goFrame = HOME) then begin
        if tabCount < 1 then
          fnShowE('Tap Dua Kali Untuk Keluar')
        else
          fnShowE('Sampai Jumpa Kembali');

        Inc(TabCount);
      end;

      fnBack;

      if ((goFrame = HOME) or (goFrame = HOME)) and (TabCount >= 2) then
      begin
        Application.Terminate;
      end;
    end;
  end
  else
  if Key = vkReturn then
  begin
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    begin
      FService.HideVirtualKeyboard;
    end;
  end;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  setForm;
end;

procedure TFMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;

procedure TFMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

procedure TFMain.lbSettingItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if Item.ItemData.Detail <> 'EXIT' then begin
    fnGoFrame(FEED, Item.ItemData.Detail);
  end else begin
    Application.Terminate;
  end;
end;

procedure TFMain.RestorePosition;
begin
  vsMain.ViewportPosition := PointF(vsMain.ViewportPosition.X, 0);
  loMain.Align := TAlignLayout.None;
  vsMain.Align := TAlignLayout.None;
  fnGetClient(Self, loMain);
  vsMain.RealignContent;
end;

procedure TFMain.setForm;
begin
  aIDUser := '1';

  createFrame;

  fnGoFrame('', Loading);
end;

procedure TFMain.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsMain.ViewportPosition);
    if FullScreen = True then
      LFocusRect.Bottom := LFocusRect.Bottom + 50;
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      loMain.Align := TAlignLayout.Horizontal;
      vsMain.RealignContent;
      Application.ProcessMessages;
      vsMain.ViewportPosition :=
        PointF(vsMain.ViewportPosition.X,
               LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

end.
