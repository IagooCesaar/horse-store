delete from estoque_movimento where 1=1;
delete from estoque_saldo where 1=1;
delete from item where 1=1;

set generator GEN_ESTOQUE_MOVIMENTO_ID to 0;
set generator GEN_ESTOQUE_SALDO_ID to 0;
set generator GEN_ITEM_ID to 0;
