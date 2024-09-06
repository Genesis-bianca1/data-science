-- Location Information (Parent)
CREATE TABLE "Location_Information" (
	"Location_Id" INTEGER UNIQUE,
	"District_Name" TINYTEXT,
	"District_Code" VARCHAR(9),
	"Ward_Name" TINYTEXT,
	"Ward_Code" VARCHAR(9),
	PRIMARY KEY("Location_Id"),
	UNIQUE("Location_Id")
);


-- House Price Information (Child)
CREATE TABLE House_Price_Information (
	House_Price_Record_Id INTEGER PRIMARY KEY AUTOINCREMENT,
	Location_Id INTEGER,
	End_Mar_2021 INTEGER,
	End_Jun_2021 INTEGER,
	End_Sep_2021 INTEGER,
	End_Dec_2021 INTEGER,
	End_Mar_2022 INTEGER,
	End_Jun_2022 INTEGER,
	End_Sep_2022 INTEGER,
	End_Dec_2022 INTEGER,
	Band_2021 CHAR(1),
	Band_2022 CHAR(1),
	Council_Tax_Record_Id INTEGER,
	FOREIGN KEY(Council_Tax_Record_Id) REFERENCES "Council_Tax_Information_2023_24" (Council_Tax_Record_Id),
	FOREIGN KEY(Location_Id) REFERENCES Location_Information (Location_Id)
);

-- Council Tax Information (Child)
CREATE TABLE "Council_Tax_Information_2023_24" (
	"Council_Tax_Record_Id"	INTEGER UNIQUE,
	"Location_Id"	INTEGER,
	"Calculated_as"	CHAR(9),
	"Band_A"	NUMERIC(6, 2),
	"Band_B"	NUMERIC(6, 2),
	"Band_C"	NUMERIC(6, 2),
	"Band_D"	NUMERIC(6, 2),
	"Band_E"	NUMERIC(6, 2),
	"Band_F"	NUMERIC(6, 2),
	"Band_G"	NUMERIC(6, 2),
	"Band_H"	NUMERIC(6, 2),
	FOREIGN KEY("Location_Id") REFERENCES "Location_Information"("Location_Id"),
	PRIMARY KEY("Council_Tax_Record_Id")
);

-- Broadband Information (Child)
CREATE TABLE "Broadband_Information_2023" (
	"Broadband_Record_Id" INTEGER,
	"Location_Id" INTEGER,
	"Calculated_as" CHAR(10),
	"Gigabit_Availability" NUMERIC(4, 2),
	"Superfast_Availability"	NUMERIC(4, 2),
	"Average_Download_Speed"	NUMERIC(5, 2),
	PRIMARY KEY("Broadband_Record_Id" AUTOINCREMENT),
	FOREIGN KEY("Location_Id") REFERENCES "Location_Information"("Location_Id")
);
