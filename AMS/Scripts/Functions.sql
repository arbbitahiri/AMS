USE [AMS]
GO
/****** Object:  UserDefinedFunction [dbo].[AttendanceConsecutiveDays]    Script Date: 04-Nov-22 4:34:48 PM ******/
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
	WHERE S.StaffID						= ISNULL(@StaffId, S.StaffID)
		AND SD.DepartmentID				= ISNULL(@DepartmentId, SD.DepartmentID)
		AND SD.StaffTypeID				= ISNULL(@StaffTypeId, SD.StaffTypeID)
		AND A.InsertedDate				BETWEEN ISNULL(@StartDate, A.InsertedDate) AND ISNULL(@EndDate, A.InsertedDate)
		AND CAST(SD.EndDate AS DATE)	>= CAST(GETDATE() AS DATE)
	GROUP BY A.StaffID, GroupingSet, A.Absent
	ORDER BY A.StaffID, StartDate;

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[CheckAccess]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arb Tahiri
-- Create date: 21/10/2022
-- Description:	Function to check if user with the roles has access to specific page.
-- =============================================
CREATE FUNCTION [dbo].[CheckAccess]
(
	@Controller		NVARCHAR(50),
	@Action			NVARCHAR(50),
	@User			NVARCHAR(450),
	@Role			NVARCHAR(450)
)
RETURNS @tbl_CheckAccess TABLE ( Access BIT )
AS
BEGIN
	IF EXISTS (SELECT 1
		FROM Core.RoleAccess RA WITH (NOLOCK)
			INNER JOIN AspNetRoles R ON							R.Id = RA.RoleID
			INNER JOIN Core.ActionMethod AM WITH (NOLOCK) ON	AM.ActionMethodID = RA.ActionMethodID
			INNER JOIN Core.Controller C WITH (NOLOCK) ON		C.ControllerID = AM.ControllerID
		WHERE RA.Access = 1
			AND C.Name = @Controller
			AND AM.Name = @Action
			AND R.Name = @Role)
		INSERT INTO @tbl_CheckAccess (Access) VALUES (1)
	ELSE
		INSERT INTO @tbl_CheckAccess (Access) VALUES (0)
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[ListOfRoleAccess]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arb Tahiri
-- Create date: 24/10/2022
-- Description:	Function to check for access on menus.
-- =============================================
CREATE FUNCTION [dbo].[ListOfRoleAccess]
(
	@Role		NVARCHAR(450),
	@Language	INT
)
RETURNS @tbl_ListOfRoleAccess TABLE
(
	ActionMethodId	INT,
	Controller		NVARCHAR(128),
	Action			NVARCHAR(128),
	Type			NVARCHAR(64),
	Access			BIT
)
AS
BEGIN
	DECLARE @tbl_Controllers TABLE
	(
		ActionMethodId	INT,
		Controller		NVARCHAR(128),
		Action			NVARCHAR(128),
		Type			NVARCHAR(64)
	)

	INSERT INTO @tbl_Controllers
	SELECT
		A.ActionMethodID,
		C.Name,
		A.Name,
		A.Type
	FROM Core.Controller C
		INNER JOIN Core.ActionMethod A ON A.ControllerID = C.ControllerID

	INSERT INTO @tbl_ListOfRoleAccess
	SELECT
		TC.ActionMethodId,
		TC.Controller,
		TC.Action,
		TC.Type,
		CASE WHEN RA.RoleAccessID IS NULL THEN 0 ELSE (CASE WHEN RA.Access = 1 THEN 1 ELSE 0 END) END
	FROM @tbl_Controllers TC
		LEFT JOIN Core.RoleAccess RA ON RA.ActionMethodID = TC.ActionMethodId AND RA.RoleID = @Role
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[Logs]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================
-- Author:		<Arb Tahiri>
-- Create date: <10.06.2022>
-- Description:	<Function to get the list of logs depending of search parameters.>
-- =================================================================================
-- SELECT * FROM [Logs] (NULL, NULL, '2022-10-06 00:00:00.000', '2022-10-06 23:59:00.000', NULL, NULL, NULL, NULL, 0, 0)
-- =================================================================================
CREATE FUNCTION [dbo].[Logs]
(
	@RoleId				NVARCHAR(450),
	@UserId				NVARCHAR(450),
	@StartDate			DATETIME,
	@EndDate			DATETIME,
	@Ip					NVARCHAR(128),
	@Controller			NVARCHAR(128),
	@Action				NVARCHAR(128),
	@HttpMethod			NVARCHAR(128),
	@Error				INT,
	@AdvancedSearch		BIT
)
RETURNS @temp_Logs TABLE
(
	[LogId]				INT,
	[Ip]				NVARCHAR(128),
	[Controller]		NVARCHAR(128),
	[Action]			NVARCHAR(128),
	[Developer]			NVARCHAR(MAX),
	[Description]		NVARCHAR(MAX),
	[Exception]			NVARCHAR(MAX),
	[FormContent]		NVARCHAR(MAX),
	[HttpMethod]		NVARCHAR(128),
	[Username]			NVARCHAR(256),
	[InsertDate]		DATETIME
)
AS
BEGIN
	IF @AdvancedSearch = 0
	BEGIN
		INSERT INTO @temp_Logs
		SELECT
			L.LogID,
			L.Ip,
			L.Controller,
			L.Action,
			L.Developer,
			L.Description,
			L.Exception,
			L.FormContent,
			L.HttpMethod,
			CONCAT(U.FirstName, ' ', U.LastName),
			L.InsertedDate
		FROM Core.Log L
			LEFT JOIN AspNetUsers U			ON U.Id = L.UserID
			LEFT JOIN AspNetUserRoles R		ON R.UserID = L.UserID
		WHERE (L.InsertedDate BETWEEN @StartDate AND @EndDate)
			AND ISNULL(R.RoleId, '')	= ISNULL(@RoleId, ISNULL(R.RoleId, ''))
			AND ISNULL(L.UserId, '')	= ISNULL(@UserId, ISNULL(L.UserId, ''))
			AND L.Ip					= ISNULL(@Ip, L.Ip)
	END
	ELSE
	BEGIN
		INSERT INTO @temp_Logs
		SELECT
			L.LogID,
			L.Ip,
			L.Controller,
			L.Action,
			L.Developer,
			L.Description,
			L.Exception,
			L.FormContent,
			L.HttpMethod,
			CONCAT(U.FirstName, ' ', U.LastName),
			L.InsertedDate
		FROM Core.Log L
			LEFT JOIN AspNetUsers U			ON U.Id = L.UserID
			LEFT JOIN AspNetUserRoles R		ON R.UserID = L.UserID
		WHERE (L.InsertedDate BETWEEN @StartDate AND @EndDate)
			AND ISNULL(R.RoleId, '')	= ISNULL(@RoleId, ISNULL(R.RoleId, ''))
			AND ISNULL(L.UserId, '')	= ISNULL(@UserId, ISNULL(L.UserId, ''))
			AND L.Ip					= ISNULL(@Ip, L.Ip)
			AND L.Controller			= ISNULL(@Controller, L.Controller)
			AND L.Action				= ISNULL(@Action, L.Action)
			AND L.HttpMethod			= ISNULL(@HttpMethod, L.HttpMethod)
			AND L.Error					= (CASE WHEN @Error = 1 THEN 1 WHEN @Error = 2 THEN 0 ELSE L.Error END)
	END
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[MenuList]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Arb Tahiri>
-- Create date: <10/06/2021>
-- Description:	<Get the list of menus for given role>
-- =============================================
-- SELECT * FROM [MenuList] ('Administrator', 1)
-- =============================================
CREATE FUNCTION [dbo].[MenuList]
(
	@role	NVARCHAR(450),
	@lang	INT
)
RETURNS 
@MenuList TABLE 
(
	[MenuId]					INT,
	[MenuTitle]					NVARCHAR(128),
	[MenuArea]					NVARCHAR(128),
	[MenuController]			NVARCHAR(128),
	[MenuAction]				NVARCHAR(128),
	[MenuOpenFor]				NVARCHAR(MAX),
	[SubMenuId]					INT,
	[SubMenuTitle]				NVARCHAR(128),
	[SubMenuArea]				NVARCHAR(128),
	[SubMenuController]			NVARCHAR(128),
	[SubMenuAction]				NVARCHAR(128),
	[SubMenuOpenFor]			NVARCHAR(MAX),
	[MenuIcon]					NVARCHAR(128),
	[SubMenuIcon]				NVARCHAR(128),
	[HasSubMenu]				BIT,
	[MenuOrdinalNumber]			INT,
	[SubMenuOrdinalNumber]		INT
)
AS
BEGIN
	INSERT INTO @MenuList
	SELECT
		M.MenuID,
		(CASE WHEN @lang = 1 THEN M.NameSQ
			  WHEN @lang = 2 THEN M.NameEN
			  ELSE M.NameSQ END),
		M.Area,
		M.Controller,
		M.[Action],
		M.OpenFor,
		NULL,
		'',
		'',
		'',
		'',
		'',
		M.Icon,
		'',
		M.HasSubMenu,
		M.OrdinalNumber,
		0
	FROM Core.Menu M
		INNER JOIN AspNetRoleClaims C ON C.ClaimType = M.ClaimType
		INNER JOIN AspNetRoles R ON R.Id = C.RoleId
	WHERE M.HasSubMenu = 0
		AND R.[Name] = @role
		AND M.Roles LIKE '%' + @role + '%'
		AND M.Active = 1
	UNION
	SELECT
		M.MenuID,
		(CASE WHEN @lang = 1 THEN M.NameSQ
			  WHEN @lang = 2 THEN M.NameEN
			  ELSE M.NameSQ END),
		M.Area,
		M.Controller,
		M.[Action],
		M.OpenFor,
		S.SubMenuID,
		(CASE WHEN @lang = 1 THEN S.NameSQ
			  WHEN @lang = 2 THEN S.NameEN
			  ELSE S.NameSQ END),
		S.Area,
		S.Controller,
		S.[Action],
		S.OpenFor,
		M.Icon,
		S.Icon,
		M.HasSubMenu,
		M.OrdinalNumber,
		S.OrdinalNumber
	FROM Core.Menu M
		INNER JOIN Core.SubMenu S ON S.MenuID = M.MenuID
		INNER JOIN AspNetRoleClaims C ON C.ClaimType = S.ClaimType
		INNER JOIN AspNetRoles R ON R.Id = C.RoleId
	WHERE M.HasSubMenu = 1
		AND R.[Name] = @role
		AND S.Roles LIKE '%' + @role + '%'
		AND M.Active = 1
		AND S.Active = 1

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[MenuListAccess]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Arb Tahiri>
-- Create date: <20/11/2021>
-- Description:	<Get list of menus that specific role has access.>
-- =============================================
-- SELECT * FROM [MenuListAccess] ('6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', 1)
-- =============================================
CREATE FUNCTION [dbo].[MenuListAccess]
(
	@role	NVARCHAR(450),
	@lang	INT
)
RETURNS @MenusTemp TABLE 
(
	[MenuId]		INT,
	[SubMenuId]		INT,
	[Menu]			NVARCHAR(150),
	[SubMenu]		NVARCHAR(150),
	[Icon]			NVARCHAR(200),
	[HasSubMenu]	BIT,
	[HasAccess]		BIT,
	[ClaimPolicy]	NVARCHAR(100)
)
AS
BEGIN
	DECLARE @tmp_Role NVARCHAR(256) = (SELECT NAME FROM AspNetRoles WHERE Id = @role)
	DECLARE @tmp_RoleClaims Table
	(
		ClaimType	NVARCHAR(256),
		RoleName	NVARCHAR(256)
	)

	INSERT INTO @tmp_RoleClaims
	SELECT
		C.[ClaimType],
		R.[Name] 
	FROM AspNetRoleClaims C
		INNER JOIN AspNetRoles R on R.Id = C.RoleId 
	WHERE RoleId = @role

	INSERT INTO @MenusTemp
	SELECT 
		M.MenuID,
		0,
		(CASE WHEN @lang = 1 THEN M.NameSQ
			  WHEN @lang = 2 THEN M.NameEN
			  ELSE M.NameSQ END),
		'',
		M.Icon,
		M.HasSubMenu,
		(CASE WHEN (SELECT COUNT(*) FROM @tmp_RoleClaims WHERE ClaimType = m.ClaimType AND M.Roles LIKE '%' + @tmp_Role + '%') > 0 THEN 1 ELSE 0 END),
		M.Claim
	FROM Core.Menu M
	WHERE M.HasSubMenu = 0
	UNION
	SELECT
		M.MenuID,
		S.SubmenuID,
		(CASE WHEN @lang = 1 THEN M.NameSQ
			  WHEN @lang = 2 THEN M.NameEN
			  ELSE M.NameSQ END),
		(CASE WHEN @lang = 1 THEN S.NameSQ
			  WHEN @lang = 2 THEN S.NameEN
			  ELSE S.NameSQ END),
		M.Icon,
		M.HasSubMenu,
		(CASE WHEN (SELECT COUNT(*) FROM @tmp_RoleClaims WHERE ClaimType = S.ClaimType AND S.Roles LIKE '%' + @tmp_Role + '%') > 0 THEN 1 ELSE 0 END),
		S.Claim
	FROM Core.Menu M
		INNER JOIN Core.SubMenu S ON S.MenuID = M.MenuID
	WHERE M.HasSubMenu = 1

RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[MenuListUrl]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arb Tahiri
-- Create date: 25/10/2022
-- Description:	Function to return list of menus with urls.
-- ==========================================================
-- SELECT * FROM MenuListUrl ('6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', 1)
-- ==========================================================
CREATE FUNCTION [dbo].[MenuListUrl]
(
	@Role		NVARCHAR(450),
	@Language	INT
)
RETURNS @tbl_Menus TABLE
(
	MenuId				INT,
	MenuName			NVARCHAR(128),
	MenuOpenFor			NVARCHAR(MAX),
	MenuURL				NVARCHAR(512),
	MenuIcon			NVARCHAR(64),
	SubMenuId			INT,
	SubMenuName			NVARCHAR(128),
	SubMenuOpenFor		NVARCHAR(MAX),
	SubMenuURL			NVARCHAR(512),
	SubMenuIcon			NVARCHAR(64),
	HasSubMenu			BIT,
	ONumberMenu			INT,
	ONumberSubMenu		INT
)
AS
BEGIN
	INSERT INTO @tbl_Menus
	SELECT 
		M.MenuID,
		(CASE WHEN @Language = 1 THEN M.NameSQ
			  WHEN @Language = 2 THEN M.NameEN
			ELSE M.NameSQ END),
		M.OpenFor,
		(CASE WHEN M.Area IS NOT NULL THEN CONCAT('/', M.Area, '/', M.Controller, '/', M.Action) ELSE CONCAT('/', M.Controller, '/', M.Action) END),
		M.Icon,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		M.HasSubMenu,
		M.OrdinalNumber,
		0
	FROM Core.MENU M	
		INNER JOIN Core.RoleAccessMenu RA ON RA.MenuID = M.MenuID AND RA.RoleID = @role AND RA.Access = 1
	WHERE M.HasSubMenu = 0
	UNION
	SELECT 
		M.MenuID,
		(CASE WHEN @Language = 1 THEN M.NameSQ
			  WHEN @Language = 2 THEN M.NameEN
			ELSE M.NameSQ END),
		M.OpenFor,
		(CASE WHEN M.Area IS NOT NULL THEN CONCAT('/', M.Area, '/', M.Controller, '/', M.Action) ELSE CONCAT('/', M.Controller, '/', M.Action) END),
		M.Icon,
		S.SubmenuID,
		(CASE WHEN @Language = 1 THEN S.NameSQ
			  WHEN @Language = 2 THEN S.NameEN
			ELSE S.NameSQ END),
		S.OpenFor,
		(CASE WHEN S.Area IS NOT NULL THEN CONCAT('/', S.Area, '/', S.Controller, '/', S.Action) ELSE CONCAT('/', S.Controller, '/', S.Action) END),
		S.Icon,
		M.HasSubMenu,
		M.OrdinalNumber,
		S.OrdinalNumber
	FROM Core.MENU M
		INNER JOIN Core.SubMenu S ON S.MenuID = M.MenuID
		INNER JOIN Core.RoleAccessSubMenu RA ON RA.SubmenuID = S.SubmenuID AND RA.RoleID = @role AND RA.Access = 1
	WHERE M.HasSubMenu = 1
	
RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[MenusAccess]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arb Tahiri
-- Create date: 24/10/2022
-- Description:	Function to show list of menus that the given role has access.
-- =============================================
CREATE FUNCTION [dbo].[MenusAccess]
(
	@Role NVARCHAR(450),
	@Language INT
)
RETURNS @tbl_MenusAccess TABLE
(
	MenuId			INT,
	MenuName		NVARCHAR(128),
	MenuAccess		BIT,
	MenuIcon		NVARCHAR(128),
	SubMenuId		INT,
	SubMenuName		NVARCHAR(128),
	SubMenuAccess	BIT,
	SubMenuIcon		NVARCHAR(128)
)
AS
BEGIN
	INSERT INTO @tbl_MenusAccess
	SELECT
		M.MenuID,
		(CASE WHEN @Language = 1 THEN M.NameSQ
			  WHEN @Language = 2 THEN M.NameEN
			ELSE M.NameSQ END),
		ISNULL(RM.Access, 0),
		M.Icon,
		NULL,
		NULL,
		NULL,
		NULL
	FROM Core.Menu M
		LEFT JOIN Core.RoleAccessMenu RM ON RM.MenuID = M.MenuID AND RM.Access = 1 AND RM.RoleID = @Role
	WHERE M.HasSubMenu = 0 AND M.Active = 1
	UNION
	SELECT
		M.MenuID,
		(CASE WHEN @Language = 1 THEN M.NameSQ
			  WHEN @Language = 2 THEN M.NameEN
			ELSE M.NameSQ END),
		0,
		SM.Icon,
		SM.MenuID,
		(CASE WHEN @Language = 1 THEN SM.NameSQ
			  WHEN @Language = 2 THEN SM.NameEN
			ELSE SM.NameSQ END),
		ISNULL(RSM.Access, 0),
		SM.Icon
	FROM Core.Menu M
		INNER JOIN Core.SubMenu SM				ON M.MenuID = SM.MenuID
		LEFT JOIN Core.RoleAccessSubMenu RSM	ON RSM.SubMenuID = SM.SubMenuID AND RSM.Access = 1 AND RSM.RoleID = @Role
	WHERE M.HasSubMenu = 1 AND M.Active = 1

RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[SearchApplication]    Script Date: 04-Nov-22 4:34:48 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[StaffConsecutiveDays]    Script Date: 04-Nov-22 4:34:48 PM ******/
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
		AND S.StaffID					= ISNULL(@StaffId, S.StaffID)
		AND SD.DepartmentID				= ISNULL(@DepartmentId, SD.DepartmentID)
		AND SD.StaffTypeID				= ISNULL(@StaffTypeId, SD.StaffTypeID)
		AND CAST(SD.EndDate AS DATE)	>= CAST(GETDATE() AS DATE)
		AND SRS.StatusTypeID			= 5
	GROUP BY S.StaffID, A.GroupingSet, A.Absent
	ORDER BY S.StaffID;
	
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[StaffListHistory]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================
-- Author:		Arb Tahiri
-- Create date: 29/09/2022
-- Description:	Function to return all previous staff list
/* =======================================================
   SELECT * FROM StaffListHistory (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1)
   ======================================================= */
CREATE FUNCTION [dbo].[StaffListHistory]
(
	@StaffId			INT,
	@DepartmentId		INT,
	@StaffTypeId		INT,
	@StartDate			DATETIME,
	@EndDate			DATETIME,
	@PersonalNumber		NVARCHAR(50),
	@FirstName			NVARCHAR(128),
	@LastName			NVARCHAR(128),
	@BirthDate			DATETIME,
	@StatusTypeId		INT,
	@Advanced			BIT,
	@Language			INT
)
RETURNS @tbl_StaffList TABLE
(
	StaffDepartmentId		INT,
	StaffId					INT,
	PersonalNumber			NVARCHAR(50),
	FirstName				NVARCHAR(128),
	LastName				NVARCHAR(128),
	DateOfBirth				DATETIME,
	Department				NVARCHAR(128),
	StaffType				NVARCHAR(128),
	StartDate				DATETIME,
	EndDate					DATETIME,
	StatusType				NVARCHAR(128)
)
AS
BEGIN
	SET @PersonalNumber = REPLACE(LTRIM(RTRIM(@PersonalNumber)), CHAR(9), '')
	SET @FirstName = REPLACE(LTRIM(RTRIM(@FirstName)), CHAR(9), '')
	SET @LastName = REPLACE(LTRIM(RTRIM(@LastName)), CHAR(9), '')

	IF @Advanced = 0
	BEGIN
		INSERT INTO @tbl_StaffList
		SELECT
			SD.StaffDepartmentID,
			SD.StaffID,
			S.PersonalNumber,
			S.FirstName,
			S.LastName,
			S.BirthDate,
			(CASE WHEN @Language = 1 THEN D.NameSQ
				  WHEN @Language = 2 THEN D.NameEN
				ELSE D.NameSQ END),
			(CASE WHEN @Language = 1 THEN ST.NameSQ
				  WHEN @Language = 2 THEN ST.NameEN
				ELSE ST.NameSQ END),
			SD.StartDate,
			SD.EndDate,
			(CASE WHEN @Language = 1 THEN Sy.NameSQ
				  WHEN @Language = 2 THEN Sy.NameEN
				ELSE Sy.NameSQ END)
		FROM StaffDepartment SD
			INNER JOIN Staff S						ON SD.StaffID = S.StaffID
			INNER JOIN Department D					ON SD.DepartmentID = D.DepartmentID
			INNER JOIN StaffType ST					ON SD.StaffTypeID = ST.StaffTypeID
			INNER JOIN StaffRegistrationStatus SRS	ON S.StaffID = SRS.StaffID
			INNER JOIN Core.StatusType SY			ON SRS.StatusTypeID = SY.StatusTypeID
		WHERE SRS.Active = 1
			AND SRS.StatusTypeID <> 5
			AND CAST(SD.EndDate AS DATE)		<= CAST(GETDATE() AS DATE)
			AND SD.StaffID						= ISNULL(@StaffId, SD.StaffID)
			AND SD.DepartmentID					= ISNULL(@DepartmentId, SD.DepartmentID)
			AND SD.StaffTypeID					= ISNULL(@StaffTypeId, SD.StaffTypeID)
			AND CAST(SD.StartDate AS DATE)		= ISNULL(CAST(@StartDate AS DATE), CAST(SD.StartDate AS DATE))
			AND CAST(SD.EndDate AS DATE)		= ISNULL(CAST(@EndDate AS DATE), CAST(SD.EndDate AS DATE))
	END
	ELSE
	BEGIN
		INSERT INTO @tbl_StaffList
		SELECT
			SD.StaffDepartmentID,
			SD.StaffID,
			S.PersonalNumber,
			S.FirstName,
			S.LastName,
			S.BirthDate,
			(CASE WHEN @Language = 1 THEN D.NameSQ
				  WHEN @Language = 2 THEN D.NameEN
				ELSE D.NameSQ END),
			(CASE WHEN @Language = 1 THEN ST.NameSQ
				  WHEN @Language = 2 THEN ST.NameEN
				ELSE ST.NameSQ END),
			SD.StartDate,
			SD.EndDate,
			(CASE WHEN @Language = 1 THEN Sy.NameSQ
				  WHEN @Language = 2 THEN Sy.NameEN
				ELSE Sy.NameSQ END)
		FROM StaffDepartment SD
			INNER JOIN Staff S						ON SD.StaffID = S.StaffID
			INNER JOIN Department D					ON SD.DepartmentID = D.DepartmentID
			INNER JOIN StaffType ST					ON SD.StaffTypeID = ST.StaffTypeID
			INNER JOIN StaffRegistrationStatus SRS	ON S.StaffID = SRS.StaffID
			INNER JOIN Core.StatusType SY			ON SRS.StatusTypeID = SY.StatusTypeID
		WHERE SRS.Active = 1
			AND SRS.StatusTypeID <> 5
			AND CAST(SD.EndDate AS DATE)		<= CAST(GETDATE() AS DATE)
			AND SD.StaffID						= ISNULL(@StaffId, SD.StaffID)
			AND SD.DepartmentID					= ISNULL(@DepartmentId, SD.DepartmentID)
			AND SD.StaffTypeID					= ISNULL(@StaffTypeId, SD.StaffTypeID)
			AND CAST(SD.StartDate AS DATE)		= ISNULL(CAST(@StartDate AS DATE), CAST(SD.StartDate AS DATE))
			AND CAST(SD.EndDate AS DATE)		= ISNULL(CAST(@EndDate AS DATE), CAST(SD.EndDate AS DATE))
			AND S.PersonalNumber				= ISNULL(@PersonalNumber, '')
			AND S.FirstName						= ISNULL(@FirstName, '')
			AND S.LastName						= ISNULL(@LastName, '')
			AND CAST(S.BirthDate AS DATE)		= ISNULL(CAST(@BirthDate AS DATE), CAST(S.BirthDate AS DATE))
			AND SRS.StatusTypeID				= ISNULL(@StatusTypeId, SRS.StatusTypeID)
	END

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[TablesWithColumns]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arb Tahiri
-- Create date: 06/10/2022
-- Description:	Function to return all database tables with its columns.
-- ======================================================================
-- SELECT * FROM TablesWithColumns()
-- ======================================================================
CREATE FUNCTION [dbo].[TablesWithColumns]()
RETURNS @tbl_TablesColumns TABLE
(
	[Schema]	NVARCHAR(50),
	[Table]		NVARCHAR(50),
	[Column]	NVARCHAR(50)
)
AS
BEGIN
	INSERT INTO @tbl_TablesColumns
	SELECT
		TABLE_SCHEMA,
		TABLE_NAME,
		COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	
	RETURN
END
GO
/****** Object:  StoredProcedure [job].[MissingStaffAttendance]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================
-- Author:			Arb Tahiri
-- Create date:		12/09/2022
-- Description:		Job to insert staff that did not attend work.
-- Execution Time:	Occurs every day at 10:00:00 PM.
-- ===============================================================
-- EXEC [job].[MissingStaffAttendance]
-- ===============================================================
CREATE PROCEDURE [job].[MissingStaffAttendance]
AS
BEGIN
	DECLARE @tbl_Attendance TABLE ( StaffID INT )
	INSERT INTO @tbl_Attendance
	SELECT
		StaffID
	FROM StaffAttendance
	WHERE CAST(InsertedDate AS DATE) = CAST(GETDATE() AS DATE) AND Active = 1

	INSERT INTO StaffAttendance (StaffID, Absent, AbsentTypeID, Description, Active, InsertedFrom, InsertedDate)
	SELECT
		S.StaffID,
		1,
		NULL,
		NULL,
		1,
		'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b',
		GETDATE()
	FROM Staff S
	WHERE
		S.StaffID NOT IN(SELECT StaffID FROM @tbl_Attendance)
END
GO
/****** Object:  StoredProcedure [job].[StaffDepartmentEndDate]    Script Date: 04-Nov-22 4:34:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================
-- Author:			Arb Tahiri
-- Create date:		30/09/2022
-- Description:		Job to insert Staff data if end date is today.
-- Execution Time:	Occurs every day at 8:00:00 PM.
-- ===============================================================
-- EXEC [job].[StaffDepartmentEndDate]
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
			UpdatedNo = (CASE WHEN UpdatedNo IS NULL THEN 1 ELSE UpdatedNo + 1 END)
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
