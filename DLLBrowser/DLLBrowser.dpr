library DLLBrowser;

uses
  Windows, Forms, Messages, Controls, SysUtils, Classes, StrUtils, dialogs,
  StdCtrls,
  uWVBrowser, uWVWinControl, uWVWindowParent, uWVTypes, uWVConstants, uWVTypeLibrary,
  uWVLibFunctions, uWVLoader, uWVInterfaces, uWVCoreWebView2Args,
  uWVBrowserBase, uWVCoreWebView2SharedBuffer, uWebBrowserForm;

type TBrowserAction = (baBack, baHome, baSetHome, baRefresh);


{$R *.res}

  function GetString(par: integer): string;
  var
    n, Len, cnt, i: integer;
    memo: TMemo;
    lb: TListBox;
    s1, s2: string;
    pb: pbyte;
    pi: pinteger;

    function GetClassName(Handle: THandle): String;
    var
      Buffer: array[0..MAX_PATH] of Char;
    begin
      Windows.GetClassName(Handle, @Buffer, MAX_PATH);
      Result := String(Buffer);
    end;

  begin
    result := '';
    if par=0 then exit;
    try
      memo := TMemo(par);
      if memo.ClassName='TMemo' then begin
        result := memo.Text;
        exit;
      end;
    except
    end;

    try
      if GetClassName(par)='TMemo' then begin

        Len := SendMessage(par, WM_GETTEXTLENGTH, 0, 0);
        if Len>0 then begin
          SetLength(s1, Len+1);
          Len := SendMessage(par, WM_GETTEXT, Len+1, LPARAM(PChar(s1)));
          sleep(100);
          SetLength(s1, Len);
        end;

        result := Trim(s1);
        exit;
      end;
    except
    end;

    try
      if GetClassName(par)='TListBox' then begin

        cnt := SendMessage(par, LB_GETCOUNT, 0, 0);
        s1 := '';
        if cnt<>LB_ERR then begin
          for i:=0 to cnt-1 do begin
            s2 := '';
            Len := SendMessage(par, LB_GETTEXTLEN, i, 0);
            if Len>0 then begin
              SetLength(s2, Len+1);
              SendMessage(par, LB_GETTEXT, i, LPARAM(PChar(s2)));
              sleep(100);
              s1 := s1 + Trim(s2) + #13#10;
            end else begin
              s1 := s1 + #13#10;
            end;
          end;
        end;

        result := Trim(s1);
        exit;
      end;
    except
    end;
    result := pstring(par)^;
  end;

function InitializeWebView4Delphi: integer; stdcall; export;
begin
  result := -1;
  try
    GlobalWebView2Loader                := TWVLoader.Create(nil);
    GlobalWebView2Loader.UserDataFolder := IncludeTrailingPathDelimiter(ExtractFileDir(GetModuleName(HINSTANCE))) + '\CustomCache';
    GlobalWebView2Loader.StartWebView2;
    GlobalWebView2Loader.AreBrowserExtensionsEnabled := true;
    result := 0;
  except
  end;
end;

function FinalizeWebView4Delphi: integer; stdcall; export;
begin
  result := -1;
  try
    DestroyGlobalWebView2Loader;
    result := 0;
  except
  end;
end;

function ShowBrowser(aDest: HWND; aBorderLess: integer; aX,aY,aW,aH: integer): integer; stdcall; export;
begin
  result := 0;
  try
    WebBrowserForm := TWebBrowserForm.Create(nil);
    if aBorderLess<>0 then WebBrowserForm.BorderStyle := bsNone;
    if aDest<>0 then WebBrowserForm.ParentWindow := aDest;
    WebBrowserForm.Show;
    if (aX+aY+aW+aH)<>0 then WebBrowserForm.SetBounds(aX,aY,aW,aH);
//    WebBrowserForm.WVBrowser1.ClearCache;
    result := integer(WebBrowserForm);
  except
  end;
end;

function SetBrowserMessageCommunication(aWB: TWebBrowserForm; aAllow: integer; aSndBuffer, aRcvBuffer: HWND): integer; stdcall; export;
// aAllow=0: bloquer  aAllow<>0: permettre
// aSndBuffer: adresse (pointer) vers le buffer de message à envoyer
// aRecBuffer: adresse (pointer) vers le buffer de réception de messages
var
  temp: boolean;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;

    temp := aWB.WVBrowser1.WebMessageEnabled;
    aWB.WVBrowser1.SndMessageBuffer := aSndBuffer;
    aWB.WVBrowser1.RcvMessageBuffer := aRcvBuffer;
    aWB.WVBrowser1.WebMessageEnabled := (aAllow<>0);
    aWB.WVBrowser1.SetMessageReceiver;

    if temp then result := 1
            else result := 0;
  except
  end;
end;

function SendMessageToBrowser(aWB: TWebBrowserForm; aMessage: integer): integer; stdcall; export;
var
  msg: string;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    msg := Trim(GetString(aMessage));
    if msg='' then exit;
    if aWB.WVBrowser1.PostWebMessageAsString(msg) then result := 0;
  except
  end;
end;


function SetBrowserScrollBars(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; export;
var
  msg: string;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    // following lines derived from:
    //    https://en.delphipraxis.net/topic/8749-twebbrowser-remove-scrollbars-not-working/
    if aValue=0 then aWB.WVBrowser1.CallDevToolsProtocolMethod('Emulation.setScrollbarsHidden', '{"hidden":true}')
                else aWB.WVBrowser1.CallDevToolsProtocolMethod('Emulation.setScrollbarsHidden', '{"hidden":false}');
    result := 0
  except
  end;
end;

function BrowserNavigate(aWB: TWebBrowserForm; aURL: integer): integer; stdcall; export;
var
  URL: string;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    URL := Trim(GetString(aURL));
    if URL='' then exit;
    if aWB.WVBrowser1.Navigate(URL) then result := 0;
    if result=0 then aWB.AddressCb.Text := URL;
  except
  end;
end;

function ExecuteBrowserScript(aWB: TWebBrowserForm; aScript: integer): integer; stdcall; export;
var
  script: string;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    script := Trim(GetString(aScript));
    if script='' then exit;
    if aWB.WVBrowser1.ExecuteScriptWithResult(script) then result := 0;
  except
  end;
end;

function SetBrowserNavigationPanel(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; export;
var
  msg: string;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    aWB.AddressPnl.Visible := (aValue<>0);
    result := 0;
  except
  end;
end;

function SetBrowserOpenInSameTab(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; export;
var
  msg: string;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    if not aWB.WVBrowser1.IsInitialized then exit;
    aWB.WVBrowser1.OpenInSameTab := (aValue<>0);
    result := 0;
  except
  end;
end;

function SetBrowserNewWindowRequested(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; export;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    aWB.WVBrowser1.OpenInSameTab := (aValue<>0);
    aWB.WVBrowser1.SetNewWindowRequested(aValue<>0);
    result := 0;
  except
  end;
end;

function SetBrowserNavigationStarting(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; export;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    aWB.WVBrowser1.SetNavigationStarting(aValue<>0);
    result := 0;
  except
  end;
end;

function BrowserAction(aWB: TWebBrowserForm; aAction: TBrowserAction): integer; stdcall; export;
begin
  result := -1;
  try
    if not assigned(aWB) then exit;
    if aWB.ClassName<>'TWebBrowserForm' then exit;
    case aAction of
      baBack:    aWB.WVBrowser1.GoBack;
      baHome:    aWB.WVBrowser1.Navigate(aWB.WVBrowser1.DefaultURL);
      baSetHome: aWB.WVBrowser1.DefaultURL := aWB.AddressCb.Text;
      baRefresh: aWB.WVBrowser1.Refresh;
    else
      exit;
    end;
    result := 0;
  except
  end;
end;


exports
  InitializeWebView4Delphi,
  FinalizeWebView4Delphi,
  ShowBrowser,
  SetBrowserMessageCommunication,
  SendMessageToBrowser,
  SetBrowserScrollBars,
  BrowserNavigate,
  ExecuteBrowserScript,
  SetBrowserNavigationPanel,
  SetBrowserOpenInSameTab,
  SetBrowserNewWindowRequested,
  SetBrowserNavigationStarting,
  BrowserAction;

begin
end.


