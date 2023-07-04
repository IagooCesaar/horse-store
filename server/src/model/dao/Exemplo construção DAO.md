# Exemplo de criação de DAO's Oficial e Em Memória

```pascal

// DAO InMemory

  
type
  TLojaModelDaoCaixaMovimentoInMemory = class(TNoRefCountObject, ILojaModelDaoCaixaMovimento)
  private
    FRepository: TLojaModelEntityCaixaMovimentoLista;
    function Clone(ASource: TLojaModelEntityCaixaMovimento): TLojaModelEntityCaixaMovimento;

    class var FDao: TLojaModelDaoCaixaMovimentoInMemory;
  public
    constructor Create;
    destructor Destroy; override; //FreeAndNil(FRepository);
    class function GetInstance: ILojaModelDaoCaixaMovimento;
    class destructor UnInitialize; // FreeAndNil(FDao);
	
   end;

// DAO Factory InMemory
uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  
type
  TLojaModelDaoCaixaFactoryInMemory = class(TNoRefCountObject, ILojaModelDaoCaixaFactory)
  private
    class var FFactory: TLojaModelDaoCaixaFactoryInMemory;
  public
    destructor Destroy; override;
    class function GetInstance: ILojaModelDaoCaixaFactory;
    class destructor UnInitialize; // FreeAndNil(FFactory);
  
  end;	
  
  
// DAO Oficial
type
  TLojaModelDaoCaixaMovimento = class(TInterfacedObject, ILojaModelDaoCaixaMovimento)
  private
    function AtribuiCampos(ds: TDataSet): TLojaModelEntityCaixaMovimento;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoCaixaMovimento;  
	
  end;
  
// DAO Factory Oficial
uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  
type
  TLojaModelDaoCaixaFactory = class(TInterfacedObject, ILojaModelDaoCaixaFactory)
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ILojaModelDaoCaixaFactory;

  end;	
```  