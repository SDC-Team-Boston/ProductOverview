-- NOTE: Pass these commands into the psql console after table creation!!

-- ALTER TABLE features RENAME COLUMN productId TO product_id;
-- ALTER TABLE related RENAME COLUMN productId TO product_id;
-- ALTER TABLE styles RENAME COLUMN id TO style_id;
-- ALTER TABLE skus RENAME COLUMN styleId TO style_id;
-- ALTER TABLE photos RENAME COLUMN styleId TO style_id;
-- ALTER TABLE styles RENAME COLUMN default_style TO "default?";
-- ALTER TABLE related RENAME COLUMN current_product_id TO "related_product_id";
-- CREATE INDEX indexStyle ON styles("product_id");
-- CREATE INDEX indexPhotos ON photos("style_id");
-- CREATE INDEX indexSkus ON skus("style_id");


---------------------------

-- CREATE DATABASE productoverview;
-- psql alancea -h 127.0.0.1 -d productoverview -f db.sql
-- \c productOverview;
-- DROP TABLE IF EXISTS related;
-- DROP TABLE IF EXISTS features;
-- DROP TABLE IF EXISTS photos;
-- DROP TABLE IF EXISTS skus;
-- DROP TABLE IF EXISTS styles;
-- DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
  id serial,
  name varchar,
  slogan varchar,
  description varchar,
  category varchar,
  default_price varchar,
  "createdAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  "updatedAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  PRIMARY KEY (id)
);

COPY products
FROM
  '/Users/alancea/Desktop/RFC2202/productOverview/db/SDCproductsOverview/sanitized_products.csv' WITH (FORMAT CSV, HEADER true);

-- SELECT * from products limit 10;
-- ALTER TABLE products
-- ADD COLUMN "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
-- ADD COLUMN "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP;

-- ALTER TABLE products DROP COLUMN createdat;
-- ALTER TABLE products DROP COLUMN updatedat;
-- ALTER TABLE products COLUMN updatedAt ON UPDATE CURRENT_TIMESTAMP;

DROP TABLE IF EXISTS styles CASCADE;

CREATE TABLE styles (
  id serial,
  product_id integer,
  name varchar,
  sale_price integer,
  original_price integer,
  default_style varchar(10),
  "createdAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  "updatedAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

COPY styles
FROM
  '/Users/alancea/Desktop/RFC2202/productOverview/db/SDCproductsOverview/sanitized_styles.csv' WITH (FORMAT CSV, HEADER true);

-- SELECT * from styles limit 10;
-- ALTER TABLE styles RENAME COLUMN id TO style_id;

DROP TABLE IF EXISTS skus CASCADE;

CREATE TABLE skus (
  id serial,
  style_id integer,
  size varchar(10),
  quantity integer,
  "createdAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  "updatedAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (style_id) REFERENCES styles(id)
);

COPY skus
FROM
  '/Users/alancea/Desktop/RFC2202/productOverview/db/SDCproductsOverview/skus.csv' WITH (FORMAT CSV, HEADER true, NULL '');

-- SELECT * from skus limit 10;
DROP TABLE IF EXISTS photos CASCADE;

CREATE TABLE photos (
  id serial,
  style_id integer,
  url varchar,
  thumbnail_url varchar,
  "createdAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  "updatedAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  primary key (id),
  foreign key (style_id) REFERENCES styles(id)
);

COPY photos
FROM
  '/Users/alancea/Desktop/RFC2202/productOverview/db/SDCproductsOverview/photos.csv' WITH (FORMAT CSV, HEADER true, NULL '');

-- SELECT * from photos limit 10;
DROP TABLE IF EXISTS features CASCADE;

CREATE TABLE features (
  id serial,
  product_id integer,
  feature varchar,
  value varchar,
  "createdAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  "updatedAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  PRIMARY KEY (id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

COPY features
FROM
  '/Users/alancea/Desktop/RFC2202/productOverview/db/SDCproductsOverview/features.csv' WITH (FORMAT CSV, HEADER true, NULL '');

-- ALTER TABLE skus RENAME COLUMN styleid TO style_id;
-- SELECT * from features limit 10;
DROP TABLE IF EXISTS related CASCADE;

CREATE TABLE related (
  id serial,
  product_id integer,
  related_product_id integer,
  "createdAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  "updatedAt" timestamp WITH TIME ZONE DEFAULT current_timestamp,
  primary key(id),
  foreign key(product_id) references products(id)
);

COPY related
FROM
  '/Users/alancea/Desktop/RFC2202/productOverview/db/SDCproductsOverview/related.csv' WITH (FORMAT CSV, HEADER true, NULL '');



-- SELECT "styles"."style_id", "styles"."name", "styles"."sale_price", "styles"."original_price", "styles"."default?",
-- "photos"."id",
-- "photos"."style_id",
-- "photos"."url",
-- "photos"."thumbnail_url"
-- FROM "styles" AS "styles"
-- LEFT OUTER JOIN "photos" AS "photos"
-- ON "styles"."style_id" = "photos"."style_id"
-- WHERE "styles"."product_id" = '2';


-- SELECT * from related limit 10;

-- INSERT INTO
--   products (
--     product_id,
--     product_name,
--     slogan,
--     description,
--     category,
--     default_price
--   )
-- SELECT
--   products.id AS product_id,
--   products.name AS product_name,
--   products.slogan,
--   products.description,
--   products.category,
--   nullif(products.default_price, '0') :: numeric AS default_price,
--   now() AS created_at,
--   now() AS updated_at
-- FROM products ON CONFLICT (id) DO UPDATE SET
--   product_id = excluded.id,
--   product_name = excluded.name,
--   slogan = excluded.slogan,
--   description = excluded.description,
--   category = excluded.category,
--   default_price = excluded.default_price,
--   updated_at = now()
--   ;