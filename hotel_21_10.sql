-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 21, 2021 at 11:28 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hotel`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AvailableRoom` (IN `uHotel_Id` INT, IN `uBeds` INT, IN `uDate_In` DATE, IN `udate_Out` DATE)  BEGIN
	SELECT room.room_id FROM room WHERE room.beds >= uBeds AND room.room_id NOT IN (
	SELECT room_id 
	FROM booking 
	INNER JOIN roombooking 
	ON booking.booking_id = roombooking.booking_id 
	WHERE hotel_id = uHotel_Id 
   	AND uDate_In < date_out 
	AND  date_in < uDate_Out);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GuestsInBooking` (IN `uBookingId` INT)  BEGIN
	SELECT * FROM guest WHERE guest.booking_id = uBookingId;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `amenity`
--

CREATE TABLE `amenity` (
  `amenity_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `amenity`
--

INSERT INTO `amenity` (`amenity_id`, `type`) VALUES
(1, 'wifi'),
(2, 'parking'),
(3, 'ensuite');

-- --------------------------------------------------------

--
-- Table structure for table `bed`
--

CREATE TABLE `bed` (
  `bed_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `no_person` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bed`
--

INSERT INTO `bed` (`bed_id`, `type`, `no_person`) VALUES
(1, 'single', 1),
(2, 'queen double', 2),
(3, 'king double', 2),
(4, 'sofa bed', 1);

-- --------------------------------------------------------

--
-- Table structure for table `booker`
--

CREATE TABLE `booker` (
  `booker_id` int(11) NOT NULL,
  `booker_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `booker`
--

INSERT INTO `booker` (`booker_id`, `booker_name`) VALUES
(1, 'peter mccullough');

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `booking_id` int(11) NOT NULL,
  `date_in` date NOT NULL,
  `date_out` date NOT NULL,
  `booker_id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `Price` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`booking_id`, `date_in`, `date_out`, `booker_id`, `hotel_id`, `Price`) VALUES
(1, '2020-01-01', '2020-01-05', 1, 1, '2');

-- --------------------------------------------------------

--
-- Table structure for table `breakfast`
--

CREATE TABLE `breakfast` (
  `breakfast_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `price_per_guest` decimal(10,0) NOT NULL,
  `about` varchar(255) NOT NULL,
  `available` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `breakfast`
--

INSERT INTO `breakfast` (`breakfast_id`, `room_id`, `price_per_guest`, `about`, `available`) VALUES
(8, 10, '20', 'full english', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cancellationpolicy`
--

CREATE TABLE `cancellationpolicy` (
  `cancellationpolicy_id` int(11) NOT NULL,
  `permitted` tinyint(1) NOT NULL,
  `timebeforecheckin` time DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cancellationpolicy`
--

INSERT INTO `cancellationpolicy` (`cancellationpolicy_id`, `permitted`, `timebeforecheckin`, `price`, `room_id`) VALUES
(1, 1, '24:00:00', '0', 1),
(2, 0, NULL, NULL, 2),
(5, 1, '24:00:00', '40', 10);

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

CREATE TABLE `guest` (
  `guest_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `booking_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`guest_id`, `name`, `date_of_birth`, `booking_id`) VALUES
(1, 'peter mccullough', '1992-01-01', 1),
(2, 'alfred hitchcock', '1990-01-01', 1);

-- --------------------------------------------------------

--
-- Table structure for table `hotel`
--

CREATE TABLE `hotel` (
  `hotel_id` int(11) NOT NULL,
  `hotel_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hotel`
--

INSERT INTO `hotel` (`hotel_id`, `hotel_name`) VALUES
(1, 'Lansdowne'),
(2, 'Merchant');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `roomtype_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room_id`, `hotel_id`, `roomtype_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(10, 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `roomamenity`
--

CREATE TABLE `roomamenity` (
  `room_id` int(11) NOT NULL,
  `amenity_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roomamenity`
--

INSERT INTO `roomamenity` (`room_id`, `amenity_id`) VALUES
(10, 1),
(10, 2);

-- --------------------------------------------------------

--
-- Table structure for table `roombed`
--

CREATE TABLE `roombed` (
  `room_id` int(11) NOT NULL,
  `bed_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roombed`
--

INSERT INTO `roombed` (`room_id`, `bed_id`) VALUES
(1, 2),
(10, 1),
(10, 2);

-- --------------------------------------------------------

--
-- Table structure for table `roombooking`
--

CREATE TABLE `roombooking` (
  `roombooking_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roombooking`
--

INSERT INTO `roombooking` (`roombooking_id`, `booking_id`, `room_id`) VALUES
(1, 1, 1),
(2, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `roomimage`
--

CREATE TABLE `roomimage` (
  `roomimage_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `image_guid` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roomimage`
--

INSERT INTO `roomimage` (`roomimage_id`, `room_id`, `image_guid`) VALUES
(3, 10, 'eda1c6f23b154b2b9e82764c8ad0ce49'),
(4, 10, '15044db7c324459ca4e6ce0c9132842f');

-- --------------------------------------------------------

--
-- Table structure for table `roomtype`
--

CREATE TABLE `roomtype` (
  `roomtype_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roomtype`
--

INSERT INTO `roomtype` (`roomtype_id`, `type`) VALUES
(1, 'standard'),
(2, 'executive'),
(3, 'luxury');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `amenity`
--
ALTER TABLE `amenity`
  ADD PRIMARY KEY (`amenity_id`);

--
-- Indexes for table `bed`
--
ALTER TABLE `bed`
  ADD PRIMARY KEY (`bed_id`);

--
-- Indexes for table `booker`
--
ALTER TABLE `booker`
  ADD PRIMARY KEY (`booker_id`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `FK_Booking_Booker_Id` (`booker_id`),
  ADD KEY `FK_Booking_Hotel_Id` (`hotel_id`);

--
-- Indexes for table `breakfast`
--
ALTER TABLE `breakfast`
  ADD PRIMARY KEY (`breakfast_id`),
  ADD KEY `FK_Breakfast_Room_Id` (`room_id`);

--
-- Indexes for table `cancellationpolicy`
--
ALTER TABLE `cancellationpolicy`
  ADD PRIMARY KEY (`cancellationpolicy_id`),
  ADD KEY `FK_CancellationPolicy_Room_Id` (`room_id`);

--
-- Indexes for table `guest`
--
ALTER TABLE `guest`
  ADD PRIMARY KEY (`guest_id`),
  ADD KEY `FK_Guest_Booking_Id` (`booking_id`);

--
-- Indexes for table `hotel`
--
ALTER TABLE `hotel`
  ADD PRIMARY KEY (`hotel_id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room_id`),
  ADD KEY `FK_Room_Hotel_Id` (`hotel_id`),
  ADD KEY `FK_Room_RoomType_Id` (`roomtype_id`);

--
-- Indexes for table `roomamenity`
--
ALTER TABLE `roomamenity`
  ADD PRIMARY KEY (`room_id`,`amenity_id`),
  ADD KEY `FK_RoomAmenity_Amenity_Id` (`amenity_id`);

--
-- Indexes for table `roombed`
--
ALTER TABLE `roombed`
  ADD PRIMARY KEY (`room_id`,`bed_id`),
  ADD KEY `FK_RoomBed_Bed_Id` (`bed_id`);

--
-- Indexes for table `roombooking`
--
ALTER TABLE `roombooking`
  ADD PRIMARY KEY (`roombooking_id`),
  ADD KEY `FK_RoomBooking_Room_Id` (`room_id`),
  ADD KEY `FK_RoomBooking_Boooking_Id` (`booking_id`);

--
-- Indexes for table `roomimage`
--
ALTER TABLE `roomimage`
  ADD PRIMARY KEY (`roomimage_id`),
  ADD KEY `FK_RoomImage_Room_Id` (`room_id`);

--
-- Indexes for table `roomtype`
--
ALTER TABLE `roomtype`
  ADD PRIMARY KEY (`roomtype_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `amenity`
--
ALTER TABLE `amenity`
  MODIFY `amenity_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `bed`
--
ALTER TABLE `bed`
  MODIFY `bed_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `booker`
--
ALTER TABLE `booker`
  MODIFY `booker_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `breakfast`
--
ALTER TABLE `breakfast`
  MODIFY `breakfast_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `cancellationpolicy`
--
ALTER TABLE `cancellationpolicy`
  MODIFY `cancellationpolicy_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `guest`
--
ALTER TABLE `guest`
  MODIFY `guest_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hotel`
--
ALTER TABLE `hotel`
  MODIFY `hotel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `roombooking`
--
ALTER TABLE `roombooking`
  MODIFY `roombooking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `roomimage`
--
ALTER TABLE `roomimage`
  MODIFY `roomimage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `roomtype`
--
ALTER TABLE `roomtype`
  MODIFY `roomtype_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `FK_Booking_Booker_Id` FOREIGN KEY (`booker_id`) REFERENCES `booker` (`booker_id`),
  ADD CONSTRAINT `FK_Booking_Hotel_Id` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`Hotel_Id`);

--
-- Constraints for table `breakfast`
--
ALTER TABLE `breakfast`
  ADD CONSTRAINT `FK_Breakfast_Room_Id` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);

--
-- Constraints for table `cancellationpolicy`
--
ALTER TABLE `cancellationpolicy`
  ADD CONSTRAINT `FK_CancellationPolicy_Room_Id` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);

--
-- Constraints for table `guest`
--
ALTER TABLE `guest`
  ADD CONSTRAINT `FK_Guest_Booking_Id` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`);

--
-- Constraints for table `room`
--
ALTER TABLE `room`
  ADD CONSTRAINT `FK_Room_Hotel_Id` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`Hotel_Id`),
  ADD CONSTRAINT `FK_Room_RoomType_Id` FOREIGN KEY (`roomtype_id`) REFERENCES `roomtype` (`roomtype_id`);

--
-- Constraints for table `roomamenity`
--
ALTER TABLE `roomamenity`
  ADD CONSTRAINT `FK_RoomAmenity_Amenity_Id` FOREIGN KEY (`amenity_id`) REFERENCES `amenity` (`amenity_id`),
  ADD CONSTRAINT `FK_RoomAmenity_Room_Id` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);

--
-- Constraints for table `roombed`
--
ALTER TABLE `roombed`
  ADD CONSTRAINT `FK_RoomBed_Bed_Id` FOREIGN KEY (`bed_id`) REFERENCES `bed` (`bed_id`),
  ADD CONSTRAINT `FK_RoomBed_Room_Id` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);

--
-- Constraints for table `roombooking`
--
ALTER TABLE `roombooking`
  ADD CONSTRAINT `FK_RoomBooking_Boooking_Id` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`),
  ADD CONSTRAINT `FK_RoomBooking_Room_Id` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);

--
-- Constraints for table `roomimage`
--
ALTER TABLE `roomimage`
  ADD CONSTRAINT `FK_RoomImage_Room_Id` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
