unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, StrUtils,
  uWebBrowserForm, uExtensionForm;

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
    Button8: TButton;
    procedure SendMsgBtnClick(Sender: TObject);

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
    procedure Button8Click(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

type TBrowserAction = (baBack, baHome, baSetHome, baRefresh);

var
  Form1: TForm1;
  WB: TWebBrowserForm;
  SndMessage: string;
  IniFile: string;
  ExtensionList: TStringList;

function InitializeWebView4Delphi: integer; stdcall; external 'DllBrowser.dll';
function InitializeWebView4DelphiWithExtensions(aExtensions: integer): integer; stdcall; external 'DllBrowser.dll';
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

procedure TForm1.FormCreate(Sender: TObject);
var
  buttonSelected : Integer;
begin
  Top := 0;
  ExtensionList := TStringList.Create;
  IniFile := ChangeFileExt(ParamStr(0), '.ini');
  if FileExists(IniFile) then begin
    ExtensionList.LoadFromFile(IniFile);
    buttonSelected := MessageDlg('Start with extensions ?',mtError, mbOKCancel, 0);
    if buttonSelected = mrOK     then InitializeWebView4DelphiWithExtensions(integer(@IniFile));
    if buttonSelected = mrCancel then InitializeWebView4Delphi;
  end else begin
    InitializeWebView4Delphi;
  end;
  WB := TWebBrowserForm(ShowBrowser(Form1.Handle,1,  0,30,620,620));
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

procedure TForm1.Button8Click(Sender: TObject);
begin
   Form2.Left := 70;
   Form2.ListBox1.Items.Text := ExtensionList.Text;
   if Form2.ShowModal= mrOK then begin
      Form2.ListBox1.Items.SaveToFile(IniFile);
      ExtensionList.Text := Form2.ListBox1.Items.Text;
   end;
end;

end.
