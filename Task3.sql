--начало транзакции
begin;
--выполнение основной логики
do $$
--декларирем переменные
declare
_book_ref char(6) := '0u08ux';
_book_date timestamp := '2024-07-05 00:12:00+00';
_total_amount numeric(10,2) := 50000.00;
_ticket_no char(13) := '1234346891230';
_passenger_id varchar(20) := '0000 000000';
_passenger_name text := 'Ivan Ivanov';
_contact_date jsonb := '{"phone": "+79999999999"}';
_flight_id int := 187662;
_fare_conditions varchar(10) := 'Economy';
_amount numeric(10,2) := 6200.00;
begin

--добавление нового бронирования
INSERT INTO bookings.bookings(
	book_ref, book_date, total_amount)
	VALUES (_book_ref, _book_date, _total_amount);

--добавление нового билета 	
INSERT INTO bookings.tickets(
	ticket_no, book_ref, passenger_id, passenger_name, contact_data)
	VALUES (_ticket_no, _book_ref, _passenger_id, _passenger_name, _contact_date);

--привязка билета к перелету
INSERT INTO bookings.ticket_flights(
	ticket_no, flight_id, fare_conditions, amount)
	VALUES (_ticket_no, _flight_id, _fare_conditions, _amount);
	
end;
$$;
commit;