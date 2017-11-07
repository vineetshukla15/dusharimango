CREATE TABLE dashboard.content_brand_network (
  airing_date DATE,
  content_id INT(11),
  content_title VARCHAR(100),
  brand_id INT(11),
  brand VARCHAR(100),
  network VARCHAR(100),
  airings INT(11) DEFAULT 0,
  spend INT(11) DEFAULT 0,
  daypart VARHCHAR(24),
  PRIMARY KEY (airing_date, content_id, brand_id, network),
  INDEX airing_date_idx (airing_date),
  INDEX content_idx (content_id),
  INDEX brand_idx (brand_id),
  INDEX network_idx (network)
);