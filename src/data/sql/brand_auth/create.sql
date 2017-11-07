DROP TABLE IF EXISTS brand_auth;
CREATE TABLE brand_auth
(
   brand_id INT(11) UNSIGNED, INDEX(brand_id),
   username VARCHAR(120), INDEX(username)
);


insert into brand_auth (brand_id, username) values (3396, 'amitkr16@outlook.com');
insert into brand_auth (brand_id, username) values (277, 'amitkr16@outlook.com');
insert into brand_auth (brand_id, username) values (0, 'nik_hils@yahoo.com');
insert into brand_auth (brand_id, username) values (0, 'kodige@gmail.com');
insert into brand_auth (brand_id, username) values (0, 'ashishchordia@gmail.com');
insert into brand_auth (brand_id, username) values (0, 'raghu_kodige@yahoo.com');
insert into brand_auth (brand_id, username) values (0, 'lampros@alphonso.tv');
insert into brand_auth (brand_id, username) values (0, 'scott92363@gmail.com');
insert into brand_auth (brand_id, username) values (0, 'ben.maughan@rovicorp.com');

SELECT * FROM insights.brand_auth;

select count(*) as authorized from brand_auth where (brand_id = 3396 or brand_id = 0)  and username = 'nik_hils@yahoo.com';