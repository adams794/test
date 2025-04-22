
--------- 1. Co to jest typ danych? ---------

DROP TABLE IF EXISTS test;
CREATE TABLE test (
a VARCHAR(10)
);
-- BEGIN TRANSACTION;
INSERT INTO test(a) VALUES (1), (2), (3), (20), (30), (45);
--COMMIT;

SELECT *
	FROM test
	ORDER BY a;

SELECT *
	FROM test
	WHERE a < '5'; 


--------- 2. Kategorie typów danych ---------


DROP TABLE IF EXISTS test;
CREATE TABLE test (
  a INTEGER
, b NUMERIC(10,2)
, c NUMERIC(10,5)
);
	
-- BEGIN TRANSACTION;
INSERT INTO test(a, b, c) VALUES (5.5456, 5.5456, 5.5456);
-- COMMIT;

SELECT *
FROM test;


--------- 3. Specyfikacja typu tekstowego ---------


DROP TABLE test;
CREATE TABLE test (
  col1 CHAR
, col2 CHAR(2000)
);


INSERT INTO test(col1) VALUES ('a');
INSERT INTO test(col1) VALUES ('aa');


DROP TABLE test;
CREATE TABLE test (
  col1 CHAR
, col2 CHAR(10)
);


INSERT INTO test(col2) VALUES ('aaa');

SELECT *
	FROM test
	WHERE col2 = 'aaa' 
;
		
SELECT *
	FROM test
	WHERE 'a' = 'a  '
		  
SELECT REPLACE(col2, ' ', 'x')
	FROM test
;
		  
INSERT INTO test(col2) VALUES ('aaaxaaaxaa');
INSERT INTO test(col2) VALUES ('aaaxaaaxaaa');
		
-- za znaki ??? podstaw dowolny znak wielobajtowy
INSERT INTO test(col2) VALUES ('????');

DROP TABLE test;
CREATE TABLE test (
	col1 CHAR
, col2 CHAR(10 BYTE)
);

-- za znaki ??? podstaw dowolny znak wielobajtowy
INSERT INTO test(col2) VALUES ('????');
		
-- VARCHAR
DROP TABLE test;
CREATE TABLE test (
	col1 CHAR(20)
, col2 VARCHAR
);

INSERT INTO test(col1, col2) VALUES ('12345678','12345678');


SELECT col1, LEN(col1) AS dl_col1
	 , col2, LEN(col2) AS dl_col2
	FROM test;
		  
-- VARCHAR(MAX)
DROP TABLE test;
CREATE TABLE test (
	col1 VARCHAR(MAX)
);


-- domyślny string
DROP TABLE test;
SELECT 'aaaa'        AS a
	  , N'aaaa'       AS b
	 , '!aaa''aaa!'  AS c
	INTO test;
	
SET QUOTED_IDENTIFIER OFF;

SELECT *
	FROM test;


--------- 4. Funkcje tekstowe ---------


SELECT p.imie 						    		 			AS imie
		 , UPPER(p.imie) 				    		 			AS duze
		 , LOWER(p.imie) 				    		 			AS male
	  -- , INITCAP(p.imie) 				    		 			AS pierwsza_duza
		 , UPPER(SUBSTRING(p.imie,1,1)) + LOWER(SUBSTRING(p.imie, 2, LEN(p.imie)-1))  AS pierwsza_duza
		 , RTRIM(p.imie, 'a') 			    		 			AS usun_a_z_p
		 , LTRIM(p.imie, 'K') 			    		 			AS usun_K_z_l
		 , TRIM(BOTH 'a' FROM p.imie) 	    		 			AS usun_a_z_obu
	  -- , LPAD(p.imie, 10, 'x') 		    		 			AS x_do_10_z_l
		 , RIGHT(REPLICATE('x', 10) + p.imie, 10) 	 			AS x_do_10_z_l
	   --, RPAD(p.imie, 10, 'x') 		    		 			AS x_do_10_z_p
		 , LEFT(p.imie + REPLICATE('x', 10), 10) 				AS x_do_10_z_p
		 , REPLACE(p.imie, 'a', 'X') 	    		 			AS a_na_X
	  -- , TRANSLATE(p.imie, 'an', 'X') 	    	 			AS an_na_X
		 , TRANSLATE(p.imie, 'an', 'X ') 	    	 			AS an_na_X
	  -- , SUBSTR(p.imie, 1, 5) 		    		 			AS pierwsze_5
		 , SUBSTRING(p.imie, 1, 5) 		    		 			AS pierwsze_5
	  -- , INSTR(p.imie, 'a', 1, 2) 		    	 			AS druga_a
		 , CHARINDEX('a', p.imie, 1) 				 			AS pierwsza_a
		 , CHARINDEX('a', p.imie, CHARINDEX('a', p.imie, 1)+1 ) AS druga_a	
		 , CONCAT(p.imie, p.drugie_imie, p.nazwisko) 			AS pelna_nazwa
	  -- , p.imie+p.drugie_imie+p.nazwisko         			AS pelna_nazwa2
	  -- , LENGTH(p.telefon||' ') 					 			AS dl
		 , LEN(p.telefon+' ') 					 	 			AS dl
      -- , LENGTHB('?') 						     			AS dl_b	
         , DATALENGTH('?') 						     			AS dl_b
FROM pracownicy p;


		
SELECT SUBSTRING(k.email
				, CHARINDEX('@', k.email, 1)+1
				, CHARINDEX('.', k.email, CHARINDEX('.', k.email, 1)+1 )  - (CHARINDEX('@', k.email, 1)+1)
				)       AS domena
		, COUNT(*) AS liczba
    FROM klienci k
GROUP BY SUBSTRING(k.email
			, CHARINDEX('@', k.email, 1)+1
			,  CHARINDEX('.', k.email, CHARINDEX('.', k.email, 1)+1 )  - (CHARINDEX('@', k.email, 1)+1)
			)                
ORDER BY liczba DESC;


-- usunięcie "ul. " z adresu
SELECT k.adres
	, LTRIM(adres, 'ul. ')       AS nowy_adres 
	, REPLACE(adres, 'ul. ', '') AS nowy_adres2 
FROM klienci k;

SELECT default_character_set_name 
FROM information_schema.SCHEMATA
WHERE schema_name = 'kurs_sql';


--------- 5. Specyfikacja typu liczbowego ---------

-- limity
DROP TABLE test;
CREATE TABLE test (
  a INTEGER
, b NUMERIC(38)
)
;

INSERT INTO test (a) 
VALUES (REPLICATE('9', 38, '9'));


INSERT INTO test (a) 
VALUES (REPLICATE('99999999999999999999999999999999999999', 126, '0')
);

-- precyzja i skala
DROP TABLE test;
CREATE TABLE test (
	a NUMERIC(5)
, b NUMERIC(5,2)
);

INSERT INTO test (a) 
		VALUES (123)
			,(1234)
			,(12345)
			, (123.1)
			,(123.12)
			,(123.123)
			,(1.123456789);

SELECT *
FROM test;

	
-- domyślny typ liczbowy
DROP TABLE test;
SELECT 1     AS a
		, +1    AS b
		, 1.555 AS c
		, -2.49 AS d
		, 5e6   AS e
	INTO test
;

SELECT *
	FROM test;

	
SELECT CAST(5 AS NUMERIC)/CAST(2 AS NUMERIC);
	
-- praktyczne zadanie
DROP TABLE samochody_tankowania;
CREATE TABLE samochody_tankowania (
	id    INTEGER IDENTITY
, cena1 NUMERIC(38,5)
, cena2 NUMERIC(38,2)
);

SELECT *
FROM samochody_tankowania;

INSERT INTO samochody_tankowania(cena1) 
		VALUES (640.45792)
			,(125.00486)
			,(286.89172)
			, (90.00580)
			, (269.07680)
			, (640.45792)
			,(163.00999)
			, (701.00659)
			,(368.00895)
			,(231.75922);
				
UPDATE samochody_tankowania
	SET cena2 = cena1;

	  
SELECT SUM(cena1) AS prawidlowo
		, SUM(cena2) AS blednie
		, SUM(CAST(cena2 AS NUMERIC(10,5))) - SUM(cena1) AS strata
FROM samochody_tankowania;


--------- 6. Funkcje liczbowe ---------


SELECT w.kwota_brutto 
		, ROUND(w.kwota_brutto, 0) 			AS round_cal
		, ROUND(w.kwota_brutto, 2) 			AS round_2
		, FLOOR(w.kwota_brutto) 			AS floor_cal
		, FLOOR(w.kwota_brutto*10)/10 		AS floor_1
		, CEILING(w.kwota_brutto) 			AS ceil_cal
		, CEILING(w.kwota_brutto*10)/10 	AS ceil_1
		, ROUND(w.kwota_brutto, 1) 			AS trunc_cal
		, ROUND(w.kwota_brutto, 1, 1) 		AS trunc_1
        , ROUND((-1)*w.kwota_brutto, 1) 	AS trunc_m_cal
		, ROUND((-1)*w.kwota_brutto, 1, 1)  AS trunc_m_1
		, ABS(w.kwota_brutto) 				AS absolute
        , ABS((-1)*w.kwota_brutto) 			AS absolute_m
		, SIGN(w.kwota_brutto) 				AS znak
        , SIGN((-1)*w.kwota_brutto) 		AS znak
		, POWER(w.kwota_brutto, 2) 			AS power_2
		, POWER(w.kwota_brutto, 3) 			AS power_3
		, w.kwota_brutto%10 				AS modulo_10
		, w.kwota_brutto%20 				AS modulo_20
FROM wplaty w;
      

SELECT przebieg                         AS przebieg
     , rok_produkcji                    AS rok_produkcji
     , przebieg - rok_produkcji         AS roznica
     , ABS(przebieg - rok_produkcji)    AS roznica_abs
     , SIGN(przebieg - rok_produkcji)  AS roznica_sign
     , CASE 
            WHEN (przebieg - rok_produkcji) >0 THEN 1
            WHEN (przebieg - rok_produkcji)  = 0 THEN 0
            ELSE -1
        END                             AS roznica_sign 
FROM samochody
WHERE id_samochodu <= 10;
  
  
SELECT a.chunk, COUNT(*)
FROM (
SELECT ROW_NUMBER() OVER(ORDER BY w.id_wplaty) 		 AS lp
    , ROW_NUMBER() OVER(ORDER BY w.id_wplaty)%4 AS chunk
    , w.*
FROM wplaty w
) a
GROUP BY a.chunk
ORDER BY a.chunk;


--------- 7. Specyfikacja typu daty ---------


DROP TABLE test;
CREATE TABLE test (
	t_data_czas		TIME
, t_data 			DATE
, t_timestamp 		DATETIME2
, t_timestamp_tz 	DATETIMEOFFSET 
);

SELECT *
FROM test;
	
DBCC useroptions
	
INSERT INTO test (t_data_czas
				, t_data
				, t_timestamp
				, t_timestamp_tz)
		VALUES (CAST('14:15:05' AS TIME)
			, CAST('2023-11-29 14:15:05.125648' AS DATE)
			, CAST('2023-11-29 14:15:05.125648' AS DATETIME2)
			, CAST('2023-11-29 14:15:05.125648 +01:0' AS DATETIMEOFFSET)
				);


--------- 8. Praca z datą i czasem ---------


SELECT 1999-01-08
, '1999-01-08'
, CAST('1999-01-08' AS DATE)
;
	  
SELECT *
FROM transakcje;
  
SELECT *
FROM transakcje
-- WHERE data BETWEEN CAST('2022-01-01' AS DATE) AND CAST('2022-12-31' AS DATE)
--   WHERE data >= CAST('2022-01-01' AS DATE) 
--     AND data <= CAST('2022-12-31' AS DATE)
;   
	
SELECT GETDATE()                         AS teraz
, GETDATE() +5						AS data_5d
--  , GETDATE()  + INTERVAL '5' DAY 		AS data_5d2
, GETDATE() +5/24                    AS data_5h
--  , GETDATE()  + INTERVAL '5' HOUR     AS data_5h2
, GETDATE()  + 5/(24*60)             AS data_5min
--  , GETDATE()  + INTERVAL '5' MINUTE   AS data_5min2
	  
/*
SYSDATETIME()                         AS teraz
--  , SYSDATETIME()+5						 AS data_5d
, SYSDATETIME() + INTERVAL '5' DAY 	 AS data_5d2
--   , SYSDATETIME()+5/24                    AS data_5h
, SYSDATETIME() + INTERVAL '5' HOUR     AS data_5h2
--  , SYSDATETIME() + 5/(24*60)             AS data_5min
, SYSDATETIME() + INTERVAL '5' MINUTE   AS data_5min2
*/
;
  
SELECT SYSDATETIME()		AS czas_serwera_datetime2  -- to samo co GETDATE(datetime) i CURRENT_TIMESTAMP tylko większa precyzja
	, SYSUTCDATETIME()	AS czas_serwera_datetime2_utc -- to samo co GETUTCDATE(datetime) tylko wiêksza precyzja
	, SYSDATETIMEOFFSET() AS czas_serwera_datetimeoffset
	, CURRENT_TIMEZONE()  AS strefa_czasowa
	, SYSDATETIMEOFFSET() AT TIME ZONE 'Pacific Standard Time' AS konwersja
	;


--------- 9. Funkcja daty ---------


-- DATEADD
SELECT t.data
	, DATEADD(MONTH, 5, t.data)   AS plus5
	, DATEADD(MONTH, -5, t.data)  AS minus5
	, DATEADD(YEAR, 2, t.data)    AS plus_2y
	--
	, DATEADD(MONTH, 12, CAST('2023-02-28' AS DATETIME2))   AS rok_przestepny
	, CAST('2023-02-28' AS DATETIME) + 365                  AS rok_przestepny2
FROM transakcje t 
;

-- DATEDIFF
SELECT DATEDIFF (MONTH, CAST('2024-01-31' AS DATETIME2), CAST('2023-01-31' AS DATETIME2) ) AS funkcja
--   , CAST('2024-01-31' AS DATETIME) -  CAST('2023-01-31' AS DATETIME)                 AS operator
	, DATEDIFF (MONTH,  CAST('2024-01-31' AS DATETIME2),  CAST('2023-01-31' AS DATETIME2) ) AS funkcja2
--   , CAST('2024-01-31' AS DATETIME) -  CAST('2023-01-31' AS DATETIME)               AS operator2
	, DATEDIFF (MONTH,  CAST('2024-01-31' AS DATETIME2),  CAST('2023-01-31' AS DATETIME2) ) AS funkcja3
--    , CAST('2024-01-31' AS DATETIME) -  CAST('2023-01-31' AS DATETIME)             AS operator3;
		   
-- DATETRUNC
SELECT  SYSDATETIME()					AS data
		, DATETRUNC(YEAR, SYSDATETIME())	AS rok
		, DATETRUNC(MONTH, SYSDATETIME())	AS miesiac
		, DATETRUNC(DAY, SYSDATETIME())	AS dzien
		, DATETRUNC(HOUR, SYSDATETIME())	AS godzina
-- alternatywa do ROUND/CEIL    
		, DATETRUNC(YEAR, DATEADD(MONTH, 6, SYSDATETIME()))	AS rok_round
		, DATETRUNC(YEAR, DATEADD(MONTH, 12, SYSDATETIME()))	AS rok_ceil
		;
				 
SELECT t.*, DATEDIFF(MONTH, t.data, SYSDATETIME()) AS roznica
FROM transakcje t
WHERE  DATEDIFF(MONTH, t.data, SYSDATETIME()) >=15
ORDER BY roznica DESC
;
 
-- LAST_DAY, NEXT_DAY  
SELECT @@DATEFIRST;
SET DATEFIRST 1 ;  

SELECT t.data
	, EOMONTH(t.data) AS last_day
	,  DATEADD(
				day
				, ( 1 + 7 - DATEPART (dw, DATEADD(day, 1, t.data) ))%7
				, DATEADD(day, 1, t.data) 
				)AS next_monday
	,  DATEADD(
				day
				, ( 1 + 7 - DATEPART (dw, DATEADD(day, 1, t.data) ))%7
				, DATEADD(day, 7, t.data) 
				)AS next_monday
	FROM transakcje t 
	WHERE id_transakcji = 14;
			 
-- DATEPART
SELECT SYSDATETIME()						AS data
	, DATEPART (SECOND, SYSDATETIME())		AS sekunda
	, DATEPART (MINUTE, SYSDATETIME())	 	AS minuta
	, DATEPART (HOUR, SYSDATETIME()) 		AS godzina
	, DATEPART (DAY, SYSDATETIME()) 		AS dzien
	, DATEPART (MONTH, SYSDATETIME()) 		AS miesiac
	, DATEPART (YEAR, SYSDATETIME()) 		AS rok
	, DATEPART (tzoffset, SYSDATETIME()) 	AS strefa_czasowa
	--
	, YEAR(SYSDATETIME())					AS rok2
	, MONTH(SYSDATETIME())					AS miesiac2
	, DAY(SYSDATETIME())					AS dzien2
	--
	, DATENAME (SECOND, SYSDATETIME()) 		AS sekunda
	, DATENAME (MINUTE, SYSDATETIME()) 		AS minuta
	, DATENAME (HOUR, SYSDATETIME()) 		AS godzina
	, DATENAME (DAY, SYSDATETIME()) 		AS dzien
	, DATENAME (MONTH, SYSDATETIME()) 		AS miesiac
	, DATENAME (YEAR, SYSDATETIME()) 		AS rok
	;

-- zadanie praktyczne
SELECT w.*					
	, DATEADD(day
				, ( 1 + 7 - DATEPART (dw, DATEADD(DAY, 1, w.data_wplaty) ))%7
				, DATEADD(DAY, 1, w.data_wplaty) 
				)AS data_od
	,DATEADD(DAY
		, -1
		, DATETRUNC(YEAR
				, DATEADD(YEAR, 1, w.data_wplaty) 
				) 
				)
				AS data_do
	, DATEDIFF(DAY
		, DATEADD(day
				, ( 1 + 7 - DATEPART (dw, DATEADD(DAY, 1, w.data_wplaty) ))%7
				, DATEADD(DAY, 1, w.data_wplaty) 
				)
		, DATEADD(DAY
				, -1
				, DATETRUNC(YEAR
						, DATEADD(YEAR, 1, w.data_wplaty) 
						) 
						)
				)AS roznica
FROM wplaty w
WHERE w.id_wplaty = 26
;


--------- 10. Typ danych BOOLEAN ---------


DROP TABLE test_boolean;

CREATE TABLE test_boolean (
	id        		INTEGER IDENTITY
	, rekord_aktywny 	BIT
	, rekord_aktywny2 	BIT
);

INSERT INTO test_boolean (rekord_aktywny, rekord_aktywny2) 
		VALUES(1, 0)
			, (2, -2)
			, (750, 0)
			, (10000, 0)
			,(NULL, NULL);

SELECT *
FROM test_boolean
WHERE rekord_aktywny = 1
--WHERE rekord_aktywny2 = 0
;
			  
SELECT *
FROM samochody;
				
ALTER TABLE samochody
ADD zarezerowany BIT
	, sprzedany BIT
;


--------- 11. Funkcje logiczne ---------


SELECT p.id_pracownika
    , CASE id_pracownika
    WHEN 1 THEN 'jeden'
    WHEN 2 THEN 'dwa'
    WHEN 3 THEN 'trzy'
    ELSE 'ponad 4'
    END AS simple_case
    , CASE 
    WHEN id_pracownika=1 THEN 'jeden'
    WHEN id_pracownika=2 THEN 'dwa'
    WHEN id_pracownika=3 THEN 'trzy'
    ELSE 'ponad 4'
    END AS searched_case
FROM pracownicy p;
  
  
SELECT s.id_samochodu
     , DATEPART(YEAR, SYSDATETIME()) AS rok_aktualny
     , s.rok_produkcji
     , DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji AS wiek_auta
     , CASE DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji
            WHEN 0 THEN 'nowe'
            WHEN 1 THEN 'nowe'
            WHEN 2 THEN 'kilkuletnie'
            WHEN 3 THEN 'kilkuletnie'
            WHEN 4 THEN 'kilkuletnie'
            WHEN 5 THEN '5-10 lat'
            WHEN 6 THEN '5-10 lat'
            WHEN 7 THEN '5-10 lat'
            WHEN 8 THEN '5-10 lat'
            WHEN 9 THEN '5-10 lat'
            WHEN 10 THEN '5-10 lat'
            ELSE 'stare'
        END AS kategoria_wiekowa_simple_case
     , CASE 
        WHEN DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji <= 1 THEN 'nowe'
        WHEN DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji BETWEEN 2 AND 4 THEN 'kilkuletnie'
        WHEN DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji BETWEEN 5 AND 10 THEN '5-10 lat'
        ELSE 'stare'
       END AS kategoria_wiekowa_searched_case
    FROM samochody s
  ORDER BY wiek_auta DESC  
;


UPDATE samochody
SET rok_produkcji = rok_produkcji +3
WHERE id_samochodu IN (23, 12, 105);
  
  
SELECT s.id_samochodu
    , DATEPART(YEAR, SYSDATETIME()) AS rok_aktualny
    , s.rok_produkcji
    , DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji AS wiek_auta
    , przebieg
    , CASE 
    WHEN DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji <= 1 AND s.przebieg > 2000 THEN 'prawie nowe'
	WHEN DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji <= 1 THEN 'nowe'
    WHEN DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji BETWEEN 2 AND 4 THEN 'kilkuletnie'
    WHEN DATEPART(YEAR, SYSDATETIME()) - s.rok_produkcji BETWEEN 5 AND 10 THEN '5-10 lat'
    ELSE 'stare'
    END AS kategoria_wiekowa_searched_case
FROM samochody s
ORDER BY wiek_auta ASC, przebieg ASC
    ;
	
--IIF
SELECT p.id_pracownika
	, IIF(p.id_pracownika > 5
		, 'Prawda'
		, 'Fałsz'
		)
	, IIF(NULL=NULL
	, 'Prawda'
	, 'Fałsz'
	)
FROM pracownicy p;


--------- 12. Funkcje do pracy z NULL ---------


SELECT p.id_pracownika
	, p.imie
	, p.drugie_imie
	, p.nazwisko
	--  , NVL(p.drugie_imie, 'brak')             AS drugie_imie_n
	, COALESCE(p.drugie_imie, 'brak')        AS drugie_imie_c
	-- , NVL(p.drugie_imie, p.nazwisko)         AS nazwa_n
	-- , COALESCE(p.drugie_imie, p.nazwisko)    AS nazwa_c
	, CASE
		WHEN p.drugie_imie IS NULL THEN 'brak'
		ELSE p.drugie_imie
	END                                     AS case_exp
FROM pracownicy p;
	  

-- COALESCE vs NVL
SELECT COALESCE(NULL,2,4,5,6)
--	, NVL(NULL,2,4,5,6)
;

	  
SELECT p.id_pracownika
, p.imie
, p.drugie_imie
, p.nazwisko
, p.imie +'-'+p.drugie_imie+'-'+p.nazwisko AS opcja1
--  , p.imie +NVL2(p.drugie_imie, '-'+p.drugie_imie, NULL)+'-'+p.nazwisko AS opcja1
FROM pracownicy p;

-- NULLIF
SELECT p.id_pracownika
	, NULLIF(p.id_pracownika, 1) AS nullifff
	, CASE p.id_pracownika
		WHEN 1 THEN NULL
		ELSE p.id_pracownika
	END AS caseee
FROM pracownicy p;

SELECT p.id_pracownika
, p.imie
, p.drugie_imie
, p.nazwisko
, NULLIF(p.drugie_imie, 'brak')          AS drugie_imie_n
, COALESCE(p.drugie_imie, 'brak')        AS drugie_imie_c
, NULLIF(NULLIF(p.drugie_imie, 'brak')
	, COALESCE(p.drugie_imie, 'brak') 
	)                                   AS porownanie
FROM pracownicy p;


--------- 13. Funkcje systemowe/informacyjne ---------


SELECT 
		  @@servername  AS serwer
		, @@servicename AS instancja
		, app_name()	AS klient
		, db_name()		AS nazwa_bazy
		, @@version		AS wersja_bazy
		, schema_name() AS schemat
		, current_user	AS uzytkownik
		, @@language	AS jezyk;


--------- 14. Konwersja typów danych ---------


-- przykłady niejawnej konwersji
SELECT k.*
	-- , 'identyfikator: '+k.id_klienta             AS ident1
		, 'identyfikator: '+CAST(k.id_klienta AS VARCHAR)    AS ident2
FROM klienci k;

SELECT CASE
		WHEN '2' > '10' THEN 'TRUE'
		ELSE 'FALSE'
		END AS tekst
		, CASE
		WHEN 2 > 10 THEN 'TRUE'
		ELSE 'FALSE'
		END AS liczba
		, CASE
		WHEN '2' > 10 THEN 'TRUE'
		ELSE 'FALSE'
		END AS mix1
		, CASE
		WHEN 2 > '10' THEN 'TRUE'
		ELSE 'FALSE'
		END AS mix2
;

SELECT *
FROM transakcje
WHERE '2' > '10';

SELECT 5 + '7';

-- CAST
SELECT CAST('29801' AS NUMERIC)                                   AS c_to_num
	, CAST(129 AS VARCHAR(3))                                    AS c_to_var
	, CAST('2024-05-12' AS DATE)                                 AS c_to_date
	, CAST('2024-05-12 05:52:19' AS DATETIME)                    AS c_to_timestamp
	, CAST('2024-05-12 05:52:19 AM +05:15' AS DATETIMEOFFSET)    AS c_to_timestamp_tz
;

SELECT CONVERT(NVARCHAR, SYSDATETIME(), 0)
	 , CONVERT(NVARCHAR, SYSDATETIME(), 104)
	 , CONVERT(NVARCHAR, SYSDATETIME(), 126);

			
SELECT CAST(
FORMAT(CAST('20240512' AS DATE), 'yyyy-dd-MM') AS DATE
);
SELECT CAST(LEFT('20240512',4)+RIGHT('20240512',2)+SUBSTRING('20240512',5,2) AS DATE);


SELECT TIMEFROMPARTS ( 23, 59, 59, 0, 0 ) AS time
	 , DATEFROMPARTS ( 2025, 12, 31 ) AS data
	 , DATETIME2FROMPARTS ( 2025, 12, 31, 23, 59, 59, 0, 0 ) AS datetime
     , DATETIMEOFFSETFROMPARTS ( 2025, 12, 31, 14, 23, 23, 0, 12, 0, 7 ) AS datetimeoffset;    
				
SELECT PARSE('800zł' AS MONEY USING 'Pl-PL');
	
		  
	-- przydatność CAST 
DROP TABLE kontrahenci;
SELECT 'Janusz' AS imie
		--, NULL   AS drugie_imie
		, 98051712345 AS pesel
INTO kontrahenci	  
;


INSERT INTO kontrahenci(imie, pesel) VALUES ('Krzysztof', '00012412345');
INSERT INTO kontrahenci(imie, pesel) VALUES ('Janina', '00012412345');

SELECT *
FROM kontrahenci;

SELECT CAST('Janusz' AS VARCHAR2(20))      AS imie
	, CAST(NULL AS VARCHAR2(20))          AS drugie_imie
	, CAST(98051712345 AS VARCHAR2(11))   AS pesel;
			  
		
-- problem z debugowaniem
DESC klienci;

SELECT k.*
	, CAST(k.telefon AS INTEGER) AS tel_liczba
FROM klienci k;

UPDATE klienci
	SET telefon = '3332O2111'
WHERE telefon = '333222111';
		   
--  COMMIT;
		  
SELECT CAST(telefon AS INTEGER)
FROM klienci
WHERE id_klienta > 15
;

UPDATE klienci
SET telefon = REPLACE(telefon, 'O', 0)
WHERE id_klienta = 5;
		 
COMMIT;


--------- 15. Zagnieżdżanie funkcji ---------


SELECT SUBSTRING(k.email
		, CHARINDEX('@', k.email, 1)+1
		,  CHARINDEX('.', k.email, CHARINDEX('.', k.email, 1)+1 )  - (CHARINDEX('@', k.email, 1)+1)
		)       AS domena
		, COUNT(*) AS liczba
FROM klienci k
GROUP BY SUBSTRING(k.email
		, CHARINDEX('@', k.email, 1)+1
		,  CHARINDEX('.', k.email, CHARINDEX('.', k.email, 1)+1 )  - (CHARINDEX('@', k.email, 1)+1)
		)                
ORDER BY liczba DESC
;

SELECT imie										AS imie
	, LEN(imie)								AS dlugosc
	, CASE
	WHEN LEN(imie) < 5 THEN 'krótkie'
	WHEN LEN(imie) BETWEEN 5 AND 8 THEN 'œrednie'
	ELSE 'd³ugie'
	END 										AS kategoria
FROM klienci;