/* find hotel ids for a given city 
first we get a list of hotels, and the basic information required for sorting 
in turn we then check availability, we do this first for the most likely hotel room to be choosen */

SET @city_id = 1;

SELECT hotel.hotel_id AS 'Hotel Id', 
	    hotel.featured AS 'Is Featured', 
       hotel.user_rating AS 'User Rating',
       hotelrating.rating AS 'Hotel Star Rating'

FROM hotel 
INNER JOIN hotelrating ON hotel.star_rating = hotelrating.hotelrating_id
WHERE hotel.city_id = @city_id;

/* For a given hotel_id get a table of the beds, their type and the room_id 
we are checking to see if the hotel has rooms that are suitable for the booking*/

SET @hotel_id = 2;

SELECT room.room_id AS 'Room Id', 
       bed.type AS 'Bed Type', 
       bed.no_person AS 'No Person',
       bed.child_only AS 'Child Only'
FROM roombed
INNER JOIN bed ON roombed.bed_id = bed.bed_id
INNER JOIN room ON roombed.room_id = room.room_id
WHERE room.hotel_id = @hotel_id;

/* once we know the room ids that are suitable we check their availability */

SET @room_id = 10;
SET @date_in = '2021-11-17';
SET @date_out = '2021-11-19';

SET @rooms_booked = (SELECT COUNT(*)
   						FROM booking 
   						INNER JOIN roombooking 
   						ON booking.booking_id = roombooking.booking_id 
   						WHERE room_id = @room_id 
   						AND @date_in <= date_out 
   						AND date_in < @date_out);
    
SET @room_allocation = (SELECT room.allocation 
                        FROM room 
                        WHERE room.room_id = @room_id);
    
SET @rooms_available = @room_allocation - @rooms_booked;
    
SELECT @rooms_available AS 'Rooms available';

/* if the rooms are available we get the pricing info */

SET @room_id = 10;
SET @date_in = '2021-12-25';
SET @date_out = '2021-12-26';

SET @price = (SELECT SUM(price.price) 
			     FROM price 
			     WHERE price.room_id = @room_id
		        AND @date_in <= price.date
			     AND price.date < @date_out);
         
SELECT @price AS "total cost of booking";

/* performing this action for each hotel, then of the appropriate hotels return them ordered correctly.

/* nows lets get all the data to display the first x number of hotels to the user */