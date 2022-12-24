delimiter $$
CREATE PROCEDURE update_card_limit()
BEGIN
	INSERT INTO ccms.card_limit
	(SELECT
	c.card_num,
	MAX(20000) AS total_limit,
	20000 - COALESCE(SUM(
		CASE 
			WHEN tt.debit_credit = 'Credit'
				THEN (-1 * t.txn_amt) 
			ELSE t.txn_amt 
		END
	), 0) AS available_limit
    FROM ccms.card c
	LEFT JOIN ccms.transaction t
		ON c.card_num = t.card_num
        AND MONTH(t.txn_datetime) = (SELECT MAX(MONTH(tx.txn_datetime)) FROM ccms.transaction tx)
        AND YEAR(t.txn_datetime) = (SELECT MAX(YEAR(tx.txn_datetime)) FROM ccms.transaction tx)
	LEFT JOIN ccms.transaction_type tt 
		ON tt.txn_type_id = t.txn_type_id
	GROUP BY c.card_num);
end $$
delimiter ;

/*
delimiter $$
CREATE PROCEDURE update_card_statement()
BEGIN
	ALTER TABLE ccms.card_statement DROP COLUMN statement_id;
    
	INSERT INTO ccms.card_statement
	(SELECT
	t.card_num,
	SUM(
		CASE 
			WHEN tt.debit_credit = 'Credit'
				THEN (-1 * t.txn_amt) 
			ELSE t.txn_amt 
		END
	) AS amt_due,
	DATE_FORMAT(txn_datetime, '%Y-%m-01') AS statement_start_date, 
	LAST_DAY(txn_datetime) AS statement_end_date,
	DATE_ADD(LAST_DAY(txn_datetime), INTERVAL 10 DAY) AS due_date
	FROM ccms.transaction t
	INNER JOIN ccms.transaction_type tt 
		ON tt.txn_type_id = t.txn_type_id
	GROUP BY t.card_num, statement_start_date, statement_end_date, due_date
	ORDER BY t.card_num, statement_start_date, statement_end_date, due_date);
    
    ALTER TABLE ccms.card_statement ADD statement_id INT NOT NULL AUTO_INCREMENT AFTER card_num, 
    AUTO_INCREMENT = 100000, ADD PRIMARY KEY (statement_id);
end $$
delimiter ;
*/
delimiter $$
CREATE PROCEDURE update_card_statement()
BEGIN
	INSERT INTO ccms.card_statement
	(SELECT
    0 as statement_id,
	t.card_num,
	SUM(
		CASE 
			WHEN tt.debit_credit = 'Credit'
				THEN (-1 * t.txn_amt) 
			ELSE t.txn_amt 
		END
	) AS amt_due,
	DATE_FORMAT(txn_datetime, '%Y-%m-01') AS statement_start_date, 
	LAST_DAY(txn_datetime) AS statement_end_date,
	DATE_ADD(LAST_DAY(txn_datetime), INTERVAL 10 DAY) AS due_date
	FROM ccms.transaction t
	INNER JOIN ccms.transaction_type tt 
		ON tt.txn_type_id = t.txn_type_id
	GROUP BY t.card_num, statement_start_date, statement_end_date, due_date
	ORDER BY t.card_num, statement_start_date, statement_end_date, due_date);
end $$
delimiter ;

/*
delimiter $$
CREATE PROCEDURE update_notification()
BEGIN
	ALTER TABLE ccms.notification DROP COLUMN notification_id;
    
    INSERT INTO ccms.notification
	(SELECT
	t.txn_id,
    t.txn_datetime as notification_datetime,
	CASE 
	WHEN tt.lcl_intnl = 'International'
		THEN
			CASE 
			WHEN tt.debit_credit = 'Debit'
				THEN CONCAT('International Transaction Alert!! Amount: $', t.txn_amt, ' is debited from your card')
			WHEN tt.debit_credit = 'Credit'
				THEN CONCAT('International Transaction Alert!! Amount: $', t.txn_amt, ' is credited to your card')
			END
	WHEN tt.lcl_intnl = 'Local'
		THEN
			CASE 
			WHEN tt.debit_credit = 'Debit'
				THEN CONCAT('Amount: $', t.txn_amt, ' is debited from your card')
			WHEN tt.debit_credit = 'Credit'
				THEN CONCAT('Amount: $', t.txn_amt, ' is credited to your card')
			END
	END AS notification,
	CASE
		WHEN tt.lcl_intnl = 'International'
			THEN 1
		WHEN tt.lcl_intnl = 'Local'
			THEN 0
	END as alert_flag
	FROM ccms.transaction t
	INNER JOIN ccms.transaction_type tt 
		ON tt.txn_type_id = t.txn_type_id);
	
    ALTER TABLE ccms.notification ADD notification_id INT NOT NULL AUTO_INCREMENT AFTER txn_id, 
    AUTO_INCREMENT = 1000000000, ADD PRIMARY KEY (notification_id);
end $$
delimiter ;
*/
delimiter $$
CREATE PROCEDURE update_notification()
BEGIN
    INSERT INTO ccms.notification
	(SELECT
	t.txn_id,
    0 as notification_id,
    t.txn_datetime as notification_datetime,
	CASE 
	WHEN tt.lcl_intnl = 'International'
		THEN
			CASE 
			WHEN tt.debit_credit = 'Debit'
				THEN CONCAT('International Transaction Alert!! Amount: $', t.txn_amt, ' is debited from your card')
			WHEN tt.debit_credit = 'Credit'
				THEN CONCAT('International Transaction Alert!! Amount: $', t.txn_amt, ' is credited to your card')
			END
	WHEN tt.lcl_intnl = 'Local'
		THEN
			CASE 
			WHEN tt.debit_credit = 'Debit'
				THEN CONCAT('Amount: $', t.txn_amt, ' is debited from your card')
			WHEN tt.debit_credit = 'Credit'
				THEN CONCAT('Amount: $', t.txn_amt, ' is credited to your card')
			END
	END AS notification,
	CASE
		WHEN tt.lcl_intnl = 'International'
			THEN 1
		WHEN tt.lcl_intnl = 'Local'
			THEN 0
	END as alert_flag
	FROM ccms.transaction t
	INNER JOIN ccms.transaction_type tt 
		ON tt.txn_type_id = t.txn_type_id);
end $$
delimiter ;

delimiter $$
CREATE PROCEDURE update_rewards()
BEGIN
	INSERT INTO ccms.rewards
	(SELECT
	t.txn_id,
	ROUND(t.txn_amt, 0) AS reward_points
	FROM ccms.transaction t);
end $$
delimiter ;