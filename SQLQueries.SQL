/* Add a hotel room */
START TRANSACTION;

   SET @hotel_id = 2;
   SET @roomtype_id = 2;
   SET @room_allocation = 5;
   SET @singlebed = 1;
   SET @doublebed = 2;
   SET @wifi = 1;
   SET @parking = 2;
   SET @image_guid_1 = 'eda1c6f23b154b2b9e82764c8ad0ce49';
   SET @image_guid_2 = '15044db7c324459ca4e6ce0c9132842f';

   /* adding a room record to the room table */
   INSERT INTO room (hotel_id, roomtype_id, allocation) 
   VALUES (@hotel_id, @roomtype_id, @room_allocation);

   SET @last_id_in_room = LAST_INSERT_ID();

   /* add two beds to the room */
   INSERT INTO roombed (room_id, bed_id)
   VALUES (@last_id_in_room, @singlebed),
          (@last_id_in_room, @doublebed);

   /* add two room ammenities */
   INSERT INTO roomamenity (room_id, amenity_id)
   VALUES (@last_id_in_room, @wifi),
          (@last_id_in_room, @parking);

   /* Add two breakfast options*/
   INSERT INTO breakfast (available, about, price_per_guest, room_id)
   VALUES (true, 'full english', 20.00, @last_id_in_room );

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

/* find hotels in a given city or country /*

/* Get the average rating for a given hotel /*



/* For a given hotel_id get a table of the beds, their type and the room_id */
/* Add an allocation thingy - for the rooms that are suitable we check the booking situation  */

SELECT room.room_id AS 'Room ID', bed.type, bed.no_person, roomtype.type, room.allocationS
FROM roombed
INNER JOIN bed ON roombed.bed_id = bed.bed_id
INNER JOIN room ON roombed.room_id = room.room_id
INNER JOIN roomtype ON roomtype.roomtype_id = room.roomtype_id
WHERE room.hotel_id = 2;

/* Once we can identify which rooms are potentially suitable we can find out how many are booked for those dates */
/* remember we know the room allocation and the date of the booking that lets us work out what rooms are available */
/* this will be a stored procedure that will be called during the booking transaction */

SET @room_id = 1;
SET @date_in = '2020-01-01';
SET @date_out = '2020-01-03';

SET @rooms_booked = (SELECT COUNT(*)
   						FROM booking 
   						INNER JOIN roombooking 
   						ON booking.booking_id = roombooking.booking_id 
   						WHERE room_id = @room_id 
   						AND @date_in < date_out 
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
   						AND @date_in < date_out 
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
   						AND @date_in < date_out 
   						AND date_in < @date_out);
    
SET @room_allocation = (SELECT room.allocation 
                        FROM room 
                        WHERE room.room_id = @room_id);
    
SET @rooms_available = @room_allocation - @rooms_booked;
    
SELECT IF(@rooms_available < @rooms_required, 'ERROR: Rooms not available', 'Rooms available for booking');

/* calling the stored procedure */


