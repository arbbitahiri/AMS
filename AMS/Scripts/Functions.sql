USE [AMS]
GO
/****** Object:  UserDefinedFunction [dbo].[SearchApplication]    Script Date: 30-Sep-22 4:14:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================
-- Author:		Arb Tahiri
-- Create date: 23/09/2022
-- Description:	Function to search for actions in application
/* ===========================================================
   SELECT * FROM SearchApplication ('', '99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', 2)
   =========================================================== */
CREATE FUNCTION [dbo].[SearchApplication]
(
	@Title		NVARCHAR(1024),
	@UserId		NVARCHAR(450),
	@Language	INT
)
RETURNS @tbl_Actions TABLE
(
	Icon			NVARCHAR(128),
	MenuTitle		NVARCHAR(512),
	SubMenuTitle	NVARCHAR(512),
	Area			NVARCHAR(128),
	Controller		NVARCHAR(128),
	Action			NVARCHAR(128)
)
AS
BEGIN
	SET @Title = REPLACE(LTRIM(RTRIM(@Title)), CHAR(9), '')

	DECLARE @tbl_Roles TABLE ( ClaimValue NVARCHAR(128) )

	INSERT INTO @tbl_Roles
	SELECT
		CONCAT(RC.ClaimType, ':', RC.ClaimValue)
	FROM AspNetRoleClaims RC
		INNER JOIN AspNetRoles R		ON RC.RoleId = R.Id
		INNER JOIN AspNetUserRoles UR	ON R.Id = UR.RoleId
	WHERE UR.UserId = @UserId and RC.ClaimValue = 'm'

	INSERT INTO @tbl_Actions
	SELECT TOP 10
		M.Icon,
		(CASE WHEN @Language = 1 THEN M.NameSQ
			  WHEN @Language = 2 THEN M.NameEN
			ELSE M.NameSQ END),
		NULL,
		M.Area,
		M.Controller,
		M.Action
	FROM Core.Menu M
		INNER JOIN @tbl_Roles R ON M.Claim = R.ClaimValue
	WHERE M.HasSubMenu = 0 AND M.Active = 1
		AND ((CASE WHEN @Language = 1 AND M.TagsSQ LIKE '%' + ISNULL(@Title, '') + '%' THEN 1 ELSE 0 END) = 1
		OR (CASE WHEN @Language = 2 AND M.TagsEN LIKE '%' + ISNULL(@Title, '') + '%' THEN 1 ELSE 0 END) = 1)
	UNION
	SELECT TOP 10
		M.Icon,
		(CASE WHEN @Language = 1 THEN M.NameSQ
			  WHEN @Language = 2 THEN M.NameEN
			ELSE M.NameSQ END),
		(CASE WHEN @Language = 1 THEN S.NameSQ
			  WHEN @Language = 2 THEN S.NameEN
			ELSE S.NameSQ END),
		S.Area,
		S.Controller,
		S.Action
	FROM Core.SubMenu S
		INNER JOIN @tbl_Roles R ON S.Claim = R.ClaimValue
		INNER JOIN Core.Menu M	ON S.MenuID = M.MenuID
	WHERE S.Active = 1
		AND ((CASE WHEN @Language = 1 AND S.TagsSQ LIKE '%' + ISNULL(@Title, '') + '%' THEN 1 ELSE 0 END) = 1
		OR (CASE WHEN @Language = 2 AND S.TagsEN LIKE '%' + ISNULL(@Title, '') + '%' THEN 1 ELSE 0 END) = 1)
	
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[StaffConsecutiveDays]    Script Date: 30-Sep-22 4:14:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:		Arb Tahiri
-- Create date: 18/09/2022
-- Description:	Function to get list of staff with consecutive days.
/* =================================================================
   SELECT * FROM StaffConsecutiveDays (NULL, NULL, NULL, 1)
   ================================================================= */
CREATE FUNCTION [dbo].[StaffConsecutiveDays]
(
	@StaffId		INT,
	@DepartmentId	INT,
	@StaffTypeId	INT,
	@Language		INT
)
RETURNS @tbl_StaffDays TABLE
(
	StaffId				INT,
	PersonalNumber		NVARCHAR(50),
	FirstName			NVARCHAR(128),
	LastName			NVARCHAR(128),
	BirthDate			DATETIME,
	Department			NVARCHAR(128),
	WorkingSince		INT,
	Attended			BIT
)
AS
BEGIN
	;WITH AttendanceCTE AS
	(
		SELECT
			StaffID,
			InsertedDate,
			GroupingSet = CAST(DATEADD(DAY, -ROW_NUMBER() OVER(PARTITION BY StaffID ORDER BY InsertedDate), InsertedDate) AS DATE),
			Absent
		FROM StaffAttendance
		WHERE Active = 1
	)
	
	INSERT INTO @tbl_StaffDays
	SELECT
		S.StaffID,
		MAX(S.PersonalNumber),
		MAX(S.FirstName),
		MAX(S.LastName),
		MAX(S.BirthDate),
		MAX((CASE WHEN @Language = 1 THEN D.NameSQ
				  WHEN @Language = 1 THEN D.NameEN
			ELSE D.NameSQ END)),
		WorkingSince = (CASE WHEN A.Absent = 0 THEN COUNT(NULLIF(A.StaffID, 0)) ELSE 0 END),
		--WorkingSince = COUNT(NULLIF(A.StaffID, 0)),
		Attended = MAX((CASE WHEN (SA.StaffAttendanceID IS NOT NULL) THEN 1 ELSE 0 END))
	FROM Staff S
		LEFT JOIN AttendanceCTE A					ON A.StaffID = S.StaffID AND CAST(A.InsertedDate AS DATE) BETWEEN CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) AND CAST(GETDATE() AS DATE) AND Absent = 0
		INNER JOIN StaffDepartment SD				ON S.StaffID = SD.StaffID
		INNER JOIN Department D						ON SD.DepartmentID = D.DepartmentID
		INNER JOIN StaffType ST						ON SD.StaffTypeID = ST.StaffTypeID
		INNER JOIN StaffRegistrationStatus SRS		ON S.StaffID = SRS.StaffID
		LEFT JOIN StaffAttendance SA		ON SA.StaffID = A.StaffID AND CAST(SA.InsertedDate AS DATE) = CAST(GETDATE() AS DATE) AND SA.Absent = 0 AND SA.Active = 1
	WHERE SRS.Active = 1
		AND S.StaffID						= ISNULL(@StaffId, S.StaffID)
		AND SD.DepartmentID				= ISNULL(@DepartmentId, SD.DepartmentID)
		AND SD.StaffTypeID				= ISNULL(@StaffTypeId, SD.StaffTypeID)
		AND CAST(SD.EndDate AS DATE)	>= CAST(GETDATE() AS DATE)
		AND SRS.StatusTypeID			= 5
	GROUP BY S.StaffID, A.GroupingSet, A.Absent
	ORDER BY S.StaffID;
	
	RETURN
END
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 30-Sep-22 4:14:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[StaffID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](450) NULL,
	[PersonalNumber] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](128) NOT NULL,
	[LastName] [nvarchar](128) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[GenderID] [int] NOT NULL,
	[CityID] [int] NOT NULL,
	[CountryID] [int] NOT NULL,
	[Address] [nvarchar](256) NULL,
	[PostalCode] [nvarchar](12) NULL,
	[Email] [nvarchar](256) NOT NULL,
	[PhoneNumber] [nvarchar](max) NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[StaffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StaffDepartment]    Script Date: 30-Sep-22 4:14:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffDepartment](
	[StaffDepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[StaffTypeID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_StaffDepartment] PRIMARY KEY CLUSTERED 
(
	[StaffDepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StaffRegistrationStatus]    Script Date: 30-Sep-22 4:14:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffRegistrationStatus](
	[StaffRegistrationStatusID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[StatusTypeID] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_StaffRegistrationStatus] PRIMARY KEY CLUSTERED 
(
	[StaffRegistrationStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_AspNetUsers] FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_AspNetUsers]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_AspNetUsers_Updated]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_City] FOREIGN KEY([CityID])
REFERENCES [Core].[City] ([CityID])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_City]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Country] FOREIGN KEY([CountryID])
REFERENCES [Core].[Country] ([CountryID])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Country]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Gender] FOREIGN KEY([GenderID])
REFERENCES [Core].[Gender] ([GenderID])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Gender]
GO
ALTER TABLE [dbo].[StaffDepartment]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartment_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffDepartment] CHECK CONSTRAINT [FK_StaffDepartment_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[StaffDepartment]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartment_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffDepartment] CHECK CONSTRAINT [FK_StaffDepartment_AspNetUsers_Updated]
GO
ALTER TABLE [dbo].[StaffDepartment]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartment_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[StaffDepartment] CHECK CONSTRAINT [FK_StaffDepartment_Department]
GO
ALTER TABLE [dbo].[StaffDepartment]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartment_Staff] FOREIGN KEY([StaffID])
REFERENCES [dbo].[Staff] ([StaffID])
GO
ALTER TABLE [dbo].[StaffDepartment] CHECK CONSTRAINT [FK_StaffDepartment_Staff]
GO
ALTER TABLE [dbo].[StaffDepartment]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartment_StaffType] FOREIGN KEY([StaffTypeID])
REFERENCES [dbo].[StaffType] ([StaffTypeID])
GO
ALTER TABLE [dbo].[StaffDepartment] CHECK CONSTRAINT [FK_StaffDepartment_StaffType]
GO
ALTER TABLE [dbo].[StaffRegistrationStatus]  WITH CHECK ADD  CONSTRAINT [FK_StaffRegistrationStatus_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffRegistrationStatus] CHECK CONSTRAINT [FK_StaffRegistrationStatus_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[StaffRegistrationStatus]  WITH CHECK ADD  CONSTRAINT [FK_StaffRegistrationStatus_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffRegistrationStatus] CHECK CONSTRAINT [FK_StaffRegistrationStatus_AspNetUsers_Updated]
GO
ALTER TABLE [dbo].[StaffRegistrationStatus]  WITH CHECK ADD  CONSTRAINT [FK_StaffRegistrationStatus_Staff] FOREIGN KEY([StaffID])
REFERENCES [dbo].[Staff] ([StaffID])
GO
ALTER TABLE [dbo].[StaffRegistrationStatus] CHECK CONSTRAINT [FK_StaffRegistrationStatus_Staff]
GO
ALTER TABLE [dbo].[StaffRegistrationStatus]  WITH CHECK ADD  CONSTRAINT [FK_StaffRegistrationStatus_StatusType] FOREIGN KEY([StatusTypeID])
REFERENCES [Core].[StatusType] ([StatusTypeID])
GO
ALTER TABLE [dbo].[StaffRegistrationStatus] CHECK CONSTRAINT [FK_StaffRegistrationStatus_StatusType]
GO
/****** Object:  StoredProcedure [job].[StaffDepartmentEndDate]    Script Date: 30-Sep-22 4:14:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================
-- Author:			Arb Tahiri
-- Create date:		30/09/2022
-- Description:		Job to insert Staff data if end date is today.
-- Execution Time:	Occurs daily at 20.00.
-- ===============================================================
CREATE PROCEDURE [job].[StaffDepartmentEndDate]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Error INT
	DECLARE @tbl_StaffDepartment TABLE ( StaffId INT )

	INSERT INTO @tbl_StaffDepartment
	SELECT
		StaffId
	FROM StaffDepartment
	WHERE CAST(EndDate AS DATE) <= CAST(GETDATE() AS DATE)

	DECLARE @StaffDepartmentCount INT = (SELECT COUNT(*) FROM @tbl_StaffDepartment)

	IF @StaffDepartmentCount > 0
	BEGIN
		UPDATE SRS
		SET
			Active = 0,
			UpdatedDate = GETDATE(),
			UpdatedFrom = '99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b',
			UpdatedNo = UpdatedNo + 1
		FROM StaffRegistrationStatus SRS
		WHERE SRS.StaffID IN (SELECT StaffId FROM @tbl_StaffDepartment)

		INSERT INTO StaffRegistrationStatus (StaffID, StatusTypeID, Active, InsertedFrom, InsertedDate)
		SELECT
			StaffID,
			1002,
			1,
			'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b',
			GETDATE()
		FROM @tbl_StaffDepartment

		SET @Error = @@ERROR
		IF @Error <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @Error
		END
	END
END
GO
