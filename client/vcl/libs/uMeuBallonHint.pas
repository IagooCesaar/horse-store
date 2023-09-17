unit uMeuBallonHint;

interface

uses WinApi.Windows;

type
  TTipoBallon = (tbNenhum , tbInfo , tbWarning , tbError);

// Exemplo para 64 bits em https://searchcode.com/total-file/14312853/
type
  {$EXTERNALSYM _tagEDITBALLOONTIP}
  _tagEDITBALLOONTIP = record
    cbStruct: DWORD;
    pszTitle: LPCWSTR;
    pszText: LPCWSTR;
    ttiIcon: Integer;
  const
    ECM_FIRST = $1500;
    EM_SHOWBALLOONTIP = (ECM_FIRST + 3);
    EM_HIDEBALLOONTIP = (ECM_FIRST + 4);
  end;
  TEditBalloonTip = _tagEDITBALLOONTIP;

type TMeuBallonHint = class
  public
    constructor ShowBallon(Window : HWnd;Texto, Titulo : PWideChar; Tipo : TTipoBallon);
    destructor  HideBallon(Window : HWnd);
end;

implementation

{ TMeuBallonHint }

destructor TMeuBallonHint.HideBallon(Window: HWnd);
var Ballon : TEditBalloonTip;
begin
   SendMessageW(Window, Ballon.EM_HIDEBALLOONTIP, 0, 0);
end;

constructor TMeuBallonHint.ShowBallon(Window: HWnd; Texto, Titulo: PWideChar;
  Tipo: TTipoBallon);
var Ballon : TEditBalloonTip;
begin
  try
     Ballon.cbStruct := SizeOf(TEditBalloonTip);
     Ballon.pszText := Texto;
     Ballon.pszTitle := Titulo;
     Ballon.ttiIcon := LParam(Tipo);

     SendMessageW(Window, Ballon.EM_SHOWBALLOONTIP, WParam(0), LParam(@Ballon));
  finally
    Ballon := default(TEditBalloonTip);
  end;
end;

end.
