unit uMeuBallonHint;

interface

uses WinApi.Windows;

type
  TTipoBallon = (tbNenhum , tbInfo , tbWarning , tbError);

type
   TEditBalloonTip = packed record
      cbStruct: DWORD ;
      pszTitle: LPCWSTR ;
      pszText: LPCWSTR;
      ttiIcon: Integer;
   const
      ECM_FIRST = $1500;
      EM_SHOWBALLOONTIP = (ECM_FIRST + 3);
      EM_HIDEBALLOONTIP = (ECM_FIRST + 4);
end;
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
   Ballon.cbStruct := SizeOf(TEditBalloonTip);
   Ballon.pszText := Texto;
   Ballon.pszTitle := Titulo;
   Ballon.ttiIcon := Integer(Tipo);
   SendMessageW(Window, Ballon.EM_SHOWBALLOONTIP, 0, Integer(@Ballon));
end;

end.
