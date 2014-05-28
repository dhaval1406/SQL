SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `web_logs` ;
USE `web_logs` ;

-- -----------------------------------------------------
-- Table `web_logs`.`Search`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `web_logs`.`Search` (
  `AccessDateTime` DATETIME NOT NULL ,
  `USER_CODE` VARCHAR(8) NULL ,
  `CUSTCD` VARCHAR(6) NULL ,
  `COOKIE_VALUE` VARCHAR(100) NULL ,
  `SessionId` VARCHAR(100) NULL ,
  `Query` VARCHAR(255) NULL ,
  `Search_Type` DECIMAL(1) NULL ,
  `Status` VARCHAR(10) NULL ,
  `URL` VARCHAR(500) NULL ,
  `Series_Code` VARCHAR(20) NULL ,
  `BRD_Code` VARCHAR(4) NULL ,
  `Link_URL` VARCHAR(500) NULL ,
  `IP` VARCHAR(20) NULL ,
  `User_Agent` VARCHAR(500) NULL ,
  PRIMARY KEY (`AccessDateTime`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `web_logs`.`Detail_Tab`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `web_logs`.`Detail_Tab` (
  `AccessDateTime` DATETIME NOT NULL ,
  `USER_CODE` VARCHAR(8) NULL ,
  `CUSTCD` VARCHAR(6) NULL ,
  `COOKIE_VALUE` VARCHAR(100) NULL ,
  `SessionId` VARCHAR(100) NULL ,
  `Tab_Name` VARCHAR(5) NULL ,
  `Series_Code` VARCHAR(20) NULL ,
  `BRD_Code` VARCHAR(4) NULL ,
  `Page_URL` VARCHAR(500) NULL ,
  `IP` VARCHAR(20) NULL ,
  `User_Agent` VARCHAR(500) NULL ,
  PRIMARY KEY (`AccessDateTime`) )
ENGINE = InnoDB;

USE `web_logs` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
