delimiter $$
create function get_active_customers_for_range(
	start_date date, 
    end_date date
)
returns int
deterministic
begin
	declare active_customers_count int;

	select 
	count(distinct c.cust_id) into active_customers_count
	from ccms.card c
	inner join ccms.transaction t
		on c.card_num = t.card_num
	where t.txn_datetime >= start_date
	and t.txn_datetime <= end_date
	and t.txn_amt != 0;
    
    return active_customers_count;
end $$
delimiter ;

delimiter $$
create function get_active_customers_in_city(
	city_name VARCHAR(30)
)
returns int
deterministic
begin
	declare active_customers_count int;

	select 
	count(distinct c.cust_id) into active_customers_count
    from ccms.card c
	inner join ccms.transaction t
		on c.card_num = t.card_num
	inner join ccms.customer cu
		on c.cust_id = cu.cust_id
	where t.txn_amt != 0
    and cu.city = city_name;
    
    return active_customers_count;
end $$
delimiter ;

delimiter $$
create function get_active_customers_for_card_type(
	card_type_name VARCHAR(10)
)
returns int
deterministic
begin
	declare active_customers_count int;

	select 
	count(distinct c.cust_id) into active_customers_count
    from ccms.card c
	inner join ccms.transaction t
		on c.card_num = t.card_num
	inner join ccms.card_type ct
		on c.card_type_id = ct.card_type_id
	where t.txn_amt != 0
    and ct.card_type = card_type_name;
    
    return active_customers_count;
end $$
delimiter ;

select get_active_customers_for_range('2022-07-01', '2022-07-30');
select get_active_customers_in_city('Manchester');
select get_active_customers_for_card_type('Gold');