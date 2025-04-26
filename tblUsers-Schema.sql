CREATE TABLE tblUsers
(
    -- Numeric Types
    UserId INT IDENTITY(1,1) PRIMARY KEY,   -- int
    SmallNumber SMALLINT,                   -- smallint
    TinyNumber TINYINT,                     -- tinyint
    BigNumber BIGINT,                       -- bigint
    MoneyAmount MONEY,                      -- money
    SmallMoneyAmount SMALLMONEY,             -- smallmoney
    DecimalValue DECIMAL(18, 4),             -- decimal
    NumericValue NUMERIC(18, 4),             -- numeric (same as decimal)
    FloatValue FLOAT,                        -- float
    RealValue REAL,                          -- real
    BitValue BIT,                            -- bit (boolean)

    -- Character Types
    Username VARCHAR(100),                   -- varchar
    PasswordHash CHAR(64),                   -- char
    FullName NVARCHAR(200),                  -- nvarchar
    NationalId NCHAR(20),                    -- nchar
    Bio TEXT,                                -- text (deprecated, but still seen)

    -- Date and Time Types
    DateOfBirth DATE,                        -- date
    RegistrationDate DATETIME,               -- datetime
    LastLogin DATETIME2(3),                  -- datetime2
    LoginTime TIME(0),                       -- time
    TimestampColumn DATETIMEOFFSET(0),       -- datetimeoffset
    CreatedAt SMALLDATETIME,                 -- smalldatetime

    -- Binary Types
    ProfilePicture VARBINARY(MAX),           -- varbinary(max)
    Document BINARY(50),                     -- binary
    DeprecatedImage IMAGE,                   -- image (deprecated, but still seen)

    -- Other Common Types
    UniqueIdentifier UNIQUEIDENTIFIER,       -- uniqueidentifier (GUID)
    XmlData XML,                             -- xml
    JsonData NVARCHAR(MAX),                  -- use nvarchar(max) to store JSON
    RowVersion ROWVERSION                    -- rowversion (auto-generated binary version stamp)
);
