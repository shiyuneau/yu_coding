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
-- Current Database: `leet_code`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `leet_code` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `leet_code`;

--
-- Table structure for table `actions_1132`
--

DROP TABLE IF EXISTS `actions_1132`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions_1132` (
                                `user_id` int DEFAULT NULL,
                                `post_id` int DEFAULT NULL,
                                `action_date` date DEFAULT NULL,
                                `action` enum('view','like','reaction','comment','report','share') DEFAULT NULL,
                                `extra` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions_1132`
--

LOCK TABLES `actions_1132` WRITE;
/*!40000 ALTER TABLE `actions_1132` DISABLE KEYS */;
INSERT INTO `actions_1132` VALUES (1,1,'2019-07-01','view',NULL),(1,1,'2019-07-01','like',NULL),(1,1,'2019-07-01','share',NULL),(2,2,'2019-07-04','view',NULL),(2,2,'2019-07-04','report','spam'),(3,4,'2019-07-04','view',NULL),(3,4,'2019-07-07','report','spam'),(4,3,'2019-07-02','view',NULL),(4,3,'2019-07-02','report','spam'),(5,2,'2019-07-03','view',NULL),(5,3,'2019-07-03','report','racism'),(5,5,'2019-07-03','view',NULL),(5,5,'2019-07-03','report','racism');
/*!40000 ALTER TABLE `actions_1132` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_1097`
--

DROP TABLE IF EXISTS `activity_1097`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_1097` (
                                 `player_id` int DEFAULT NULL,
                                 `device_id` int DEFAULT NULL,
                                 `event_date` date DEFAULT NULL,
                                 `games_played` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_1097`
--

LOCK TABLES `activity_1097` WRITE;
/*!40000 ALTER TABLE `activity_1097` DISABLE KEYS */;
INSERT INTO `activity_1097` VALUES (1,2,'2016-03-01',5),(1,2,'2016-03-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-01',0),(3,4,'2018-07-03',5),(4,5,'2016-03-02',7);
/*!40000 ALTER TABLE `activity_1097` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_1141`
--

DROP TABLE IF EXISTS `activity_1141`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_1141` (
                                 `user_id` int DEFAULT NULL,
                                 `session_id` int DEFAULT NULL,
                                 `activity_date` date DEFAULT NULL,
                                 `activity_type` enum('open_session','end_session','scroll_down','send_message') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_1141`
--

LOCK TABLES `activity_1141` WRITE;
/*!40000 ALTER TABLE `activity_1141` DISABLE KEYS */;
INSERT INTO `activity_1141` VALUES (1,1,'2019-07-20','open_session'),(1,1,'2019-07-20','scroll_down'),(1,1,'2019-07-20','end_session'),(2,4,'2019-07-20','open_session'),(2,4,'2019-07-21','send_message'),(2,4,'2019-07-21','end_session'),(3,2,'2019-07-21','open_session'),(3,2,'2019-07-21','send_message'),(3,2,'2019-07-21','end_session'),(4,3,'2019-06-25','open_session'),(4,3,'2019-06-25','end_session'),(3,5,'2019-07-21','open_session'),(3,5,'2019-07-21','send_message'),(3,5,'2019-07-21','end_session');
/*!40000 ALTER TABLE `activity_1141` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_511`
--

DROP TABLE IF EXISTS `activity_511`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_511` (
                                `player_id` int DEFAULT NULL,
                                `device_id` int DEFAULT NULL,
                                `event_date` date DEFAULT NULL,
                                `games_played` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_511`
--

LOCK TABLES `activity_511` WRITE;
/*!40000 ALTER TABLE `activity_511` DISABLE KEYS */;
INSERT INTO `activity_511` VALUES (1,2,'2016-03-01',5),(1,2,'2016-03-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);
/*!40000 ALTER TABLE `activity_511` ENABLE KEYS */;
UNLOCK TABLES;

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
                           `State` varchar(255) DEFAULT NULL,
                           KEY `id` (`AddressId`)
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
-- Table structure for table `bonus_577`
--

DROP TABLE IF EXISTS `bonus_577`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bonus_577` (
                             `EmpId` int DEFAULT NULL,
                             `Bonus` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bonus_577`
--

LOCK TABLES `bonus_577` WRITE;
/*!40000 ALTER TABLE `bonus_577` DISABLE KEYS */;
INSERT INTO `bonus_577` VALUES (2,500),(4,2000);
/*!40000 ALTER TABLE `bonus_577` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books_1098`
--

DROP TABLE IF EXISTS `books_1098`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books_1098` (
                              `book_id` int DEFAULT NULL,
                              `name` varchar(50) DEFAULT NULL,
                              `available_from` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books_1098`
--

LOCK TABLES `books_1098` WRITE;
/*!40000 ALTER TABLE `books_1098` DISABLE KEYS */;
INSERT INTO `books_1098` VALUES (1,'Kalila And Demna','2010-01-01'),(2,'28 Letters','2012-05-12'),(3,'The Hobbit','2019-06-10'),(4,'13 Reasons Why','2019-06-01'),(5,'The Hunger Games','2008-09-21');
/*!40000 ALTER TABLE `books_1098` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_574`
--

DROP TABLE IF EXISTS `candidate_574`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_574` (
                                 `id` int DEFAULT NULL,
                                 `Name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_574`
--

LOCK TABLES `candidate_574` WRITE;
/*!40000 ALTER TABLE `candidate_574` DISABLE KEYS */;
INSERT INTO `candidate_574` VALUES (1,'A'),(2,'B'),(3,'C'),(4,'D'),(5,'E');
/*!40000 ALTER TABLE `candidate_574` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cinema_603`
--

DROP TABLE IF EXISTS `cinema_603`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cinema_603` (
                              `seat_id` int NOT NULL AUTO_INCREMENT,
                              `free` tinyint(1) DEFAULT NULL,
                              PRIMARY KEY (`seat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cinema_603`
--

LOCK TABLES `cinema_603` WRITE;
/*!40000 ALTER TABLE `cinema_603` DISABLE KEYS */;
INSERT INTO `cinema_603` VALUES (1,1),(2,0),(3,1),(4,1),(5,1);
/*!40000 ALTER TABLE `cinema_603` ENABLE KEYS */;
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
-- Table structure for table `customer_1045`
--

DROP TABLE IF EXISTS `customer_1045`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_1045` (
                                 `customer_id` int DEFAULT NULL,
                                 `product_key` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_1045`
--

LOCK TABLES `customer_1045` WRITE;
/*!40000 ALTER TABLE `customer_1045` DISABLE KEYS */;
INSERT INTO `customer_1045` VALUES (1,5),(2,6),(3,5),(3,6),(1,6);
/*!40000 ALTER TABLE `customer_1045` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
                             `Id` int DEFAULT NULL,
                             `Name` varchar(255) DEFAULT NULL,
                             KEY `id` (`Id`)
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
-- Table structure for table `department_580`
--

DROP TABLE IF EXISTS `department_580`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_580` (
                                  `dept_id` int DEFAULT NULL,
                                  `dept_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_580`
--

LOCK TABLES `department_580` WRITE;
/*!40000 ALTER TABLE `department_580` DISABLE KEYS */;
INSERT INTO `department_580` VALUES (1,'Architecture'),(2,'Art'),(3,'Biotechnology'),(4,'East Asian Studies'),(5,'Engineering'),(9,'Politics'),(7,'Law');
/*!40000 ALTER TABLE `department_580` ENABLE KEYS */;
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
-- Table structure for table `employee_1076`
--

DROP TABLE IF EXISTS `employee_1076`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_1076` (
                                 `employee_id` int DEFAULT NULL,
                                 `name` varchar(10) DEFAULT NULL,
                                 `experience_years` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_1076`
--

LOCK TABLES `employee_1076` WRITE;
/*!40000 ALTER TABLE `employee_1076` DISABLE KEYS */;
INSERT INTO `employee_1076` VALUES (1,'Khaled',3),(2,'Ali',2),(3,'John',1),(4,'Doe',2);
/*!40000 ALTER TABLE `employee_1076` ENABLE KEYS */;
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
-- Table structure for table `employee_569`
--

DROP TABLE IF EXISTS `employee_569`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_569` (
                                `Id` int DEFAULT NULL,
                                `Company` varchar(255) DEFAULT NULL,
                                `Salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_569`
--

LOCK TABLES `employee_569` WRITE;
/*!40000 ALTER TABLE `employee_569` DISABLE KEYS */;
INSERT INTO `employee_569` VALUES (1,'A',2341),(2,'A',341),(3,'A',15),(4,'A',15314),(5,'A',451),(6,'A',513),(7,'B',15),(8,'B',13),(9,'B',1154),(10,'B',1345),(11,'B',1221),(12,'B',234),(13,'C',2345);
/*!40000 ALTER TABLE `employee_569` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_570`
--

DROP TABLE IF EXISTS `employee_570`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_570` (
                                `Id` int DEFAULT NULL,
                                `Name` varchar(255) DEFAULT NULL,
                                `Department` varchar(255) DEFAULT NULL,
                                `ManagerId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_570`
--

LOCK TABLES `employee_570` WRITE;
/*!40000 ALTER TABLE `employee_570` DISABLE KEYS */;
INSERT INTO `employee_570` VALUES (102,'Dan','A',101),(103,'James','A',101),(104,'Amy','A',101),(105,'Anne','A',101),(106,'Ron','B',101);
/*!40000 ALTER TABLE `employee_570` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_577`
--

DROP TABLE IF EXISTS `employee_577`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_577` (
                                `EmpId` int DEFAULT NULL,
                                `Name` varchar(255) DEFAULT NULL,
                                `Supervisor` int DEFAULT NULL,
                                `Salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_577`
--

LOCK TABLES `employee_577` WRITE;
/*!40000 ALTER TABLE `employee_577` DISABLE KEYS */;
INSERT INTO `employee_577` VALUES (1,'John',3,1000),(2,'Dan',3,2000),(4,'Thomas',3,4000),(3,'Brad',NULL,4000);
/*!40000 ALTER TABLE `employee_577` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_579`
--

DROP TABLE IF EXISTS `employee_579`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_579` (
                                `Id` int DEFAULT NULL,
                                `Month` int DEFAULT NULL,
                                `Salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_579`
--

LOCK TABLES `employee_579` WRITE;
/*!40000 ALTER TABLE `employee_579` DISABLE KEYS */;
INSERT INTO `employee_579` VALUES (1,1,20),(2,1,20),(1,2,30),(2,2,30),(3,2,40),(1,3,40),(3,3,60),(1,4,60),(3,4,70),(1,7,90),(1,8,90);
/*!40000 ALTER TABLE `employee_579` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_615`
--

DROP TABLE IF EXISTS `employee_615`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_615` (
                                `employee_id` int DEFAULT NULL,
                                `department_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_615`
--

LOCK TABLES `employee_615` WRITE;
/*!40000 ALTER TABLE `employee_615` DISABLE KEYS */;
INSERT INTO `employee_615` VALUES (1,1),(2,1),(3,1);
/*!40000 ALTER TABLE `employee_615` ENABLE KEYS */;
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
-- Table structure for table `enrollments_1112`
--

DROP TABLE IF EXISTS `enrollments_1112`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments_1112` (
                                    `student_id` int DEFAULT NULL,
                                    `course_id` int DEFAULT NULL,
                                    `grade` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments_1112`
--

LOCK TABLES `enrollments_1112` WRITE;
/*!40000 ALTER TABLE `enrollments_1112` DISABLE KEYS */;
INSERT INTO `enrollments_1112` VALUES (2,2,95),(2,3,95),(1,1,90),(1,2,99),(3,1,80),(3,2,75),(3,3,82);
/*!40000 ALTER TABLE `enrollments_1112` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follow_614`
--

DROP TABLE IF EXISTS `follow_614`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follow_614` (
                              `followee` varchar(255) DEFAULT NULL,
                              `follower` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follow_614`
--

LOCK TABLES `follow_614` WRITE;
/*!40000 ALTER TABLE `follow_614` DISABLE KEYS */;
INSERT INTO `follow_614` VALUES ('A','B'),('B','C'),('B','D'),('D','E');
/*!40000 ALTER TABLE `follow_614` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friendrequest_597`
--

DROP TABLE IF EXISTS `friendrequest_597`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friendrequest_597` (
                                     `sender_id` int DEFAULT NULL,
                                     `send_to_id` int DEFAULT NULL,
                                     `request_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friendrequest_597`
--

LOCK TABLES `friendrequest_597` WRITE;
/*!40000 ALTER TABLE `friendrequest_597` DISABLE KEYS */;
INSERT INTO `friendrequest_597` VALUES (1,2,'2016-06-01'),(1,3,'2016-06-01'),(1,4,'2016-06-01'),(2,3,'2016-06-02'),(3,4,'2016-06-09');
/*!40000 ALTER TABLE `friendrequest_597` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_585`
--

DROP TABLE IF EXISTS `insurance_585`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_585` (
                                 `PID` int DEFAULT NULL,
                                 `TIV_2015` decimal(15,2) DEFAULT NULL,
                                 `TIV_2016` decimal(15,2) DEFAULT NULL,
                                 `LAT` decimal(5,2) DEFAULT NULL,
                                 `LON` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_585`
--

LOCK TABLES `insurance_585` WRITE;
/*!40000 ALTER TABLE `insurance_585` DISABLE KEYS */;
INSERT INTO `insurance_585` VALUES (1,10.00,5.00,10.00,10.00),(2,20.00,20.00,20.00,20.00),(3,10.00,30.00,20.00,20.00),(4,10.00,40.00,40.00,40.00);
/*!40000 ALTER TABLE `insurance_585` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items_1159`
--

DROP TABLE IF EXISTS `items_1159`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_1159` (
                              `item_id` int DEFAULT NULL,
                              `item_brand` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items_1159`
--

LOCK TABLES `items_1159` WRITE;
/*!40000 ALTER TABLE `items_1159` DISABLE KEYS */;
INSERT INTO `items_1159` VALUES (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');
/*!40000 ALTER TABLE `items_1159` ENABLE KEYS */;
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
-- Table structure for table `matches_1194`
--

DROP TABLE IF EXISTS `matches_1194`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matches_1194` (
                                `match_id` int DEFAULT NULL,
                                `first_player` int DEFAULT NULL,
                                `second_player` int DEFAULT NULL,
                                `first_score` int DEFAULT NULL,
                                `second_score` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matches_1194`
--

LOCK TABLES `matches_1194` WRITE;
/*!40000 ALTER TABLE `matches_1194` DISABLE KEYS */;
INSERT INTO `matches_1194` VALUES (1,15,45,3,0),(2,30,25,1,2),(3,30,15,2,0),(4,40,20,5,2),(5,35,50,1,1);
/*!40000 ALTER TABLE `matches_1194` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `numbers_571`
--

DROP TABLE IF EXISTS `numbers_571`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `numbers_571` (
                               `Number` int DEFAULT NULL,
                               `Frequency` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `numbers_571`
--

LOCK TABLES `numbers_571` WRITE;
/*!40000 ALTER TABLE `numbers_571` DISABLE KEYS */;
INSERT INTO `numbers_571` VALUES (0,1),(1,1),(2,1),(3,1),(4,1);
/*!40000 ALTER TABLE `numbers_571` ENABLE KEYS */;
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
-- Table structure for table `orders_1098`
--

DROP TABLE IF EXISTS `orders_1098`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_1098` (
                               `order_id` int DEFAULT NULL,
                               `book_id` int DEFAULT NULL,
                               `quantity` int DEFAULT NULL,
                               `dispatch_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_1098`
--

LOCK TABLES `orders_1098` WRITE;
/*!40000 ALTER TABLE `orders_1098` DISABLE KEYS */;
INSERT INTO `orders_1098` VALUES (1,1,2,'2018-07-26'),(2,1,1,'2018-11-05'),(3,3,8,'2019-06-11'),(4,4,6,'2019-06-05'),(5,4,5,'2019-06-20'),(6,5,9,'2009-02-02'),(7,5,8,'2010-04-13');
/*!40000 ALTER TABLE `orders_1098` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_1159`
--

DROP TABLE IF EXISTS `orders_1159`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders_1159` (
                               `order_id` int DEFAULT NULL,
                               `order_date` date DEFAULT NULL,
                               `item_id` int DEFAULT NULL,
                               `buyer_id` int DEFAULT NULL,
                               `seller_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_1159`
--

LOCK TABLES `orders_1159` WRITE;
/*!40000 ALTER TABLE `orders_1159` DISABLE KEYS */;
INSERT INTO `orders_1159` VALUES (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2),(5,'2019-08-04',1,3,4),(6,'2019-08-05',4,3,4),(7,'2019-08-06',2,2,4),(8,'2019-08-04',2,3,1);
/*!40000 ALTER TABLE `orders_1159` ENABLE KEYS */;
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
-- Table structure for table `players_1194`
--

DROP TABLE IF EXISTS `players_1194`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `players_1194` (
                                `player_id` int DEFAULT NULL,
                                `group_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players_1194`
--

LOCK TABLES `players_1194` WRITE;
/*!40000 ALTER TABLE `players_1194` DISABLE KEYS */;
INSERT INTO `players_1194` VALUES (10,2),(15,1),(20,3),(25,1),(30,1),(35,2),(40,3),(45,1),(50,2);
/*!40000 ALTER TABLE `players_1194` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `point_2d_612`
--

DROP TABLE IF EXISTS `point_2d_612`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `point_2d_612` (
                                `x` int NOT NULL,
                                `y` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `point_2d_612`
--

LOCK TABLES `point_2d_612` WRITE;
/*!40000 ALTER TABLE `point_2d_612` DISABLE KEYS */;
INSERT INTO `point_2d_612` VALUES (-1,-1),(0,0),(-1,-2);
/*!40000 ALTER TABLE `point_2d_612` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_1045`
--

DROP TABLE IF EXISTS `product_1045`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_1045` (
    `product_key` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_1045`
--

LOCK TABLES `product_1045` WRITE;
/*!40000 ALTER TABLE `product_1045` DISABLE KEYS */;
INSERT INTO `product_1045` VALUES (5),(6);
/*!40000 ALTER TABLE `product_1045` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_1082`
--

DROP TABLE IF EXISTS `product_1082`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_1082` (
                                `product_id` int DEFAULT NULL,
                                `product_name` varchar(10) DEFAULT NULL,
                                `unit_price` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_1082`
--

LOCK TABLES `product_1082` WRITE;
/*!40000 ALTER TABLE `product_1082` DISABLE KEYS */;
INSERT INTO `product_1082` VALUES (1,'S8',1000),(2,'G4',800),(3,'iPhone',1400);
/*!40000 ALTER TABLE `product_1082` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_1164`
--

DROP TABLE IF EXISTS `products_1164`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products_1164` (
                                 `product_id` int DEFAULT NULL,
                                 `new_price` int DEFAULT NULL,
                                 `change_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_1164`
--

LOCK TABLES `products_1164` WRITE;
/*!40000 ALTER TABLE `products_1164` DISABLE KEYS */;
INSERT INTO `products_1164` VALUES (1,20,'2019-08-14'),(2,50,'2019-08-14'),(1,30,'2019-08-15'),(1,35,'2019-08-16'),(2,65,'2019-08-17'),(3,20,'2019-08-18');
/*!40000 ALTER TABLE `products_1164` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_1076`
--

DROP TABLE IF EXISTS `project_1076`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_1076` (
                                `project_id` int DEFAULT NULL,
                                `employee_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_1076`
--

LOCK TABLES `project_1076` WRITE;
/*!40000 ALTER TABLE `project_1076` DISABLE KEYS */;
INSERT INTO `project_1076` VALUES (1,1),(1,2),(1,3),(2,1),(2,4);
/*!40000 ALTER TABLE `project_1076` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `removals`
--

DROP TABLE IF EXISTS `removals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `removals` (
                            `post_id` int DEFAULT NULL,
                            `remove_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `removals`
--

LOCK TABLES `removals` WRITE;
/*!40000 ALTER TABLE `removals` DISABLE KEYS */;
/*!40000 ALTER TABLE `removals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `removals_1132`
--

DROP TABLE IF EXISTS `removals_1132`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `removals_1132` (
                                 `post_id` int DEFAULT NULL,
                                 `remove_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `removals_1132`
--

LOCK TABLES `removals_1132` WRITE;
/*!40000 ALTER TABLE `removals_1132` DISABLE KEYS */;
INSERT INTO `removals_1132` VALUES (2,'2019-07-20'),(5,'2019-07-18');
/*!40000 ALTER TABLE `removals_1132` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_accepted_602`
--

DROP TABLE IF EXISTS `request_accepted_602`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_accepted_602` (
                                        `requester_id` int NOT NULL,
                                        `accepter_id` int DEFAULT NULL,
                                        `accept_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_accepted_602`
--

LOCK TABLES `request_accepted_602` WRITE;
/*!40000 ALTER TABLE `request_accepted_602` DISABLE KEYS */;
INSERT INTO `request_accepted_602` VALUES (1,2,'2016-06-03'),(1,3,'2016-06-08'),(2,3,'2016-06-08'),(3,4,'2016-06-09');
/*!40000 ALTER TABLE `request_accepted_602` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requestaccepted_597`
--

DROP TABLE IF EXISTS `requestaccepted_597`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requestaccepted_597` (
                                       `requester_id` int DEFAULT NULL,
                                       `accepter_id` int DEFAULT NULL,
                                       `accept_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestaccepted_597`
--

LOCK TABLES `requestaccepted_597` WRITE;
/*!40000 ALTER TABLE `requestaccepted_597` DISABLE KEYS */;
INSERT INTO `requestaccepted_597` VALUES (1,2,'2016-06-03'),(1,3,'2016-06-08'),(2,3,'2016-06-08'),(3,4,'2016-06-09'),(3,4,'2016-06-10');
/*!40000 ALTER TABLE `requestaccepted_597` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salary_615`
--

DROP TABLE IF EXISTS `salary_615`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salary_615` (
                              `id` int DEFAULT NULL,
                              `employee_id` int DEFAULT NULL,
                              `amount` int DEFAULT NULL,
                              `pay_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salary_615`
--

LOCK TABLES `salary_615` WRITE;
/*!40000 ALTER TABLE `salary_615` DISABLE KEYS */;
INSERT INTO `salary_615` VALUES (1,1,9000,'2017-03-31'),(2,2,6000,'2017-03-31'),(3,3,10000,'2017-03-31'),(4,1,7000,'2017-02-26'),(5,2,6000,'2017-02-27'),(6,3,8000,'2017-02-22');
/*!40000 ALTER TABLE `salary_615` ENABLE KEYS */;
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
-- Table structure for table `sales_1082`
--

DROP TABLE IF EXISTS `sales_1082`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_1082` (
                              `seller_id` int DEFAULT NULL,
                              `product_id` int DEFAULT NULL,
                              `buyer_id` int DEFAULT NULL,
                              `sale_date` date DEFAULT NULL,
                              `quantity` int DEFAULT NULL,
                              `price` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_1082`
--

LOCK TABLES `sales_1082` WRITE;
/*!40000 ALTER TABLE `sales_1082` DISABLE KEYS */;
INSERT INTO `sales_1082` VALUES (1,1,1,'2019-01-21',2,2000),(1,2,2,'2019-02-17',1,800),(2,1,3,'2019-06-02',1,800),(3,3,3,'2019-05-13',2,2800);
/*!40000 ALTER TABLE `sales_1082` ENABLE KEYS */;
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
-- Table structure for table `spending_1127`
--

DROP TABLE IF EXISTS `spending_1127`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spending_1127` (
                                 `user_id` int DEFAULT NULL,
                                 `spend_date` date DEFAULT NULL,
                                 `platform` enum('desktop','mobile') DEFAULT NULL,
                                 `amount` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spending_1127`
--

LOCK TABLES `spending_1127` WRITE;
/*!40000 ALTER TABLE `spending_1127` DISABLE KEYS */;
INSERT INTO `spending_1127` VALUES (1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100),(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);
/*!40000 ALTER TABLE `spending_1127` ENABLE KEYS */;
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
-- Table structure for table `student_580`
--

DROP TABLE IF EXISTS `student_580`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_580` (
                               `student_id` int DEFAULT NULL,
                               `student_name` varchar(45) DEFAULT NULL,
                               `gender` varchar(6) DEFAULT NULL,
                               `dept_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_580`
--

LOCK TABLES `student_580` WRITE;
/*!40000 ALTER TABLE `student_580` DISABLE KEYS */;
INSERT INTO `student_580` VALUES (1,'Will','M',7),(2,'Jane','F',5),(3,'Alex','M',4),(4,'Bill',NULL,4),(8,'Bezalel',NULL,3),(9,'Parto',NULL,9);
/*!40000 ALTER TABLE `student_580` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_618`
--

DROP TABLE IF EXISTS `student_618`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_618` (
                               `name` varchar(50) DEFAULT NULL,
                               `continent` varchar(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_618`
--

LOCK TABLES `student_618` WRITE;
/*!40000 ALTER TABLE `student_618` DISABLE KEYS */;
INSERT INTO `student_618` VALUES ('Jane','America'),('Pascal','Europe'),('Xi','Asia'),('Jack','America'),('Alice','Europe'),('Alice','Europe');
/*!40000 ALTER TABLE `student_618` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey_log_578`
--

DROP TABLE IF EXISTS `survey_log_578`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey_log_578` (
                                  `id` int DEFAULT NULL,
                                  `action` varchar(255) DEFAULT NULL,
                                  `question_id` int DEFAULT NULL,
                                  `answer_id` int DEFAULT NULL,
                                  `q_num` int DEFAULT NULL,
                                  `timestamp` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey_log_578`
--

LOCK TABLES `survey_log_578` WRITE;
/*!40000 ALTER TABLE `survey_log_578` DISABLE KEYS */;
INSERT INTO `survey_log_578` VALUES (5,'show',285,NULL,1,123),(5,'answer',285,124124,1,124),(5,'show',369,NULL,2,125),(5,'skip',369,NULL,2,126);
/*!40000 ALTER TABLE `survey_log_578` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_array`
--

DROP TABLE IF EXISTS `test_array`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_array` (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `ids` varchar(255) DEFAULT NULL,
                              `name` varchar(255) DEFAULT NULL,
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_array`
--

LOCK TABLES `test_array` WRITE;
/*!40000 ALTER TABLE `test_array` DISABLE KEYS */;
INSERT INTO `test_array` VALUES (1,'{1,2}','alice'),(2,'{2,3}','john'),(3,'{3}',NULL);
/*!40000 ALTER TABLE `test_array` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions_1193`
--

DROP TABLE IF EXISTS `transactions_1193`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions_1193` (
                                     `id` int DEFAULT NULL,
                                     `country` varchar(4) DEFAULT NULL,
                                     `state` enum('approved','declined') DEFAULT NULL,
                                     `amount` int DEFAULT NULL,
                                     `trans_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions_1193`
--

LOCK TABLES `transactions_1193` WRITE;
/*!40000 ALTER TABLE `transactions_1193` DISABLE KEYS */;
INSERT INTO `transactions_1193` VALUES (121,'US','approved',1000,'2018-12-18'),(122,'US','declined',2000,'2018-12-19'),(123,'US','approved',2000,'2019-01-01'),(124,'DE','approved',2000,'2019-01-07');
/*!40000 ALTER TABLE `transactions_1193` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tree_608`
--

DROP TABLE IF EXISTS `tree_608`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tree_608` (
                            `id` int DEFAULT NULL,
                            `p_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tree_608`
--

LOCK TABLES `tree_608` WRITE;
/*!40000 ALTER TABLE `tree_608` DISABLE KEYS */;
INSERT INTO `tree_608` VALUES (1,NULL),(2,1),(3,1),(4,2),(5,2);
/*!40000 ALTER TABLE `tree_608` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `triangle_610`
--

DROP TABLE IF EXISTS `triangle_610`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `triangle_610` (
                                `x` int DEFAULT NULL,
                                `y` int DEFAULT NULL,
                                `z` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `triangle_610`
--

LOCK TABLES `triangle_610` WRITE;
/*!40000 ALTER TABLE `triangle_610` DISABLE KEYS */;
INSERT INTO `triangle_610` VALUES (13,15,30),(10,20,15);
/*!40000 ALTER TABLE `triangle_610` ENABLE KEYS */;
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
-- Table structure for table `users_1159`
--

DROP TABLE IF EXISTS `users_1159`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_1159` (
                              `user_id` int DEFAULT NULL,
                              `join_date` date DEFAULT NULL,
                              `favorite_brand` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_1159`
--

LOCK TABLES `users_1159` WRITE;
/*!40000 ALTER TABLE `users_1159` DISABLE KEYS */;
INSERT INTO `users_1159` VALUES (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');
/*!40000 ALTER TABLE `users_1159` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vote_574`
--

DROP TABLE IF EXISTS `vote_574`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vote_574` (
                            `id` int DEFAULT NULL,
                            `CandidateId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vote_574`
--

LOCK TABLES `vote_574` WRITE;
/*!40000 ALTER TABLE `vote_574` DISABLE KEYS */;
INSERT INTO `vote_574` VALUES (1,2),(2,4),(3,3),(4,2),(5,5);
/*!40000 ALTER TABLE `vote_574` ENABLE KEYS */;
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

-- Dump completed on 2021-11-01 15:44:49
