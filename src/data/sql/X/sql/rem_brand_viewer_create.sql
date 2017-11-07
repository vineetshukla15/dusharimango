CREATE TABLE dashboard.brand_viewer (
  brand VARCHAR(100),
  lat FLOAT(5,2),
  lng FLOAT(5,2),
  airing_date DATE,
  viewers INT(10) DEFAULT 0,
  PRIMARY KEY (brand, lat, lng, airing_date),
  INDEX brand_idx (brand),
  INDEX airing_date_idx (airing_date)
);