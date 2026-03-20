unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls,
  uWVBrowser, uWebBrowserForm;

type
// extracted from uWVTypes.pas:
  {$IFDEF DELPHI12_UP}
    wvstring = type string;
  {$ELSE}
    {$IFDEF FPC}
      wvstring = type UnicodeString;
    {$ELSE}
      wvstring = type WideString;
    {$ENDIF}
  {$ENDIF}
// end of extraction

type
  TForm1 = class(TForm)
    MessagesPnl: TPanel;
    Edit1: TEdit;
    SendMsgBtn: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SharedBufferEdt: TEdit;
    PostSharedBufferBtn: TButton;
    Panel3: TPanel;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    MessagesList: TListBox;
    Panel4: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ScrollBar3: TScrollBar;
    ScrollBar4: TScrollBar;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure SendMsgBtnClick(Sender: TObject);

    procedure WVBrowser1InitializationError(Sender: TObject; aErrorCode: HRESULT; const aErrorMessage: wvstring);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure ScrollBar4Change(Sender: TObject);

    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

type TBrowserAction = (baBack, baHome, baSetHome, baRefresh);

var
  Form1: TForm1;
  WB: TWebBrowserForm;
  WVBrowser1: TWVBrowser;
  SndMessage: string;

function InitializeWebView4Delphi: integer; stdcall; external 'DllBrowser.dll';
function FinalizeWebView4Delphi: integer; stdcall; external 'DllBrowser.dll';
function ShowBrowser(aDest: HWND; aBorderLess: integer; aX,aY,aW,aH: integer): integer; stdcall; external 'DllBrowser.dll';
function SetBrowserMessageCommunication(aWB: TWebBrowserForm; aAllow: integer; aSndBuffer, aRcvBuffer: HWND): integer; stdcall; external 'DllBrowser.dll';
function SendMessageToBrowser(aWB: TWebBrowserForm; aMessage: integer): integer; stdcall; external 'DllBrowser.dll';
function SetBrowserScrollBars(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; external 'DllBrowser.dll';
function BrowserNavigate(aWB: TWebBrowserForm; aURL: integer): integer; stdcall; external 'DllBrowser.dll';
function ExecuteBrowserScript(aWB: TWebBrowserForm; aScript: integer): integer; stdcall; external 'DllBrowser.dll';
function SetBrowserOpenInSameTab(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; external 'DllBrowser.dll';
function SetBrowserNewWindowRequested(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; external 'DllBrowser.dll';
function SetBrowserNavigationStarting(aWB: TWebBrowserForm; aValue: integer): integer; stdcall; external 'DllBrowser.dll';
function BrowserAction(aWB: TWebBrowserForm; aAction: TBrowserAction): integer; stdcall; external 'DllBrowser.dll';


// documentation: https://pkg.go.dev/github.com/energye/wv/windows

implementation

{$R *.dfm}

const
  CUSTOM_SHARED_BUFFER_SIZE = 1024;

procedure TForm1.SendMsgBtnClick(Sender: TObject);
var
  msg: string;
begin
  msg := Edit1.Text;
  SendMessageToBrowser(WB,integer(@msg));
end;

procedure TForm1.WVBrowser1InitializationError(Sender: TObject;
  aErrorCode: HRESULT; const aErrorMessage: wvstring);
begin
  showmessage(aErrorMessage);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Top := 0;
  InitializeWebView4Delphi;
  WB := TWebBrowserForm(ShowBrowser(Form1.Handle,1,  0,30,620,620));
  WVBrowser1 := WB.WVBrowser1;
  SetBrowserNewWindowRequested(WB,1);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FinalizeWebView4Delphi;
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  URL: string;
  Initialdir: string;
begin
  Initialdir := ExtractFilePath(ParamStr(0));
  Opendialog1.InitialDir := InitialDir;
  if not OpenDialog1.Execute then exit;
  URL := 'File:///' + OpenDialog1.FileName;
  BrowserNavigate(WB,integer(@URL));
  ScrollBar3.OnChange := nil;
  ScrollBar4.OnChange := nil;

  ScrollBar1.Min := 0;
  ScrollBar2.Min := 0;
  ScrollBar3.Min := 0;
  ScrollBar4.Min := 0;

  ScrollBar1.Max := 40000;
  ScrollBar2.Max := 275;
  ScrollBar3.Max := 4000;
  ScrollBar4.Max := 600;
  ScrollBar3.Position := 1000;
  ScrollBar4.Position := 275;

  ScrollBar3.OnChange := ScrollBar3Change;
  ScrollBar4.OnChange := ScrollBar4Change;
  SetBrowserMessageCommunication(WB,1, 0,MessagesList.Handle);
  SetBrowserScrollBars(WB,0);      
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
var
  script: string;
begin
  script := 'ShiftHorz('+inttostr(Scrollbar1.Position)+')';
  ExecuteBrowserScript(WB,integer(@script));
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
var
  script: string;
begin
  script := 'ShiftVert('+inttostr(Scrollbar2.Position)+')';
  ExecuteBrowserScript(WB,integer(@script));
end;

procedure TForm1.ScrollBar3Change(Sender: TObject);
var
  p: integer;
  script: string;
begin
  p := Scrollbar3.Position;
  script := 'ZoomHorz('+inttostr(p)+')';
  ExecuteBrowserScript(WB,integer(@script));
  Label3.Caption := Format('Horizontal Zoom %d (%3.3f x)',[p,1000/p]);
end;

procedure TForm1.ScrollBar4Change(Sender: TObject);
var
  p: integer;
  script: string;
begin
  p := Scrollbar4.Position;
  script := 'ZoomVert('+inttostr(p)+')';
  ExecuteBrowserScript(WB,integer(@script));
  Label3.Caption := Format('Vertical Zoom %d (%3.3f x)',[p,25/p]);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  scriptCode: string;
  injectCode: string;
  f: TextFile;
begin
  injectCode := 'const head = document.head;' + #13#10 +
                'const script = document.createElement("script");' + #13#10 +
                'script.src = "WebView_Klaus.js";' + #13#10 +
                'head.appendChild(script);';

  if ExecuteBrowserScript(WB,integer(@injectCode))=0 then showmessage('Injection OK')
                                                        else showmessage('Injection error');

  scriptCode := 'Hello';
  if ExecuteBrowserScript(WB,integer(@scriptCode))<=0 then showmessage('Script OK')
                                                         else showmessage('Script error');

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  scriptCode: string;
begin
  scriptCode := Trim(Edit1.Text);
showmessage(scriptCode);
  if ExecuteBrowserScript(WB,integer(@scriptCode))=0 then showmessage('Script OK') else showmessage('Script error');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  BrowserAction(WB,baBack);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  BrowserAction(WB,baHome);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  BrowserAction(WB,baSetHome);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  BrowserAction(WB,baRefresh);
end;

end.
