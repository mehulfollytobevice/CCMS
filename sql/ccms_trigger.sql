delimiter $$
CREATE TRIGGER update_rewards AFTER INSERT ON ccms.transaction
FOR EACH ROW
BEGIN
	INSERT INTO ccms.rewards(txn_id, reward_points) VALUES (new.txn_id, ROUND(new.txn_amt, 0));
END $$
delimiter ;

delimiter $$
CREATE TRIGGER update_notification AFTER INSERT ON ccms.transaction
FOR EACH ROW
BEGIN
	DELETE FROM ccms.notification;
    call update_notification();
END $$
delimiter ;

delimiter $$
CREATE TRIGGER update_card_limit AFTER INSERT ON ccms.transaction
FOR EACH ROW
BEGIN
	DELETE FROM ccms.card_limit;
	CALL update_card_limit();
END $$
delimiter ;

delimiter $$
CREATE TRIGGER update_card_statement AFTER INSERT ON ccms.transaction
FOR EACH ROW
BEGIN
	DELETE FROM ccms.card_statement;
	CALL update_card_statement();
END $$
delimiter ;
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
show triggers;
drop trigger update_notification;

Select * from ccms.transaction where txn_datetime > '2022-09-08' and card_num = 2686291279908810;
delete from ccms.transaction where txn_datetime > '2022-09-08' and card_num = 2686291279908810;
commit;
Select count(*) from ccms.transaction;
Select count(*) from ccms.notification;
Select count(*) from ccms.rewards;

INSERT INTO ccms.transaction (card_num, txn_id, txn_datetime, txn_amt, txn_type_id, terminal_id, merchant_id)
VALUES(
'2686291279908810', '202209080003452686291279908810026', '2022-09-08 00:03:45', '75.23', '1002', '1026', '1004')
'2686291279908810', '202209080610532686291279908810005', '2022-09-08 06:10:53', '62.19', '1001', '1005', '1009')
'2686291279908810', '202209081242122686291279908810018', '2022-09-08 12:42:12', '76.84', '1002', '1018', '1011')
'2686291279908810', '202209081748102686291279908810005', '2022-09-08 17:48:10', '44.07', '1002', '1005', '1001')
*/