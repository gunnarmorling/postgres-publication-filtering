CREATE SCHEMA inventory;
SET search_path TO inventory;

CREATE TABLE products (
  id SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(512),
  weight FLOAT,
  quantity INTEGER NOT NULL
);
ALTER SEQUENCE products_id_seq RESTART WITH 101;
ALTER TABLE products REPLICA IDENTITY FULL;

INSERT INTO products
VALUES (default,'scooter','Small 2-wheel scooter',3.14, 5),
       (default,'car battery','12V car battery',8.1, 10),
       (default,'12-pack drill bits','12-pack of drill bits with sizes ranging from #40 to #3',0.8, 44),
       (default,'hammer','12oz carpenter''s hammer',0.75, 12),
       (default,'hammer','14oz carpenter''s hammer',0.875, 42),
       (default,'hammer','16oz carpenter''s hammer',1.0, 37),
       (default,'rocks','box of assorted rocks',5.3, 9),
       (default,'jacket','water resistent black wind breaker',0.1, 19),
       (default,'spare tire','24 inch spare tire',22.2, 28);

CREATE TABLE customers (
  id SERIAL NOT NULL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  avatar BYTEA
);
ALTER SEQUENCE customers_id_seq RESTART WITH 1001;
ALTER TABLE customers REPLICA IDENTITY FULL;

INSERT INTO customers
VALUES (default,'Sally','Thomas','sally.thomas@acme.com', null),
       (default,'George','Bailey','gbailey@foobar.com', null),
       (default,'Edward','Walker','ed@walker.com', null),
       (default,'Anne','Kretchmar','annek@noanswer.org', null);
