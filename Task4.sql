--начало транзакции
begin;
--выполнение основной логики
do $$
--декларирем переменные
declare
_ticket_no char(13) := '0005432604860';
_passenger_id varchar(20) := '6959 393082';
_flight_id int := 139218;
_boarding_no int := 1;
_seat_no varchar(4) := '1C';

begin
--проверка существования рейса
select flight_id into _flight_id 
from bookings.flights
where flight_id = _flight_id and status = 'On Time';

if _flight_id is null then
	raise exception 'Рейс не существует';
end if;

--проверка билета у пассажира на рейс
select tf.flight_id into _flight_id from bookings.ticket_flights tf
join bookings.tickets tic
on tf.ticket_no = tic.ticket_no
where tf.flight_id = _flight_id 
and tf.ticket_no = _ticket_no 
and tic.passenger_id = _passenger_id;

if _flight_id is null then
	raise exception 'Ошибка проверки билета у пассажира на рейс';
end if;

--создание нового посадочного талона
INSERT INTO bookings.boarding_passes(
	ticket_no, flight_id, boarding_no, seat_no)
	VALUES (_ticket_no, _flight_id, _boarding_no, _seat_no);

exception 
	when others then
	--выводим сообщение об ошибке
	raise notice 'Transaction failed: %', SQLERRM;
	--прерываем выполнение блока SQL
	return;

end;
$$;
commit;

