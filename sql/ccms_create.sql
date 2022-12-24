-- DROP DATABASE IF EXISTS ccms;
CREATE DATABASE ccms;

-- DROP TABLE ccms.customer;
CREATE TABLE ccms.customer
	(
    cust_id CHAR(6),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone CHAR(12),
    address VARCHAR(120),
    city VARCHAR(30),
    state VARCHAR(30),
    zip VARCHAR(6),
    PRIMARY KEY (cust_id)
    );
    
-- DROP TABLE ccms.netbanking;
CREATE TABLE ccms.netbanking
	(
    cust_id CHAR(6) NOT NULL,
    username VARCHAR(30),
    password VARCHAR(40) NOT NULL,
    password_exp_date DATE NOT NULL,
    security_ques VARCHAR(100),
    security_ans VARCHAR(50),
    PRIMARY KEY (username),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

-- DROP TABLE ccms.card_type;
CREATE TABLE ccms.card_type
	(
    card_type_id CHAR(4), 
    card_type VARCHAR(10) NOT NULL, 
    card_network VARCHAR(12) NOT NULL, 
    privilege VARCHAR(50),
    PRIMARY KEY (card_type_id),
    CHECK (card_type IN ('Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond')),
    CHECK (card_network IN ('MasterCard', 'VISA'))
	);

-- DROP TABLE ccms.card;
CREATE TABLE ccms.card
	(
    cust_id CHAR(6) NOT NULL,
    card_num CHAR(16),
    valid_from DATE NOT NULL,
    valid_thru DATE NOT NULL,
    security_code CHAR(3) NOT NULL,
    card_type_id CHAR(4) NOT NULL, 
    PRIMARY KEY (card_num),
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (card_type_id) REFERENCES card_type(card_type_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	);

-- DROP TABLE ccms.card_limit;
CREATE TABLE ccms.card_limit
	(
    card_num CHAR(16),
    total_limit NUMERIC(8,2),
    available_limit NUMERIC(8,2),
    PRIMARY KEY (card_num),
    FOREIGN KEY (card_num) REFERENCES card(card_num)
		ON DELETE CASCADE
		ON UPDATE CASCADE
    );

-- DROP TABLE ccms.card_statement;
CREATE TABLE ccms.card_statement
	(
    statement_id INT AUTO_INCREMENT,
    card_num CHAR(16) NOT NULL,
    amt_due NUMERIC(8,2),
    statement_start_date DATE,
    statement_end_date DATE,
    due_date DATE,
    PRIMARY KEY (statement_id),
    FOREIGN KEY (card_num) REFERENCES card(card_num)
		ON DELETE CASCADE
		ON UPDATE CASCADE
    );

-- DROP TABLE ccms.transaction_type;
CREATE TABLE ccms.transaction_type
	(
    txn_type_id CHAR(4),
    debit_credit VARCHAR(6) NOT NULL,
    lcl_intnl VARCHAR(13) NOT NULL,
    PRIMARY KEY (txn_type_id),
    CHECK (debit_credit IN ('Credit', 'Debit')),
    CHECK (lcl_intnl IN ('Local', 'International'))
    );

-- DROP TABLE ccms.transaction_terminal;
CREATE TABLE ccms.transaction_terminal
	(
    terminal_id CHAR(4),
    x_terminal NUMERIC(8,4) NOT NULL,
    y_terminal NUMERIC(8,4) NOT NULL,
    PRIMARY KEY (terminal_id)
    );

-- DROP TABLE ccms.merchant_type;
CREATE TABLE ccms.merchant_type
	(
    merchant_type_id CHAR(2),
    merchant_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (merchant_type_id)
    );

-- DROP TABLE ccms.merchant;
CREATE TABLE ccms.merchant
	(
    merchant_id CHAR(4),
    merchant VARCHAR(30) NOT NULL,
    merchant_type_id CHAR(2) NOT NULL,
    PRIMARY KEY (merchant_id),
    FOREIGN KEY (merchant_type_id) REFERENCES merchant_type(merchant_type_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
    );

-- DROP TABLE ccms.transaction;
CREATE TABLE ccms.transaction
	(
    card_num CHAR(16) NOT NULL,
    txn_id CHAR(33),
    txn_datetime DATETIME NOT NULL,
    txn_amt NUMERIC(8,2),
    txn_type_id CHAR(4) NOT NULL,
    terminal_id CHAR(4) NOT NULL,
    merchant_id CHAR(4) NOT NULL,
    PRIMARY KEY (txn_id),
    FOREIGN KEY (card_num) REFERENCES card(card_num)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (txn_type_id) REFERENCES transaction_type(txn_type_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (terminal_id) REFERENCES transaction_terminal(terminal_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (merchant_id) REFERENCES merchant(merchant_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
    );

-- DROP TABLE ccms.notification;
CREATE TABLE ccms.notification
	(
    txn_id CHAR(33) NOT NULL,
    notification_id INT NOT NULL AUTO_INCREMENT,
    notification_datetime DATETIME NOT NULL,
    notification VARCHAR(120),
    alert_flag INT,
    PRIMARY KEY (notification_id),
    FOREIGN KEY (txn_id) REFERENCES transaction(txn_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CHECK (alert_flag IN (0, 1))
	) AUTO_INCREMENT = 1000000000;

-- DROP TABLE ccms.rewards;
CREATE TABLE ccms.rewards
	(
    txn_id CHAR(33),
    reward_points NUMERIC(4,0),
    PRIMARY KEY (txn_id),
    FOREIGN KEY (txn_id) REFERENCES transaction(txn_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	);