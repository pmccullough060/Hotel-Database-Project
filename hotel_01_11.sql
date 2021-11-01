-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 01, 2021 at 11:04 PM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `BookingAvailable` (IN `uroom_id` INT, IN `udate_in` DATE, IN `udate_out` DATE, IN `rooms_required` INT)  BEGIN
	SET @rooms_booked = (SELECT COUNT(*)
   						 FROM booking 
   						 INNER JOIN roombooking 
   						 ON booking.booking_id = roombooking.booking_id 
   						 WHERE room_id = uroom_id 
   						 AND udate_in < date_out 
   						 AND date_in < udate_out);
    
    SET @room_allocation = (SELECT room.allocation 
                            FROM room 
                            WHERE room.room_id = uroom_id);
    
    
    SET @rooms_available = @room_allocation - @rooms_booked;
    
IF(@rooms_available < rooms_required) 
	THEN
    SIGNAL SQLSTATE '45000' SET message_text = 'ERROR: Rooms not available';
ELSE
	SELECT 'Rooms available for booking';
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GuestsInBooking` (IN `uBookingId` INT)  BEGIN
	SELECT * FROM guest WHERE guest.booking_id = uBookingId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RoomsAvailable` (IN `uroom_id` INT, IN `udate_in` DATE, IN `udate_out` DATE, OUT `urooms_available` INT)  BEGIN
	SET @rooms_booked = (SELECT COUNT(*)
   						 FROM booking 
   						 INNER JOIN roombooking 
   						 ON booking.booking_id = roombooking.booking_id 
   						 WHERE room_id = uroom_id 
   						 AND udate_in < date_out 
   						 AND date_in < udate_out);
    
    SET @room_allocation = (SELECT room.allocation 
                            FROM room 
                            WHERE room.room_id = uroom_id);
    
    SET urooms_available = @room_allocation - @rooms_booked;
    
    SELECT urooms_available AS 'Rooms available';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RoomsBooked` (IN `uroom_id` INT, IN `udate_in` DATE, IN `udate_out` DATE, OUT `room_booked` INT)  BEGIN
	SET room_booked = (SELECT COUNT(*)
   	FROM booking 
   	INNER JOIN roombooking 
   	ON booking.booking_id = roombooking.booking_id 
   	WHERE room_id = uroom_id 
   	AND udate_in < date_out 
   	AND date_in < udate_out);
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
-- Table structure for table `amenityhotel`
--

CREATE TABLE `amenityhotel` (
  `amenityhotel_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `amenityhotel`
--

INSERT INTO `amenityhotel` (`amenityhotel_id`, `type`) VALUES
(1, 'Pool'),
(2, 'Parking Included'),
(3, 'WiFi included'),
(4, 'Pet friendly');

-- --------------------------------------------------------

--
-- Table structure for table `bed`
--

CREATE TABLE `bed` (
  `bed_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `no_person` int(11) NOT NULL,
  `child_only` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bed`
--

INSERT INTO `bed` (`bed_id`, `type`, `no_person`, `child_only`) VALUES
(1, 'single', 1, 0),
(2, 'queen double', 2, 0),
(3, 'king double', 2, 0),
(4, 'sofa bed', 1, 0),
(5, 'child bed', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `booking_id` int(11) NOT NULL,
  `date_in` date NOT NULL,
  `date_out` date NOT NULL,
  `user_id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `Price` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`booking_id`, `date_in`, `date_out`, `user_id`, `hotel_id`, `Price`) VALUES
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
(8, 10, '20', 'full english', 1),
(9, 11, '20', 'full english', 1),
(10, 13, '20', 'full irish', 1),
(11, 14, '0', 'breakfast', 1),
(12, 15, '0', 'breakfast', 1);

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
(5, 1, '24:00:00', '40', 10),
(6, 1, '24:00:00', '40', 11),
(7, 1, '24:00:00', '40', 13),
(8, 1, '24:00:00', '40', 14),
(9, 1, '24:00:00', '40', 15);

-- --------------------------------------------------------

--
-- Table structure for table `city`
--

CREATE TABLE `city` (
  `city_id` int(11) NOT NULL,
  `country_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `city`
--

INSERT INTO `city` (`city_id`, `country_id`, `name`) VALUES
(1, 1, 'Belfast'),
(2, 1, 'London'),
(3, 1, 'Edinburgh'),
(4, 2, 'Dublin');

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `country_id` int(11) NOT NULL,
  `complete_name` varchar(255) NOT NULL,
  `alpha_3_code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`country_id`, `complete_name`, `alpha_3_code`, `name`) VALUES
(1, 'United Kingdom of Great Britain and Northern Ireland', 'GBR', 'United Kingdom'),
(2, 'Ireland', 'IRL', 'Ireland'),
(3, 'Greece', 'GRC', 'Greece'),
(4, 'France', 'FRA', 'France'),
(5, 'Spain', 'ESP', 'Spain');

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
  `hotel_name` varchar(255) NOT NULL,
  `city_id` int(11) NOT NULL,
  `address` varchar(255) NOT NULL,
  `postcode` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hotel`
--

INSERT INTO `hotel` (`hotel_id`, `hotel_name`, `city_id`, `address`, `postcode`) VALUES
(1, 'Lansdowne', 1, '657 Antrim Rd, Belfast', 'BT15 4EF'),
(2, 'Merchant', 1, '16 Skipper St, Belfast', 'BT1 2DZ'),
(3, 'Park Plaza', 2, 'Westminster, Bridge Road, Lambeth, London', 'SE1 7UT'),
(7, 'The Tower Hotel', 2, 'St Katherines Way, Tower Hamlets, London', 'E1W 1LD'),
(8, 'The Maldron Hotel', 4, 'Parnell Square West, Rotunda, Dublin', 'D01 HX02');

-- --------------------------------------------------------

--
-- Table structure for table `hotelamenityhotel`
--

CREATE TABLE `hotelamenityhotel` (
  `hotel_id` int(11) NOT NULL,
  `amenityhotel_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hotelamenityhotel`
--

INSERT INTO `hotelamenityhotel` (`hotel_id`, `amenityhotel_id`) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 2),
(3, 3),
(3, 4),
(7, 2),
(7, 3),
(8, 1),
(8, 2),
(8, 3);

-- --------------------------------------------------------

--
-- Table structure for table `hotelimage`
--

CREATE TABLE `hotelimage` (
  `hotelimage_id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `guid` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hotelimage`
--

INSERT INTO `hotelimage` (`hotelimage_id`, `hotel_id`, `guid`) VALUES
(1, 7, '78f0942c909f4c158c9ca4bda2878aa5'),
(2, 7, '59e5e36b8c114be3b2c0ca402e7b8654'),
(3, 3, '55008aa0132f4f76b1cacb6a536de66b'),
(4, 3, 'fffbcc046185484689ff83c5d20338e2'),
(5, 1, 'dd725c4c5df347fd918ae70083234266'),
(6, 1, 'bf92e60d42144a44ad4cd863984ef39b'),
(7, 2, '3ea12979e411428a9802955b410ae58d'),
(8, 2, 'f19e11c542444c26a9a8c42850e53c11'),
(9, 8, 'f648d3031ba64f74b209029a62720510'),
(10, 8, '23e53d7f9f3b4707ac606c27fb8686a4');

-- --------------------------------------------------------

--
-- Table structure for table `price`
--

CREATE TABLE `price` (
  `price_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `price` decimal(10,0) NOT NULL,
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `price`
--

INSERT INTO `price` (`price_id`, `date`, `price`, `room_id`) VALUES
(1, '2021-11-01', '100', 10),
(2, '2021-11-02', '100', 10),
(3, '2021-11-03', '100', 10),
(4, '2021-11-04', '100', 10),
(5, '2021-11-05', '100', 10),
(6, '2021-11-06', '100', 10),
(7, '2021-11-07', '170', 10),
(8, '2021-11-08', '100', 10),
(9, '2021-11-09', '100', 10),
(10, '2021-11-10', '100', 10),
(11, '2021-11-11', '100', 10),
(12, '2021-11-12', '100', 10),
(13, '2021-11-13', '100', 10),
(14, '2021-11-14', '100', 10),
(15, '2021-11-15', '100', 10),
(16, '2021-11-16', '100', 10),
(17, '2021-11-17', '100', 10),
(18, '2021-11-18', '100', 10),
(19, '2021-11-19', '100', 10),
(20, '2021-11-20', '100', 10),
(21, '2021-11-21', '150', 10),
(22, '2021-11-22', '150', 10),
(23, '2021-11-23', '150', 10),
(24, '2021-11-24', '150', 10),
(25, '2021-11-25', '200', 10),
(26, '2021-11-26', '100', 10),
(27, '2021-11-27', '100', 10),
(28, '2021-11-28', '100', 10),
(29, '2021-11-29', '100', 10),
(30, '2021-11-30', '100', 10),
(31, '2021-12-01', '100', 10),
(32, '2021-12-02', '100', 10),
(33, '2021-12-03', '100', 10),
(34, '2021-12-04', '100', 10),
(35, '2021-12-05', '100', 10),
(36, '2021-12-06', '100', 10),
(37, '2021-12-07', '100', 10),
(38, '2021-12-08', '100', 10),
(39, '2021-12-09', '100', 10),
(40, '2021-12-10', '100', 10),
(41, '2021-12-11', '100', 10),
(42, '2021-12-12', '100', 10),
(43, '2021-12-13', '100', 10),
(44, '2021-12-14', '100', 10),
(45, '2021-12-15', '100', 10),
(46, '2021-12-16', '100', 10),
(47, '2021-12-17', '100', 10),
(48, '2021-12-18', '100', 10),
(49, '2021-12-19', '100', 10),
(50, '2021-12-20', '100', 10),
(51, '2021-12-21', '100', 10),
(52, '2021-12-22', '100', 10),
(53, '2021-12-23', '100', 10),
(54, '2021-12-24', '100', 10),
(55, '2021-12-25', '300', 10),
(56, '2021-12-26', '100', 10),
(57, '2021-12-27', '100', 10),
(58, '2021-12-28', '100', 10),
(59, '2021-12-29', '100', 10),
(60, '2021-12-30', '100', 10),
(61, '2021-12-31', '100', 10),
(62, '2022-01-01', '100', 10);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `roomtype_id` int(11) NOT NULL,
  `allocation` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room_id`, `hotel_id`, `roomtype_id`, `allocation`) VALUES
(1, 1, 1, 3),
(2, 1, 2, 5),
(3, 1, 3, 2),
(10, 2, 2, 5),
(11, 2, 1, 5),
(13, 8, 2, 5),
(14, 7, 2, 5),
(15, 7, 2, 10);

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
(10, 2),
(11, 1),
(11, 2),
(13, 1),
(13, 2),
(14, 1),
(14, 2),
(15, 1),
(15, 2);

-- --------------------------------------------------------

--
-- Table structure for table `roombed`
--

CREATE TABLE `roombed` (
  `roombed_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `bed_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roombed`
--

INSERT INTO `roombed` (`roombed_id`, `room_id`, `bed_id`) VALUES
(1, 1, 2),
(2, 10, 1),
(3, 10, 2),
(4, 10, 5),
(5, 11, 1),
(6, 13, 2),
(7, 14, 2),
(8, 14, 2),
(9, 15, 1);

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
(2, 1, 2),
(4, 1, 1);

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
(4, 10, '15044db7c324459ca4e6ce0c9132842f'),
(5, 11, '60e09342d6e54e80aa85c13da1b36b6a'),
(6, 11, 'c366618191544aac9a59031ab26ca806'),
(7, 3, 'eda1c6f23b154b2b9e82764c8ad0ce49'),
(8, 3, '15044db7c324459ca4e6ce0c9132842f'),
(11, 13, '32a713f28c5b4006855c3106b4f9d61a'),
(12, 13, 'd58b6e5589fb48bd93e44a45c417b481'),
(13, 14, '2fbc09d8053a49f9a5d49c59cdc263bd'),
(14, 14, 'c48f0690ba414571a3c81d11d9ba81f3'),
(15, 15, '2fbc09d8053a49f9a5d49c59cdc263bd'),
(16, 15, 'c48f0690ba414571a3c81d11d9ba81f3');

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

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_name`, `user_password`, `user_email`, `first_name`, `last_name`) VALUES
(1, 'davegorm1', 'd53c5dc84be586b8c1e7a78dc8bc805b204f285f3cde94', 'davegorm1@qub.ac.uk', 'David', 'Gorman'),
(2, 'cooldude', 'bd407669ec0a1648215dfc2ae6ba13b5b22c39d4b7a9ec', 'petermccullough@qub.ac.uk', 'Peter', 'McCullough'),
(3, 'dwightshrute', '4ce11f95599d2ac8d16063815b3c3f3af328b36f3c640e', 'dwightshrute@dundermifflin.com', 'Dwight', 'Shrute'),
(4, 'pamela20', 'dfde0cf0458470bf96ef06d156dfa3a2f1c9862e766977', 'pamela@qub.ac.uk', 'Pamela', 'Beasly');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `amenity`
--
ALTER TABLE `amenity`
  ADD PRIMARY KEY (`amenity_id`);

--
-- Indexes for table `amenityhotel`
--
ALTER TABLE `amenityhotel`
  ADD PRIMARY KEY (`amenityhotel_id`);

--
-- Indexes for table `bed`
--
ALTER TABLE `bed`
  ADD PRIMARY KEY (`bed_id`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `FK_Booking_Hotel_Id` (`hotel_id`),
  ADD KEY `FK_Booking_User_Id` (`user_id`);

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
-- Indexes for table `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`city_id`),
  ADD KEY `FK_City_Country_Id` (`country_id`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`country_id`);

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
  ADD PRIMARY KEY (`hotel_id`),
  ADD KEY `FK_Hotel_City_Id` (`city_id`);

--
-- Indexes for table `hotelamenityhotel`
--
ALTER TABLE `hotelamenityhotel`
  ADD PRIMARY KEY (`hotel_id`,`amenityhotel_id`),
  ADD KEY `FK_HotelAmenityHotel_AmenityHotel_Id` (`amenityhotel_id`);

--
-- Indexes for table `hotelimage`
--
ALTER TABLE `hotelimage`
  ADD PRIMARY KEY (`hotelimage_id`),
  ADD KEY `FK_HotelImage_Hotel_Id` (`hotel_id`);

--
-- Indexes for table `price`
--
ALTER TABLE `price`
  ADD PRIMARY KEY (`price_id`),
  ADD KEY `FK_Price_Room_Id` (`room_id`);

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
  ADD PRIMARY KEY (`roombed_id`),
  ADD KEY `FK_RoomBed_Room_Id` (`room_id`),
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
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `amenity`
--
ALTER TABLE `amenity`
  MODIFY `amenity_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `amenityhotel`
--
ALTER TABLE `amenityhotel`
  MODIFY `amenityhotel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `bed`
--
ALTER TABLE `bed`
  MODIFY `bed_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `breakfast`
--
ALTER TABLE `breakfast`
  MODIFY `breakfast_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `cancellationpolicy`
--
ALTER TABLE `cancellationpolicy`
  MODIFY `cancellationpolicy_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `city`
--
ALTER TABLE `city`
  MODIFY `city_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `country_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `guest`
--
ALTER TABLE `guest`
  MODIFY `guest_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hotel`
--
ALTER TABLE `hotel`
  MODIFY `hotel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `hotelimage`
--
ALTER TABLE `hotelimage`
  MODIFY `hotelimage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `price`
--
ALTER TABLE `price`
  MODIFY `price_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `roombed`
--
ALTER TABLE `roombed`
  MODIFY `roombed_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `roombooking`
--
ALTER TABLE `roombooking`
  MODIFY `roombooking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `roomimage`
--
ALTER TABLE `roomimage`
  MODIFY `roomimage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `roomtype`
--
ALTER TABLE `roomtype`
  MODIFY `roomtype_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `FK_Booking_Hotel_Id` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`Hotel_Id`),
  ADD CONSTRAINT `FK_Booking_User_Id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

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
-- Constraints for table `city`
--
ALTER TABLE `city`
  ADD CONSTRAINT `FK_City_Country_Id` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`);

--
-- Constraints for table `guest`
--
ALTER TABLE `guest`
  ADD CONSTRAINT `FK_Guest_Booking_Id` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`);

--
-- Constraints for table `hotel`
--
ALTER TABLE `hotel`
  ADD CONSTRAINT `FK_Hotel_City_Id` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`);

--
-- Constraints for table `hotelamenityhotel`
--
ALTER TABLE `hotelamenityhotel`
  ADD CONSTRAINT `FK_HotelAmenityHotel_AmenityHotel_Id` FOREIGN KEY (`amenityhotel_id`) REFERENCES `amenityhotel` (`amenityhotel_id`),
  ADD CONSTRAINT `FK_HotelAmenityHotel_Hotel_Id` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`hotel_id`);

--
-- Constraints for table `hotelimage`
--
ALTER TABLE `hotelimage`
  ADD CONSTRAINT `FK_HotelImage_Hotel_Id` FOREIGN KEY (`hotel_id`) REFERENCES `hotel` (`hotel_id`);

--
-- Constraints for table `price`
--
ALTER TABLE `price`
  ADD CONSTRAINT `FK_Price_Room_Id` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);

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
