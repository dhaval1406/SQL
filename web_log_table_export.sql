SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `web_logs`;
USE `web_logs`;

-- -----------------------------------------------------
-- Table `web_logs`.`Search`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `web_logs`.`Search` (
  `AccessDateTime` DATETIME NOT NULL,
  `USER_CODE` VARCHAR(8),
  `CUSTCD` VARCHAR(6),
  `COOKIE_VALUE` VARCHAR(100),
  `SessionId` VARCHAR(100),
  `Query` VARCHAR(255),
  `Search_Type` DECIMAL(1),
  `Status` VARCHAR(10),
  `URL` VARCHAR(500),
  `Series_Code` VARCHAR(20),
  `BRD_Code` VARCHAR(4),
  `Link_URL` VARCHAR(500),
  `IP` VARCHAR(20),
  `User_Agent` VARCHAR(500),
  PRIMARY KEY (`AccessDateTime`)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `web_logs`.`Detail_Tab`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `web_logs`.`Detail_Tab` (
  `AccessDateTime` DATETIME NOT NULL,
  `USER_CODE` VARCHAR(8),
  `CUSTCD` VARCHAR(6),
  `COOKIE_VALUE` VARCHAR(100),
  `SessionId` VARCHAR(100),
  `Tab_Name` VARCHAR(5),
  `Series_Code` VARCHAR(20),
  `BRD_Code` VARCHAR(4),
  `Page_URL` VARCHAR(500),
  `IP` VARCHAR(20),
  `User_Agent` VARCHAR(500),
  PRIMARY KEY (`AccessDateTime`)
) ENGINE=InnoDB;

USE `web_logs`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
