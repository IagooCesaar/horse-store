/*------------------------------------------------------------------------------
  Redefinie valores dos generators
------------------------------------------------------------------------------*/

set generator GEN_ESTOQUE_MOVIMENTO_ID to 0;
set generator GEN_ESTOQUE_SALDO_ID to 0;
set generator GEN_ITEM_ID to 0;
set generator GEN_CAIXA_ID to 0;
set generator GEN_CAIXA_MOVIMENTO_ID to 0;
set generator GEN_VENDA_ID to 0;


/*------------------------------------------------------------------------------
  Limpa as tabelas
------------------------------------------------------------------------------*/

delete from estoque_movimento where 1=1  ;
delete from estoque_saldo where 1=1      ;
delete from preco_venda where 1=1        ;
delete from item where 1=1               ;
delete from caixa_movimento where 1=1    ;
delete from caixa where 1=1              ;
delete from venda_meio_pagto where 1=1   ;
delete from venda_item where 1=1         ;
delete from venda where 1=1              ;

