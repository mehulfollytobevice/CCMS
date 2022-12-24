delimiter $$
CREATE PROCEDURE get_city_customers_txns(
	IN city_name VARCHAR(30)
)
BEGIN
	SELECT 
	cu.city,
    cu.first_name,
    cu.last_name,
    cu.email,
    SUM(t.txn_amt) AS total_txn_amt,
    COUNT(t.txn_id) AS total_txn_num
	FROM customer cu
	INNER JOIN card c
		on c.cust_id = cu.cust_id
	INNER JOIN ccms.transaction t
		ON c.card_num = t.card_num
	INNER JOIN ccms.transaction_type tt
		ON tt.txn_type_id = t.txn_type_id
	WHERE tt.debit_credit = 'Debit'
    AND cu.city = city_name
    GROUP BY cu.city, cu.first_name, cu.last_name, cu.email;
END $$
delimiter ;

delimiter $$
CREATE PROCEDURE get_merchant_txns(
	IN merchant_name VARCHAR(30)
)
BEGIN
	SELECT 
	m.merchant,
    SUM(t.txn_amt) AS total_txn_amt,
    COUNT(t.txn_id) AS total_txn_num
	FROM merchant m
	INNER JOIN merchant_type mt
		on mt.merchant_type_id = m.merchant_type_id
	INNER JOIN ccms.transaction t
		ON m.merchant_id = t.merchant_id
	INNER JOIN ccms.transaction_type tt
		ON tt.txn_type_id = t.txn_type_id
	WHERE tt.debit_credit = 'Debit'
    AND m.merchant = merchant_name
    GROUP BY m.merchant;
END $$
delimiter ;

call get_city_customers_txns('Manchester');
call get_merchant_txns('Costco');