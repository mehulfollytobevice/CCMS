CREATE VIEW merchant_transactions AS
	SELECT
		RANK() OVER (ORDER BY count(t.txn_id) DESC) AS rank_by_num_txn,
		RANK() OVER (ORDER BY sum(t.txn_amt) DESC) AS rank_by_txn_amt,
		mt.merchant_type,
		m.merchant,
		count(t.txn_id) as num_transactions,
		sum(t.txn_amt) as total_txn_amt
	FROM ccms.merchant m
	INNER JOIN ccms.transaction t
		ON t.merchant_id = m.merchant_id
	INNER JOIN ccms.transaction_type tt
		ON tt.txn_type_id = t.txn_type_id
	INNER JOIN ccms.merchant_type mt
		ON mt.merchant_type_id = m.merchant_type_id
	WHERE tt.debit_credit = 'Debit'
	GROUP BY mt.merchant_type, m.merchant;

CREATE VIEW customer_transactions AS
	SELECT
		RANK() OVER (ORDER BY count(t.txn_id) DESC) AS rank_by_num_txn,
		RANK() OVER (ORDER BY sum(t.txn_amt) DESC) AS rank_by_txn_amt,
		cu.first_name,
		cu.last_name,
		cu.email,
		count(t.txn_id) as num_transactions,
		sum(t.txn_amt) as total_txn_amt
	FROM ccms.customer cu
	INNER JOIN ccms.card c
		ON c.cust_id = cu.cust_id
	INNER JOIN ccms.transaction t
		ON c.card_num = t.card_num
	INNER JOIN ccms.transaction_type tt
		ON tt.txn_type_id = t.txn_type_id
	WHERE tt.debit_credit = 'Debit'
	GROUP BY cu.first_name, cu.last_name, cu.email;

CREATE VIEW city_transactions AS
	SELECT
		RANK() OVER (ORDER BY count(t.txn_id) DESC) AS rank_by_num_txn,
		RANK() OVER (ORDER BY sum(t.txn_amt) DESC) AS rank_by_txn_amt,
		cu.city,
		count(t.txn_id) as num_transactions,
		sum(t.txn_amt) as total_txn_amt
	FROM ccms.customer cu
	INNER JOIN ccms.card c
		ON c.cust_id = cu.cust_id
	INNER JOIN ccms.transaction t
		ON c.card_num = t.card_num
	INNER JOIN ccms.transaction_type tt
		ON tt.txn_type_id = t.txn_type_id
	WHERE tt.debit_credit = 'Debit'
	GROUP BY cu.city;

CREATE VIEW transactions_time_series AS
	SELECT
		RANK() OVER (ORDER BY count(t.txn_id) DESC) AS rank_by_num_txn,
		RANK() OVER (ORDER BY sum(t.txn_amt) DESC) AS rank_by_txn_amt,
		DATE(t.txn_datetime) as txn_date,
		count(t.txn_id) as num_transactions,
		sum(t.txn_amt) as total_txn_amt
	FROM ccms.transaction t
	INNER JOIN ccms.transaction_type tt
		ON tt.txn_type_id = t.txn_type_id
	WHERE tt.debit_credit = 'Debit'
	GROUP BY DATE(t.txn_datetime)
    ORDER BY DATE(t.txn_datetime) DESC;