CREATE SCHEMA IF NOT EXISTS "sh";

CREATE TABLE IF NOT EXISTS "sh".addresses (
   "id" SERIAL PRIMARY KEY,
   "address" varchar(255) NOT NULL,
   "floor" varchar(255) DEFAULT NULL,
   "apartment" varchar(255) DEFAULT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".universities (
   "id" SERIAL PRIMARY KEY,
   "name" varchar(255) NOT NULL,
   "campus" varchar(255) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".carrers (
   "id" SERIAL PRIMARY KEY,
   "name" varchar(255) NOT NULL,
   "abbr" varchar(255) NOT NULL,
   "university_id" bigint CHECK ("university_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_university_id FOREIGN KEY("university_id") REFERENCES "sh".universities("id")
);

CREATE TABLE IF NOT EXISTS "sh".states (
   "id" SERIAL PRIMARY KEY,
   "name" varchar(255) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".cities (
   "id" SERIAL PRIMARY KEY,
   "name" varchar(255) NOT NULL,
   "state_id" bigint CHECK ("state_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_state_id FOREIGN KEY("state_id") REFERENCES "sh".states("id")
);

CREATE TABLE IF NOT EXISTS "sh".concepts (
   "id" SERIAL PRIMARY KEY,
   "percentage_increase" double precision NOT NULL,
   "period_increase" int NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".coordinates (
   "id" SERIAL PRIMARY KEY,
   "lat" double precision NOT NULL,
   "lon" double precision NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".restrictions (
   "id" SERIAL PRIMARY KEY,
   "pets" boolean NOT NULL,
   "smokers" boolean NOT NULL,
   "children" boolean NOT NULL,
   "renter_count" int NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".persons (
   "id" SERIAL PRIMARY KEY,
   "lastname" varchar(255) NOT NULL,
   "firstname" varchar(255) NOT NULL,
   "gender" varchar(255) NOT NULL,
   "birth_date" date DEFAULT NULL,
   "phone" varchar(255) DEFAULT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".owners (
   "id" SERIAL PRIMARY KEY,
   "persons_id" bigint CHECK ("persons_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_persons_id FOREIGN KEY("persons_id") REFERENCES "sh".persons("id")
);

CREATE TABLE IF NOT EXISTS "sh".ownerships_types (
   "id" SERIAL PRIMARY KEY,
   "description" varchar(255) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".ownerships (
   "id" SERIAL PRIMARY KEY,
   "shared" boolean NOT NULL,
   "rooms" int NOT NULL,
   "bathrooms" int NOT NULL,
   "size" int NOT NULL,
   "rating" int NOT NULL,
   "ownerships_state" boolean NOT NULL,
   "ownerships_types_id" bigint CHECK ("ownerships_types_id" >= 0) NOT NULL,
   "owners_id" bigint CHECK ("owners_id" >= 0) NOT NULL,
   "restrictions_id" bigint CHECK ("restrictions_id" >= 0) NOT NULL DEFAULT NULL,
   "coordinates_id" bigint CHECK ("coordinates_id" >= 0) NOT NULL,
   "addresses_id" bigint CHECK ("addresses_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_ownerships_types_id FOREIGN KEY("ownerships_types_id") REFERENCES "sh".ownerships_types("id"),
   CONSTRAINT fk_owners_id FOREIGN KEY("owners_id") REFERENCES "sh".owners("id"),
   CONSTRAINT fk_restrictions_id FOREIGN KEY("restrictions_id") REFERENCES "sh".restrictions("id"),
   CONSTRAINT fk_coordinates_id FOREIGN KEY("coordinates_id") REFERENCES "sh".coordinates("id"),
   CONSTRAINT fk_addresses_id FOREIGN KEY("addresses_id") REFERENCES "sh".addresses("id")
);

CREATE TABLE IF NOT EXISTS "sh".ownerships_images (
   "id" SERIAL PRIMARY KEY,
   "imageurl" varchar(255) NOT NULL,
   "public_id" varchar(255) NOT NULL,
   "ownerships_id" bigint CHECK ("ownerships_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_ownerships_id FOREIGN KEY("ownerships_id") REFERENCES "sh".ownerships("id")
);

CREATE TABLE IF NOT EXISTS "sh".students (
   "id" SERIAL PRIMARY KEY,
   "file_number" bigint NOT NULL,
   "shared" boolean DEFAULT NULL,
   "persons_id" bigint CHECK ("persons_id" >= 0) NOT NULL,
   "carrers_id" bigint CHECK ("carrers_id" >= 0) DEFAULT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_persons_id FOREIGN KEY("persons_id") REFERENCES "sh".persons("id"),
   CONSTRAINT fk_carrers_id FOREIGN KEY("carrers_id") REFERENCES "sh".carrers("id")
);

CREATE TABLE IF NOT EXISTS "sh".rents (
   "id" SERIAL PRIMARY KEY ,
   "start_date" date NOT NULL,
   "end_date" date NOT NULL,
   "ownerships_id" bigint CHECK ("ownerships_id" >= 0) NOT NULL,
   "students_id" bigint CHECK ("students_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_ownerships_id FOREIGN KEY("ownerships_id") REFERENCES "sh".ownerships("id"),
   CONSTRAINT fk_students_id FOREIGN KEY("students_id") REFERENCES "sh".students("id")
);

CREATE TABLE IF NOT EXISTS "sh".prices_rents (
   "id" SERIAL PRIMARY KEY,
   "amount" double precision NOT NULL,
   "datetime" date NOT NULL,
   "rents_id" bigint CHECK ("rents_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_rents_id FOREIGN KEY("rents_id") REFERENCES "sh".rents("id")
);

CREATE TABLE IF NOT EXISTS "sh".publications (
   "id" SERIAL PRIMARY KEY ,
   "title" varchar(255) NOT NULL,
   "description" varchar(255) NOT NULL,
   "datetime" timestamp without time zone NOT NULL,
   "expiration_date" timestamp without time zone DEFAULT NULL,
   "price" double precision NOT NULL,
   "is_furnished" boolean NOT NULL,
   "contact_name" varchar(255) NOT NULL,
   "contact_phone" varchar(255) NOT NULL,
   "contact_email" varchar(255) NOT NULL,
   "publication_state" boolean NOT NULL,
   "ownerships_id" bigint CHECK ("ownerships_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_ownerships_id FOREIGN KEY("ownerships_id") REFERENCES "sh".ownerships("id")
);

CREATE TABLE IF NOT EXISTS "sh".requests (
   "id" SERIAL PRIMARY KEY,
   "request_state" boolean NOT NULL,
   "message" varchar(255) NOT NULL,
   "datetime" date NOT NULL,
   "publications_id" bigint CHECK ("publications_id" >= 0) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_publications_id FOREIGN KEY("publications_id") REFERENCES "sh".publications("id")
);

CREATE TABLE IF NOT EXISTS "sh".user_categories (
   "id" SERIAL PRIMARY KEY,
   "descripcion" varchar(255) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS "sh".users (
   "id" SERIAL PRIMARY KEY,
   "username" varchar(255) NOT NULL,
   "email" varchar(255) NOT NULL,
   "password" varchar(255) NOT NULL,
   "user_status" boolean NOT NULL,
   "remember_token" varchar(100) DEFAULT NULL,
   "persons_id" bigint CHECK ("persons_id" >= 0) NOT NULL,
   "user_categories_id" bigint CHECK ("user_categories_id" >= 0) DEFAULT NULL,
   "avatar" varchar(255) DEFAULT NULL,
   "bio" varchar(255) DEFAULT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL,

   CONSTRAINT fk_user_categories_id FOREIGN KEY("user_categories_id") REFERENCES "sh".user_categories("id")
);

CREATE TABLE IF NOT EXISTS "sh".tags (
   "id" SERIAL PRIMARY KEY,
   "descripcion" varchar(255) NOT NULL,
   "created_at" timestamp WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   "updated_at" timestamp NULL DEFAULT NULL
);

---------------------------------INSERT DATA---------------------------------
INSERT INTO "sh".addresses (id, address, floor, apartment, created_at, updated_at) VALUES
	(1, '3609 Gorczany Crossroad Suite 758\nLefflershire, NH 56188', '7', 'z', now(), NULL),
	(2, '44260 Marie Villages\nSouth Sheldonmouth, AK 88033-9898', '8', 'u', now(), NULL),
	(3, '35892 Welch Stravenue\nWest Meda, AL 69599-9249', '2', 'b', now(), NULL),
	(4, '45511 Donnelly Ranch\nLake Tyreeton, ME 33141', '5', 'k', now(), NULL),
	(5, '25931 Armstrong Mountains Apt. 337\nLornaville, IA 24776', '5', 'j', now(), NULL),
	(6, '99270 Schmeler Radial\nSawaynport, HI 62906', '1', 'e', now(), NULL),
	(7, '83465 Jaylen Prairie\nHeaneyhaven, NH 13680-0045', '8', 'i', now(), NULL),
	(8, '25407 Breanna Squares\nHermannfurt, KS 36178-1031', '5', 'g', now(), NULL),
	(9, '672 Jerde Hill Apt. 885\nPort Landen, MA 02675-7808', '8', 's', now(), NULL),
	(10, '1171 Marlee Gateway\nNew Thalia, AR 64170', '0', 'd', now(), NULL),
	(11, '778 Hintz Common Suite 552\nHayesview, ME 72377-0861', '5', 'z', now(), NULL),
	(12, '2578 Lueilwitz Lakes\nKatlyntown, MT 32197', '1', 'h', now(), NULL),
	(13, '921 Kimberly Crossing Apt. 802\nEast Jerome, VA 51377', '3', 'v', now(), NULL),
	(14, '63060 Hackett Land Apt. 021\nEast Maybell, KY 45101-0646', '7', 'k', now(), NULL),
	(15, '9489 Rohan Extensions Apt. 083\nJordanview, TX 77424-6551', '3', 'k', now(), NULL),
	(16, '8957 Jordon Springs Suite 035\nWest Rigobertoborough, PA 71403', '7', 'k', NULL, NULL),
	(17, '3989 Botsford Inlet Suite 613\nNew Abdullahmouth, CA 98757-4198', '8', 'r', NULL, NULL),
	(18, '69831 Breitenberg Court\nPort Halliechester, FL 36139-0785', '9', 'l', now(), NULL),
	(19, '30083 Fahey Ports\nEichmannborough, TN 16646-8019', '6', 's', now(), NULL),
	(20, '74536 Swift Passage\nLake Joaquinbury, WY 79714-4906', '4', 'z', now(), NULL);

INSERT INTO "sh".universities (id, name, campus, created_at, updated_at) VALUES
	(1, 'Universidad Tecnologica Nacional', 'Regional Tucuman', now(), NULL);

INSERT INTO "sh".carrers (id, name, abbr, university_id, created_at, updated_at) VALUES
	(1, 'Ingeniería en sistemas de información', 'ISI', 1, now(), NULL),
	(2, 'Ingeniería mecánica', 'MEC', 1, now(), NULL),
	(3, 'Ingeniería eléctrica', 'ELE', 1, now(), NULL),
	(4, 'Ingeniería electrónica', 'ELT', 1, now(), NULL),
	(5, 'Ingeniería civil', 'CIV', 1, now(), NULL);

INSERT INTO "sh".states (id, name, created_at, updated_at) VALUES
	(1, 'Montana', now(), NULL),
	(2, 'Utah', now(), NULL),
	(3, 'Pennsylvania', now(), NULL),
	(4, 'Nebraska', now(), NULL),
	(5, 'Connecticut', now(), NULL),
	(6, 'Pennsylvania', now(), NULL),
	(7, 'Oklahoma', now(), NULL),
	(8, 'Pennsylvania', now(), NULL),
	(9, 'Kansas', now(), NULL),
	(10, 'Vermont', now(), NULL),
	(11, 'New York', now(), NULL),
	(12, 'Oklahoma', now(), NULL),
	(13, 'Mississippi', now(), NULL),
	(14, 'Alaska', now(), now()),
	(15, 'Oklahoma', now(), NULL),
	(16, 'Texas', now(), NULL),
	(17, 'Kansas', now(), NULL),
	(18, 'District of Columbia', now(), NULL),
	(19, 'Tucumán', now(), NULL),
	(20, 'North Dakota', now(), NULL);

INSERT INTO "sh".cities (id, name, state_id, created_at, updated_at) VALUES
	(1, 'San Miguel de Tucumán', 19, now(), NULL),
	(2, 'Jovanyport', 3, now(), NULL),
	(3, 'Lake Milton', 16, now(), NULL),
	(4, 'South Jaydaville', 18, now(), NULL),
	(5, 'New Julianneborough', 10, now(), NULL),
	(6, 'Bergnaumbury', 5, now(), NULL),
	(7, 'Romagueramouth', 2, now(), NULL),
	(8, 'Roxanebury', 7, now(), NULL),
	(9, 'Ondrickaview', 12, now(), NULL),
	(10, 'West Odaport', 9, now(), NULL),
	(11, 'Cormierside', 6, now(), NULL),
	(12, 'Ernieside', 7, now(), NULL),
	(13, 'Waltertown', 3, now(), NULL),
	(14, 'Kemmerview', 3, now(), NULL),
	(15, 'Port Burnicechester', 13, now(), NULL),
	(16, 'New Margotside', 3, now(), NULL),
	(17, 'Rohanside', 1, now(), NULL),
	(18, 'Timmothymouth', 10, now(), NULL),
	(19, 'Walkerstad', 18, now(), NULL),
	(20, 'Rennertown', 4, now(), NULL);

INSERT INTO "sh".concepts (id, percentage_increase, period_increase, created_at, updated_at) VALUES
	(1, 56, 4, now(), NULL),
	(2, 41, 7, now(), NULL),
	(3, 12, 8, now(), NULL),
	(4, 40, 5, now(), NULL),
	(5, 87, 7, now(), NULL),
	(6, 96, 3, now(), NULL),
	(7, 63, 7, now(), NULL),
	(8, 69, 4, now(), NULL),
	(9, 57, 8, now(), NULL),
	(10, 37, 9, now(), NULL);

INSERT INTO "sh".coordinates (id, lat, lon, created_at, updated_at) VALUES
	(1, 33.52638300, 138.97612800, now(), NULL),
	(2, 41.35756300, -16.81469700, now(), NULL),
	(3, -29.15581900, 160.97224500, now(), NULL),
	(4, -11.79419400, -147.57951600, now(), NULL),
	(5, -20.43378400, 152.91731500, now(), NULL),
	(6, 34.93618400, -95.93820500, now(), NULL),
	(7, 43.15154100, -168.27769000, now(), NULL),
	(8, 29.53913800, -170.70813000, now(), NULL),
	(9, 22.53595300, -47.73867500, now(), NULL),
	(10, 83.29440300, -142.50902900, now(), NULL),
	(11, -52.56810200, 93.72061000, now(), NULL),
	(12, 61.37010700, -154.46828200, now(), NULL),
	(13, -68.77808600, 149.29773800, now(), NULL),
	(14, 43.42082700, -75.07330600, now(), NULL),
	(15, -84.75815600, 135.93143200, now(), NULL),
	(16, 27.41149200, -102.37042500, now(), NULL),
	(17, 42.48427600, -126.79720600, now(), NULL),
	(18, -65.86576300, 116.55523900, now(), NULL),
	(19, -35.57757900, 51.97452800, now(), NULL),
	(20, 56.23658100, 121.60773400, now(), NULL);

INSERT INTO "sh".persons (id, lastname, firstname, gender, birth_date, phone, created_at, updated_at) VALUES
	(1, 'Altenwerth', 'Edwardo', 'male', '1995-04-13', '+15314181299', now(), NULL),
	(2, 'Jast', 'Nels', 'female', '2002-03-12', '+18138390150', now(), NULL),
	(3, 'Bayer', 'Hershel', 'female', '1995-10-24', '+14453050771', now(), NULL),
	(4, 'Rowe', 'Ewald', 'male', '2013-04-26', '+17733443231', now(), NULL),
	(5, 'Rohan', 'Keara', 'female', '1994-08-30', '+18052246892', now(), NULL),
	(6, 'Kuhlman', 'Ray', 'female', '1984-03-20', '+16514456877', now(), NULL),
	(7, 'Parisian', 'Alanna', 'male', '1993-07-31', '+12069741167', now(), NULL),
	(8, 'Flatley', 'Monroe', 'female', '2003-02-10', '+18120682179', now(), NULL),
	(9, 'Conner', 'Raul', 'female', '1974-11-21', '+16177786830', now(), NULL),
	(10, 'Hettinger', 'Roel', 'female', '1996-04-20', '+12796578908', now(), NULL),
	(11, 'Hermiston', 'Rozella', 'male', '1995-06-14', '+17860402276', now(), NULL),
	(12, 'Kassulke', 'Sydney', 'male', '1974-05-28', '+12691194053', now(), NULL),
	(13, 'Murazik', 'Zakary', 'female', '1994-09-30', '+19060046132', now(), NULL),
	(14, 'Hagenes', 'Marcelle', 'male', '1971-10-30', '+14147712766', now(), NULL),
	(15, 'Sanford', 'Maynard', 'female', '1990-11-06', '+13161260693', now(), NULL),
	(16, 'Howell', 'Lavada', 'female', '1989-03-07', '+12834565756', now(), NULL),
	(17, 'Padberg', 'Adonis', 'female', '2008-02-09', '+14583630393', now(), NULL),
	(18, 'Torphy', 'Terrence', 'female', '1985-01-06', '+14059460873', now(), NULL),
	(19, 'Lueilwitz', 'Mose', 'female', '1996-03-16', '+16304816399', now(), NULL),
	(20, 'Langosh', 'Carson', 'female', '1993-10-17', '+13347302440', now(), NULL);

INSERT INTO "sh".owners (id, persons_id, created_at, updated_at) VALUES
	(1, 1, now(), NULL),
	(2, 2, now(), NULL),
	(3, 3, now(), NULL),
	(4, 4, now(), NULL),
	(5, 5, now(), NULL),
	(6, 6, now(), NULL),
	(7, 7, now(), NULL),
	(8, 8, now(), NULL),
	(9, 9, now(), NULL),
	(10, 10, now(), NULL),
	(11, 11, now(), NULL),
	(12, 12, now(), NULL),
	(13, 13, now(), NULL),
	(14, 14, now(), NULL),
	(15, 15, now(), NULL),
	(16, 16, now(), NULL),
	(17, 17, now(), NULL),
	(18, 18, now(), NULL),
	(19, 19, now(), NULL),
	(20, 20, now(), NULL);

INSERT INTO "sh".ownerships_types (id, description, created_at, updated_at) VALUES
	(1, 'Departamento', now(), NULL),
	(2, 'Casa', now(), NULL);

INSERT INTO "sh".restrictions (id, pets, smokers, children, renter_count, created_at, updated_at) VALUES
	(1, TRUE, FALSE, FALSE, 2, now(), NULL),
	(2, TRUE, FALSE, FALSE, 0, now(), NULL),
	(3, FALSE, FALSE, TRUE, 3, now(), NULL),
	(4, FALSE, TRUE, FALSE, 8, now(), NULL),
	(5, FALSE, FALSE, TRUE, 5, now(), NULL),
	(6, FALSE, TRUE, FALSE, 2, now(), NULL),
	(7, FALSE, FALSE, TRUE, 0, now(), NULL),
	(8, FALSE, TRUE, FALSE, 4, now(), NULL),
	(9, FALSE, FALSE, TRUE, 8, now(), NULL),
	(10, FALSE, FALSE, TRUE, 0, now(), NULL),
	(11, FALSE, FALSE, FALSE, 3, now(), NULL),
	(12, TRUE, TRUE, FALSE, 0, now(), NULL),
	(13, FALSE, FALSE, FALSE, 2, now(), NULL),
	(14, FALSE, TRUE, FALSE, 2, now(), NULL),
	(15, FALSE, TRUE, TRUE, 3, now(), NULL),
	(16, TRUE, TRUE, TRUE, 0, now(), NULL),
	(17, FALSE, FALSE, FALSE, 4, now(), NULL),
	(18, TRUE, FALSE, TRUE, 4, now(), NULL),
	(19, FALSE, FALSE, TRUE, 5, now(), NULL),
	(20, FALSE, TRUE, FALSE, 6, now(), NULL);

INSERT INTO "sh".ownerships (id, shared, rooms, bathrooms, size, rating, ownerships_state, ownerships_types_id, owners_id, restrictions_id, coordinates_id, addresses_id, created_at, updated_at) VALUES
	(1, TRUE, 6, 4, 86, 1, FALSE, 1, 10, 3, 5, 13, now(), NULL),
	(2, FALSE, 2, 2, 40, 2, FALSE, 2, 14, 2, 9, 11, now(), NULL),
	(3, FALSE, 8, 4, 38, 3, TRUE, 1, 14, 3, 7, 2, now(), NULL),
	(4, TRUE, 10, 1, 83, 5, FALSE, 1, 20, 1, 7, 6, now(), NULL),
	(5, FALSE, 5, 3, 37, 3, TRUE, 1, 20, 3, 9, 15, now(), NULL),
	(6, FALSE, 2, 3, 80, 2, TRUE, 2, 18, 1, 12, 10, now(), NULL),
	(7, FALSE, 5, 2, 31, 4, FALSE, 1, 3, 2, 16, 1, now(), NULL);

INSERT INTO "sh".students (id, file_number, shared, persons_id, carrers_id, created_at, updated_at) VALUES
	(1, 4577, FALSE, 1, 2, now(), NULL),
	(2, 4504, TRUE, 2, 3, now(), NULL),
	(3, 8880, TRUE, 3, 4, now(), NULL),
	(4, 1681, FALSE, 4, 1, now(), NULL),
	(5, 1380, FALSE, 5, 5, now(), NULL),
	(6, 3874, TRUE, 6, 5, now(), NULL),
	(7, 3586, FALSE, 7, 5, now(), NULL),
	(8, 6951, TRUE, 8, 2, now(), NULL),
	(9, 8289, TRUE, 9, 2, now(), NULL),
	(10, 3531, TRUE, 10, 5, now(), NULL),
	(11, 6517, FALSE, 11, 1, now(), NULL),
	(12, 8419, FALSE, 12, 1, now(), NULL),
	(13, 1331, FALSE, 13, 4, now(), NULL),
	(14, 5435, TRUE, 14, 4, now(), NULL),
	(15, 7790, TRUE, 15, 2, now(), NULL),
	(16, 1898, FALSE, 16, 2, now(), NULL),
	(17, 2448, FALSE, 17, 4, now(), NULL),
	(18, 7792, TRUE, 18, 2, now(), NULL),
	(19, 5566, FALSE, 19, 3, now(), NULL),
	(20, 1542, TRUE, 20, 3, now(), NULL);

INSERT INTO "sh".rents (id, start_date, end_date, ownerships_id, students_id, created_at, updated_at) VALUES
	(1, now(), '2022-07-02', 1, 13, now(), NULL),
	(2, now(), '2022-05-12', 2, 12, now(), NULL),
	(3, now(), '2022-07-14', 3, 14, now(), NULL),
	(4, now(), '2022-11-30', 4, 13, now(), NULL),
	(5, now(), '2022-06-18', 5, 6, now(), NULL),
	(6, now(), '2022-12-27', 6, 13, now(), NULL),
	(7, now(), '2022-09-24', 7, 1, now(), NULL),
	(8, now(), '2022-06-11', 1, 9, now(), NULL),
	(9, now(), '2022-09-20', 2, 14, now(), NULL),
	(10, now(), '2022-05-21', 3, 2, now(), NULL),
	(11, now(), '2022-05-23', 4, 18, now(), NULL),
	(12, now(), '2022-12-21', 5, 11, now(), NULL),
	(13, now(), '2022-09-13', 6, 1, now(), NULL),
	(14, now(), '2022-09-03', 7, 6, now(), NULL),
	(15, now(), '2022-09-09', 1, 9, now(), NULL),
	(16, now(), '2022-06-27', 2, 13, now(), NULL),
	(17, now(), '2022-11-24', 3, 10, now(), NULL),
	(18, now(), '2022-01-17', 4, 11, now(), NULL),
	(19, now(), '2022-11-29', 5, 11, now(), NULL),
	(20, now(), '2022-07-10', 6, 18, now(), NULL);

INSERT INTO "sh".prices_rents (id, amount, datetime, rents_id, created_at, updated_at) VALUES
	(1, 16288.76, now(), 4, now(), NULL),
	(2, 13442.29, now(), 17, now(), NULL),
	(3, 12313.77, now(), 7, now(), NULL),
	(4, 7721.97, now(), 11, now(), NULL),
	(5, 2356.89, now(), 1, now(), NULL),
	(6, 17556.09, now(), 2, now(), NULL),
	(7, 9352.09, now(), 7, now(), NULL),
	(8, 26844.2, now(), 6, now(), NULL),
	(9, 16959.86, now(), 5, now(), NULL),
	(10, 29730.68, now(), 17, now(), NULL),
	(11, 12090.67, now(), 15, now(), NULL),
	(12, 2610.17, now(), 3, now(), NULL),
	(13, 26315.25, now(), 11, now(), NULL),
	(14, 29176.41, now(), 20, now(), NULL),
	(15, 29804.9, now(), 8, now(), NULL),
	(16, 24770.99, now(), 8, now(), NULL),
	(17, 15895.62, now(), 10, now(), NULL),
	(18, 22198.55, now(), 20, now(), NULL),
	(19, 22081.62, now(), 14, now(), NULL),
	(20, 15487.13, now(), 5, now(), NULL);

INSERT INTO "sh".publications (id, title, description, datetime, expiration_date, price, is_furnished, contact_name, contact_phone, contact_email, publication_state, ownerships_id, created_at, updated_at) VALUES
	(1, 'Voluptatem et est hic.', 'Ut quisquam dicta officiis eaque aspernatur et cumque. Qui fuga qui veniam.', now(), '2022-05-02 00:00:00', 45857.06, FALSE, 'Edmund Macejkovic', '669-773-6217', 'fkohler@hotmail.com', FALSE, 1, now(), NULL),

	(2, 'Dolorum eius est autem.', 'Molestias atque quaerat eligendi incidunt voluptas qui sed. Eaque vero quis molestias culpa.', now(), '2022-05-02 00:00:00', 84843.89, FALSE, 'Miss Idell Kihn DVM', '+1-351-736-4889', 'kunze.devonte@boehm.biz', TRUE, 2, now(), NULL),

	(3, 'Et qui autem est quod.', 'Aliquid id illo soluta dolor. Unde vel debitis iure. Ducimus unde consequatur voluptatibus est.', now(), '2022-05-02 00:00:00', 9513.53, TRUE, 'Miss Beryl Collins', '949-633-5514', 'jakayla.rice@herman.com', TRUE, 3, now(), NULL),

	(4, 'Magnam sunt a est vel.', 'Molestiae sint qui maiores qui optio. Et ut et harum veritatis dolorum.', now(), '2022-05-02 00:00:00', 40690.28, TRUE, 'Damian Ritchie I', '+18163141243', 'ksenger@kulas.com', FALSE, 4, now(), NULL),

	(5, 'Ut natus et et unde.', 'Est rerum eius aliquid libero et rerum. Autem similique laboriosam fugit voluptatum.', now(), '2022-05-02 00:00:00', 19030.93, TRUE, 'Mr. Jettie Christiansen', '+1-608-212-3831', 'jaiden61@hotmail.com', TRUE, 5, now(), NULL),

	(6, 'Aut mollitia et rem.', 'Voluptates error ullam quam sed ullam nostrum. Libero qui veniam dolores.', now(), '2022-05-02 00:00:00', 8234.69, TRUE, 'Felicity Hansen', '+17432352613', 'hosea.kihn@yahoo.com', TRUE, 6, now(), NULL),

	(7, 'Aut natus harum aut.', 'Est velit vero quibusdam quis est quaerat sunt. Omnis quidem inventore id voluptas ab est.', now(), '2022-05-02 00:00:00', 18806.35, FALSE, 'Laisha Towne', '1-316-557-2501', 'mraz.lavern@jast.com', FAlSE, 7, now(), NULL),

	(8, 'In enim est nemo qui ut.', 'Consectetur ab eligendi maiores autem consequatur sequi vero. Cum sit laboriosam ea quia.', now(), '2022-05-02 00:00:00', 59272.69, TRUE, 'Johnson Boyle', '(530) 517-7783', 'jacquelyn.smitham@haley.biz', FALSE, 1, now(), NULL),

	(9, 'Voluptatem quos sunt ea.', 'Corrupti tempora ea ipsum et illum. Omnis voluptate ut aut aspernatur.', now(), '2022-05-02 00:00:00', 43938.92, FALSE, 'Finn Walker', '512-660-9691', 'qfay@kris.com', FALSE, 1, now(), NULL),

	(10, 'Ea et dolor quo aut.', 'Molestiae aut magni in voluptatum voluptas. Sit voluptatem voluptate error dolorem.', now(), '2022-05-02 00:00:00', 96261.34, TRUE, 'Wava Leuschke PhD', '+18283500164', 'gibson.allison@zulauf.com', FALSE, 2, now(), NULL),

	(11, 'Et est ut voluptas.', 'Beatae natus est et a esse molestias. Commodi vero culpa eum. Ut sint est neque dolore.', now(), '2022-05-02 00:00:00', 17820.98, FALSE, 'Prof. Adrian Bauch II', '+1.719.656.1086', 'alena.pollich@johns.biz', TRUE, 3, now(), NULL),

	(12, 'Soluta eos nemo nostrum.', 'Beatae enim minima ab voluptas. Est cupiditate qui fugit officia dolor.', now(), '2022-05-02 00:00:00', 7768.42, TRUE, 'Dr. Anastacio Kovacek', '+1 (251) 777-8428', 'collins.maribel@hotmail.com', TRUE, 4, now(), NULL),

	(13, 'Iste et natus a hic.', 'Non modi voluptas est atque cupiditate sit. Itaque repudiandae sit libero accusamus suscipit.', now(), '2022-05-02 00:00:00', 3040.39, FALSE, 'Daren Cremin', '501.231.9465', 'stacy.rice@jacobs.com', TRUE, 5, now(), NULL),

	(14, 'Impedit aut qui nisi ea.', 'Iure optio minima et quam maxime unde. Sed laborum corporis quos sed ut maxime.', now(), '2022-05-02 00:00:00', 12917.09, TRUE, 'Prof. Gloria Langworth', '1-580-462-5932', 'kane23@hotmail.com', FALSE, 6, now(), NULL),

	(15, 'Ad amet et odio at.', 'Necessitatibus et recusandae vel eius omnis. Odit qui tempora et. Quam in non ducimus.', now(), '2022-05-02 00:00:00', 40181.69, TRUE, 'Shaina Ruecker Jr.', '+1 (520) 687-6658', 'clotilde.heaney@hilpert.biz', FALSE, 7, now(), NULL),

	(16, 'Aliquid unde ea natus.', 'Sed ipsam ex provident maxime est qui. Ipsa non labore ipsam quos velit quos harum.', now(), '2022-05-02 00:00:00', 90344.4, TRUE, 'Mr. Ian Quitzon IV', '337-470-4371', 'virginie.kris@larson.com', TRUE, 1, now(), NULL),

	(17, 'Quibusdam et error unde.', 'Eveniet eos sed fugit autem perferendis. Nulla temporibus quo totam nostrum.', now(), '2022-05-02 00:00:00', 69749.3, FALSE, 'Russ Denesik', '+1.682.218.5763', 'imogene26@gmail.com', TRUE, 2, now(), NULL),

	(18, 'Et placeat et nihil sed.', 'Excepturi est numquam magni repellendus ab occaecati suscipit. Ratione dolores nesciunt hic quia.', now(), '2022-05-02 00:00:00', 89384.79, TRUE, 'Dr. Aiden Kuhn', '276.982.8074', 'ruthe.hahn@yahoo.com', FALSE, 3, now(), NULL),

	(19, 'Id quis iste excepturi.', 'Sit blanditiis temporibus deleniti magnam cumque. Quod quas ut quam. Cum distinctio hic quo.', now(), '2022-05-02 00:00:00', 31555.87, TRUE, 'Jamarcus Fahey', '(931) 622-7040', 'lbode@yahoo.com', TRUE, 4, now(), NULL),

	(20, 'In culpa sunt est est.', 'Amet eius ex doloremque. Tenetur consequuntur quod ab eos aut libero. Autem itaque et eligendi.', now(), '2022-05-02 00:00:00', 80423.67, TRUE, 'Malvina Hintz', '+1-360-962-2015', 'beier.hilbert@mccullough.com', TRUE, 5, now(), NULL);


INSERT INTO "sh".requests (id, request_state, message, datetime, publications_id, created_at, updated_at) VALUES
	(1, TRUE, 'Atque vero recusandae suscipit beatae ea sint. Minima dolorem ut cupiditate id.', now(), 1, now(), NULL),
	(2, FALSE, 'In consequatur et fuga. Doloribus recusandae ut quod tempore. Sed ut qui fugit quidem.', now(), 2, now(), NULL),
	(3, FALSE, 'Minus animi ipsam qui. Eligendi non consequatur et.', now(), 3, now(), NULL),
	(4, FALSE, 'Ut modi earum non voluptas ullam eligendi. Corporis est qui laboriosam consequuntur.', now(), 4, now(), NULL),
	(5, FALSE, 'Non nulla porro ipsam. Ea officiis itaque dolores porro sed. Reprehenderit magnam enim facilis.', now(), 5, now(), NULL),
	(6, FALSE, 'Sit modi maxime vel voluptas accusantium. Nisi expedita maxime inventore repellendus atque quia.', now(), 6, now(), NULL),
	(7, FALSE, 'Eos veniam aut possimus magni. Quia illum qui et voluptatem nulla.', now(), 7, now(), NULL),
	(8, FALSE, 'Aut architecto temporibus quisquam amet. Possimus necessitatibus ab dolorem eaque autem vero.', now(), 8, now(), NULL),
	(9, TRUE, 'Molestiae et itaque et ea numquam ipsam. Et officia praesentium et consequatur sint.', now(), 9, now(), NULL),
	(10, FALSE, 'Architecto et nisi aut quia neque in illum. Aut fugiat illum quo et.', now(), 10, now(), NULL),
	(11, TRUE, 'Ipsum non in dolorem et. Ut et fugit magni aperiam. Perferendis et nulla quas laborum.', now(), 11, now(), NULL),
	(12, FALSE, 'Est nesciunt voluptas et eum. Eum id enim perferendis non.', now(), 12, now(), NULL),
	(13, FALSE, 'Vel non necessitatibus qui occaecati debitis soluta. Architecto molestiae fuga ratione et quia qui.', now(), 13, now(), NULL),
	(14, TRUE, 'Quam quam quia consequatur blanditiis dicta ut voluptatibus. Nobis ea nesciunt laborum aperiam.', now(), 14, now(), NULL),
	(15, FALSE, 'Exercitationem nam est vel voluptas et. Maxime minus minima nesciunt magni recusandae earum.', now(), 15, now(), NULL),
	(16, TRUE, 'Quos deleniti aut id sunt est est aut. Qui autem ipsum est. Enim et consequatur libero et eius.', now(), 16, now(), NULL),
	(17, FALSE, 'Maxime aut reiciendis sint dolore id est. Sed tempora quibusdam aut in.', now(), 17,  now(), NULL),
	(18, TRUE, 'Officiis quibusdam at sequi adipisci. In quibusdam sed natus ex. Ipsa doloremque quaerat ullam.', now(), 18, now(), NULL),
	(19, FALSE, 'Optio voluptatibus nemo perspiciatis rerum est ut. Voluptatem non voluptas dolorem dicta.', now(), 19, now(), NULL),
	(20, TRUE, 'Voluptas ut modi molestiae quos maxime ea vero. Dolor quaerat ut consequatur itaque alias.', now(), 20, now(), NULL);

INSERT INTO "sh".user_categories (id, descripcion, created_at, updated_at) VALUES
	(1, 'Admin', now(), NULL),
	(2, 'Hydrologist', now(), NULL),
	(3, 'Mathematical Science Teacher', now(), NULL),
	(4, 'Audiologist', now(), NULL),
	(5, 'Avionics Technician', now(), NULL),
	(6, 'School Social Worker', now(), NULL);

INSERT INTO "sh".users (id, username, email, password, user_status, remember_token, persons_id, user_categories_id, avatar, bio, created_at, updated_at) VALUES
	(1, 'admin', 'admin@admin.com', '$2y$10$oBIVbHlhN44w4rkTF/d.6eF5Mit5B0WkTS5S0gwAuntcz24fa23Eu', true, NULL, 1, 1, NULL, NULL, now(), NULL);


INSERT INTO "sh".tags (id, descripcion, created_at, updated_at) VALUES
	(1, 'Comedia', now(), NULL),
	(2, 'Entretenimiento', now(), NULL),
	(3, 'Juegos', now(), NULL),
	(4, 'Deporte', now(), NULL),
	(5, 'Baile', now(), NULL),
	(6, 'Animes y cómics', now(), NULL),
	(7, 'Vide cotidiana', now(), NULL),
	(8, 'Automoción y vehículos', now(), NULL),
	(9, 'Música', now(), NULL),
	(10, 'Animales', now(), NULL),
	(11, 'Ciencia y educación', now(), NULL),
	(12, 'Comida y bebida', now(), NULL),
	(13, 'Familia', now(), NULL),
	(14, 'Belleza y estilo', now(), NULL),
	(15, 'Fitness y salud', now(), NULL),
	(16, 'Arte', now(), NULL),
	(17, 'ASMR', now(), NULL),
	(18, 'Hogar y jardín', now(), NULL),
	(19, 'Viajes', now(), NULL),
	(20, 'Actividades al aire libre', now(), NULL);
