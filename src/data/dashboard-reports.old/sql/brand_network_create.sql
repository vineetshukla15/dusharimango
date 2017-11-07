CREATE TABLE dashboard.brand_network (
  airing_date DATE,
  brand_id INT(11),
  brand VARCHAR(100),
  network VARCHAR(100),
  airings INT(11) DEFAULT 0,
  spend INT(11) DEFAULT 0,
  PRIMARY KEY (airing_date, brand_id, network),
  INDEX airing_date_idx (airing_date),
  INDEX brand_idx (brand_id),
  INDEX network_idx (network)
);