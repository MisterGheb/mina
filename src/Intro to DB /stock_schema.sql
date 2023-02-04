CREATE TABLE `dbAssMilestone2_holdings` (
  `id` INT NOT NULL,
  `volume` INT NULL,
  `bid_price` DOUBLE NULL,
  `bought_on` DATE NULL,
  `users_id` INT NOT NULL,
  `stocks_id` INT NOT NULL,
  PRIMARY KEY (`id`, `users_id`, `stocks_id`),
  INDEX `fk_holdings_users1_idx` (`users_id` ASC) VISIBLE,
  INDEX `fk_holdings_stocks1_idx` (`stocks_id` ASC) VISIBLE,
  CONSTRAINT `fk_holdings_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_holdings_stocks1`
    FOREIGN KEY (`stocks_id`)
    REFERENCES `mydb`.`stocks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE `dbAssMilestone2_OHLC` (
  `stocks_id` INT NOT NULL,
  `market_id` INT NOT NULL,
  `open` DOUBLE NULL,
  `high` DOUBLE NULL,
  `low` DOUBLE NULL,
  `close` DOUBLE NULL,
  `volume` INT NULL,
  PRIMARY KEY (`stocks_id`, `market_id`),
  INDEX `fk_stocks_has_market_day_market_day1_idx` (`market_id` ASC) VISIBLE,
  INDEX `fk_stocks_has_market_day_stocks_idx` (`stocks_id` ASC) VISIBLE,
  CONSTRAINT `fk_stocks_has_market_day_stocks`
    FOREIGN KEY (`stocks_id`)
    REFERENCES `mydb`.`stocks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stocks_has_market_day_market_day1`
    FOREIGN KEY (`market_id`)
    REFERENCES `mydb`.`market_day` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE `dbAssMilestone2_orders` (
  `id` INT NOT NULL,
  `bid_price` DOUBLE NULL,
  `type` VARCHAR(4) NULL,
  `created_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  `status` VARCHAR(20) NULL,
  `bid_volume` INT NULL,
  `executed_volume` INT NULL,
  `users_id` INT NOT NULL,
  `stocks_id` INT NOT NULL,
  PRIMARY KEY (`id`, `users_id`, `stocks_id`),
  INDEX `fk_orders_users1_idx` (`users_id` ASC) VISIBLE,
  INDEX `fk_orders_stocks1_idx` (`stocks_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `mydb`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_stocks1`
    FOREIGN KEY (`stocks_id`)
    REFERENCES `mydb`.`stocks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE `dbAssMilestone2_sectors` (
  `id` int(11) NOT NULL,
  `stock_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dbAssMilestone2_stock` (
  `id` INT NOT NULL,
  `name` VARCHAR(20) NULL,
  `total_volume` INT NULL,
  `unallocated` INT NULL,
  `price` DOUBLE NULL,
  `sectors_id` INT NOT NULL,
  PRIMARY KEY (`id`, `sectors_id`),
  INDEX `fk_stocks_sectors1_idx` (`sectors_id` ASC) VISIBLE,
  CONSTRAINT `fk_stocks_sectors1`
    FOREIGN KEY (`sectors_id`)
    REFERENCES `mydb`.`sectors` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE `dbAssMilestone2_users` (
  `id` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  `email` VARCHAR(50) NULL,
  `available_funds` DOUBLE NULL,
  `blocked_funds` DOUBLE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `dbAssMilestone2_market_day` (
  `id` INT NOT NULL,
  `day` INT NULL,
  `status` VARCHAR(10) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

