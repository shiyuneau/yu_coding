-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: leet_code
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `AddressId` int DEFAULT NULL,
  `PersonId` int DEFAULT NULL,
  `City` varchar(255) DEFAULT NULL,
  `State` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,2,'New York City','New York'),(2,3,'Leetcode','California');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cinema_620`
--

DROP TABLE IF EXISTS `cinema_620`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cinema_620` (
  `id` int DEFAULT NULL,
  `movie` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `rating` float(2,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cinema_620`
--

LOCK TABLES `cinema_620` WRITE;
/*!40000 ALTER TABLE `cinema_620` DISABLE KEYS */;
INSERT INTO `cinema_620` VALUES (1,'War','great 3D',8.9),(2,'Science','fiction',8.5),(3,'irish','boring',6.2),(4,'Ice song','Fantacy',8.6),(5,'House card','Interesting',9.1);
/*!40000 ALTER TABLE `cinema_620` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses_596`
--

DROP TABLE IF EXISTS `courses_596`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses_596` (
  `student` varchar(255) DEFAULT NULL,
  `class` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses_596`
--

LOCK TABLES `courses_596` WRITE;
/*!40000 ALTER TABLE `courses_596` DISABLE KEYS */;
INSERT INTO `courses_596` VALUES ('A','Math'),('B','English'),('C','Math'),('D','Biology'),('E','Math'),('F','Computer'),('G','Math'),('H','Math'),('I','Math');
/*!40000 ALTER TABLE `courses_596` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `Id` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Joe'),(2,'Henry'),(3,'Sam'),(4,'Max');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_1179`
--

DROP TABLE IF EXISTS `department_1179`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_1179` (
  `id` int DEFAULT NULL,
  `revenue` int DEFAULT NULL,
  `month` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_1179`
--

LOCK TABLES `department_1179` WRITE;
/*!40000 ALTER TABLE `department_1179` DISABLE KEYS */;
INSERT INTO `department_1179` VALUES (1,8000,'Jan'),(2,9000,'Jan'),(3,10000,'Feb'),(1,7000,'Feb'),(1,6000,'Mar');
/*!40000 ALTER TABLE `department_1179` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_184`
--

DROP TABLE IF EXISTS `department_184`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_184` (
  `Id` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_184`
--

LOCK TABLES `department_184` WRITE;
/*!40000 ALTER TABLE `department_184` DISABLE KEYS */;
INSERT INTO `department_184` VALUES (1,'IT'),(2,'Sales');
/*!40000 ALTER TABLE `department_184` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_185`
--

DROP TABLE IF EXISTS `department_185`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_185` (
  `Id` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_185`
--

LOCK TABLES `department_185` WRITE;
/*!40000 ALTER TABLE `department_185` DISABLE KEYS */;
INSERT INTO `department_185` VALUES (1,'IT'),(2,'Sales');
/*!40000 ALTER TABLE `department_185` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `Id` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Salary` int DEFAULT NULL,
  `ManagerId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Joe',70000,3),(2,'Henry',80000,4),(3,'Sam',60000,NULL),(4,'Max',90000,NULL);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_184`
--

DROP TABLE IF EXISTS `employee_184`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_184` (
  `Id` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Salary` int DEFAULT NULL,
  `DepartmentId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_184`
--

LOCK TABLES `employee_184` WRITE;
/*!40000 ALTER TABLE `employee_184` DISABLE KEYS */;
INSERT INTO `employee_184` VALUES (1,'Joe',70000,1),(2,'Jim',90000,1),(3,'Henry',80000,2),(4,'Sam',60000,2),(5,'Max',90000,1);
/*!40000 ALTER TABLE `employee_184` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_185`
--

DROP TABLE IF EXISTS `employee_185`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_185` (
  `Id` int DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Salary` int DEFAULT NULL,
  `DepartmentId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_185`
--

LOCK TABLES `employee_185` WRITE;
/*!40000 ALTER TABLE `employee_185` DISABLE KEYS */;
INSERT INTO `employee_185` VALUES (1,'Joe',88000,1),(4,'Max',90000,1),(5,'Janet',69000,1),(6,'Randy',85000,1);
/*!40000 ALTER TABLE `employee_185` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_old`
--

DROP TABLE IF EXISTS `employee_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_old` (
  `Id` int DEFAULT NULL,
  `Salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_old`
--

LOCK TABLES `employee_old` WRITE;
/*!40000 ALTER TABLE `employee_old` DISABLE KEYS */;
INSERT INTO `employee_old` VALUES (1,100),(2,200),(3,300);
/*!40000 ALTER TABLE `employee_old` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `Id` int DEFAULT NULL,
  `Num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,1),(2,1),(3,1),(4,2),(5,1),(6,2),(7,2);
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `Id` int DEFAULT NULL,
  `CustomerId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,3),(2,1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `PersonId` int DEFAULT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (1,'Allen','Wang'),(2,'Bob','Alice');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person_182`
--

DROP TABLE IF EXISTS `person_182`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_182` (
  `Id` int DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person_182`
--

LOCK TABLES `person_182` WRITE;
/*!40000 ALTER TABLE `person_182` DISABLE KEYS */;
INSERT INTO `person_182` VALUES (1,'a@b.com'),(2,'c@d.com');
/*!40000 ALTER TABLE `person_182` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salary_627`
--

DROP TABLE IF EXISTS `salary_627`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salary_627` (
  `id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salary_627`
--

LOCK TABLES `salary_627` WRITE;
/*!40000 ALTER TABLE `salary_627` DISABLE KEYS */;
INSERT INTO `salary_627` VALUES (1,'A','f',2500),(2,'B','m',1500),(3,'C','f',5500),(4,'D','m',500);
/*!40000 ALTER TABLE `salary_627` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scores` (
  `Id` int DEFAULT NULL,
  `Score` decimal(3,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scores`
--

LOCK TABLES `scores` WRITE;
/*!40000 ALTER TABLE `scores` DISABLE KEYS */;
INSERT INTO `scores` VALUES (1,3.50),(2,3.65),(3,4.00),(4,3.85),(5,4.00),(6,3.65),(7,4.00);
/*!40000 ALTER TABLE `scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat_626`
--

DROP TABLE IF EXISTS `seat_626`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat_626` (
  `id` int DEFAULT NULL,
  `student` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat_626`
--

LOCK TABLES `seat_626` WRITE;
/*!40000 ALTER TABLE `seat_626` DISABLE KEYS */;
INSERT INTO `seat_626` VALUES (1,'Abbot'),(2,'Doris'),(3,'Emerson'),(4,'Green'),(5,'Jeames');
/*!40000 ALTER TABLE `seat_626` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stadium_601`
--

DROP TABLE IF EXISTS `stadium_601`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stadium_601` (
  `id` int DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `people` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stadium_601`
--

LOCK TABLES `stadium_601` WRITE;
/*!40000 ALTER TABLE `stadium_601` DISABLE KEYS */;
INSERT INTO `stadium_601` VALUES (1,'2017-01-01',10),(2,'2017-01-02',109),(3,'2017-01-03',150),(4,'2017-01-04',99),(5,'2017-01-05',145),(6,'2017-01-06',1455),(7,'2017-01-07',199),(8,'2017-01-09',188);
/*!40000 ALTER TABLE `stadium_601` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trips`
--

DROP TABLE IF EXISTS `trips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trips` (
  `Id` int DEFAULT NULL,
  `Client_Id` int DEFAULT NULL,
  `Driver_Id` int DEFAULT NULL,
  `City_Id` int DEFAULT NULL,
  `Status` enum('completed','cancelled_by_driver','cancelled_by_client') DEFAULT NULL,
  `Request_at` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trips`
--

LOCK TABLES `trips` WRITE;
/*!40000 ALTER TABLE `trips` DISABLE KEYS */;
INSERT INTO `trips` VALUES (1,1,10,1,'completed','2013-10-01'),(2,2,11,1,'cancelled_by_driver','2013-10-01'),(3,3,12,6,'completed','2013-10-01'),(4,4,13,6,'cancelled_by_client','2013-10-01'),(5,1,10,1,'completed','2013-10-02'),(6,2,11,6,'completed','2013-10-02'),(7,3,12,6,'completed','2013-10-02'),(8,2,12,12,'completed','2013-10-03'),(9,3,10,12,'cancelled_by_driver','2013-10-03'),(10,4,13,12,'completed','2013-10-03'),(11,3,10,6,'cancelled_by_driver','2013-10-02'),(12,5,12,12,'cancelled_by_client','2013-10-01'),(13,4,13,1,'completed','2013-10-03');
/*!40000 ALTER TABLE `trips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `Users_Id` int DEFAULT NULL,
  `Banned` varchar(50) DEFAULT NULL,
  `Role` enum('client','driver','partner') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'No','client'),(2,'Yes','client'),(3,'No','client'),(4,'No','client'),(10,'No','driver'),(11,'No','driver'),(12,'No','driver'),(13,'No','driver'),(5,'Yes','client');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weather`
--

DROP TABLE IF EXISTS `weather`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weather` (
  `Id` int DEFAULT NULL,
  `RecordDate` date DEFAULT NULL,
  `Temperature` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weather`
--

LOCK TABLES `weather` WRITE;
/*!40000 ALTER TABLE `weather` DISABLE KEYS */;
INSERT INTO `weather` VALUES (1,'2015-01-01',10),(2,'2015-01-02',25),(3,'2015-01-03',20),(4,'2015-01-04',30);
/*!40000 ALTER TABLE `weather` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-09  9:55:21
