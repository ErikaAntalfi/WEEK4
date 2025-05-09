CREATE DATABASE TIGER_WEEK4_LEGO;

CREATE DATABASE _TIGER_WEEK4_GLOBAL_TOOLS;

CREATE OR REPLACE SCHEMA week4_stages;

-- 1. Направете STAGE, който да оперира със съдържанието на CSV файловете

CREATE STAGE _TIGER_WEEK4_GLOBAL_TOOLS.week4_stages.lego_documents;

-- 2. Копирайте файла colors.csv в ТЕМПОРАЛНА таблица

CREATE OR REPLACE TEMPORARY TABLE TIGER_WEEK4_LEGO.lego_colors.temp_colors(
id NUMBER,
name VARCHAR(20),
rgb VARCHAR(6),
is_trans CHAR
);

CREATE OR REPLACE TEMPORARY TABLE TIGER_WEEK4_LEGO.lego_colors.temp_colors
AS 
SELECT  $1 AS id, 
        $2 AS name,
        $3 AS rgb, 
        $4 AS is_trans
FROM @_TIGER_WEEK4_GLOBAL_TOOLS.week4_stages.lego_documents/colors.csv
WHERE 1 = 2;


COPY INTO temp_colors
FROM (
SELECT $1, $2, $3, $4 FROM
@_TIGER_WEEK4_GLOBAL_TOOLS.week4_stages.lego_documents/colors.csv
)
FILE_FORMAT = (
    TYPE =  CSV, SKIP_HEADER = 1
)

SELECT*
FROM temp_colors

-- 3. Създайте нова таблица, която да съдържа само и единствено стойностите на колоните които са дефинирани като is_trans t. Новата таблица не трябва да съдържа колонката is_trans.

SELECT*
FROM temp_colors
WHERE is_trans = 't'

CREATE OR REPLACE TABLE temp_colors_is_trans_t AS
SELECT $1 AS id,$2 AS name, $3 AS rgb
FROM temp_colors
WHERE is_trans = 't'

SELECT* FROM temp_colors_is_trans_t


-- 4. Създайте таблица, td_top_themes_this_month - която да съдържа две колонки theme и count. В един единствен запис добавете бройката на срещания на Star Wars от файла themes.csv

CREATE OR REPLACE TEMPORARY TABLE TIGER_WEEK4_LEGO.lego_colors.temp_themes
AS 
SELECT  $1 AS id, 
        $2 AS name,
        $3 AS parent_id, 
FROM @_TIGER_WEEK4_GLOBAL_TOOLS.week4_stages.lego_documents/themes.csv
WHERE 1 = 2;


COPY INTO temp_themes
FROM (
SELECT $1, $2, $3 FROM
@_TIGER_WEEK4_GLOBAL_TOOLS.week4_stages.lego_documents/themes.csv
)
FILE_FORMAT = (
    TYPE =  CSV, SKIP_HEADER = 1
)

SELECT*
FROM  temp_themes


SELECT COUNT(*) 
FROM temp_themes 
WHERE name = 'Star Wars';



CREATE OR REPLACE TABLE td_top_themes_this_month (
    theme STRING,
    count INT
);


SELECT*
FROM  td_top_themes_this_month


CREATE OR REPLACE TABLE td_top_themes_this_month AS
SELECT 'Star Wars' AS theme, COUNT(*) AS count
FROM temp_themes
WHERE name = 'Star Wars';


SELECT*
FROM  td_top_themes_this_month

CREATE SCHEMA TIGER_WEEK4_LEGO.lego_colors;
CREATE SCHEMA TIGER_WEEK4_LEGO_lego_inventories;
CREATE SCHEMA TIGER_WEEK4_LEGO_lego_inventory_parts;
CREATE SCHEMA TIGER_WEEK4_LEGO_lego_inventory_sets;
CREATE SCHEMA TIGER_WEEK4_LEGO_lego_part_categories;
CREATE SCHEMA TIGER_WEEK4_LEGO_lego_parts;
CREATE SCHEMA TIGER_WEEK4_LEGO_lego_sets;
CREATE SCHEMA TIGER_WEEK4_LEGO_lego_themes;