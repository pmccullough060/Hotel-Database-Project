/* Add a hotel room */
START TRANSACTION;

   SET @hotel_id = 2;
   SET @roomtype_id = 2;
   SET @singlebed = 1;
   SET @doublebed = 2;
   SET @wifi = 1;
   SET @parking = 2;
   SET @image_guid_1 = 'eda1c6f23b154b2b9e82764c8ad0ce49';
   SET @image_guid_2 = '15044db7c324459ca4e6ce0c9132842f';

   /* adding a room record to the room table */
   INSERT INTO room (hotel_id, roomtype_id) 
   VALUES (@hotel_id, @roomtype_id);

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

/* For a given hotel_id get a table of the beds, their type and the room_id */
/* Add an allocation thingy - for the rooms that are suitable we check the booking situation  */

SELECT room.room_id AS 'Room ID', bed.type, bed.no_person, roomtype.type
FROM roombed
INNER JOIN bed ON roombed.bed_id = bed.bed_id
INNER JOIN room ON roombed.room_id = room.room_id
INNER JOIN roomtype ON roomtype.roomtype_id = room.roomtype_id
WHERE room.hotel_id = 2;

/* Now we know what rooms are of interest  */
/* we can look at the booking table with these room ids and see what is available, then present that to the user */

SELECT room_id 
FROM booking 
INNER JOIN roombooking 
ON booking.booking_id = roombooking.booking_id 
WHERE hotel_id = uHotel_Id 
AND uDate_In < date_out 
AND date_in < uDate_Out);
