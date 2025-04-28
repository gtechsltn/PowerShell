-- Insert 1000 sample users with binary data
DECLARE @i INT = 1;

WHILE @i <= 1000
BEGIN
    INSERT INTO tblUsers
    (
        SmallNumber,
        TinyNumber,
        BigNumber,
        MoneyAmount,
        SmallMoneyAmount,
        DecimalValue,
        NumericValue,
        FloatValue,
        RealValue,
        BitValue,
        Username,
        PasswordHash,
        FullName,
        NationalId,
        Bio,
        DateOfBirth,
        RegistrationDate,
        LastLogin,
        LoginTime,
        TimestampColumn,
        CreatedAt,
        ProfilePicture,
        Document,
        DeprecatedImage,
        UniqueIdentifier,
        XmlData,
        JsonData
        -- RowVersion is auto-generated
    )
    VALUES
    (
        CAST(RAND() * 32767 AS SMALLINT),                                                         -- SmallNumber
        CAST(RAND() * 255 AS TINYINT),                                                            -- TinyNumber
        ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)),                                                   -- BigNumber
        CAST(RAND() * 10000 AS MONEY),                                                            -- MoneyAmount
        CAST(RAND() * 1000 AS SMALLMONEY),                                                        -- SmallMoneyAmount
        CAST(RAND() * 100000 AS DECIMAL(18,4)),                                                   -- DecimalValue
        CAST(RAND() * 100000 AS NUMERIC(18,4)),                                                   -- NumericValue
        RAND() * 100000,                                                                          -- FloatValue
        RAND() * 100000,                                                                          -- RealValue

        CAST((RAND() * 1) AS BIT),                                                                -- BitValue

        'user' + CAST(@i AS VARCHAR(10)),                                                         -- Username
        REPLICATE('A', 64),                                                                       -- PasswordHash (simple dummy 64 chars)
        'Full Name ' + CAST(@i AS VARCHAR(10)),                                                   -- FullName
        RIGHT('0000000000' + CAST(@i AS VARCHAR(10)), 10),                                        -- NationalId
        'Bio for user ' + CAST(@i AS VARCHAR(10)),                                                -- Bio
        DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 10000), GETDATE()),                              -- DateOfBirth
        DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 1000), GETDATE()),                               -- RegistrationDate
        DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 30), GETDATE()),                                 -- LastLogin
        CAST(DATEADD(SECOND, @i % 86400, '00:00:00') AS TIME),                                    -- LoginTime
        SYSDATETIMEOFFSET(),                                                                      -- TimestampColumn
        GETDATE(),                                                                                -- CreatedAt
        
        -- BINARY FIELDS (DUMMY DATA)
        CAST(CONVERT(VARBINARY(MAX), 'Profile_' + CAST(@i AS VARCHAR(10))) AS VARBINARY(MAX)),    -- ProfilePicture
        CAST(REPLICATE(CAST(@i AS BINARY(1)), 50) AS BINARY(50)),                                 -- Document (50 bytes)
        CAST(CONVERT(VARBINARY(MAX), 'Image_' + CAST(@i AS VARCHAR(10))) AS IMAGE),               -- DeprecatedImage
        
        -- Other fields
        NEWID(),                                                                                  -- UniqueIdentifier
        '<User><Id>' + CAST(@i AS VARCHAR(10)) + '</Id></User>',                                  -- XmlData
        '{"userId":' + CAST(@i AS VARCHAR(10)) + '}'                                              -- JsonData
    );

    SET @i = @i + 1;
END
