CREATE TABLE MandateType 
(MandateTypeID int IDENTITY(1,1) PRIMARY KEY,
MandateDescription varchar(500))

CREATE TABLE DatasetCodes 
(Code varchar(10) PRIMARY KEY,
CodeDesc varchar(500))

CREATE TABLE MandateCodeMap
(Code varchar(10) FOREIGN KEY REFERENCES DatasetCodes(Code),
MandateTypeID int FOREIGN KEY REFERENCES MandateType(MandateTypeID),
PRIMARY KEY (Code, MandateTypeID))

CREATE TABLE States
(StateCode char(2) PRIMARY KEY,
StateName varchar(50),
PopulationDensity float,
Population2018 int,
AreaSquareMiles float)

CREATE TABLE StateMandate
(StateMandateID int IDENTITY(1,1) PRIMARY KEY,
StateCode char(2) FOREIGN KEY REFERENCES States(StateCode),
MandateTypeID int FOREIGN KEY REFERENCES MandateType(MandateTypeID),
StartDate date not null,
EndDate date)

CREATE TABLE StateCaseData
(StateCaseDataID int IDENTITY(1,1) PRIMARY KEY,
StateCode char(2) FOREIGN KEY REFERENCES States(StateCode),
SubmissionDate date,
TotalCases int,
ConfirmedCases int,
ProbableCases int,
NewCases int,
ProbableNewCases int,
TotalDeaths int,
ConfirmedDeaths int,
ProbableDeaths int,
NewDeaths int,
ProbableNewDeaths int,
Created date)

--Example Code and Mandate Entry
--State Mandate Table will be filled by importing the dataset
--State Table will also be filled using an import process
insert into DatasetCodes (Code, CodeDesc) values
('FM_ALL','Mandate face mask use by all individuals in public spaces'),
('FM_ALL2','Second mandate for facemasks by all individuals in public places'),
('FM_EMP','Mandate face mask use by employees in public-facing businesses'),
('FM_END','State ended statewide mask use by individuals in public spaces')

insert into MandateType values ('Facemask Order (General Public)'),('Facemask Order (Employees in Public-Facing Businesses)')

select * from MandateType
select * from DatasetCodes

insert into MandateCodeMap (MandateTypeID, Code) values (1, 'FM_ALL'),(1,'FM_ALL2'),(1,'FM_END'),(2,'FM_EMP')