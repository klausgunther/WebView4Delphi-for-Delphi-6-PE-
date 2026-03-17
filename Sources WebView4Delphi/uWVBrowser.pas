unit uWVBrowser;

{$IFDEF FPC}{$MODE Delphi}{$ENDIF}

{$I webview2.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.Types, Vcl.Forms, System.Math,
  {$ELSE}
  Windows, Messages, Classes, Types, Forms, Math, StrUtils, {$IFDEF FPC}LResources,{$ENDIF}
  {$ENDIF}
Dialogs, Sysutils,
  uWVBrowserBase, uWVInterfaces, uWVCoreWebView2Args, uWVTypeLibrary, uWVWindowParent;

type
  {$IFNDEF FPC}{$IFDEF DELPHI16_UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}{$ENDIF}
  /// <summary>
  ///  VCL and LCL version of TWVBrowserBase that puts together all browser procedures, functions, properties and events in one place.
  ///  It has all you need to create, modify and destroy a web browser.
  /// </summary>
  TWVBrowser = class(TWVBrowserBase)
    // **Klaus begin
    private
      // The messages should be single line text messages.
      // If a message contains a multi-line text, the calling application must be able to handle this.
      fSndMessageBuffer: HWND;        // Handle of a Delphi object containing the message to send
      fRcvMessageBuffer: HWND;        // Handle of a Delphi TList object receiving a new message on arrival
      // these Delphi objects should be used with an OnChange event.
      // the SndMessageBuffer will be erased on send completion. So the calling program will be noticed.
      // a new message will be added to the RcvMessageBuffer. So the calling program will be noticed.
      // the calling program must allways handle the element [0] first, then delete it, until list is empty.
      //
      // Special options:
      // say "browser is initialized"
      fIsInitialized: boolean;
      // open all navigation requests in the same browser tab
      fOpenInSameTab: boolean;
    // **Klaus end

    protected
      function  GetParentForm : TCustomForm;

    public
      procedure MoveFormTo(const x, y: Integer); override;
      procedure MoveFormBy(const x, y: Integer); override;
      procedure ResizeFormWidthTo(const x : Integer); override;
      procedure ResizeFormHeightTo(const y : Integer); override;
      procedure SetFormLeftTo(const x : Integer); override;
      procedure SetFormTopTo(const y : Integer); override;
      procedure WebMessageReceived(Sender: TObject;
        const aWebView: ICoreWebView2;
        const aArgs: ICoreWebView2WebMessageReceivedEventArgs);
      procedure SetMessageReceiver;
      procedure NewWindowRequested(Sender: TObject; const aWebView: ICoreWebView2;    // **Klaus
        const aArgs: ICoreWebView2NewWindowRequestedEventArgs);
      procedure SetNewWindowRequested(aAction: boolean);

    published
      property BrowserExecPath;
      property UserDataFolder;
      property DefaultURL;
      property AdditionalBrowserArguments;
      property Language;
      property TargetCompatibleBrowserVersion;
      property AllowSingleSignOnUsingOSPrimaryAccount;
      property OnInitializationError;
      property OnEnvironmentCompleted;
      property OnControllerCompleted;
      property OnAfterCreated;
      property OnExecuteScriptCompleted;
      property OnCapturePreviewCompleted;
      property OnNavigationStarting;
      property OnNavigationCompleted;
      property OnFrameNavigationStarting;
      property OnFrameNavigationCompleted;
      property OnSourceChanged;
      property OnHistoryChanged;
      property OnContentLoading;
      property OnDocumentTitleChanged;
      property OnNewWindowRequested;
      property OnWebResourceRequested;
      property OnScriptDialogOpening;
      property OnPermissionRequested;
      property OnProcessFailed;
      property OnWebMessageReceived;
      property OnContainsFullScreenElementChanged;
      property OnWindowCloseRequested;
      property OnDevToolsProtocolEventReceived;
      property OnZoomFactorChanged;
      property OnMoveFocusRequested;
      property OnAcceleratorKeyPressed;
      property OnGotFocus;
      property OnLostFocus;
      property OnCursorChanged;
      property OnBrowserProcessExited;
      property OnRasterizationScaleChanged;
      property OnWebResourceResponseReceived;
      property OnDOMContentLoaded;
      property OnWebResourceResponseViewGetContentCompleted;
      property OnGetCookiesCompleted;
      property OnTrySuspendCompleted;
      property OnFrameCreated;
      property OnDownloadStarting;
      property OnClientCertificateRequested;
      property OnPrintToPdfCompleted;
      property OnBytesReceivedChanged;
      property OnEstimatedEndTimeChanged;
      property OnDownloadStateChanged;
      property OnFrameNameChanged;
      property OnFrameDestroyed;
      property OnCompositionControllerCompleted;
      property OnCallDevToolsProtocolMethodCompleted;
      property OnAddScriptToExecuteOnDocumentCreatedCompleted;
      property OnWidget0CompMsg;
      property OnWidget1CompMsg;
      property OnRenderCompMsg;
      property OnD3DWindowCompMsg;
      property OnPrintCompleted;
      property OnRetrieveHTMLCompleted;
      property OnRetrieveTextCompleted;
      property OnRetrieveMHTMLCompleted;
      property OnClearCacheCompleted;
      property OnClearDataForOriginCompleted;
      property OnOfflineCompleted;
      property OnIgnoreCertificateErrorsCompleted;
      property OnRefreshIgnoreCacheCompleted;
      property OnSimulateKeyEventCompleted;
      property OnIsMutedChanged;
      property OnIsDocumentPlayingAudioChanged;
      property OnIsDefaultDownloadDialogOpenChanged;
      property OnProcessInfosChanged;
      property OnFrameNavigationStarting2;
      property OnFrameNavigationCompleted2;
      property OnFrameContentLoading;
      property OnFrameDOMContentLoaded;
      property OnFrameWebMessageReceived;
      property OnBasicAuthenticationRequested;
      property OnContextMenuRequested;
      property OnCustomItemSelected;
      property OnStatusBarTextChanged;
      property OnFramePermissionRequested;
      property OnClearBrowsingDataCompleted;
      property OnServerCertificateErrorActionsCompleted;
      property OnServerCertificateErrorDetected;
      property OnFaviconChanged;
      property OnGetFaviconCompleted;
      property OnPrintToPdfStreamCompleted;
      property OnGetCustomSchemes;
      property OnGetNonDefaultPermissionSettingsCompleted;
      property OnSetPermissionStateCompleted;
      property OnLaunchingExternalUriScheme;
      property OnGetProcessExtendedInfosCompleted;
      property OnBrowserExtensionRemoveCompleted;
      property OnBrowserExtensionEnableCompleted;
      property OnProfileAddBrowserExtensionCompleted;
      property OnProfileGetBrowserExtensionsCompleted;
      property OnProfileDeleted;
      property OnExecuteScriptWithResultCompleted;
      property OnNonClientRegionChanged;
      property OnNotificationReceived;
      property OnNotificationCloseRequested;
      property OnSaveAsUIShowing;
      property OnShowSaveAsUICompleted;
      property OnSaveFileSecurityCheckStarting;
      property OnScreenCaptureStarting;
      property OnFrameScreenCaptureStarting;
      property OnFrameChildFrameCreated;
      property OnFindActiveMatchIndexChanged;
      property OnFindMatchCountChanged;
      property OnFindStartCompleted;
      property OnDragStarting;

      property SndMessageBuffer: HWND read fSndMessageBuffer write fSndMessageBuffer;       // **Klaus
      property RcvMessageBuffer: HWND read fRcvMessageBuffer write fRcvMessageBuffer;       // **Klaus
      property IsInitialized: boolean read fIsInitialized write fIsInitialized;             // **Klaus
      property OpenInSameTab: boolean read fOpenInSameTab write fOpenInSameTab;             // **Klaus
  end;

{$IFDEF FPC}
procedure Register;
{$ENDIF}

implementation


const
  CUSTOM_SHARED_BUFFER_SIZE = 1024;

{procedure TWVBrowser.NewWindowRequested(Sender: TObject; const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2NewWindowRequestedEventArgs);
var
  TempArgs : TCoreWebView2NewWindowRequestedEventArgs;
begin
showmessage('try interception');
  // use this event to block a new window for this request.
  // instead, use a Navigate request inside the same tab.
//  if not OpenInSameTab then exit;                    // is the option not selected ?
  TempArgs := TCoreWebView2NewWindowRequestedEventArgs.Create(aArgs);
  TempArgs.Handled := true;                          // block the New window request
  TWVBrowser(Sender).Navigate(TempArgs.URI);         // navigate within the current tab
 showmessage('intercepted '+TempArgs.URI);
  TempArgs.Free;
end;    }

procedure AppendStringToTListBox(s: string; adest: HWND);
var
  s1, s2: string;
  p: integer;
begin
//        SendMessage(adest,LB_RESETCONTENT,0,0);
        s1 := s + #13#10;
        while s1<>'' do begin
          p := pos(#13#10,s1);
          if p>0 then begin
            s2 := LeftStr(s1,p-1);
            s1 := MidStr(s1,p+2,Length(s1));
            SendMessage(adest,LB_ADDSTRING,0,integer(pchar(s2)));
          end;
        end;
        if s1<>'' then SendMessage(adest,LB_ADDSTRING,0,integer(pchar(s1)));
end;

procedure TWVBrowser.WebMessageReceived(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2WebMessageReceivedEventArgs);
var
  TempArgs : TCoreWebView2WebMessageReceivedEventArgs;
  TempMsg  : string;
begin
  TempArgs := TCoreWebView2WebMessageReceivedEventArgs.Create(aArgs);
  TempMsg  := TempArgs.WebMessageAsString;
  AppendStringToTListBox(TempMsg,TWVBrowser(Sender).RcvMessageBuffer);
  TempArgs.Free;
end;

procedure TWVBrowser.SetMessageReceiver;
begin
  if WebMessageEnabled then OnWebMessageReceived := WebMessageReceived
                       else OnWebMessageReceived := nil;
end;

// **Klaus addon begin
procedure TWVBrowser.NewWindowRequested(Sender: TObject; const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2NewWindowRequestedEventArgs);
var
  TempArgs : TCoreWebView2NewWindowRequestedEventArgs;
begin
  // use this event to block a new window for this request.
  // instead, use a Navigate request inside the same tab.
//showmessage('detected');
  if not OpenInSameTab then exit;                    // is the option not selected ?
  TempArgs := TCoreWebView2NewWindowRequestedEventArgs.Create(aArgs);
  TempArgs.Handled := true;                          // block the New window request
  TWVBrowser(Sender).Navigate(TempArgs.URI);         // navigate within the current tab
//showmessage('intercepted');
  TempArgs.Free;
end;

procedure TWVBrowser.SetNewWindowRequested(aAction: boolean);
begin
  if aAction then OnNewWindowRequested := NewWindowRequested
             else OnNewWindowRequested := nil;
end;
// **Klaus addon end

function TWVBrowser.GetParentForm : TCustomForm;
var
  TempComp : TComponent;
begin
  Result   := nil;
  TempComp := Owner;

  while (TempComp <> nil) do
    if (TempComp is TCustomForm) then
      begin
        Result := TCustomForm(TempComp);
        exit;
      end
     else
      TempComp := TempComp.owner;
end;

procedure TWVBrowser.MoveFormTo(const x, y: Integer);
var
  TempForm : TCustomForm;
  TempRect : TRect;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    begin
      TempRect.Left   := min(max(x, max(screen.DesktopLeft, 0)), screen.DesktopWidth  - TempForm.Width);
      TempRect.Top    := min(max(y, max(screen.DesktopTop,  0)), screen.DesktopHeight - TempForm.Height);
      TempRect.Right  := TempRect.Left + TempForm.Width  - 1;
      TempRect.Bottom := TempRect.Top  + TempForm.Height - 1;

      TempForm.SetBounds(TempRect.Left, TempRect.Top, TempRect.Right - TempRect.Left + 1, TempRect.Bottom - TempRect.Top + 1);
    end;
end;

procedure TWVBrowser.MoveFormBy(const x, y: Integer);
var
  TempForm : TCustomForm;
  TempRect : TRect;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    begin
      TempRect.Left   := min(max(TempForm.Left + x, max(screen.DesktopLeft, 0)), screen.DesktopWidth  - TempForm.Width);
      TempRect.Top    := min(max(TempForm.Top  + y, max(screen.DesktopTop,  0)), screen.DesktopHeight - TempForm.Height);
      TempRect.Right  := TempRect.Left + TempForm.Width  - 1;
      TempRect.Bottom := TempRect.Top  + TempForm.Height - 1;

      TempForm.SetBounds(TempRect.Left, TempRect.Top, TempRect.Right - TempRect.Left + 1, TempRect.Bottom - TempRect.Top + 1);
    end;
end;

procedure TWVBrowser.ResizeFormWidthTo(const x : Integer);
var
  TempForm : TCustomForm;
  TempX, TempDeltaX : integer;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    begin
      TempX          := max(x, 100);
      TempDeltaX     := TempForm.Width  - TempForm.ClientWidth;
      TempForm.Width := TempX + TempDeltaX;
    end;
end;

procedure TWVBrowser.ResizeFormHeightTo(const y : Integer);
var
  TempForm : TCustomForm;
  TempY, TempDeltaY : integer;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    begin
      TempY           := max(y, 100);
      TempDeltaY      := TempForm.Height - TempForm.ClientHeight;
      TempForm.Height := TempY + TempDeltaY;
    end;
end;

procedure TWVBrowser.SetFormLeftTo(const x : Integer);
var
  TempForm : TCustomForm;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    TempForm.Left := min(max(x, max(screen.DesktopLeft, 0)), screen.DesktopWidth  - TempForm.Width);
end;

procedure TWVBrowser.SetFormTopTo(const y : Integer);
var
  TempForm : TCustomForm;
begin
  TempForm := GetParentForm;
  if (TempForm <> nil) then
    TempForm.Top := min(max(y, max(screen.DesktopTop, 0)), screen.DesktopHeight - TempForm.Height);
end;

{$IFDEF FPC}
procedure Register;
begin
  {$I res/twvbrowser.lrs}
  RegisterComponents('WebView4Delphi', [TWVBrowser]);
end;
{$ENDIF}


end.