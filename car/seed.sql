DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS component;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS model;
DROP TABLE IF EXISTS brand;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS dealer;
DROP TABLE IF EXISTS customer;

CREATE TABLE IF NOT EXISTS supplier(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL
);
INSERT INTO supplier (name, address) VALUES
('Robert Bosch', 'German'),
('Denso Corp.', 'Japan'),
('ZF Friedrichshafen', 'German'),
('Magna International Inc.', 'Canada'),
('Aisin Corp.', 'Japan'),
('Continental', 'German'),
('Hyundai Mobis', 'South Korea'),
('Faurecia', 'France'),
('Lear Corp.', 'United States'),
('Valeo', 'France');

CREATE TABLE IF NOT EXISTS dealer(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    level INT NOT NULL
);
INSERT INTO dealer (name, address, level) VALUES
('Camimbo', '30134 Main Court', 2),
('Aimbu', '47299 Hoard Avenue', 1),
('Wikibox', '3810 Elmside Trail', 3),
('Meetz', '44 Clarendon Trail', 2),
('Kimia', '9 Artisan Place', 1);

CREATE TABLE IF NOT EXISTS customer(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    sex TEXT NOT NULL,
    income NUMERIC(10, 2) NOT NULL
);
INSERT INTO customer (name, address, phone, sex, income) VALUES
('Brit Couroy', '93 Hansons Street', '375-242-0974', 'unknown', 829816.86),
('Garrik Linzey', '8754 Lighthouse Bay Hill', '331-922-0171', 'male', 294995.06),
('Garrek Netting', '64 Homewood Circle', '281-421-4093', 'female', 362956.4),
('Sal Billsberry', '26 Orin Terrace', '835-480-0677', 'unknown', 629928.45),
('Sylvester Bartolomeo', '4536 La Follette Center', '603-753-7861', 'female', 246344.73),
('Flore Spofforth', '8 Corry Crossing', '963-214-1986', 'male', 744893.87),
('Lowrance Scad', '9 Canary Trail', '111-209-6073', 'female', 839456.41),
('Lion Dakhov', '698 Fallview Road', '968-211-0164', 'male', 963850.77),
('Brose Foskew', '74 Hauk Terrace', '864-411-0788', 'unknown', 315608.26),
('Lee Heller', '90241 Oak Center', '805-631-2902', 'male', 576006.54),
('Kacie Woodstock', '64 School Drive', '590-445-4801', 'unknown', 400679.11),
('Beatrice Gunn', '32 Aberg Hill', '571-354-7705', 'unknown', 171021.94),
('Patin Trinke', '1 Express Terrace', '779-991-9968', 'female', 407844.61),
('Ulrica Tuckerman', '16 Declaration Drive', '926-392-9533', 'female', 639680.0),
('Rosanne Chatt', '0918 Corry Way', '971-369-6355', 'unknown', 104875.44),
('Liuka Handrok', '0 Hazelcrest Lane', '499-678-0035', 'unknown', 923211.83),
('Lonni Crook', '00115 Loftsgordon Trail', '793-186-7434', 'male', 60159.84),
('Sibyl Serjeantson', '18 Sauthoff Pass', '996-173-0577', 'female', 23604.16),
('Jaquenette O''Bruen', '501 Parkside Center', '522-452-5314', 'female', 921779.38),
('Alice Indge', '7099 Reinke Junction', '821-500-4058', 'female', 267579.75);

CREATE TABLE IF NOT EXISTS brand(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
INSERT INTO brand (name) VALUES
('Ford'),
('Toyota'),
('BMW'),
('Honda'),
('Nissan'),
('Buick'),
('Benz'),
('Audi'),
('Chevrolet'),
('Volkswagen');

CREATE TABLE IF NOT EXISTS model(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    brand_id SERIAL REFERENCES brand(id)
);
INSERT INTO model(name, brand_id) VALUES
('EVOS', 1),
('Figo', 1),
('Mirai', 2),
('Starlet', 2),
('I4', 3),
('X7', 3),
('XR-V', 4),
('ZR-V', 4),
('TIIDA', 5),
('NV200', 5),
('Enspire', 6),
('Avenir', 6),
('EQC', 7),
('GLS', 7),
('A3', 8),
('A6', 8),
('Montana', 9),
('Express', 9),
('Passat', 10),
('Nivus', 10);

CREATE TABLE IF NOT EXISTS car(
    id TEXT PRIMARY KEY CHECK(LENGTH(id) = 17),
    color TEXT NOT NULL,
    engine_capacity NUMERIC(2, 1) NOT NULL,
    transmission TEXT NOT NULL,
    model_id SERIAL REFERENCES model(id)
);
INSERT INTO car (id, color, engine_capacity, transmission, model_id) VALUES
('1G4HR54K45U367013', 'Green', 4.8, 'tiptronic', 18),
('1N6AA0CCXEN503288', 'Purple', 1.3, 'manual', 1),
('SALAG2V60FA814511', 'Khaki', 4.7, 'manual', 5),
('WAUFFAFL3CN224853', 'Orange', 2.4, 'tiptronic', 8),
('2C3CDZFJ8FH644666', 'Purple', 3.7, 'dual clutch', 9),
('WAUEF98E47A924046', 'Yellow', 2.4, 'dual clutch', 11),
('4JGBB9FB8AA018253', 'Teal', 4.9, 'tiptronic', 5),
('2T1KU4EE8BC081105', 'Pink', 1.9, 'manual', 18),
('YV1952AS1D1204563', 'Violet', 2.4, 'tiptronic', 11),
('WDDGF4HB8DA743571', 'Violet', 4.4, 'dual clutch', 10),
('SALFR2BG9DH900577', 'Indigo', 4.7, 'dual clutch', 14),
('WBA4A5C57FD572782', 'Violet', 4.2, 'dual clutch', 7),
('YV1672MK5A2557337', 'Turquoise', 2.4, 'automatic', 6),
('19UUA9E5XDA758985', 'Fuscia', 1.3, 'manual', 12),
('1N6AA0CJ0FN252362', 'Aquamarine', 2.7, 'manual', 18),
('1N4AB7APXDN007894', 'Red', 1.8, 'automatic', 11),
('2C3CDXDT9CH013932', 'Violet', 1.2, 'automatic', 8),
('3D73M4CL8BG987112', 'Teal', 1.1, 'dual clutch', 9),
('3VW4A7AT5DM260409', 'Aquamarine', 1.6, 'dual clutch', 12),
('1D7RW3BKXAS694746', 'Puce', 3.4, 'manual', 2);

CREATE TABLE IF NOT EXISTS component(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at DATE NOT NULL,
    supplier_id SERIAL REFERENCES supplier(id),
    car_id TEXT REFERENCES car(id)
);
INSERT INTO component (name, created_at, supplier_id, car_id) VALUES
('battery', '2021-07-04', 4, '1G4HR54K45U367013'),
('radiator', '2021-11-14', 8, '1G4HR54K45U367013'),
('wheel', '2021-03-29', 4, '1G4HR54K45U367013'),
('conveyer belt', '2021-05-30', 3, '1G4HR54K45U367013'),
('battery', '2021-12-15', 10, '1N6AA0CCXEN503288'),
('radiator', '2021-06-23', 9, '1N6AA0CCXEN503288'),
('wheel', '2021-04-21', 8, '1N6AA0CCXEN503288'),
('conveyer belt', '2021-12-16', 6, '1N6AA0CCXEN503288'),
('battery', '2021-05-09', 3, 'SALAG2V60FA814511'),
('radiator', '2021-09-02', 2, 'SALAG2V60FA814511'),
('wheel', '2021-07-27', 9, 'SALAG2V60FA814511'),
('conveyer belt', '2021-09-14', 5, 'SALAG2V60FA814511'),
('battery', '2021-10-25', 1, 'WAUFFAFL3CN224853'),
('radiator', '2021-04-05', 9, 'WAUFFAFL3CN224853'),
('wheel', '2021-04-08', 4, 'WAUFFAFL3CN224853'),
('conveyer belt', '2021-01-22', 6, 'WAUFFAFL3CN224853'),
('battery', '2021-02-19', 9, '2C3CDZFJ8FH644666'),
('radiator', '2021-04-18', 10, '2C3CDZFJ8FH644666'),
('wheel', '2021-08-29', 10, '2C3CDZFJ8FH644666'),
('conveyer belt', '2021-05-10', 1, '2C3CDZFJ8FH644666'),
('battery', '2021-05-01', 5, 'WAUEF98E47A924046'),
('radiator', '2021-01-13', 10, 'WAUEF98E47A924046'),
('wheel', '2021-11-12', 1, 'WAUEF98E47A924046'),
('conveyer belt', '2021-06-02', 10, 'WAUEF98E47A924046'),
('battery', '2021-06-25', 10, '4JGBB9FB8AA018253'),
('radiator', '2021-02-10', 1, '4JGBB9FB8AA018253'),
('wheel', '2021-02-18', 10, '4JGBB9FB8AA018253'),
('conveyer belt', '2021-08-02', 5, '4JGBB9FB8AA018253'),
('battery', '2021-09-11', 5, '2T1KU4EE8BC081105'),
('radiator', '2021-03-25', 5, '2T1KU4EE8BC081105'),
('wheel', '2021-06-25', 7, '2T1KU4EE8BC081105'),
('conveyer belt', '2021-03-10', 8, '2T1KU4EE8BC081105'),
('battery', '2021-04-28', 7, 'YV1952AS1D1204563'),
('radiator', '2021-07-05', 1, 'YV1952AS1D1204563'),
('wheel', '2021-03-16', 7, 'YV1952AS1D1204563'),
('conveyer belt', '2021-05-15', 4, 'YV1952AS1D1204563'),
('battery', '2021-08-12', 5, 'WDDGF4HB8DA743571'),
('radiator', '2021-02-07', 1, 'WDDGF4HB8DA743571'),
('wheel', '2021-10-06', 2, 'WDDGF4HB8DA743571'),
('conveyer belt', '2021-08-30', 1, 'WDDGF4HB8DA743571'),
('battery', '2021-07-04', 2, 'SALFR2BG9DH900577'),
('radiator', '2021-06-30', 4, 'SALFR2BG9DH900577'),
('wheel', '2021-10-11', 3, 'SALFR2BG9DH900577'),
('conveyer belt', '2021-04-10', 5, 'SALFR2BG9DH900577'),
('battery', '2021-05-26', 4, 'WBA4A5C57FD572782'),
('radiator', '2021-06-04', 10, 'WBA4A5C57FD572782'),
('wheel', '2021-11-03', 7, 'WBA4A5C57FD572782'),
('conveyer belt', '2021-11-11', 3, 'WBA4A5C57FD572782'),
('battery', '2021-12-07', 9, 'YV1672MK5A2557337'),
('radiator', '2021-01-15', 7, 'YV1672MK5A2557337'),
('wheel', '2021-03-30', 1, 'YV1672MK5A2557337'),
('conveyer belt', '2021-05-01', 5, 'YV1672MK5A2557337'),
('battery', '2021-11-27', 2, '19UUA9E5XDA758985'),
('radiator', '2021-07-16', 6, '19UUA9E5XDA758985'),
('wheel', '2021-03-20', 4, '19UUA9E5XDA758985'),
('conveyer belt', '2021-11-24', 5, '19UUA9E5XDA758985'),
('battery', '2021-11-16', 1, '1N6AA0CJ0FN252362'),
('radiator', '2021-01-06', 10, '1N6AA0CJ0FN252362'),
('wheel', '2021-11-21', 2, '1N6AA0CJ0FN252362'),
('conveyer belt', '2020-12-24', 10, '1N6AA0CJ0FN252362'),
('battery', '2021-12-13', 6, '1N4AB7APXDN007894'),
('radiator', '2021-06-18', 4, '1N4AB7APXDN007894'),
('wheel', '2021-08-01', 8, '1N4AB7APXDN007894'),
('conveyer belt', '2021-04-06', 3, '1N4AB7APXDN007894'),
('battery', '2021-07-13', 5, '2C3CDXDT9CH013932'),
('radiator', '2021-03-18', 3, '2C3CDXDT9CH013932'),
('wheel', '2021-12-03', 10, '2C3CDXDT9CH013932'),
('conveyer belt', '2021-06-12', 6, '2C3CDXDT9CH013932'),
('battery', '2021-07-28', 8, '3D73M4CL8BG987112'),
('radiator', '2021-05-31', 1, '3D73M4CL8BG987112'),
('wheel', '2021-07-10', 1, '3D73M4CL8BG987112'),
('conveyer belt', '2021-03-04', 4, '3D73M4CL8BG987112'),
('battery', '2021-07-09', 3, '3VW4A7AT5DM260409'),
('radiator', '2021-09-01', 1, '3VW4A7AT5DM260409'),
('wheel', '2021-04-08', 9, '3VW4A7AT5DM260409'),
('conveyer belt', '2021-04-05', 8, '3VW4A7AT5DM260409'),
('battery', '2021-01-26', 2, '1D7RW3BKXAS694746'),
('radiator', '2021-09-19', 7, '1D7RW3BKXAS694746'),
('wheel', '2021-12-14', 8, '1D7RW3BKXAS694746'),
('conveyer belt', '2021-06-12', 8, '1D7RW3BKXAS694746');


CREATE TABLE IF NOT EXISTS transaction(
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    cost NUMERIC(10, 2) NOT NULL,
    car_id TEXT REFERENCES car(id),
    customer_id SERIAL REFERENCES customer(id),
    dealer_id SERIAL REFERENCES dealer(id)
);
INSERT INTO transaction (date, cost, car_id, customer_id, dealer_id) VALUES
('2022-11-13', 51025.04, '1G4HR54K45U367013', 1, 5),
('2021-12-22', 384506.32, '1N6AA0CCXEN503288', 2, 2),
('2022-11-20', 202842.13, 'SALAG2V60FA814511', 3, 3),
('2022-02-28', 297194.89, 'WAUFFAFL3CN224853', 4, 4),
('2022-06-29', 76086.49, '2C3CDZFJ8FH644666', 5, 1),
('2022-05-30', 673641.54, 'WAUEF98E47A924046', 6, 1),
('2022-09-17', 865441.69, '4JGBB9FB8AA018253', 7, 5),
('2022-02-21', 86883.16, '2T1KU4EE8BC081105', 8, 4),
('2022-02-01', 140047.13, 'YV1952AS1D1204563', 9, 3),
('2022-05-23', 394817.77, 'WDDGF4HB8DA743571', 10, 2),
('2022-09-30', 297249.87, 'SALFR2BG9DH900577', 11, 2),
('2022-12-12', 352294.76, 'WBA4A5C57FD572782', 12, 4),
('2022-08-17', 315926.38, 'YV1672MK5A2557337', 13, 3),
('2022-01-24', 992038.11, '19UUA9E5XDA758985', 14, 5),
('2022-06-17', 886037.11, '1N6AA0CJ0FN252362', 15, 1),
('2022-10-07', 875172.55, '1N4AB7APXDN007894', 16, 4),
('2022-06-23', 379733.32, '2C3CDXDT9CH013932', 17, 3),
('2022-03-09', 188306.48, '3D73M4CL8BG987112', 18, 5),
('2022-02-22', 279113.18, '3VW4A7AT5DM260409', 19, 2),
('2022-11-30', 720866.65, '1D7RW3BKXAS694746', 20, 1);
