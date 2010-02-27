unit wPrincipalForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uCalx, ExtCtrls, Buttons, ComCtrls, ImgList, ToolWin,
  uAboutForm;

type
  TPrincipalForm = class(TForm, IEntrada)
    Panel1: TPanel;
    OperacaoTreeView: TTreeView;
    Splitter1: TSplitter;
    Panel2: TPanel;
    EntradaMemo: TMemo;
    PilhaPaintBox: TPaintBox;
    EnterButton: TBitBtn;
    ImageList: TImageList;
    AjudaText: TStaticText;
    ToolBarComum: TToolBar;
    ToolBarPilha: TToolBar;
    procedure FormCreate(Sender: TObject);
    procedure PilhaPaintBoxPaint(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
    procedure EntradaMemoKeyPress(Sender: TObject; var Key: Char);
    procedure OperacaoTreeViewDblClick(Sender: TObject);
    procedure OperacaoTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure EntradaMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FPilha: IPilha;
    procedure Carrega;
    procedure ClickButton(Sender: TObject);
    { IEntrada }
    function GetSobCursor: string;
    function GetTexto: string;
    procedure SetSobCursor(const Value: string);
    procedure SetTexto(const Value: string);

    procedure About;
    function GetPilha: IPilha;
    procedure Invalida;
  public
    { Public declarations }
  end;

var
  PrincipalForm: TPrincipalForm;

implementation

{$R *.dfm}

procedure TPrincipalForm.FormCreate(Sender: TObject);
begin
  Caption := Titulo;
  FPilha := TPilha.Create;
  FPilha.Entrada := Self;
  AjudaText.Caption := 'RPN: Para fazer uma conta entre primeiro os parâmetros e' +
    ' depois o operador, ex.:'#13#10'22 [Enter] 3 +';
  Carrega;
end;

procedure TPrincipalForm.PilhaPaintBoxPaint(Sender: TObject);
begin
  FPilha.Draw(PilhaPaintBox.Canvas, Rect(0, 0, PilhaPaintBox.Width,
    PilhaPaintBox.Height));
end;

procedure TPrincipalForm.EnterButtonClick(Sender: TObject);
begin
  TFabricaElemento.Enter(Self);
  EntradaMemo.SetFocus;
end;

procedure TPrincipalForm.EntradaMemoKeyPress(Sender: TObject;
  var Key: Char);
begin
  TFabricaElemento.PressKey(Self, Key);
end;

procedure TPrincipalForm.Carrega;

  procedure InclueNo(ANo: TNo; ANode: TTreeNode);
  var
    laco1: TNo;
    laco2: TTipoOperacao;
    atual, operacao: TTreeNode;
  begin
    for laco1 := Low(TNo) to High(TNo) do
      if NoDefinicoes[laco1].Pai = ANo then
      begin
        atual := OperacaoTreeView.Items.AddChild(ANode, NoDefinicoes[laco1].Nome);
        for laco2 := Low(TTipoOperacao) to High(TTipoOperacao) do
          if Operacoes[laco2].No = laco1 then
          begin
            operacao := OperacaoTreeView.Items.AddChild(atual, Operacoes[laco2].Nome);
            operacao.ImageIndex := Operacoes[laco2].Imagem;
            operacao.SelectedIndex := Operacoes[laco2].Imagem;
          end;
        InclueNo(laco1, atual);
      end;
  end;

var
  laco: TNo;
  raiz: TTreeNode;
  laco2: TTipoOperacao;
  LToolButton: TToolButton;
  LToolBar: array [TBotao] of TToolBar;
begin
  OperacaoTreeView.Items.BeginUpdate;
  try
    OperacaoTreeView.Items.Clear;
    for laco := Low(TNo) to High(TNo) do
      if (laco <> noNenhum) and (NoDefinicoes[laco].Pai = noNenhum) then
      begin
        raiz := OperacaoTreeView.Items.AddChild(nil, NoDefinicoes[laco].Nome);
        InclueNo(laco, raiz);
      end;
  finally
    OperacaoTreeView.Items.EndUpdate;
  end;
  LToolBar[boNao] := nil;
  LToolBar[boPilha] := ToolBarPilha;
  LToolBar[boComum] := ToolBarComum;
  for laco2 := High(TTipoOperacao) downto Low(TTipoOperacao) do
    if Operacoes[laco2].Botao <> boNao then
    begin
      LToolButton := TToolButton.Create(LToolBar[Operacoes[laco2].Botao]);
      LToolButton.Caption := Operacoes[laco2].Nome;
      LToolButton.Parent := LToolBar[Operacoes[laco2].Botao];
      LToolButton.ImageIndex := Operacoes[laco2].Imagem;
      LToolButton.Hint := Operacoes[laco2].Nome + ': ' + Operacoes[laco2].Dica;
      LToolButton.OnClick := ClickButton;
    end;
end;

function TPrincipalForm.GetPilha: IPilha;
begin
  Result := FPilha;
end;

function TPrincipalForm.GetTexto: string;
begin
  Result := EntradaMemo.Lines.Text;
end;

procedure TPrincipalForm.SetTexto(const Value: string);
begin
  EntradaMemo.Lines.Text := Value;
end;

procedure TPrincipalForm.Invalida;
begin
  PilhaPaintBox.Invalidate;
  EntradaMemo.SelStart := MaxInt;
end;

procedure TPrincipalForm.OperacaoTreeViewDblClick(Sender: TObject);
begin
  if not OperacaoTreeView.Selected.HasChildren then
  begin
    EntradaMemo.Lines.Add(OperacaoTreeView.Selected.Text);
    TFabricaElemento.Enter(Self);
    EntradaMemo.SetFocus;
  end;
end;

procedure TPrincipalForm.OperacaoTreeViewChange(Sender: TObject;
  Node: TTreeNode);
var
  laco: TTipoOperacao;
begin
  if not Node.HasChildren then
  begin
    for laco := Low(TTipoOperacao) to High(TTipoOperacao) do
      if SameText(Operacoes[laco].Nome, Node.Text) then
      begin
        AjudaText.Caption := Operacoes[laco].Nome + ': ' + Operacoes[laco].Dica;
      end;
  end;
end;

procedure TPrincipalForm.ClickButton(Sender: TObject);
begin
  EntradaMemo.Lines.Add((Sender as TToolButton).Caption);
  TFabricaElemento.Enter(Self);
  EntradaMemo.SetFocus;
end;

procedure TPrincipalForm.About;
var
  LAboutForm: TAboutForm;
begin
  LAboutForm := TAboutForm.Create(nil);
  try
    LAboutForm.ShowModal;
  finally
    LAboutForm.Release;
  end;
end;

procedure TPrincipalForm.EntradaMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TFabricaElemento.KeyDown(Self, Key, Shift);
end;

function TPrincipalForm.GetSobCursor: string;
var
  LTamanho: Integer;
begin
  if EntradaMemo.SelLength < 1 then
  begin
    LTamanho := 1;
    EntradaMemo.SelStart := EntradaMemo.SelStart - 1;
    EntradaMemo.SelLength := LTamanho;
    while (Copy(EntradaMemo.SelText, 1, 1) <> ' ') and (EntradaMemo.SelStart > 0) do
    begin
      EntradaMemo.SelStart := EntradaMemo.SelStart - 1;
      Inc(LTamanho);
      EntradaMemo.SelLength := LTamanho;
    end;
    if Copy(EntradaMemo.SelText, 1, 1) = ' ' then
    begin
      EntradaMemo.SelStart := EntradaMemo.SelStart + 1;
      Dec(LTamanho);
      EntradaMemo.SelLength := LTamanho;
    end;
    EntradaMemo.SelLength := EntradaMemo.SelLength + 1;
    while (EntradaMemo.SelLength > LTamanho) and (Copy(EntradaMemo.SelText, EntradaMemo.SelLength, 1) <> ' ') do
    begin
      LTamanho := EntradaMemo.SelLength;
      EntradaMemo.SelLength := EntradaMemo.SelLength + 1;
    end;
    if Copy(EntradaMemo.SelText, EntradaMemo.SelLength, 1) = ' ' then
      EntradaMemo.SelLength := EntradaMemo.SelLength - 1;
  end;
  Result := EntradaMemo.SelText;
end;

procedure TPrincipalForm.SetSobCursor(const Value: string);
begin
  if EntradaMemo.SelLength > 0 then
    EntradaMemo.SelText := Value;
end;

end.
