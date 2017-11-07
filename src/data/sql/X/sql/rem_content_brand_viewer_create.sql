CREATE TABLE dashboard.content_brand_viewer (
  content_id INT(11),
  content_title VARCHAR(100),
  brand VARCHAR(100),
  lat FLOAT(5,2),
  lng FLOAT(5,2),
  airing_date DATE,
  viewers INT(11) DEFAULT 0,
  PRIMARY KEY (content_id, brand, lat, lng, airing_date),
  INDEX content_idx (content_id),
  INDEX brand_idx (brand),
  INDEX airing_date_idx (airing_date)
);