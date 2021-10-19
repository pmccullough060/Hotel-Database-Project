/* Create a new hotel room*/

START TRANSACTION;

   SET @hotel_id = 1;
   SET @roomtype_id = 2;
   SET @singlebed = 1;
   SET @doublebed = 2;
   SET @wifi = 1;
   SET @parking = 2;

   /* adding a room record to the room table */

   INSERT INTO room (hotel_id, roomtype_id) 
   VALUES (@hotel_id, @roomtype_id);

   SET @last_id_in_room = LAST_INSERT_ID();

   /* add two beds to the room */

   INSERT INTO roombed (room_id, bed_id)
   VALUES (@last_id_in_room, @singlebed)
          (@last_id_in_room, @doublebed);

   /* add two room ammenities */

   INSERT INTO roomamenity (room_id, amenity_id)
   VALUES (@last_id_in_room, @wifi)
          (@last_id_in_room, @parking);

   /* Add two breakfast options*/
   INSERT INTO breakfast (available, about, price_per_guest, room_id)
   VALUES (true, 'full english', 20.00, @last_id_in_room )
          (false, @last_id_in_room );

   /* add two cancellation options */
   INSERT INTO cancellationpolicy (permitted, timebeforecheckin, room_id)
   VALUES (true, 40.00, '24:00:00', @last_id_in_room )
          (false, @last_id_in_room );

COMMIT;