unit uExtensionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    OpenDialog1: TOpenDialog;
    Button6: TButton;
    ListBox2: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;
  dir: string;

implementation

{$R *.dfm}

procedure TForm2.Button4Click(Sender: TObject);
begin
  // validate the extension list
  ModalResult := mrOK;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure ListFileDir(Path: string; FileList: TStrings);
var
  SR: TSearchRec;
  s, ext: string;
begin
  dir := Path;
  Form2.ListBox2.Clear;
  Form2.ListBox2.Visible := true;
  if FindFirst(Path + '*.*', faAnyFile, SR) = 0 then
  begin
    repeat
{
faReadOnly   1  Fichiers en lecture seule
faHidden     2  Fichiers cachés
faSysFile    4  Fichiers système
faVolumeID   8  Fichiers d’identification de volume
faDirectory 16  Fichiers répertoire
faArchive   32  Fichiers archive
faSymLink   64  Lien symbolique
faAnyFile   71  Tous les fichiers
}
      if  not ( (SR.Attr and faHidden>0) or (SR.Attr and faSysFile>0) or (SR.Attr and faVolumeID>0) ) then
      begin
        s := SR.Name;
        if s<>'.' then begin
          ext := Lowercase(ExtractFileExt(s));
          if ( (ext='.crx') or (ext='.zip') ) then    s := Path + s
            else   if (ext='') then                   s := Path + s + '\';
          if pos(Path,s)=1 then FileList.Add(s);
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TForm2.Button6Click(Sender: TObject);
var
  s: string;
begin
  ListFileDir('C:\', ListBox2.Items);
end;

procedure TForm2.ListBox2DblClick(Sender: TObject);
var
  s, ext: string;
begin
  if ListBox2.ItemIndex<0 then exit;
  s := ListBox2.Items[ListBox2.ItemIndex];
  ext := ExtractFileExt(s);
  if ext='' then ListFileDir(s, ListBox2.Items);
end;

procedure TForm2.ListBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ListBox2.ItemIndex<0 then exit;
  Edit1.Text := ListBox2.Items[ListBox2.ItemIndex];
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  i, n: integer;
  s: string;
begin
  n := ListBox1.Count;
  s := Edit1.Text;
  if n>0 then begin
    for i:=0 to n-1 do
        if ListBox1.Items[i]=s then exit;
  end;
  ListBox1.Items.Add(s);
  ListBox2.Visible := false;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  ind: integer;
begin
  ind := ListBox1.ItemIndex;
  if ind<0 then exit;
  if trim(Edit1.Text)='' then exit;
  ListBox1.Items.Delete(ind);
  ListBox1.Items.Insert(ind,Edit1.Text);
  ListBox2.Visible := false;
end;

procedure TForm2.ListBox1Click(Sender: TObject);
begin
  Edit1.Text := ListBox1.Items[ListBox1.ItemIndex];
  ListBox2.Visible := false;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  ind: integer;
begin
  ind := ListBox1.ItemIndex;
  if ind<0 then exit;
  ListBox1.Items.Delete(ind);
  ListBox2.Visible := false;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  ind: integer;
begin
  ind := ListBox1.ItemIndex;
  if ind<0 then exit;
  if trim(Edit1.Text)='' then exit;
  ListBox1.Items.Delete(ind);
end;

end.
