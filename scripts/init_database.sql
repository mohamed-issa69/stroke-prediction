
USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'StrokePrediction')
BEGIN
    ALTER DATABASE StrokePrediction SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE StrokePrediction;
END;
GO


CREATE DATABASE StrokePrediction;

USE StrokePrediction;

CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
