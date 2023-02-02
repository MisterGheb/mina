CREATE TABLE `dbAssMilestone2_holdings` (
  `id` int(11) NOT NULL,
  `stock_id` int(11) DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `purchase_price` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dbAssMilestone2_OHLC` (
  `id` int(11) NOT NULL,
  `open` int(11) DEFAULT NULL,
  `close` int(11) DEFAULT NULL,
  `high` int(11) DEFAULT NULL,
  `low` int(11) DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dbAssMilestone2_orders` (
  `id` int(11) NOT NULL,
  `stock_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `purchase_price` int(11) DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dbAssMilestone2_sectors` (
  `id` int(11) NOT NULL,
  `stock_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dbAssMilestone2_stock` (
  `id` int(11) NOT NULL,
  `stock_name` varchar(45) DEFAULT NULL,
  `sector_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dbAssMilestone2_users` (
  `user_id` int(11) NOT NULL,
  `Full Name` varchar(45) DEFAULT NULL,
  `Country of Residence` varchar(45) DEFAULT NULL,
  `stock_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


