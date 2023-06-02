unit Loja.DM.Imagens;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TdmImagens = class(TDataModule)
    imgIco48: TImageList;
    imgIco24: TImageList;
    imgIco16: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmImagens: TdmImagens;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
