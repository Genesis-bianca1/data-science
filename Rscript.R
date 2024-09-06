#Packages for db syncing and pass SQL code
install.packages("DBI")
install.packages("RSQLite")

library(DBI)
library(RSQLite)

#Connecting DB path to RStudio
my_db <- "/Users/genesisvega/Desktop/my_db.db"
mydb <- dbConnect(RSQLite::SQLite(), dbname = my_db)




#Task 3 - Average House Price for Deddington of Cherwell district.

#Logic for years 21-22 averages
Ded_Avg_Hou_Price <-dbGetQuery(mydb, "SELECT 'Deddington' AS Ward,
                              (End_Mar_2021 + End_Jun_2021 + End_Sep_2021 + End_Dec_2021) /4 AS 'Avg House Price 21',
                              (End_Mar_2022 + End_Jun_2022 + End_Sep_2022 + End_Dec_2022) /4 AS 'Avg House Price 22'
                              FROM House_Price_Information AS HPI
                              -- Connects tables via foreign key
                              JOIN Location_Information AS LI 
                              ON HPI.Location_Id = LI.Location_Id
                              -- filter result by ward & district code
                              WHERE LI.Ward_Name = 'Deddington' 
                               AND LI.District_Code= 'E07000177';")
print(Ded_Avg_Hou_Price)




#Task 4 - 2021 to 2022 Average increase/decrease in house prices in Blackbird Leys of City of Oxford district.
Bbleys_Avg_Percent_Diff <- dbGetQuery(mydb, "SELECT
                                      -- Operation
                                      ROUND(AVG(End_Dec_2022 - End_Dec_2021) / AVG(End_Dec_2021) * 100, 2) AS 'Avg % Change'
                                      FROM House_Price_Information AS HPI
                                      -- Connects tables via foreign key
                                      JOIN Location_Information AS LI 
                                      ON HPI.Location_Id = LI.Location_Id
                                      -- filter result by ward & district names
                                      WHERE LI.Ward_Name = 'Blackbird Leys'
                                        AND LI.District_Name = 'Oxford';")

print(Bbleys_Avg_Percent_Diff)




#Task 5 - Find ward within Oxfordshire with the highest house price in a quarter of a year.
# Reveal ward with max price
Max_Houpri_Ward <- dbGetQuery(mydb, "SELECT LI.Ward_name AS Ward,
                              MAX(End_Dec_2022) AS 'Highest House Price in Dec 22'
                              FROM House_Price_Information AS HPI
                              -- Join to retrieve matching ward name
                              JOIN Location_Information AS LI 
                              ON HPI.Location_Id = LI.Location_Id;")

print(Max_Houpri_Ward)




#Task 6 - Superfast availability % in Cholsey of South Oxfordshire district
Chol_Sfast <- dbGetQuery(mydb, "SELECT BI.Superfast_Availability
                          FROM Location_Information AS LI
                          -- Join to retrieve matching ward details
                          JOIN Broadband_Information_2023 AS BI 
                          ON BI.Location_Id = LI.Location_Id
                          WHERE LI.Ward_Name = 'Cholsey'
                            AND LI.District_Code = 'E07000179';")
print(Chol_Sfast)

# Task 6 - Alternative - find through specifying a % figure

particular_Sfast_Avail <- dbGetQuery(mydb, "SELECT  BI.Superfast_Availability, LI.Ward_Code, LI.Ward_Name
                                     FROM Broadband_Information_2023 AS BI
                                     -- Join to retrieve ward details
                                     JOIN Location_Information AS LI 
                                     ON BI.Location_Id = LI.Location_Id
                                     -- Filter by specifying a value %
                                     WHERE BI.Superfast_Availability = '100.00%';")
print(particular_Sfast_Avail)




#Task 7 - Comparing All Districts' Averages: Gigabit Availability, Superfast & Download Speed.
Avg_Broadb_perf <- dbGetQuery(mydb, "SELECT LI.District_Name AS District,
                                -- Calc Averages to 2 decimal points
                                ROUND(AVG(Gigabit_Availability), 2) AS 'Avg Gigabit Availability',
                                ROUND(AVG(Superfast_Availability), 2) AS 'Avg Superfast',
                                ROUND(AVG(Average_Download_Speed), 2) AS 'Avg Download Speed'
                              FROM Broadband_Information_2023 AS BI
                              JOIN Location_Information AS LI 
                              ON BI.Location_Id = LI.Location_Id
                              -- group averages as districts
                              GROUP BY LI.District_Name;")
print(Avg_Broadb_perf)




#Task 8 - Average council tax for Bicester town by band
Avg_Bic_CTax <- dbGetQuery(mydb, "SELECT 'Bicester' AS Town,
                          --Calc avg for Bicester bands
                          AVG(Band_A) AS Avg_Band_A,
                          AVG(Band_B)AS Avg_Band_B,
                          AVG(Band_C) AS Avg_Band_C
                          FROM Council_Tax_Information_2023_24 AS CI
                          -- Match tables to retrieve observations starting with 'Bicester'
                          JOIN Location_Information AS LI 
                          ON CI.Location_Id = LI.Location_Id
						              WHERE Ward_Name LIKE 'Bicester%' AND District_Code = 'E07000177';")
print(Avg_Bic_CTax)




# Task 9 - Difference btwn C.Tax charges of same bands, same district, two diff towns
                            # Define operation to workout & show C.Tax differences 
Avg_CTax_Towns <- dbGetQuery(mydb, "SELECT
                            ROUND (Band_A_1 - Band_A_2, 2) AS 'Band A Difference',
                            ROUND(Band_B_1 - Band_B_2, 2) AS 'Band B Difference',
                            ROUND(Band_C_1 - Band_C_2, 2) AS 'Band C Difference'
                            --Figures above are derived from...
                            FROM(
                            SELECT
                            -- Calc average charge of each town per band
                            AVG(CASE WHEN LI.Ward_Name LIKE 'Abingdon%' THEN Band_A END) AS Band_A_1,
                            AVG(CASE WHEN LI.Ward_Name LIKE 'Wantage%' THEN Band_A END) AS Band_A_2,
                            AVG(CASE WHEN LI.Ward_Name LIKE 'Abingdon%' THEN Band_B END) AS Band_B_1,
                            AVG(CASE WHEN LI.Ward_Name LIKE 'Wantage%' THEN Band_B END) AS Band_B_2,
                            AVG(CASE WHEN LI.Ward_Name LIKE 'Abingdon%' THEN Band_C END) AS Band_C_1,
                            AVG(CASE WHEN LI.Ward_Name LIKE 'Wantage%' THEN Band_C END) AS Band_C_2
                            FROM Council_Tax_Information_2023_24 AS CI
                            JOIN Location_Information AS LI
                            ON CI.Location_Id = LI.Location_Id
                            -- Define district constraint
                            WHERE LI.District_Code = 'E07000180'
                             );")
print(Avg_CTax_Towns)

dbDisconnect(mydb)