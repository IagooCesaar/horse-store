CREATE DOMAIN FLAG AS CHAR(1) CHECK (VALUE IN ('S','N'));

COMMIT;

ALTER TABLE ITEM ADD FLG_PERM_SALD_NEG FLAG DEFAULT 'S' ;
ALTER TABLE ITEM ADD FLG_TAB_PRECO FLAG DEFAULT 'S' ;

COMMIT;

update item set FLG_PERM_SALD_NEG = 'S', flg_tab_preco = 'S' where 1=1

COMMIT;

