-- Location Information
INSERT INTO "Location_Information" ("District_Name", "District_Code", "Ward_Name", "Ward_Code")
SELECT "Local_authority_name", "Local_authority_code", "Ward_name", "Ward_code"
FROM Unnormalised_Clean_Data;

-- House Price Information
INSERT INTO "House_Price_Information" ("End_Mar_2021", "End_Jun_2021", "End_Sep_2021", "End_Dec_2021", "End_Mar_2022", "End_Jun_2022", "End_Sep_2022", "End_Dec_2022", "Band_2021", "Band_2022")
SELECT "Mar_2021", "Jun_2021", "Sep_2021", "Dec_2021", "Mar_2022", "Jun_2022", "Sep_2022", "Dec_2022", "Band_year_2021", "Band_year_2022"
FROM Unnormalised_Clean_Data;

-- Council Tax Information
INSERT INTO Council_Tax_Information_2023_24 (Calculated_as, Band_A, Band_B, Band_C, Band_D, Band_E, Band_F, Band_G, Band_H)
SELECT "Calculated_as(ct)", B_A, B_B, B_C, B_D, B_E, B_F, B_G, B_H
FROM Unnormalised_Clean_Data;

-- Broadband Information
INSERT INTO Broadband_Information_2023 (Calculated_as, Gigabit_Availability, Superfast_Availability, Average_Download_Speed)
SELECT "Calculated_as(bb)", Gigabit_avail, Superfast_avail, "Avg_download_speed(Mbps)"
FROM Unnormalised_Clean_Data;

