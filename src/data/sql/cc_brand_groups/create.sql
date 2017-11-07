DROP TABLE IF EXISTS insights.cc_brand_groups;
CREATE TABLE insights.cc_brand_groups
(
   id INT(10) UNSIGNED, PRIMARY KEY(id),
   topcat VARCHAR(120), INDEX(topcat),
   subcat VARCHAR(120), INDEX(subcat)#,
   #UNIQUE KEY(topcat, subcat) 'Food & Beverage::Pizza' and lot of other topcat::subcat occur multiple times
);

INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (1, 'Food & Beverage', 'Soft Drinks');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (2, 'Food & Beverage', 'Sparkling Water');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (3, 'Food & Beverage', 'Sports Drinks');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (4, 'Food & Beverage', 'Juice');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (5, 'Food & Beverage', 'Energy Drink');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (6, 'Food & Beverage', 'Cereals');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (7, 'Food & Beverage', 'Dairy ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (8, 'Food & Beverage', 'Water');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (9, 'Food & Beverage', 'Beer & Alcohol');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (10, 'Food & Beverage', 'Coffee & Tea');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (11, 'Food & Beverage', 'Peanut Butter');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (12, 'Food & Beverage', 'Crackers & Cookies');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (13, 'Food & Beverage', 'Chips');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (14, 'Food & Beverage', 'Chocolate');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (15, 'Food & Beverage', 'Ice Cream');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (16, 'Food & Beverage', 'Resturants');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (17, 'Food & Beverage', 'Fast Food - Mexican');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (18, 'Food & Beverage', 'Fast Food - Chinese');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (19, 'Food & Beverage', 'Fast Food - Chicken');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (20, 'Food & Beverage', 'Fast Food - Burgers & Fries');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (21, 'Food & Beverage', 'Fast Food - Seafood');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (22, 'Food & Beverage', 'Fast Food - Subs');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (23, 'Food & Beverage', 'Dessert Toppings');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (24, 'Food & Beverage', 'Creamer');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (25, 'Food & Beverage', 'Baby Food');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (26, 'Food & Beverage', 'Snacks');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (27, 'Food & Beverage', 'Sweets');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (28, 'Food & Beverage', 'Eggs');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (29, 'Food & Beverage', 'Pizza');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (30, 'Food & Beverage', 'Spreads');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (31, 'Food & Beverage', 'Pasta & Rice');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (32, 'Food & Beverage', 'Nuts');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (33, 'Food & Beverage', 'condiments');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (34, 'Food & Beverage', 'Hispanic');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (35, 'Food & Beverage', 'Pizza');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (36, 'Food & Beverage', 'Canned Fruit & dried fruit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (37, 'Food & Beverage', 'Meat & Seafood');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (38, 'Food & Beverage', 'Grocery Retailers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (39, 'Food & Beverage', 'Fruits & Vegetables');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (40, 'Food & Beverage', 'Permade meals');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (41, 'Food & Beverage', 'Candy/Gum');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (42, 'Games', 'Board Games');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (43, 'Home & Garden', 'Bedroom');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (44, 'Home & Garden', 'Bathroom');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (45, 'Home & Garden', 'Domestic Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (46, 'Home & Garden', 'Senior Care');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (47, 'Home & Garden', 'Remodeling/Restoation');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (48, 'Home & Garden', 'Home Appliances');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (49, 'Home & Garden', 'Climate Control');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (50, 'Home & Garden', 'Cleaning Supplies & Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (51, 'Home & Garden', 'Kitchen Ware');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (52, 'Home & Garden', 'Small Kitchen Appliances');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (53, 'Home & Garden', 'Major Kitchen Appliances');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (54, 'Home & Garden', 'Locks & Locksmiths');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (55, 'Home & Garden', 'Home Furnishings');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (56, 'Home & Garden', 'Home Improvement');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (57, 'Home & Garden', 'Roofing');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (58, 'Home & Garden', 'Flooring');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (59, 'Home & Garden', 'Storage & Shelving ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (60, 'Home & Garden', 'Painting');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (61, 'Home & Garden', 'Doors & Windows');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (62, 'Home & Garden', 'Hardware Stores');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (63, 'Home & Garden', 'Home Improvement tools');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (64, 'Home & Garden', 'Laundry');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (65, 'Home & Garden', 'General home goods');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (66, 'Home & Garden', 'Batteries');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (67, 'Home & Garden', 'Paper Towels');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (68, 'Home & Garden', 'Pest control');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (69, 'Home & Garden', 'Yard & Garden');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (70, 'Home & Garden', 'Pool & Spa');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (71, 'Home & Garden', 'Patio');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (72, 'Real Estate', 'Real Estate Agencies');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (73, 'Real Estate', 'Property Development');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (74, 'Life & Entertainment', 'Apartments & Residential Retals');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (75, 'Life & Entertainment', 'Kids entertainment');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (76, 'Life & Entertainment', 'Live Entertainment');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (77, 'Life & Entertainment', 'Live Sports Entertainment');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (78, 'Life & Entertainment', 'Museum');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (79, 'Life & Entertainment', 'Wine Tasting');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (80, 'Life & Entertainment', 'Shows & Expo\'s');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (81, 'Life & Entertainment', 'Clubs');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (82, 'Life & Entertainment', 'Theme & Water Parks');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (83, 'Life & Entertainment', 'Bowling');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (84, 'Life & Entertainment', 'Lottery');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (85, 'Life & Entertainment', 'Casino ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (86, 'Life & Entertainment', 'Outdoors');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (87, 'Life & Entertainment', 'Entertainment News');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (88, 'Life & Entertainment', 'Flim and TV');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (89, 'Life & Entertainment', 'Flim and TV');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (90, 'Life & Entertainment', 'Musical Artists');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (91, 'Life & Entertainment', 'Music Equipment');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (92, 'Life & Entertainment', 'Visual Arts');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (93, 'Life & Entertainment', 'Authors/Books');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (94, 'Life & Entertainment', 'Religion');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (95, 'Life & Entertainment', 'Radio');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (96, 'Vehicles & Parts', 'Auto');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (97, 'Vehicles & Parts', 'Recreational');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (98, 'Vehicles & Parts', 'Commercial');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (99, 'Vehicles & Parts', 'Parts/Accessories/Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (100, 'Vehicles & Parts', 'Service Centers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (101, 'Vehicles & Parts', 'Motor Oil');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (102, 'Vehicles & Parts', 'Tires');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (103, 'Vehicles & Parts', 'Auto Interior');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (104, 'Vehicles & Parts', 'Part Retailers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (105, 'Vehicles & Parts', 'Auto Exterior');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (106, 'Vehicles & Parts', 'Vehicle Shopping');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (107, 'Financial Services', 'Insurance');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (108, 'Financial Services', 'Home Insurance');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (109, 'Financial Services', 'Health/Life Insurance');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (110, 'Financial Services', 'Tax Preperation');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (111, 'Financial Services', 'Banking');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (112, 'Financial Services', 'Home financing/refinancing');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (113, 'Financial Services', 'Small Loan');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (114, 'Financial Services', 'Credit ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (115, 'Financial Services', 'Educational Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (116, 'Financial Services', 'Investing');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (117, 'Legal & Law services', 'Lawyers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (118, 'Legal & Law services', 'Lawyers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (119, 'Pharma & Medical', 'Medical Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (120, 'Pharma & Medical', 'Medical Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (121, 'Pharma & Medical', 'Pharmaceuticals Companies');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (122, 'Pharma & Medical', 'Doctors');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (123, 'Pharma & Medical', 'Drugs');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (124, 'Pharma & Medical', 'Vision');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (125, 'Pharma & Medical', 'Dental');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (126, 'Pharma & Medical', 'Denture');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (127, 'Pharma & Medical', 'Hearing');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (128, 'Health & Beauty', 'Face & Body Care');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (129, 'Health & Beauty', 'Face & Body Care');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (130, 'Health & Beauty', 'Hair Care');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (131, 'Health & Beauty', 'Nails');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (132, 'Health & Beauty', 'Make up & cometics');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (133, 'Health & Beauty', 'Pain Relife ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (134, 'Health & Beauty', 'Cold Sore Treatment');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (135, 'Health & Beauty', 'Health Supplements');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (136, 'Health & Beauty', 'Stomach Health');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (137, 'Health & Beauty', 'Heart Burn Medication');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (138, 'Health & Beauty', 'Breathing');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (139, 'Health & Beauty', 'Allergy Relief ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (140, 'Health & Beauty', 'Eye Care');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (141, 'Health & Beauty', 'Itch Relief');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (142, 'Health & Beauty', 'Joint Health');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (143, 'Health & Beauty', 'Sleeping Aid');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (144, 'Health & Beauty', 'feminine care');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (145, 'Health & Beauty', 'Cold & Flu');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (146, 'Health & Beauty', 'Pregnancy Tests');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (147, 'Health & Beauty', 'Nictotine Replacement');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (148, 'Health & Beauty', 'Acen Treatment');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (149, 'Health & Beauty', 'Nasal Care');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (150, 'Health & Beauty', 'Lifestyle');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (151, 'Health & Beauty', 'Braces');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (152, 'Health & Beauty', 'Alert');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (153, 'Health & Beauty', 'Mens Health');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (154, 'Health & Beauty', 'Weight Loss');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (155, 'Health & Beauty', 'Baby');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (156, 'Health & Beauty', 'Rehab');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (157, 'Sporting Goods', 'General Retail');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (158, 'Sporting Goods', 'Soccer Retail');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (159, 'Sporting Goods', 'Football');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (160, 'Sporting Goods', 'Baseball');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (161, 'Sporting Goods', 'Sports Supplements');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (162, 'Sporting Goods', 'People/Professional Teams/Leagues');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (163, 'Sporting Goods', 'Golf Retail');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (164, 'Sporting Goods', 'Camping & Hunting');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (165, 'Sporting Goods', 'Equipment');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (166, 'Sporting Goods', 'Recreational/Gym/Spa');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (167, 'Sporting Goods', 'Racing');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (168, 'Travel', 'Tourist Destinations');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (169, 'Travel', 'Tourist Destinations');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (170, 'Travel', 'Hotels & Motels');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (171, 'Travel', 'Rail & Bus');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (172, 'Travel', 'Car Retnal & Taxi Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (173, 'Travel', 'Air Travel');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (174, 'Travel', 'Travel agencies & services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (175, 'Education & Training', 'Colleges & Universities');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (176, 'Education & Training', 'Standardized & Admissions Test');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (177, 'Education & Training', 'Driving Education');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (178, 'Education & Training', 'Primary and Secondary Education (k-12)');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (179, 'Education & Training', 'Educational Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (180, 'Education & Training', 'Early Childhood education');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (181, 'Retail & Marketplaces', 'Stores');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (182, 'Retail & Marketplaces', 'Marketplaces');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (183, 'Retail & Marketplaces', 'Online Retailers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (184, 'Government & Non-profits', 'Eating Disorders');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (185, 'Government & Non-profits', 'Human rights');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (186, 'Government & Non-profits', 'Medical Non-Profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (187, 'Government & Non-profits', 'Religious Non-Profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (188, 'Government & Non-profits', 'Online ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (189, 'Government & Non-profits', 'Housing Non-Profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (190, 'Government & Non-profits', 'Education Based Non-Profti');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (191, 'Government & Non-profits', 'Environmental Non-Profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (192, 'Government & Non-profits', 'Pet Non-Profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (193, 'Government & Non-profits', 'Music Non-profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (194, 'Government & Non-profits', 'Medical Non-Profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (195, 'Government & Non-profits', 'Veterans non-profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (196, 'Government & Non-profits', 'Wildlife non-profits');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (197, 'Government & Non-profits', 'Kids non-profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (198, 'Government & Non-profits', 'Food Non-profit');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (199, 'Government & Non-profits', 'Lobbying');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (200, 'Government & Non-profits', 'Military');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (201, 'Government & Non-profits', 'Financial   ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (202, 'Government & Non-profits', 'Health');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (203, 'Government & Non-profits', 'Food  ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (204, 'Government & Non-profits', 'politicians');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (205, 'Government & Non-profits', 'International');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (206, 'Government & Non-profits', 'Transportation');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (207, 'Government & Non-profits', 'Recreation');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (208, 'Government & Non-profits', 'Family');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (209, 'Government & Non-profits', 'Labor');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (210, 'Government & Non-profits', 'Public Saftey ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (211, 'Government & Non-profits', 'Laws');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (212, 'Government & Non-profits', 'Office');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (213, 'Electronics & Communication', 'Cell Phone Provider');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (214, 'Electronics & Communication', 'Internet Phone Service');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (215, 'Electronics & Communication', 'Cable, Internet, Phone providers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (216, 'Electronics & Communication', 'Operating system');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (217, 'Electronics & Communication', 'Software');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (218, 'Electronics & Communication', 'Business Software');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (219, 'Electronics & Communication', 'Cyber Security');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (220, 'Electronics & Communication', 'Televisions');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (221, 'Electronics & Communication', 'Computers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (222, 'Electronics & Communication', 'Cases & Covers');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (223, 'Electronics & Communication', 'Video Games');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (224, 'Electronics & Communication', 'Camera');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (225, 'Electronics & Communication', 'Entertainment ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (226, 'Electronics & Communication', 'Navigation');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (227, 'Electronics & Communication', 'Processors');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (228, 'Electronics & Communication', 'Smart Phones');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (229, 'Electronics & Communication', 'Digital Printing');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (230, 'Electronics & Communication', 'Games');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (231, 'Online Services', 'Music Streaming');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (232, 'Online Services', 'Web Development');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (233, 'Online Services', 'Business Related');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (234, 'Online Services', 'On Demand Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (235, 'Online Services', 'Dating');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (236, 'Online Services', 'Social Media');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (237, 'Online Services', 'Educational Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (238, 'Online Services', 'Sports News');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (239, 'Online Services', 'Video Stream');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (240, 'Online Services', 'Review');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (241, 'Online Services', 'Patent');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (242, 'Online Services', 'Subscription Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (243, 'Online Services', 'Online Betting');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (244, 'Online Services', 'Bingo');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (245, 'Online Services', 'Financial Services');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (246, 'Apparel, Accessories & Footwear', 'Fashion');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (247, 'Apparel, Accessories & Footwear', 'Jeans');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (248, 'Apparel, Accessories & Footwear', 'Athletic');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (249, 'Apparel, Accessories & Footwear', 'Adult Casual');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (250, 'Apparel, Accessories & Footwear', 'Young Adult Casual');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (251, 'Apparel, Accessories & Footwear', 'Retail Stores');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (252, 'Apparel, Accessories & Footwear', 'Online Retail  ');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (253, 'Apparel, Accessories & Footwear', 'Bras & Panties');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (254, 'Apparel, Accessories & Footwear', 'Watches');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (255, 'Apparel, Accessories & Footwear', 'Fragrance');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (256, 'Apparel, Accessories & Footwear', 'Accessories');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (257, 'Apparel, Accessories & Footwear', 'Sunglasses');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (258, 'Apparel, Accessories & Footwear', 'Jewelry');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (259, 'Apparel, Accessories & Footwear', 'Lingerie');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (260, 'Apparel, Accessories & Footwear', 'Footware');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (261, 'Apparel, Accessories & Footwear', 'Footware Retail Stores');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (262, 'Apparel, Accessories & Footwear', 'Footware Online Retail');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (263, 'Pet Supplies', 'Pet Food');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (264, 'Pet Supplies', 'Health');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (265, 'Pet Supplies', 'Accessories');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (266, 'Pet Supplies', 'Stores');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (267, 'Toys', 'Arts/Crafts');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (268, 'Toys', 'Boy Toys');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (269, 'Toys', 'Board Games');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (270, 'Business & Industrial', 'Utlities');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (271, 'Business & Industrial', 'Oil');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (272, 'Business & Industrial', 'Convenience Store');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (273, 'Business & Industrial', 'Advertising');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (274, 'Business & Industrial', 'Mail Delivery');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (275, 'Business & Industrial', 'Transportation');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (276, 'Business & Industrial', 'Safety');
INSERT INTO insights.cc_brand_groups (id, topcat, subcat) VALUES (277, 'Business & Industrial', 'Consumer Goods');

SELECT count(*) FROM insights.cc_brand_groups
order by id;