USE [AMS]
GO
/****** Object:  UserDefinedFunction [dbo].[AttendanceConsecutiveDays]    Script Date: 28-Sep-22 4:16:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author:		Arb Tahiri
-- Create date: 05/09/2022
-- Description:	Function to return the consecutive days of work for employees
/* ===========================================================================
   SELECT * FROM AttendanceConsecutiveDays (NULL, NULL, NULL, NULL, NULL, 1) ORDER BY StaffId
   =========================================================================== */
CREATE FUNCTION [dbo].[AttendanceConsecutiveDays]
(
	@StaffId		INT,
	@DepartmentId	INT,
	@StaffTypeId	INT,
	@StartDate		DATETIME,
	@EndDate		DATETIME,
	@Language		INT
)
RETURNS @tbl_StaffDays TABLE
(
	StaffAttendanceId	INT,
	StaffId				INT,
	PersonalNumber		NVARCHAR(50),
	FirstName			NVARCHAR(128),
	LastName			NVARCHAR(128),
	Department			NVARCHAR(128),
	StaffType			NVARCHAR(128),
	StartDate			DATETIME,
	EndDate				DATETIME,
	WorkingSince		INT
)
AS
BEGIN
	;WITH AttendanceCTE AS
	(
		SELECT
			StaffAttendanceID,
			StaffID,
			InsertedDate,
			GroupingSet = CAST(DATEADD(DAY, -ROW_NUMBER() OVER(PARTITION BY StaffID ORDER BY InsertedDate), InsertedDate) AS DATE),
			Absent
		FROM StaffAttendance
		WHERE Active = 1 AND Absent = 0
	)

	INSERT INTO @tbl_StaffDays
	SELECT
		MAX(A.StaffAttendanceID),
		A.StaffID,
		MAX(S.PersonalNumber),
		MAX(S.FirstName),
		MAX(S.LastName),
		MAX((CASE WHEN @Language = 1 THEN D.NameSQ
			  WHEN @Language = 1 THEN D.NameEN
			ELSE D.NameSQ END)),
		MAX((CASE WHEN @Language = 1 THEN ST.NameSQ
			  WHEN @Language = 1 THEN ST.NameEN
			ELSE ST.NameSQ END)),
		StartDate = MIN(A.InsertedDate),
		EndDate = MAX(A.InsertedDate),
		WorkingSince = COUNT(NULLIF(A.StaffID, 0))
	FROM AttendanceCTE A
		INNER JOIN Staff S				ON A.StaffID = S.StaffID
		INNER JOIN StaffDepartment SD	ON S.StaffID = SD.StaffDepartmentID
		INNER JOIN Department D			ON SD.DepartmentID = D.DepartmentID
		INNER JOIN StaffType ST			ON SD.StaffTypeID = ST.StaffTypeID
	WHERE S.StaffID				= ISNULL(@StaffId, S.StaffID)
		AND SD.DepartmentID		= ISNULL(@DepartmentId, SD.DepartmentID)
		AND SD.StaffTypeID		= ISNULL(@StaffTypeId, SD.StaffTypeID)
		AND A.InsertedDate		BETWEEN ISNULL(@StartDate, A.InsertedDate) AND ISNULL(@EndDate, A.InsertedDate)
	GROUP BY A.StaffID, GroupingSet, A.Absent
	ORDER BY A.StaffID, StartDate;

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[SearchApplication]    Script Date: 28-Sep-22 4:16:20 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[StaffConsecutiveDays]    Script Date: 28-Sep-22 4:16:20 PM ******/
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
