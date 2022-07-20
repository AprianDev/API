-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2022 at 02:37 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkIdLogin` (IN `in_Username` VARCHAR(32))  READS SQL DATA
SELECT COUNT(*) as jml from login where username = in_Username$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUserByUsername` (IN `in_Username` VARCHAR(32))  DELETE FROM user where id = (SELECT user_id from login where username = in_Username)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDataUser` ()  READS SQL DATA
SELECT 
	a.user_id,
	a.username,
    b.name,
    b.phone,
    b.email,
    b.address
	FROM
   		login a
   	INNER JOIN
       	user b
    ON
    	a.user_id = b.id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDataUserByID` (IN `in_Id` INT)  SELECT 
	a.username,
    b.name,
    b.phone,
    b.email,
    b.address
	FROM
   		login a
   	INNER JOIN
       	user b
    ON
    	a.user_id = b.id
    WHERE
    	b.id = in_Id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertLogin` (IN `in_Username` VARCHAR(32), IN `in_Password` VARCHAR(100), IN `in_UserId` INT)  insert into login values(in_Username, in_Password, in_UserId)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUser` (IN `in_Name` VARCHAR(255), IN `in_Email` VARCHAR(255), IN `in_Phone` VARCHAR(30), IN `in_Address` TEXT)  insert into user values('',in_Name, in_Email, in_Phone, in_Address)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `signIn` (IN `in_Username` VARCHAR(32), IN `in_Password` VARCHAR(100))  SELECT count(*) as jml FROM login where username = in_Username and password = in_password$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLogin` (IN `in_Username` VARCHAR(32), IN `in_Password` VARCHAR(100))  update login set password = in_Password where username = in_Username$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUser` (IN `in_UserId` INT, IN `in_Name` VARCHAR(255), IN `in_Email` VARCHAR(255), IN `in_Phone` VARCHAR(30), IN `in_Address` TEXT)  update user set name = in_Name,email = in_Email, phone = in_Phone, address =  in_Address where id = in_UserId$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `username` varchar(32) NOT NULL,
  `password` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`username`, `password`, `user_id`) VALUES
('aprian', '5e41d7e4e598e9425a011a7363cde9a0', 1),
('udinganteng', '6e6dcdcf1683fa6c6e742c35411da48a', 9),
('ujangganteng', '8b979ca1382c404b19e90f758a86dc26', 10);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `address` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `email`, `phone`, `address`) VALUES
(1, 'Muhammad Aprian Fauzi', 'm.aprianf17@gmail.com', '082126910003', 'Jln. Baleagung no.46 Baleendah'),
(9, 'Udin', 'udin@gmail.com', '082126910003', 'JLN. Baleagung no.46'),
(10, 'Ujang', 'Ujang@gmail.com', '082126910003', 'JLN. Baleagung no.46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`username`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
