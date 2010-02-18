unit uCalx;

interface

uses
  SysUtils, Classes, Windows, Types, Graphics, Math;

type
  TTipoOperacao = (
    //Pilha
    opDup, opDrop, opClear, opEdit, opSwap,
    //Geral
    opAdd, opSub, opMul, opDiv, opChS,
    //Comum
    opInv, opPow, opPerc, opSqr, opSqRt,
    //Trigonometria
    opPi, opSin, opCos, opTan, opASin, opACos, opATan,
    //Configuracao
    opAbout);

  IPilha = interface; //foward

  IEntrada = interface
    ['{E0256543-67D4-4F27-BE33-2C79327B43E6}']
    function GetSobCursor: string;
    function GetTexto: string;
    procedure SetSobCursor(const Value: string);
    procedure SetTexto(const Value: string);

    procedure About;
    function GetPilha: IPilha;
    procedure Invalida;
    property SobCursor: string read GetSobCursor write SetSobCursor;
    property Texto: string read GetTexto write SetTexto;
  end;

  IElementoPilha = interface
    ['{37CFB649-A0C7-4BE5-89EF-786AC7FCD947}']
    function GetPilha: IPilha;
    procedure SetPilha(const Value: IPilha);

    procedure Assign(AElemento: IElementoPilha);
    function Clone: IElementoPilha;
    procedure Draw(APosicao: Integer; ACanvas: TCanvas; var ARect: TRect);
    function ToString: string;
    property Pilha: IPilha read GetPilha write SetPilha;
  end;

  IOperacao = interface
    ['{4DED9048-5415-4A17-9E88-182F9A0107F8}']
    function GetTipoOperacao: TTipoOperacao;
    procedure SetTipoOperacao(Value: TTipoOperacao);

    procedure Executa;
    property TipoOperacao: TTipoOperacao read GetTipoOperacao write SetTipoOperacao;
  end;

  IPilha = interface
    ['{2DCFED9D-B85D-4B23-8115-F5BF4CF49093}']
    function GetElemento(Index: Integer): IElementoPilha;
    function GetEntrada: IEntrada;
    procedure SetElemento(Index: Integer; const Value: IElementoPilha);
    procedure SetEntrada(const Value: IEntrada);

    procedure Clear;
    function Count: Integer;
    procedure Draw(ACanvas: TCanvas; ARect: TRect);
    function Pop: IElementoPilha;
    procedure Push(const AElemento: IElementoPilha); overload;
    procedure Push(const AValue: string); overload;
    property Elemento[Index: Integer]: IElementoPilha read GetElemento write SetElemento; default;
    property Entrada: IEntrada read GetEntrada write SetEntrada;
  end;

  TPilha = class(TInterfacedObject, IPilha)
  private
    FList: TInterfaceList;
    FEntrada: IEntrada;
  protected
    { IPilha }
    function GetElemento(Index: Integer): IElementoPilha;
    function GetEntrada: IEntrada;
    procedure SetElemento(Index: Integer; const Value: IElementoPilha);
    procedure SetEntrada(const Value: IEntrada);

    procedure Clear;
    function Count: Integer;
    procedure Draw(ACanvas: TCanvas; ARect: TRect);
    function Pop: IElementoPilha;
    procedure Push(const AElemento: IElementoPilha); overload;
    procedure Push(const AValue: string); overload;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TFabricaElemento = class(TObject)
  private
    class function TryCreateElemento(const AValue: string): IElementoPilha;
  public
    class function CreateElemento(const AValue: string): IElementoPilha;
    class procedure KeyDown(AEntrada: IEntrada; var AKey: Word; AShift: TShiftState);
    class procedure PressKey(AEntrada: IEntrada; var AKey: Char);
    class procedure Enter(const AEntrada: IEntrada); overload;
    class procedure Enter(const APilha: IPilha; const AEntrada: string); overload;
  end;

  TElementoPilha = class(TInterfacedObject, IElementoPilha)
  private
    FPilha: IPilha;
  protected
    { IElementoPilha }
    function GetPilha: IPilha;
    procedure SetPilha(const Value: IPilha);

    procedure Assign(AElemento: IElementoPilha); virtual;
    function Clone: IElementoPilha;
    procedure Draw(APosicao: Integer; ACanvas: TCanvas; var ARect: TRect); virtual;
    function ToString: string; virtual;
  public
  end;

  TClasseOperacao = class of TOperacao;

  TOperacao = class(TElementoPilha, IOperacao)
  private
    FTipoOperacao: TTipoOperacao;
  protected
    procedure Assign(AElemento: IElementoPilha); override;
    function ToString: string; override;
    { IOperacao }
    function GetTipoOperacao: TTipoOperacao;
    procedure SetTipoOperacao(Value: TTipoOperacao);

    procedure Executa; virtual; abstract;
  end;

  TOperacaoPilha = class(TOperacao)
  protected
    procedure Executa; override;
  end;

  TOperacaoConstante = class(TOperacao)
  protected
    procedure Executa; override;
  end;

  TOperacaoUnario = class(TOperacao)
  protected
    procedure Executa; override;
  end;

  IUnarioOperacao = interface
    ['{6DBEC9CC-EA9F-46C9-81DF-307B7B2F3DBA}']
    function OperacaoUnario(AOperacao: IOperacao): IElementoPilha;
  end;

  TOperacaoBinario = class(TOperacao)
  protected
    procedure Executa; override;
  end;

  IBinarioOperacao = interface
    ['{2F1F778C-E8E5-48FD-B886-E05636538346}']
    function OperacaoBinario(AOperacao: IOperacao; AElemento: IElementoPilha): IElementoPilha;
  end;

  IToNumero = interface
    ['{7D4B3284-CA47-4FB8-8BF8-163B7B7D9BDC}']
    function Numero: Extended;
  end;

  IToNumeroRelativo = interface
    ['{806614F3-9EDD-45C2-816B-B358F37CEE5D}']
    function NumeroRelativo(const AValue: Extended; const AOperacao: IOperacao): Extended;
  end;

  TElementoNumero = class(TElementoPilha, IUnarioOperacao, IBinarioOperacao, IToNumero)
  private
    FNumero: Extended;
  protected
    procedure Assign(AElemento: IElementoPilha); override;
    procedure Draw(APosicao: Integer; ACanvas: TCanvas; var ARect: TRect); override;
    function ToString: string; override;
    { IUnarioOperacao }
    function OperacaoUnario(AOperacao: IOperacao): IElementoPilha;
    { IBinarioOperacao }
    function OperacaoBinario(AOperacao: IOperacao; AElemento: IElementoPilha): IElementoPilha;
    { IToNumero }
    function Numero: Extended;
  public
    constructor Create(const AValue: string); overload;
    constructor Create(const AValue: Extended); overload;
    class function IsValid(const AValue: string): Boolean;
    class function TrocaSinal(const AValue: string): string;
  end;

  TElementoPercentual = class(TElementoPilha, IUnarioOperacao, IBinarioOperacao, IToNumero, IToNumeroRelativo)
  private
    FPercentual: Extended;
  protected
    procedure Assign(AElemento: IElementoPilha); override;
    procedure Draw(APosicao: Integer; ACanvas: TCanvas; var ARect: TRect); override;
    function ToString: string; override;
    { IUnarioOperacao }
    function OperacaoUnario(AOperacao: IOperacao): IElementoPilha;
    { IBinarioOperacao }
    function OperacaoBinario(AOperacao: IOperacao; AElemento: IElementoPilha): IElementoPilha;
    { IToNumero }
    function Numero: Extended;
    { IToNumeroRelativo }
    function NumeroRelativo(const AValue: Extended; const AOperacao: IOperacao): Extended;
  public
    constructor Create(const AValue: string); overload;
    constructor Create(const AValue: Extended); overload;
    class function IsValid(const AValue: string): Boolean;
    class function TrocaSinal(const AValue: string): string;
  end;

  TNo = (noNenhum, noRaiz, noGeral, noPilha, noMatematica, noComum,
    noTrigonometria, noConfiguracao);

  TBotao = (boNao, boPilha, boComum);

  TNoDefinicao = record
    Nome: string;
    Pai: TNo;
  end;

  TStringOperacao = record
    Operacao: TTipoOperacao;
    Nome: string;
    Classe: TClasseOperacao;
    No: TNo;
    Imagem: Integer;
    Botao: TBotao;
    Dica: string;
  end;

const
  NoDefinicoes: array [TNo] of TNoDefinicao = (
    (Nome: ''; Pai: noNenhum),
    (Nome: 'Operações'; Pai: noNenhum),
    (Nome: 'Geral'; Pai: noRaiz),
    (Nome: 'Pilha'; Pai: noRaiz),
    (Nome: 'Matemática'; Pai: noRaiz),
    (Nome: 'Comum'; Pai: noMatematica),
    (Nome: 'Trigonometria'; Pai: noMatematica),
    (Nome: 'Configuração'; Pai: noRaiz)
  );

  Operacoes: array [TTipoOperacao] of TStringOperacao = (
    //Pilha
    (Operacao: opDup; Nome: 'Dup'; Classe: TOperacaoPilha; No: noPilha; Imagem: 2; Botao: boPilha; Dica: 'Duplica o primeiro item da pilha (atalho: [Enter] com entrada vazia)'),
    (Operacao: opDrop; Nome: 'Drop'; Classe: TOperacaoPilha; No: noPilha; Imagem: 3; Botao: boPilha; Dica: 'Apaga o primeiro item da pilha (atalho: [BkSpace] com entrada vazia)'),
    (Operacao: opClear; Nome: 'Clear'; Classe: TOperacaoPilha; No: noPilha; Imagem: 18; Botao: boPilha; Dica: 'Apaga todos os itens da pilha (atalho: [Esc] com entrada vazia)'),
    (Operacao: opEdit; Nome: 'Edit'; Classe: TOperacaoPilha; No: noPilha; Imagem: 16; Botao: boPilha; Dica: 'Edita o primeiro item da pilha (atalho: [Seta Abaixo] com entrada vazia)'),
    (Operacao: opSwap; Nome: 'Swap'; Classe: TOperacaoPilha; No: noPilha; Imagem: 17; Botao: boPilha; Dica: 'Troca o primeiro item da pilha com o segundo (atalho: [Seta Direita] com entrada vazia ou [Ctrl]+[Seta Direita] em qualquer situação)'),
    //Geral
    (Operacao: opAdd; Nome: 'Add'; Classe: TOperacaoBinario; No: noGeral; Imagem: 4; Botao: boComum; Dica: 'Soma (atalho: [+])'),
    (Operacao: opSub; Nome: 'Sub'; Classe: TOperacaoBinario; No: noGeral; Imagem: 5; Botao: boComum; Dica: 'Subtração (atalho: [-])'),
    (Operacao: opMul; Nome: 'Mul'; Classe: TOperacaoBinario; No: noGeral; Imagem: 6; Botao: boComum; Dica: 'Multiplicação (atalho: [*])'),
    (Operacao: opDiv; Nome: 'Div'; Classe: TOperacaoBinario; No: noGeral; Imagem: 7; Botao: boComum; Dica: 'Divisão (atalho: [/])'),
    (Operacao: opChS; Nome: 'ChS'; Classe: TOperacaoUnario; No: noGeral; Imagem: 9; Botao: boComum; Dica: 'Troca o sinal (atalho: [Seta Acima] com entrada vazia, ou [Seta Acima] sobre o número perto do cursor)'),
    //Comum
    (Operacao: opInv; Nome: 'Inv'; Classe: TOperacaoUnario; No: noComum; Imagem: 15; Botao: boComum; Dica: 'Inverso 1/x'),
    (Operacao: opPow; Nome: 'Pow'; Classe: TOperacaoBinario; No: noComum; Imagem: 8; Botao: boComum; Dica: 'Potência (atalho: [^])'),
    (Operacao: opPerc; Nome: 'Perc'; Classe: TOperacaoUnario; No: noComum; Imagem: 10; Botao: boComum; Dica: 'Converte número para percentual'),
    (Operacao: opSqr; Nome: 'Sqr'; Classe: TOperacaoUnario; No: noComum; Imagem: 11; Botao: boComum; Dica: 'Quadrado x^2'),
    (Operacao: opSqRt; Nome: 'SqRt'; Classe: TOperacaoUnario; No: noComum; Imagem: 12; Botao: boComum; Dica: 'Raiz Quadrada x^(1/2)'),
    //Trigonometria
    (Operacao: opPi; Nome: 'Pi'; Classe: TOperacaoConstante; No: noTrigonometria; Imagem: 13; Botao: boNao; Dica: 'constante - número pi'),
    (Operacao: opSin; Nome: 'Sin'; Classe: TOperacaoUnario; No: noTrigonometria; Imagem: 1; Botao: boNao; Dica: 'seno de x'),
    (Operacao: opCos; Nome: 'Cos'; Classe: TOperacaoUnario; No: noTrigonometria; Imagem: 1; Botao: boNao; Dica: 'cosseno de x'),
    (Operacao: opTan; Nome: 'Tan'; Classe: TOperacaoUnario; No: noTrigonometria; Imagem: 1; Botao: boNao; Dica: 'tangente de x'),
    (Operacao: opASin; Nome: 'ASin'; Classe: TOperacaoUnario; No: noTrigonometria; Imagem: 1; Botao: boNao; Dica: 'arco seno de x'),
    (Operacao: opACos; Nome: 'ACos'; Classe: TOperacaoUnario; No: noTrigonometria; Imagem: 1; Botao: boNao; Dica: 'arco cosseno de x'),
    (Operacao: opATan; Nome: 'ATan'; Classe: TOperacaoUnario; No: noTrigonometria; Imagem: 1; Botao: boNao; Dica: 'arco tangente de x'),
    //Configuracao
    (Operacao: opAbout; Nome: 'About'; Classe: TOperacaoPilha; No: noConfiguracao; Imagem: 14; Botao: boNao; Dica: 'Sobre o Calx (este programa)')
  );

implementation

{ TPilha }

procedure TPilha.Clear;
begin
  FList.Clear;
end;

function TPilha.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TPilha.Create;
begin
  FList := TInterfaceList.Create;
end;

destructor TPilha.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TPilha.Draw(ACanvas: TCanvas; ARect: TRect);
var
  laco: Integer;
begin
  ACanvas.Pen.Color := clBlack;
  ACanvas.Brush.Color := clWindow;
  ACanvas.Rectangle(ARect);
  ARect := Rect(ARect.Left + 1, ARect.Top + 1, ARect.Right - 1, ARect.Bottom - 1);
  for laco := 0 to Count - 1 do
    GetElemento(laco).Draw(laco + 1, ACanvas, ARect);
end;

function TPilha.GetElemento(Index: Integer): IElementoPilha;
begin
  Result := FList[Count - 1 - Index] as IElementoPilha;
end;

function TPilha.GetEntrada: IEntrada;
begin
  Result := FEntrada;
end;

function TPilha.Pop: IElementoPilha;
begin
  Result := GetElemento(0);
  Result.Pilha := nil;
  FList.Delete(Count - 1);
end;

procedure TPilha.Push(const AElemento: IElementoPilha);
var
  LOperacao: IOperacao;
begin
  AElemento.Pilha := Self;
  if Supports(AElemento, IOperacao, LOperacao) then
    LOperacao.Executa
  else
    FList.Add(AElemento);
end;

procedure TPilha.Push(const AValue: string);
begin
  Push(TFabricaElemento.CreateElemento(AValue));
end;

procedure TPilha.SetElemento(Index: Integer; const Value: IElementoPilha);
begin
  FList[Count - 1 - Index] := Value;
end;

procedure TPilha.SetEntrada(const Value: IEntrada);
begin
  FEntrada := Value;
end;

{ TFabricaElemento }

class function TFabricaElemento.CreateElemento(
  const AValue: string): IElementoPilha;
begin
  Result := TryCreateElemento(AValue);
  if not Assigned(Result) then
    raise Exception.CreateFmt('"%s" não foi interpretado', [AValue]);
end;

class procedure TFabricaElemento.Enter(const AEntrada: IEntrada);
var
  LEntrada: string;
begin
  LEntrada := AEntrada.Texto;
  AEntrada.Texto := '';
  Enter(AEntrada.GetPilha, LEntrada);
  AEntrada.Invalida;
end;

class procedure TFabricaElemento.Enter(const APilha: IPilha;
  const AEntrada: string);
var
  p: Integer;
  LEntrada, LRestoEntrada: string;
begin
  LEntrada := Trim(StringReplace(AEntrada, #13#10, ' ', [rfReplaceAll]));
  p := Pos(' ', LEntrada);
  if p > 0 then
  begin
    LRestoEntrada := Copy(LEntrada, p + 1, MaxInt);
    LEntrada := Copy(LEntrada, 1, p - 1);
  end
  else
    LRestoEntrada := '';
  APilha.Push(LEntrada);
  if LRestoEntrada <> '' then
    Enter(APilha, LRestoEntrada)
end;

class procedure TFabricaElemento.KeyDown(AEntrada: IEntrada;
  var AKey: Word; AShift: TShiftState);
begin
  if (AKey = VK_RIGHT) and ((AEntrada.Texto = '') or (AShift = [ssCtrl])) then
  begin
    if AEntrada.Texto = '' then
      AEntrada.Texto := 'Swap'
    else
      AEntrada.Texto := AEntrada.Texto + ' Swap';
    Enter(AEntrada);
    AKey := 0;
  end
  else if AKey = VK_ESCAPE then
  begin
    if AEntrada.Texto = '' then
    begin
      AEntrada.Texto := 'Clear';
      Enter(AEntrada);
    end
    else
      AEntrada.Texto := '';
    AKey := 0;
  end
  else if (AKey = VK_DOWN) and (AEntrada.Texto = '') then
  begin
    AEntrada.Texto := 'Edit';
    Enter(AEntrada);
    AKey := 0;
  end
  else if (AKey = VK_UP) and (AEntrada.Texto = '') then
  begin
    AEntrada.Texto := 'ChS';
    Enter(AEntrada);
    AKey := 0;
  end
  else if (AKey = VK_UP) and (TElementoNumero.IsValid(AEntrada.SobCursor)) then
  begin
    AEntrada.SobCursor := TElementoNumero.TrocaSinal(AEntrada.SobCursor);
    AKey := 0;
  end
  else if (AKey = VK_UP) and (TElementoPercentual.IsValid(AEntrada.SobCursor)) then
  begin
    AEntrada.SobCursor := TElementoPercentual.TrocaSinal(AEntrada.SobCursor);
    AKey := 0;
  end;
end;

class procedure TFabricaElemento.PressKey(AEntrada: IEntrada;
  var AKey: Char);
var
  LEnter: Boolean;
  LEntrada: string;
begin
  LEntrada := '';
  if AKey = ThousandSeparator then
    AKey := DecimalSeparator;
  case AKey of
    #8:
      if AEntrada.Texto = '' then
        LEntrada := 'Drop';
    '+': LEntrada := 'Add';
    '-': LEntrada := 'Sub';
    '*': LEntrada := 'Mul';
    '/': LEntrada := 'Div';
    '^': LEntrada := 'Pow';
  end;
  LEnter := (LEntrada <> '') or (AKey = #13);
  if LEnter then
  begin
    if AEntrada.Texto = '' then
      AEntrada.Texto := LEntrada
    else
      AEntrada.Texto := AEntrada.Texto + ' ' + LEntrada;
    Enter(AEntrada);
    AKey := #0;
  end;
end;

class function TFabricaElemento.TryCreateElemento(
  const AValue: string): IElementoPilha;
var
  laco: TTipoOperacao;
begin
  Result := nil;
  if TElementoPercentual.IsValid(AValue) then
    Result := TElementoPercentual.Create(AValue)
  else if TElementoNumero.IsValid(AValue) then
    Result := TElementoNumero.Create(AValue)
  else
  begin
    for laco := Low(TTipoOperacao) to High(TTipoOperacao) do
      if SameText(Operacoes[laco].Nome, AValue) then
      begin
        Result := Operacoes[laco].Classe.Create;
        (Result as IOperacao).TipoOperacao := Operacoes[laco].Operacao;
        Break;
      end;
  end;
  if (not Assigned(Result)) and (AValue = '') then
  begin
    Result := Operacoes[opDup].Classe.Create;
    (Result as IOperacao).TipoOperacao := Operacoes[opDup].Operacao;
  end;
end;

{ TElementoPilha }

procedure TElementoPilha.Assign(AElemento: IElementoPilha);
begin
  //Faz Nada
end;

function TElementoPilha.Clone: IElementoPilha;
var
  LObject: TObject;
begin
  LObject := ClassType.Create;
  try
    Assert(Supports(LObject, IElementoPilha, Result), 'Classe não implementa interface IElementoPilha');
    Result.Assign(Self);
  except
    LObject.Free;
  end;
end;

procedure TElementoPilha.Draw(APosicao: Integer; ACanvas: TCanvas;
  var ARect: TRect);
var
  LPosicao: string;
begin
  LPosicao := IntToStr(APosicao) + ':';
  ACanvas.TextOut(1, ARect.Bottom - ACanvas.TextHeight(LPosicao) - 1, LPosicao);
end;

function TElementoPilha.GetPilha: IPilha;
begin
  Result := FPilha;
end;

procedure TElementoPilha.SetPilha(const Value: IPilha);
begin
  FPilha := Value;
end;

function TElementoPilha.ToString: string;
begin
  Result := '';
end;

{ TOperacao }

procedure TOperacao.Assign(AElemento: IElementoPilha);
var
  LOperacao: IOperacao;
begin
  inherited;
  if Supports(AElemento, IOperacao, LOperacao) then
    SetTipoOperacao(LOperacao.TipoOperacao);
end;

function TOperacao.GetTipoOperacao: TTipoOperacao;
begin
  Result := FTipoOperacao;
end;

procedure TOperacao.SetTipoOperacao(Value: TTipoOperacao);
begin
  FTipoOperacao := Value;
end;

function TOperacao.ToString: string;
begin
  Result := Operacoes[FTipoOperacao].Nome;
end;

{ TOperacaoPilha }

procedure TOperacaoPilha.Executa;
var
  LPilha: IPilha;
  LElemento1, LElemento2: IElementoPilha;
begin
  LPilha := GetPilha;
  case GetTipoOperacao of
    opDup: begin
      if LPilha.Count < 1 then
        raise Exception.Create('A pilha está vazia');
      LElemento1 := LPilha[0];
      LElemento2 := LElemento1.Clone;
      LPilha.Push(LElemento2);
    end;
    opDrop: begin
      if LPilha.Count < 1 then
        raise Exception.Create('A pilha está vazia');
      LPilha.Pop;
    end;
    opClear: begin
      LPilha.Clear;
    end;
    opEdit: begin
      if LPilha.Count < 1 then
        raise Exception.Create('A pilha está vazia');
      LElemento1 := LPilha.Pop;
      LPilha.Entrada.Texto := LElemento1.ToString;
    end;
    opSwap: begin
      if LPilha.Count < 2 then
        raise Exception.Create('É necessário 2 itens na pilha');
      LElemento1 := LPilha.Pop;
      LElemento2 := LPilha.Pop;
      LPilha.Push(LElemento1);
      LPilha.Push(LElemento2);
    end;
    opAbout: LPilha.Entrada.About;
  else
    raise Exception.Create('A pilha não suporta este tipo de operacao');
  end;
end;

{ TOperacaoConstante }

procedure TOperacaoConstante.Executa;
begin
  case GetTipoOperacao of
    opPi: GetPilha.Push(TElementoNumero.Create(Pi));
  else
    raise Exception.Create('Constante inexistente');
  end;
end;

{ TOperacaoUnario }

procedure TOperacaoUnario.Executa;
var
  LPilha: IPilha;
  LUnarioOperacao: IUnarioOperacao;
  LElemento: IElementoPilha;
begin
  LPilha := GetPilha;
  if LPilha.Count < 1 then
    raise Exception.Create('É necessário 1 parâmetro para esta operação');
  LElemento := LPilha.Pop;
  try
    if not Supports(LElemento, IUnarioOperacao, LUnarioOperacao) then
      raise Exception.Create('Primeiro parâmetro não suporta operações com 1 parâmetro');
    LElemento := LUnarioOperacao.OperacaoUnario(Self);
  except
    LPilha.Push(LElemento);
    raise;
  end;
  LPilha.Push(LElemento);
end;

{ TOperacaoBinario }

procedure TOperacaoBinario.Executa;
var
  LPilha: IPilha;
  LBinarioOperacao: IBinarioOperacao;
  LElemento1, LElemento2: IElementoPilha;
begin
  LPilha := GetPilha;
  if LPilha.Count < 2 then
    raise Exception.Create('É necessário 2 parâmetros para esta operação');
  LElemento2 := LPilha.Pop;
  LElemento1 := LPilha.Pop;
  try
    if not Supports(LElemento1, IBinarioOperacao, LBinarioOperacao) then
      raise Exception.Create('Primeiro parâmetro não suporta operações com 2 parâmetros');
    LElemento1 := LBinarioOperacao.OperacaoBinario(Self, LElemento2);
  except
    LPilha.Push(LElemento1);
    LPilha.Push(LELemento2);
    raise;
  end;
  LPilha.Push(LElemento1);
end;

{ TElementoNumero }

procedure TElementoNumero.Assign(AElemento: IElementoPilha);
var
  LToNumero: IToNumero;
begin
  inherited;
  if Supports(AElemento, IToNumero, LToNumero) then
    FNumero := LToNumero.Numero;
end;

constructor TElementoNumero.Create(const AValue: string);
begin
  Assert(IsValid(AValue), 'Não é um Número válido');
  Create(StrToFloat(AValue));
end;

constructor TElementoNumero.Create(const AValue: Extended);
begin
  FNumero := AValue;
end;

procedure TElementoNumero.Draw(APosicao: Integer; ACanvas: TCanvas;
  var ARect: TRect);
var
  LNumero: string;
begin
  inherited;
  LNumero := FloatToStr(FNumero);
  ACanvas.TextOut(ARect.Right - ACanvas.TextWidth(LNumero) - 1, ARect.Bottom - ACanvas.TextHeight(LNumero) - 1, LNumero);
  ARect.Bottom := ARect.Bottom - ACanvas.TextHeight(LNumero) - 2;
end;

class function TElementoNumero.IsValid(const AValue: string): Boolean;
var
  LNumero: Extended;
begin
  Result := TryStrToFloat(AValue, LNumero);
end;

function TElementoNumero.Numero: Extended;
begin
  Result := FNumero;
end;

function TElementoNumero.OperacaoBinario(AOperacao: IOperacao; AElemento: IElementoPilha): IElementoPilha;
var
  LToNumero: IToNumero;
  LToNumeroRelativo: IToNumeroRelativo;
  ASegundoValor: Extended;
begin
  if Supports(AElemento, IToNumeroRelativo, LToNumeroRelativo) then
    ASegundoValor := LToNumeroRelativo.NumeroRelativo(FNumero, AOperacao)
  else if Supports(AElemento, IToNumero, LToNumero) then
    ASegundoValor := LToNumero.Numero
  else
    raise Exception.Create('Segundo parâmetro não pode ser convertido em número');
  case AOperacao.TipoOperacao of
    opAdd: FNumero := FNumero + ASegundoValor;
    opSub: FNumero := FNumero - ASegundoValor;
    opMul: FNumero := FNumero * ASegundoValor;
    opDiv: FNumero := FNumero / ASegundoValor;
    opPow: FNumero := Power(FNumero, ASegundoValor);
  else
    raise Exception.Create('Primeiro parâmetro não suporta este tipo de operação');
  end;
  Result := Self;
end;

function TElementoNumero.OperacaoUnario(
  AOperacao: IOperacao): IElementoPilha;
begin
  case AOperacao.TipoOperacao of
    opChS: FNumero := -FNumero;
    opInv: begin
      if FNumero = 0 then
        raise Exception.Create('Não é possível determinar o inverso de zero');
      FNumero := 1/FNumero;
    end;
    opPerc: begin
      Result := TElementoPercentual.Create(FNumero);
      Exit;
    end;
    opSQR: FNumero := Sqr(FNumero);
    opSqRt: begin
      if FNumero < 0 then
        raise Exception.Create('Não é possível extrair raiz quadrada de número negativo');
      FNumero := Sqrt(FNumero);
    end;
    opSin: FNumero := Sin(FNumero);
    opCos: FNumero := Cos(FNumero);
    opTan: FNumero := Tan(FNumero);
    opASin: FNumero := ArcSin(FNumero);
    opACos: FNumero := ArcCos(FNumero);
    opATan: FNumero := ArcTan(FNumero);
  else
    raise Exception.Create('Parâmetro não suporta este tipo de operação');
  end;
  Result := Self;
end;

function TElementoNumero.ToString: string;
begin
  Result := FloatToStr(FNumero);
end;

class function TElementoNumero.TrocaSinal(const AValue: string): string;
var
  LNumero: IElementoPilha;
  LOperacao: IOperacao;
begin
  Result := AValue;
  LNumero := Create(AValue);
  LOperacao := TOperacaoUnario.Create;
  LOperacao.TipoOperacao := opChS;
  (LNumero as IUnarioOperacao).OperacaoUnario(LOperacao);
  Result := LNumero.ToString;
end;

{ TElementoPercentual }

constructor TElementoPercentual.Create(const AValue: string);
begin
  Assert(IsValid(AValue), 'Não é um Percental válido');
  Create(StrToFloat(Copy(AValue, 1, Length(AValue) - 1)));
end;

procedure TElementoPercentual.Assign(AElemento: IElementoPilha);
var
  LToNumero: IToNumero;
begin
  inherited;
  if Supports(AElemento, IToNumero, LToNumero) then
    FPercentual := LToNumero.Numero;
end;

constructor TElementoPercentual.Create(const AValue: Extended);
begin
  FPercentual := AValue / 100;
end;

procedure TElementoPercentual.Draw(APosicao: Integer; ACanvas: TCanvas;
  var ARect: TRect);
var
  LPercentual: string;
begin
  inherited;
  LPercentual := FloatToStr(FPercentual * 100) + '%';
  ACanvas.Font.Color := clBlue;
  try
    ACanvas.TextOut(ARect.Right - ACanvas.TextWidth(LPercentual) - 1, ARect.Bottom - ACanvas.TextHeight(LPercentual) - 1, LPercentual);
  finally
    ACanvas.Font.Color := clWindowText;
  end;
  ARect.Bottom := ARect.Bottom - ACanvas.TextHeight(LPercentual) - 2;
end;

class function TElementoPercentual.IsValid(const AValue: string): Boolean;
var
  LNumero: Extended;
begin
  Result := (Copy(AValue, Length(AValue), 1) = '%') and
    TryStrToFloat(Copy(AValue, 1, Length(AValue) - 1), LNumero);
end;

function TElementoPercentual.Numero: Extended;
begin
  Result := FPercentual;
end;

function TElementoPercentual.NumeroRelativo(
  const AValue: Extended; const AOperacao: IOperacao): Extended;
begin
  if AOperacao.TipoOperacao in [opAdd, opSub] then
    Result := AValue * FPercentual
  else
    Result := FPercentual;
end;

function TElementoPercentual.OperacaoBinario(AOperacao: IOperacao;
  AElemento: IElementoPilha): IElementoPilha;
var
  LToNumero: IToNumero;
begin
  if not Supports(AElemento, IToNumero, LToNumero) then
    raise Exception.Create('Segundo parâmetro não pode ser convertido em número');
  case AOperacao.TipoOperacao of
    opAdd: FPercentual := FPercentual + LToNumero.Numero;
    opSub: FPercentual := FPercentual - LToNumero.Numero;
    opMul: FPercentual := FPercentual * LToNumero.Numero;
    opDiv: FPercentual := FPercentual / LToNumero.Numero;
    opPow: FPercentual := Power(FPercentual, LToNumero.Numero);
  else
    raise Exception.Create('Primeiro parâmetro não suporta este tipo de operação');
  end;
  Result := Self;
end;

function TElementoPercentual.OperacaoUnario(
  AOperacao: IOperacao): IElementoPilha;
begin
  case AOperacao.TipoOperacao of
    opChS: FPercentual := -FPercentual;
    opInv: begin
      if FPercentual = 0 then
        raise Exception.Create('Não é possível determinar o inverso de zero');
      FPercentual := 1/FPercentual;
    end;
    opPerc: FPercentual := FPercentual / 100;
    opSQR: FPercentual := Sqr(FPercentual);
    opSqRt: begin
      if FPercentual < 0 then
        raise Exception.Create('Não é possível extrair raiz quadrada de número negativo');
      FPercentual := Sqrt(FPercentual);
    end;
  else
    //Outra operação com percentual, faz converter em número e executa a operação
    Result := TElementoNumero.Create(FPercentual);
    (Result as IUnarioOperacao).OperacaoUnario(AOperacao);
    Exit;
  end;
  Result := Self;
end;

function TElementoPercentual.ToString: string;
begin
  Result := FloatToStr(FPercentual * 100) + '%';
end;

class function TElementoPercentual.TrocaSinal(
  const AValue: string): string;
var
  LPercentual: IElementoPilha;
  LOperacao: IOperacao;
begin
  Result := AValue;
  LPercentual := Create(AValue);
  LOperacao := TOperacaoUnario.Create;
  LOperacao.TipoOperacao := opChS;
  (LPercentual as IUnarioOperacao).OperacaoUnario(LOperacao);
  Result := LPercentual.ToString;
end;

end.
