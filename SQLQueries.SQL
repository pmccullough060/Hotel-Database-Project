/* Add a hotel room */
START TRANSACTION;

   SET @hotel_id = 7;
   SET @roomtype_id = 2;
   SET @room_allocation = 10;
   SET @singlebed = 1;
   SET @doublebed = 2;
   SET @wifi = 1;
   SET @parking = 2;
   SET @image_guid_1 = '2fbc09d8053a49f9a5d49c59cdc263bd';
   SET @image_guid_2 = 'c48f0690ba414571a3c81d11d9ba81f3';

   /* adding a room record to the room table */
   INSERT INTO room (hotel_id, roomtype_id, allocation) 
   VALUES (@hotel_id, @roomtype_id, @room_allocation);

   SET @last_id_in_room = LAST_INSERT_ID();

   /* add two beds to the room */
   INSERT INTO roombed (room_id, bed_id)
   VALUES (@last_id_in_room, @singlebed);

   /* add two room ammenities */
   INSERT INTO roomamenity (room_id, amenity_id)
   VALUES (@last_id_in_room, @wifi),
          (@last_id_in_room, @parking);

   /* Add two breakfast options*/
   INSERT INTO breakfast (available, about, price_per_guest, room_id)
   VALUES (true, 'breakfast', 00.00, @last_id_in_room );

   /* add two cancellation options */
   INSERT INTO cancellationpolicy (permitted, price, timebeforecheckin, room_id)
   VALUES (true, 40.00, '24:00:00', @last_id_in_room );

   /* add guids for two images of the room so they can be retrieved from the CDN*/
   INSERT INTO roomimage (room_id, image_guid)
   VALUES (@last_id_in_room, @image_guid_1),
          (@last_id_in_room, @image_guid_2);

COMMIT;

/* remove a hotel room*/

START TRANSACTION;

   set @room_id = 5;

   DELETE FROM roomimage WHERE room_id = @room_id;
   DELETE FROM cancellationpolicy WHERE room_id = @room_id;
   DELETE FROM breakfast WHERE room_id = @room_id;
   DELETE FROM roomamenity WHERE room_id = @room_id;
   DELETE FROM roombed WHERE room_id = @room_id;
   DELETE FROM room WHERE room_id = @room_id;

COMMIT;

/* Adding a new Hotel */

/* Add a hotel */
START TRANSACTION;

   SET @hotel_name = 'The Maldron Hotel';
   SET @city_id = 4;
   SET @wifi = 3;
   SET @parking = 2;
   SET @address = 'Parnell Square West, Rotunda, Dublin';
   SET @postcode = 'D01 HX02';
   SET @image_guid_1 = 'f648d3031ba64f74b209029a62720510';
   SET @image_guid_2 = '23e53d7f9f3b4707ac606c27fb8686a4';

   /* adding a room record to the room table */
   INSERT INTO hotel (hotel_name, city_id, address, postcode) 
   VALUES (@hotel_name, @city_id, @address, @postcode);

   SET @last_id_in_hotel = LAST_INSERT_ID();

   /* add two room ammenities */
   INSERT INTO hotelamenityhotel (hotel_id, amenityhotel_id)
   VALUES (@last_id_in_hotel, @wifi),
          (@last_id_in_hotel, @parking)
          (@last_id_in_hotel, 1);

   /* add guids for two images of the room so they can be retrieved from the CDN*/
   INSERT INTO hotelimage (hotel_id, guid)
   VALUES (@last_id_in_hotel, @image_guid_1),
          (@last_id_in_hotel, @image_guid_2);

COMMIT;

/* Adding a review */

/* login a user */

SET @username = 'billybob';
SET @email = 'billybobgmail.com';

SELECT user.user_password AS 'Password hash'
FROM user
WHERE user.user_email LIKE 'billybob@gmail.com';

/* find hotels in a given city or country */

SELECT hotel.hotel_id, hotel_name, amenityhotel.type 
FROM hotel 
INNER JOIN hotelamenityhotel ON hotel.hotel_id = hotelamenityhotel.hotel_id
INNER JOIN amenityhotel ON hotelamenityhotel.amenityhotel_id = amenityhotel.amenityhotel_id
WHERE hotel.city_id = 2;

/* Get the average rating for a given hotel /*



/* Get the amenties for a hotel */

SELECT hotel.hotel_id, hotel_name, amenityhotel.type 
FROM hotel 
INNER JOIN hotelamenityhotel ON hotel.hotel_id = hotelamenityhotel.hotel_id
INNER JOIN amenityhotel ON hotelamenityhotel.amenityhotel_id = amenityhotel.amenityhotel_id
WHERE hotel.hotel_id = 3;

/*find hotel based on an area and ammenities */

SELECT hotel.hotel_id, hotel_name, amenityhotel.type 
FROM hotel 
INNER JOIN hotelamenityhotel ON hotel.hotel_id = hotelamenityhotel.hotel_id
INNER JOIN amenityhotel ON hotelamenityhotel.amenityhotel_id = amenityhotel.amenityhotel_id
WHERE hotel.city_id = 2
AND amenityhotel.amenityhotel_id = 2;

/* For a given hotel_id get a table of the beds, their type and the room_id */

SELECT room.room_id AS 'Room ID', bed.type, bed.no_person, roomtype.type, room.allocationS
FROM roombed
INNER JOIN bed ON roombed.bed_id = bed.bed_id
INNER JOIN room ON roombed.room_id = room.room_id
INNER JOIN roomtype ON roomtype.roomtype_id = room.roomtype_id
WHERE room.hotel_id = 2;

/* Once we can identify which rooms are potentially suitable we can find out how many are booked for those dates */
/* remember we know the room allocation and the date of the booking that lets us work out what rooms are available */
/* this will be a stored procedure that will be called during the booking transaction */
/* the day in is the night you stay. */

SET @room_id = 1;
SET @date_in = '2020-01-01';
SET @date_out = '2020-01-03';

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

/* Getting the availability for a given set of dates and a room_id using the stored procedure in phpmyadmin*/

SET @rooms_available = 0;
CALL RoomsAvailable(1, '2020-01-01', '2020-01-03', @rooms_available);
SELECT @rooms_available as 'rooms available';

/* Get the breakfast options */

SELECT breakfast.room_id, breakfast.price_per_guest, breakfast.about, breakfast.available
FROM room
INNER JOIN breakfast ON room.room_id = breakfast.room_id
WHERE room.room_id = 10;

/* Get the cancellation options */

/* Get the room price for the booking */
/* remember pricing is inclusive of the checkin date and exclusive of the checkout date */

SET @room_id = 10;
SET @date_in = '2021-11-10';
SET @date_out = '2021-11-13';

SET @price = (SELECT SUM(price.price) 
			     FROM price 
			     WHERE price.room_id = @room_id
		        AND @date_in <= price.date
			     AND price.date < @date_out);
         
SELECT @price AS "total cost of booking";

/* now its time to create a room booking - this is performed within a transaction */
/* Checking to make sure that each room is available for booking before we add to the booking table */

SET @room_id = 1;
SET @date_in = '2020-01-01';
SET @date_out = '2020-01-03';
SET @rooms_required = 2;

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
    
IF(@rooms_available <= @rooms_required) 
	THEN
	SELECT 'ERROR: Rooms not available';
ELSE
	SELECT 'Rooms available for booking';
END IF;

SET @room_id = 1;
SET @date_in = '2020-01-01';
SET @date_out = '2020-01-03';
SET @rooms_required = 1;

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
    
SELECT IF(@rooms_available < @rooms_required, 'ERROR: Rooms not available', 'Rooms available for booking');

/* calling the stored procedure */


