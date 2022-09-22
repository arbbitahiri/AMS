USE [master]
GO
/****** Object:  Database [AMS]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE DATABASE [AMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AMS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [AMS] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [AMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AMS] SET RECOVERY FULL 
GO
ALTER DATABASE [AMS] SET  MULTI_USER 
GO
ALTER DATABASE [AMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AMS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'AMS', N'ON'
GO
ALTER DATABASE [AMS] SET QUERY_STORE = OFF
GO
/****** Object:  Login [NT SERVICE\Winmgmt]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [NT SERVICE\Winmgmt] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\SQLWriter]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [NT SERVICE\SQLWriter] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\SQLTELEMETRY]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [NT SERVICE\SQLTELEMETRY] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT SERVICE\SQLSERVERAGENT]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [NT SERVICE\SQLSERVERAGENT] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT Service\MSSQLSERVER]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [NT Service\MSSQLSERVER] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [NT AUTHORITY\SYSTEM]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/****** Object:  Login [dataprognet\arb.tahiri]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [dataprognet\arb.tahiri] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [ams]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [ams] WITH PASSWORD=N'Eh3+QYT002ctSr1dkBk4cuTzuBbRCgKIPBl71lF+lic=', DEFAULT_DATABASE=[AMS], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
ALTER LOGIN [ams] DISABLE
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [##MS_PolicyTsqlExecutionLogin##]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [##MS_PolicyTsqlExecutionLogin##] WITH PASSWORD=N'/udEx56kFD8mPEz+QkvLsgHmviqYznMVux8+dmxSLSw=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER LOGIN [##MS_PolicyTsqlExecutionLogin##] DISABLE
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [##MS_PolicyEventProcessingLogin##]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE LOGIN [##MS_PolicyEventProcessingLogin##] WITH PASSWORD=N'JGpHcQR1b9fhn21PIxbwtYXbKexUUr005gXXVYXfI0w=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER LOGIN [##MS_PolicyEventProcessingLogin##] DISABLE
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\Winmgmt]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLWriter]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLSERVERAGENT]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT Service\MSSQLSERVER]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [dataprognet\arb.tahiri]
GO
USE [AMS]
GO
/****** Object:  User [ams]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE USER [ams] FOR LOGIN [ams] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [ams]
GO
/****** Object:  Schema [Core]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE SCHEMA [Core]
GO
/****** Object:  Schema [His]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE SCHEMA [His]
GO
/****** Object:  Schema [job]    Script Date: 22-Sep-22 3:31:57 PM ******/
CREATE SCHEMA [job]
GO
/****** Object:  UserDefinedFunction [dbo].[AttendanceConsecutiveDays]    Script Date: 22-Sep-22 3:31:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================
-- Author:		Arb Tahiri
-- Create date: 05/09/2022
-- Description:	Function to return the consecutive days of work for employees
/* ===========================================================================
   SELECT * FROM AttendanceConsecutiveDays (NULL, NULL, NULL, NULL, NULL, 1)
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
		WHERE Active = 1
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
		WorkingSince = (CASE WHEN A.Absent = 0 THEN COUNT(NULLIF(A.StaffID, 0)) ELSE 0 END)
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
/****** Object:  UserDefinedFunction [dbo].[Logs]    Script Date: 22-Sep-22 3:31:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================
-- Author:		<Arb Tahiri>
-- Create date: <10.06.2022>
-- Description:	<Function to get the list of logs depending of search parameters.>
-- =================================================================================
-- SELECT * FROM [Logs] ('', '', '2022-06-09', '2022-06-11', NULL, NULL, NULL, NULL, 0)
-- =================================================================================
CREATE FUNCTION [dbo].[Logs] 
(
	@RoleId				NVARCHAR(450),
	@UserId				NVARCHAR(450),
	@StartDate			DATE,
	@EndDate			DATE,
	@Ip					NVARCHAR(128),
	@Controller			NVARCHAR(128),
	@Action				NVARCHAR(128),
	@HttpMethod			NVARCHAR(128),
	@Error				BIT
)
RETURNS
@temp_Logs TABLE 
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
		LEFT JOIN AspNetUsers U ON U.Id = L.UserID
		LEFT JOIN AspNetUserRoles R ON R.UserID = L.UserID
	WHERE (CAST(L.InsertedDate AS DATE) BETWEEN @StartDate AND @EndDate)
		AND ISNULL(L.UserId, '')	= ISNULL(@UserId, ISNULL(L.UserId, ''))
		AND ISNULL(R.RoleId, '')	= ISNULL(@RoleId, ISNULL(R.RoleId, ''))
		AND L.Ip					= ISNULL(@Ip, L.Ip)
		AND L.Controller			= ISNULL(@Controller, L.Controller)
		AND L.Action				= ISNULL(@Action, L.Action)
		AND L.HttpMethod			= ISNULL(@HttpMethod, L.HttpMethod)
		AND L.Error					= (CASE WHEN @Error = 0 THEN L.Error ELSE @Error END)
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[MenuList]    Script Date: 22-Sep-22 3:31:57 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[MenuListAccess]    Script Date: 22-Sep-22 3:31:57 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[StaffConsecutiveDays]    Script Date: 22-Sep-22 3:31:57 PM ******/
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
		LEFT JOIN AttendanceCTE A			ON A.StaffID = S.StaffID AND CAST(A.InsertedDate AS DATE) BETWEEN CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) AND CAST(GETDATE() AS DATE)
		INNER JOIN StaffDepartment SD		ON S.StaffID = SD.StaffID
		INNER JOIN Department D				ON SD.DepartmentID = D.DepartmentID
		INNER JOIN StaffType ST				ON SD.StaffTypeID = ST.StaffTypeID
		LEFT JOIN StaffAttendance SA		ON SA.StaffID = A.StaffID AND CAST(SA.InsertedDate AS DATE) = CAST(GETDATE() AS DATE) AND SA.Absent = 0 AND SA.Active = 1
	WHERE S.StaffID						= ISNULL(@StaffId, S.StaffID)
		AND SD.DepartmentID				= ISNULL(@DepartmentId, SD.DepartmentID)
		AND SD.StaffTypeID				= ISNULL(@StaffTypeId, SD.StaffTypeID)
		AND CAST(SD.EndDate AS DATE)	>= CAST(GETDATE() AS DATE)
	GROUP BY S.StaffID, A.GroupingSet, A.Absent
	ORDER BY S.StaffID;
	
	RETURN
END
GO
/****** Object:  Table [Core].[City]    Script Date: 22-Sep-22 3:31:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[City](
	[CityID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Core].[Country]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Core].[Gender]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[Gender](
	[GenderID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](50) NOT NULL,
	[NameEN] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED 
(
	[GenderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Core].[Log]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[Log](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](450) NULL,
	[IP] [nvarchar](64) NOT NULL,
	[Controller] [nvarchar](128) NOT NULL,
	[Action] [nvarchar](128) NOT NULL,
	[Developer] [nvarchar](32) NULL,
	[Description] [nvarchar](128) NULL,
	[HttpMethod] [nvarchar](24) NOT NULL,
	[Url] [nvarchar](1024) NOT NULL,
	[FormContent] [nvarchar](2048) NULL,
	[Error] [bit] NOT NULL,
	[Exception] [nvarchar](max) NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Core].[Menu]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[Menu](
	[MenuID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[HasSubMenu] [bit] NOT NULL,
	[Icon] [nvarchar](128) NULL,
	[Claim] [nvarchar](128) NULL,
	[ClaimType] [nvarchar](128) NULL,
	[Area] [nvarchar](128) NULL,
	[Controller] [nvarchar](128) NULL,
	[Action] [nvarchar](128) NULL,
	[OrdinalNumber] [int] NOT NULL,
	[Roles] [nvarchar](2048) NULL,
	[OpenFor] [nvarchar](max) NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Core].[Notification]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[Notification](
	[NotificationID] [int] IDENTITY(1,1) NOT NULL,
	[Receiver] [nvarchar](450) NOT NULL,
	[Type] [int] NOT NULL,
	[Title] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[Url] [nvarchar](1024) NULL,
	[Icon] [nvarchar](128) NOT NULL,
	[Read] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Core].[RealRole]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[RealRole](
	[RealRoleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](450) NOT NULL,
	[RoleID] [nvarchar](450) NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_RealRole] PRIMARY KEY CLUSTERED 
(
	[RealRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Core].[StatusType]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[StatusType](
	[StatusTypeID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_StatusType] PRIMARY KEY CLUSTERED 
(
	[StatusTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Core].[SubMenu]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Core].[SubMenu](
	[SubMenuID] [int] IDENTITY(1,1) NOT NULL,
	[MenuID] [int] NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Icon] [nvarchar](128) NULL,
	[Claim] [nvarchar](128) NULL,
	[ClaimType] [nvarchar](128) NULL,
	[Area] [nvarchar](128) NULL,
	[Controller] [nvarchar](128) NULL,
	[Action] [nvarchar](128) NULL,
	[OrdinalNumber] [int] NOT NULL,
	[Roles] [nvarchar](2048) NULL,
	[OpenFor] [nvarchar](max) NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_SubMenu] PRIMARY KEY CLUSTERED 
(
	[SubMenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AbsentType]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AbsentType](
	[AbsentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_AbsentType] PRIMARY KEY CLUSTERED 
(
	[AbsentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NameSQ] [nvarchar](256) NULL,
	[NameEN] [nvarchar](256) NULL,
	[Description] [nvarchar](512) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[PersonalNumber] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](128) NOT NULL,
	[LastName] [nvarchar](128) NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[ProfileImage] [nvarchar](512) NULL,
	[AllowNotification] [bit] NOT NULL,
	[Language] [int] NOT NULL,
	[AppMode] [int] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentType]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentType](
	[DocumentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_DocumentType] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 22-Sep-22 3:31:58 PM ******/
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
/****** Object:  Table [dbo].[StaffAttendance]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffAttendance](
	[StaffAttendanceID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[Absent] [bit] NOT NULL,
	[AbsentTypeID] [int] NULL,
	[Description] [nvarchar](2048) NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_StaffDepartmentAttendance] PRIMARY KEY CLUSTERED 
(
	[StaffAttendanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StaffDepartment]    Script Date: 22-Sep-22 3:31:58 PM ******/
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
/****** Object:  Table [dbo].[StaffDocument]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffDocument](
	[StaffDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [int] NOT NULL,
	[DocumentTypeID] [int] NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Path] [nvarchar](2048) NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[Active] [bit] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_StaffDocument] PRIMARY KEY CLUSTERED 
(
	[StaffDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StaffRegistrationStatus]    Script Date: 22-Sep-22 3:31:58 PM ******/
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
/****** Object:  Table [dbo].[StaffType]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffType](
	[StaffTypeID] [int] IDENTITY(1,1) NOT NULL,
	[NameSQ] [nvarchar](128) NOT NULL,
	[NameEN] [nvarchar](128) NOT NULL,
	[Active] [bit] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_StaffType] PRIMARY KEY CLUSTERED 
(
	[StaffTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [His].[AppSettings]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [His].[AppSettings](
	[AppSettingsID] [int] IDENTITY(1,1) NOT NULL,
	[OldVersion] [nvarchar](max) NOT NULL,
	[NewVersion] [nvarchar](max) NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NULL,
 CONSTRAINT [PK_AppSettings] PRIMARY KEY CLUSTERED 
(
	[AppSettingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [His].[AspNetUser]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [His].[AspNetUser](
	[AspNetUserID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](450) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[PersonalNumber] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](128) NOT NULL,
	[LastName] [nvarchar](128) NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[ProfileImage] [nvarchar](512) NULL,
	[AllowNotification] [bit] NOT NULL,
	[Language] [int] NOT NULL,
	[AppMode] [int] NOT NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AspNetUser] PRIMARY KEY CLUSTERED 
(
	[AspNetUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Core].[City] ON 

INSERT [Core].[City] ([CityID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Ferizaj', N'Ferizaj', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:48:49.833' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[City] ([CityID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, N'Londër', N'London', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:48:57.543' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[City] OFF
GO
SET IDENTITY_INSERT [Core].[Country] ON 

INSERT [Core].[Country] ([CountryID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Kosovë', N'Kosova', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:48:33.353' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Country] ([CountryID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, N'Angli', N'England', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:48:41.103' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[Country] OFF
GO
SET IDENTITY_INSERT [Core].[Gender] ON 

INSERT [Core].[Gender] ([GenderID], [NameSQ], [NameEN]) VALUES (1, N'Mashkull', N'Male')
INSERT [Core].[Gender] ([GenderID], [NameSQ], [NameEN]) VALUES (2, N'Femër', N'Female')
SET IDENTITY_INSERT [Core].[Gender] OFF
GO
SET IDENTITY_INSERT [Core].[Log] ON 

INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4841, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-19T16:14:01.220' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4842, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-19T16:14:03.920' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4843, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-09-19T16:15:06.067' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4844, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBKNfWNVuCMCSEUpxIVqkvfEd5GF6BhBYXXtOpahqVb-r8H_Gj1hIoDgfWwMTGW1ezujhklhQAoXBGaAAHwtkHsCZqgH3NbFGVHVcr9fYLl0-WMtlCVPLkbjL4pZJM3XXx9WGPpshe-dO0kIkgsT2tZs9uJZs-nCQvTt0DaaKIhOw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-19T16:15:07.447' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4845, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:15:10.603' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4846, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:15:11.773' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4847, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:15:13.487' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4848, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:15:21.483' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4849, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:16:46.557' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4850, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:17:00.803' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4851, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:17:04.980' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4852, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:17:12.053' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4853, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=09/14/2022', NULL, 0, NULL, CAST(N'2022-09-19T16:17:13.700' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4854, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:20:13.723' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4855, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:20:26.313' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4856, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:20:50.253' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4857, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:20:56.443' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4858, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History/)wS2xUQDnb4y0k5CIbjF(A==?startDate=09%2F14%2F2022%2014%3A26%3A48&amp;endDate=09%2F19%2F2022%2014%3A59%3A55', NULL, 0, NULL, CAST(N'2022-09-19T16:21:02.603' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4859, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:27:24.170' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4860, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:27:37.437' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4861, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:28:03.273' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4862, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:28:27.257' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4863, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History/)wS2xUQDnb4y0k5CIbjF(A==?startDate=09%2F14%2F2022%2014%3A26%3A48&amp;endDate=09%2F19%2F2022%2014%3A59%3A55', NULL, 0, NULL, CAST(N'2022-09-19T16:29:07.153' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4864, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:29:49.053' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4865, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:30:00.520' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4866, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:30:02.523' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4867, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:30:10.053' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4868, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:35:00.920' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4869, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:35:02.553' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4870, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:35:08.410' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4871, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:35:11.053' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4872, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=09/14/2022', NULL, 0, NULL, CAST(N'2022-09-19T16:35:15.093' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4873, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:36:23.703' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4874, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:36:34.520' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4875, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:36:36.287' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4876, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:36:38.533' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4877, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=09/14/2022', NULL, 0, NULL, CAST(N'2022-09-19T16:36:44.617' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4878, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', NULL, NULL, N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=09/14/2022', NULL, 1, N'{"ClassName":"System.Data.SqlTypes.SqlTypeException","Message":"SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.","Data":null,"InnerException":null,"HelpURL":null,"StackTraceString":"   at Microsoft.Data.SqlClient.SqlCommand.<>c.<ExecuteDbDataReaderAsync>b__188_0(Task`1 result)\r\n   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()\r\n   at System.Threading.Tasks.Task.<>c.<.cctor>b__272_0(Object obj)\r\n   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)\r\n--- End of stack trace from previous location ---\r\n   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)\r\n   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Query.Internal.SingleQueryingEnumerable`1.AsyncEnumerator.InitializeReaderAsync(AsyncEnumerator enumerator, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.SqlServer.Storage.Internal.SqlServerExecutionStrategy.ExecuteAsync[TState,TResult](TState state, Func`4 operation, Func`4 verifySucceeded, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Query.Internal.SingleQueryingEnumerable`1.AsyncEnumerator.MoveNextAsync()\r\n   at Microsoft.EntityFrameworkCore.Query.ShapedQueryCompilingExpressionVisitor.SingleOrDefaultAsync[TSource](IAsyncEnumerable`1 asyncEnumerable, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Query.ShapedQueryCompilingExpressionVisitor.SingleOrDefaultAsync[TSource](IAsyncEnumerable`1 asyncEnumerable, CancellationToken cancellationToken)\r\n   at AMS.Controllers.AttendanceController.History(String ide, DateTime startDate, DateTime endDate) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Controllers\\AttendanceController.cs:line 144\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.TaskOfIActionResultExecutor.Execute(IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 165\r\n--- End of stack trace from previous location ---\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146232016,"Source":"Microsoft.Data.SqlClient","WatsonBuckets":null}', CAST(N'2022-09-19T16:36:58.210' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4879, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:37:29.493' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4880, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:37:34.990' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4881, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:37:36.840' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4882, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:37:38.920' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4883, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=09/14/2022', NULL, 0, NULL, CAST(N'2022-09-19T16:37:46.123' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4884, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:41:48.867' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4885, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:41:58.887' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4886, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:42:28.167' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4887, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:44:11.803' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4888, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:44:20.673' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4889, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:44:25.557' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4890, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:45:34.243' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4891, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:45:43.237' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4892, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:45:47.053' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4893, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:49:25.097' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4894, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-19T16:49:33.733' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4895, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-19T16:49:50.353' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4896, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937&endDate2=', NULL, 0, NULL, CAST(N'2022-09-19T16:50:00.700' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4897, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History/)wS2xUQDnb4y0k5CIbjF(A==?startDate=09%2F14%2F2022%2014%3A26%3A48&amp;endDate2=19%2F09%2F2022', NULL, 0, NULL, CAST(N'2022-09-19T16:50:05.833' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4898, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.89', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://192.168.1.89:2022/', NULL, 0, NULL, CAST(N'2022-09-19T21:29:40.670' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4899, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.89', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://192.168.1.89:2022/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-19T21:29:41.373' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4900, NULL, N'192.168.1.114', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://192.168.1.89:2022/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-09-20T08:41:35.193' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4901, NULL, N'192.168.1.114', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://192.168.1.89:2022/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["admin"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la4WV-ngJSQIYZKtwK2XQbSUYdzUiffG-ClbWqps2pJuyiW_jt561K-FrGVk52rR3M-esMdqmQ_66mc0z2rdHGTPdeP5hsK21YU-aJv53N096xWFiLbpgBlO1R6KmqsVBAI"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:41:59.480' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4902, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://192.168.1.89:2022/Home/Index', NULL, 0, NULL, CAST(N'2022-09-20T08:42:00.400' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4903, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://192.168.1.89:2022/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T08:42:00.437' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4904, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://192.168.1.89:2022/Profile', NULL, 0, NULL, CAST(N'2022-09-20T08:42:20.690' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4905, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Attendance?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:21.430' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4906, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://192.168.1.89:2022/Profile', NULL, 0, NULL, CAST(N'2022-09-20T08:42:23.957' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4907, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Attendance?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:24.553' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4908, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Document', N'Arb Tahiri', N'Form to display list of documents for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Document?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:25.380' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4909, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Department', N'Arb Tahiri', N'Form to display list of departments for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Department?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:27.370' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4910, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Attendance?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:28.920' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4911, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Document', N'Arb Tahiri', N'Form to display list of documents for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Document?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:30.210' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4912, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Attendance?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:32.820' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4913, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Profile', N'_Department', N'Arb Tahiri', N'Form to display list of departments for staff.', N'GET', N'https://192.168.1.89:2022/Profile/_Department?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:34.913' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4914, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://192.168.1.89:2022/Document', NULL, 0, NULL, CAST(N'2022-09-20T08:42:42.190' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4915, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://192.168.1.89:2022/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la7TOnfTPJpK7k7cmgEjPbVsBmf2_HlL6LB-8-jhy685PQGK-dXA7t8pR2aS1rhMI8-LZrocJLV7YhUofiv99XQn-gZiRfqu6fZ2N5LpALVJHigmCy4tqnG-BWWHE-IJ4r57FBUTgGO-InhXI_P27TOZB_HRPloPJmgQXANt_saTtQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:42:42.693' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4916, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Document', N'Edit', N'Arb Tahiri', N'Form to edit a document.', N'GET', N'https://192.168.1.89:2022/Document/Edit?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T08:42:48.617' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4917, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://192.168.1.89:2022/Staff', NULL, 0, NULL, CAST(N'2022-09-20T08:42:54.553' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4918, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://192.168.1.89:2022/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la7Tfo5lRT0r7HSvWPX7KyH_kH1udzrge2wtLQ9ma71ux3R6ULY13WSHYApr3CcuCyi0na19iPly8_n_Um6b3b8afDeqNB2eYfC7cr6yghSM_PMq89Y8lSSjyJBHI3mUrqRrdFheHxZauMXEtYxiuiIcGL7sYdUbWzTVQ_dk5srVoA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:42:55.117' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4919, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'InProcess', N'Arb Tahiri', N'Form to display list of staff that are in process of registration.', N'GET', N'https://192.168.1.89:2022/Staff/InProcess', NULL, 0, NULL, CAST(N'2022-09-20T08:43:01.027' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4920, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://192.168.1.89:2022/Staff/Register?ide=1RbMNmpsqzvMWktnS4knbA==', NULL, 0, NULL, CAST(N'2022-09-20T08:43:06.097' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4921, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Edit', N'Arb Tahiri', N'Action to edit staff data.', N'POST', N'https://192.168.1.89:2022/Staff/Edit', N'[{"Key":"StaffIde","Value":["1RbMNmpsqzvMWktnS4knbA=="]},{"Key":"MethodType","Value":["2"]},{"Key":"PersonalNumber","Value":["1242823636"]},{"Key":"Firstname","Value":["Amigo"]},{"Key":"Lastname","Value":["AAAA"]},{"Key":"Email","Value":["231321@32132asxc.com"]},{"Key":"PhoneNumber","Value":["38345354354"]},{"Key":"BirthDate","Value":["09/04/2022"]},{"Key":"GenderId","Value":["2"]},{"Key":"CityId","Value":["1"]},{"Key":"CountryId","Value":["2"]},{"Key":"Address","Value":["dikun"]},{"Key":"PostalCode","Value":["70000"]},{"Key":"Username","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la5CmY-WV8AlYbOUVEBu9EkDXjOwbqsSsaerE2s6x1VBw903TtUV5wB3o7ioCSiO4MuxW-EGm_kfo9t62weL09mgRl0bsIyJuGOM5FD0KRo6kTO4jci5rCtXNtEjN8wHGXyrrC9N_EV_cGcOqg3j0N33cjEVt2Eq0qnbo48pEXPA-Q"]},{"Key":"NewUser","Value":["false"]}]', 0, NULL, CAST(N'2022-09-20T08:43:10.807' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4922, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://192.168.1.89:2022/Staff/Documents/1RbMNmpsqzvMWktnS4knbA==', NULL, 0, NULL, CAST(N'2022-09-20T08:43:10.937' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4923, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'_AddDocument', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://192.168.1.89:2022/Staff/_AddDocument?ide=1RbMNmpsqzvMWktnS4knbA==', NULL, 0, NULL, CAST(N'2022-09-20T08:43:13.430' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4924, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'AddDocument', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://192.168.1.89:2022/Staff/AddDocument', N'[{"Key":"StaffIde","Value":["1RbMNmpsqzvMWktnS4knbA=="]},{"Key":"DocumentTypeId","Value":["2"]},{"Key":"Title","Value":["Certifikata lindjes"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la7H6yhMTA-Qd5Cm0I0EyL65oXwL4tglfW6HNG_SflL7oNxJu94f6fPjjrrJ_oRwf75eI2vcXo8s5A1d0IG74DHzjjGEwWCg3973mO_m7CYD-Q8P0cuohP7Rty7yl1Jdg565RsXd9DDmKfCVFJ34ly_Q3hMnZdnvfV-3B_0Yo8AgJw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:43:32.327' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4925, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'AddDocument', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://192.168.1.89:2022/Staff/AddDocument', N'[{"Key":"StaffIde","Value":["1RbMNmpsqzvMWktnS4knbA=="]},{"Key":"DocumentTypeId","Value":["2"]},{"Key":"Title","Value":["Certifikata lindjes"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la7H6yhMTA-Qd5Cm0I0EyL65oXwL4tglfW6HNG_SflL7oNxJu94f6fPjjrrJ_oRwf75eI2vcXo8s5A1d0IG74DHzjjGEwWCg3973mO_m7CYD-Q8P0cuohP7Rty7yl1Jdg565RsXd9DDmKfCVFJ34ly_Q3hMnZdnvfV-3B_0Yo8AgJw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:43:49.947' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4926, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://192.168.1.89:2022/Staff/Documents/1RbMNmpsqzvMWktnS4knbA==', NULL, 0, NULL, CAST(N'2022-09-20T08:43:51.867' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4927, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Departments', N'Arb Tahiri', N'Entry form for department. Fourth step of registration/editation of staff.', N'GET', N'https://192.168.1.89:2022/Staff/Departments?ide=1RbMNmpsqzvMWktnS4knbA==', NULL, 0, NULL, CAST(N'2022-09-20T08:43:57.557' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4928, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Finish', N'Arb Tahiri', N'Action to add finished status in staff registration.', N'POST', N'https://192.168.1.89:2022/Staff/Finish', N'[{"Key":"ide","Value":["1RbMNmpsqzvMWktnS4knbA=="]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la4jOAnhEyVXXFEKRgW-Usl8W3BMcDQ-OlSqMPh14UwdqDSBlNjDcwHQ5Ls0IqMP_zgkHXoQkiQawV64KsiaxRfgq9R0vIR3nuVPRIiXeQdtVx7GvlIYIDgnJ1ysREPNKv3Rqr7kJbq-v7nilhJhQW4kct4DhU8W9hPjt3tJNwyp6A"]}]', 0, NULL, CAST(N'2022-09-20T08:44:01.337' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4929, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://192.168.1.89:2022/Staff', NULL, 0, NULL, CAST(N'2022-09-20T08:44:03.467' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4930, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://192.168.1.89:2022/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la5oz1aq5qJmRPNNVYqJthRboAzNTXEzUI0fvMvz1J0QA9lu4vNeYdIdUospi-uIKpQyDFZoTBBDQW6Yz0aLLe83YeL-65OToqU_xs9FJSdojLxb1Ouz_uXmZiK4ClOMnre4VgekX-JO-8SpAcBRbgpiy7hyufPAj_zkrzQFp_iIHg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:44:03.970' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4931, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Staff', N'InProcess', N'Arb Tahiri', N'Form to display list of staff that are in process of registration.', N'GET', N'https://192.168.1.89:2022/Staff/InProcess', NULL, 0, NULL, CAST(N'2022-09-20T08:44:06.720' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4932, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://192.168.1.89:2022/Attendance', NULL, 0, NULL, CAST(N'2022-09-20T08:44:10.183' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4933, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://192.168.1.89:2022/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-20T08:44:10.873' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4934, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://192.168.1.89:2022/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la56bE5hRmQ7nK72HWVMgli8n_Tz5XuiN2FSfQpgn2xtAQm0cG88dXcRSYVVTSi3iUTcElD0gMaD8aFKggkfjdeNxpJokdRJmTnL2mU_gT7_nod2i8wDcKCLsSFzOFzY7Kzwk2pozEDfCYKf3ErHO-9YhZwzQhle5_LKooTR7ZMasw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:44:12.457' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4935, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://192.168.1.89:2022/Attendance', NULL, 0, NULL, CAST(N'2022-09-20T08:44:20.807' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4936, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://192.168.1.89:2022/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-20T08:44:21.397' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4937, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://192.168.1.89:2022/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-20T08:44:23.000' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4938, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://192.168.1.89:2022/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la5TsCntU3tmRaUYTEPqzcP8LsK3fKZXe2Wpj4DAbk4fLitZboHeBffIQ2IDj0olFgyAqvp_MWrx6bZXz-_MX2g0juywE47dnz9nZgJ_4ctFZxmfBwkxjjLJP--T4Iz50TEoekKHViSfVskigDrTDs466VW1gJlDc9S0PDqL-MsaRA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:44:24.580' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4939, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://192.168.1.89:2022/Attendance/History?ide=KOdWayAvLxjucAJgFTnGLQ==&startDate=2022-09-19T15:00:05.553&endDate=2022-09-19T15:00:05.553', NULL, 0, NULL, CAST(N'2022-09-20T08:44:31.157' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4940, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.114', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://192.168.1.89:2022/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-20T08:44:37.020' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4941, NULL, N'192.168.1.90', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://192.168.1.89:2022/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-09-20T08:45:43.487' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4942, NULL, N'192.168.1.90', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://192.168.1.89:2022/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["admin"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8NiCfBzXNAVJqKxid7Y2la6xukKSLNMdQ9dkBDmLUwO1k4I8pq-hgWIVaMmPNF9qbFC4cJiuxQ2Y1HaqPNsSv3KPRI252L1D72Lmq2uS87E5W5GIdKoxnOQpIBIaT6PjKSGkRvDc2Q_mxk9xZfHD14s"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T08:46:04.647' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4943, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.90', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://192.168.1.89:2022/Home/Index', NULL, 0, NULL, CAST(N'2022-09-20T08:46:04.733' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4944, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'192.168.1.90', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://192.168.1.89:2022/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T08:46:04.783' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4945, NULL, N'192.168.1.90', N'Identity', N'/Account/Manage/Index', NULL, NULL, N'GET', N'https://192.168.1.89:2022/Identity/Account/Manage', NULL, 0, NULL, CAST(N'2022-09-20T08:46:21.323' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4946, NULL, N'192.168.1.90', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://192.168.1.89:2022/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-09-20T08:46:34.730' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4947, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FHome%2FIndex', NULL, 0, NULL, CAST(N'2022-09-20T09:00:47.910' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4948, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FHome%2FIndex', NULL, 0, NULL, CAST(N'2022-09-20T09:02:23.533' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4949, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FHome%2FIndex', NULL, 0, NULL, CAST(N'2022-09-20T09:02:27.407' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4950, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2FHome%2FIndex', N'[{"Key":"Input.returnUrl","Value":["/Home/Index"]},{"Key":"Input.Email","Value":["admin"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBhuD8HHeuhpAxWJnISonkRLQ6PPu20pkOHre9QFr47_Qg8rkA6lb2ONTvGqK2F01dgW6Fxv61pRTVE9fsylbyK9_RXoepfjJ50xirYnF6G2em64xRG-b0BOLSrrYwrBaE"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T09:04:14.083' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4951, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2FHome%2FIndex', N'[{"Key":"Input.returnUrl","Value":["/Home/Index"]},{"Key":"Input.Email","Value":["admin"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBhuD8HHeuhpAxWJnISonkRLQ6PPu20pkOHre9QFr47_Qg8rkA6lb2ONTvGqK2F01dgW6Fxv61pRTVE9fsylbyK9_RXoepfjJ50xirYnF6G2em64xRG-b0BOLSrrYwrBaE"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T09:04:14.083' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4952, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-20T09:04:15.867' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4953, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T09:04:15.927' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4954, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-20T09:04:32.217' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4955, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-20T09:04:33.553' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4956, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-20T09:04:36.693' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4957, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAvGg7x2ShTkrQbhSQ50LQqUsZSjFtUfPBnszn8e81BN4KEVIvZM0veWfomyhNLmCm4jPo5pDwuGBml3VsqhIB0UG6Q5zmhbFlpPpiHm-bFFz8XzsaVKgiwv2uYcUfeL6u0CwK4pCCrHZyvQWv3iXMOfujkicLuoNrRSGE3IUon9g"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T09:04:38.040' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4958, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?StaffIde=)wS2xUQDnb4y0k5CIbjF(A==&StartDate=2022-09-14T14:26:48.187&EndDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:04:41.407' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4959, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:04:44.043' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4960, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?StaffIde=)wS2xUQDnb4y0k5CIbjF(A%3D%3D&amp;StartDate=09%2F14%2F2022%2014%3A26%3A48&amp;EndDate=09%2F19%2F2022%2014%3A59%3A55', NULL, 0, NULL, CAST(N'2022-09-20T09:04:48.520' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4961, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-20T09:23:06.467' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4962, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T09:23:07.830' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4963, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-09-20T09:24:07.963' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4964, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCsuA6tELSpGSyZFZ9wv1d9UQ9ZyRJR51Cq2XjdHEAqOnqeq7akYBUXkeORkQ_OxBlq8dP8VehalTREaagd1I5gzzkQYC4OmpoGjXFaCoZFM9gHOpL75mR0NgpVt0tcd4Veuty5ItZI6V2GkGtnTKKj2xm7fzWyAT4h6ViGJf_R9A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T09:24:09.523' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4965, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=KOdWayAvLxjucAJgFTnGLQ==', NULL, 0, NULL, CAST(N'2022-09-20T09:24:18.303' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4966, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=KOdWayAvLxjucAJgFTnGLQ==', NULL, 0, NULL, CAST(N'2022-09-20T09:24:19.720' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4967, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=KOdWayAvLxjucAJgFTnGLQ==&startDate=2022-09-08T14:26:48.187&endDate=2022-09-14T14:26:48.187', NULL, 0, NULL, CAST(N'2022-09-20T09:24:27.093' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4968, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-09-20T09:24:32.183' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4969, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB_Ssyo8W5xWkpwHs2ysuLGpRFYPEdQ0AUPfxaEAaH_P_DRqWM5bu5CW7jMZvac7lS7YyRjH63iwzpf_MDv67rPZ3iwnJ-plDkQoPQ51Ioc6l_3n8LAc7I0iovRJXqDemMXLw72x3ZAZdmY0L6EQPXFnm2oP03kdANI1uFHs8d0XA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T09:24:32.977' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4970, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:24:36.497' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4971, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:24:37.173' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4972, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:26:21.477' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4973, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:26:23.877' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4974, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?sIde=2PnkkUgilTC2A)sJk13jRw%3D%3D', NULL, 0, NULL, CAST(N'2022-09-20T09:27:01.310' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4975, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T09:31:50.793' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4976, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=wKNPnKNkze3Sc6ctRIgUrg==', NULL, 0, NULL, CAST(N'2022-09-20T09:32:07.903' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4977, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-09-20T09:32:37.753' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4978, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB84cXmBVCC5msgVif9BeRT-m-aLufSehdPsfruy4l80waUwg4L1BUnjXIzoqLkIisz0yg1_KAwqHnVFNSIprUpptIWmTMVoEFr-_Y3xB6A54bLPQLfjys2CHjJ_QS2iBRr5_4SC44GL81VzmaHIrGNqSxF7CgMwBsO9mqMB9wvIQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T09:32:40.240' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4979, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:32:43.323' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4980, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:32:45.370' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4981, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:32:49.923' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4982, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:33:01.987' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4983, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?sIde=2PnkkUgilTC2A)sJk13jRw%3D%3D', NULL, 0, NULL, CAST(N'2022-09-20T09:33:09.353' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4984, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:36:07.740' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4985, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:36:18.067' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4986, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:36:20.367' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4987, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:36:55.027' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4988, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?sIde=2PnkkUgilTC2A)sJk13jRw%3D%3D', NULL, 0, NULL, CAST(N'2022-09-20T09:37:05.610' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4989, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:41:28.157' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4990, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:41:39.247' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4991, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:42:04.693' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4992, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:42:09.907' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4993, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:42:15.110' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4994, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:42:15.827' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4995, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:42:17.520' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4996, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:42:21.303' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4997, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:44:06.803' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4998, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:44:19.003' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4999, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:45:32.443' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5000, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=2PnkkUgilTC2A)sJk13jRw==&sIde=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:45:37.093' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5001, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:45:39.820' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5002, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:45:40.870' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5003, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:45:41.907' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5004, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:45:43.277' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5005, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'Index', N'Arb Tahiri', N'Form to display staff profile.', N'GET', N'https://localhost:5001/Profile?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:58:10.160' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5006, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Profile', N'_Attendance', N'Arb Tahiri', N'Form to display list of attendance for staff.', N'GET', N'https://localhost:5001/Profile/_Attendance?ide=)wS2xUQDnb4y0k5CIbjF(A==', NULL, 0, NULL, CAST(N'2022-09-20T09:58:22.410' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5007, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=)wS2xUQDnb4y0k5CIbjF(A==&startDate=2022-09-14T14:26:48.187&endDate=2022-09-19T14:59:55.937', NULL, 0, NULL, CAST(N'2022-09-20T09:59:15.833' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5008, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Action to add absent type and add description for staff.', N'POST', N'https://localhost:5001/Attendance/StaffAttendance', N'[{"Key":"AbsentDetails.AttendanceIde","Value":["2PnkkUgilTC2A)sJk13jRw=="]},{"Key":"AbsentDetails.AbsentTypeId","Value":[""]},{"Key":"AbsentDetails.Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBOrFeI-Cf-yeEjgu49Cy-sI8Yin0o_3cmMZFGKp8u8ZL0UKgRRljFbSa7obVKiP7s6g7pFm2kGJLbFSG3QldiC049FFIQIBSiFWBkQlW59_SPzWxMreuFI1T1h8qQYSOLMUAvg9zESvmfTliU8Zr58tSvZkr2gFR-6BKgUEUw3lA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T10:00:11.110' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5009, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-09-20T10:30:26.540' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5010, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T10:30:28.733' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5011, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T10:41:48.370' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5012, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-09-20T10:41:53.790' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5013, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBd8v_WzRbr5wUOH5NRhm1aO9GaySMzmAFgprq26ShyCQCoFXyIwVBXBcsE1KwLIKPydQzIbM_cUBcKXG9zjLJyXCY2_eaYJUrwqCaThgfaGtVUgY8u6mTYvhL8q4a-3zzKRy_rt3CJlckeMxAI2cCcLBttvlx4JizQSrRi3kjeGw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T10:41:55.323' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5014, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'ChangeLanguage', N'Arb Tahiri', N'Change language.', N'GET', N'https://localhost:5001/Staff/ChangeLanguage?culture=sq-AL&returnUrl=%2FStaff', NULL, 0, NULL, CAST(N'2022-09-20T10:41:57.730' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5015, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-09-20T10:41:57.877' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5016, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBJTJngVyG7xqz343Jx4s3X7O_5Un5kShSX_8Nm70kTKpzKYUziKjjyyyGQN5e864x8YceY6PKIbSXd3F0AXhbjoxbmDVOQrxjUVmuPlNs71AqEUEm39yHfAj1bA0Uh92iwWQrXWwn3tbaupXuYkn_2004WQQsgorq4K8YdLXmgqw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T10:41:58.580' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5017, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-09-20T10:42:01.057' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5018, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-09-20T10:42:14.077' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5019, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-09-20T10:42:31.320' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5020, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-09-20T10:42:41.643' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5021, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-09-20T10:46:11.610' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5022, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Action to register staff.', N'POST', N'https://localhost:5001/Staff/Register', N'[{"Key":"StaffIde","Value":[""]},{"Key":"MethodType","Value":["1"]},{"Key":"PersonalNumber","Value":["1234569789"]},{"Key":"Firstname","Value":["Loretta"]},{"Key":"Lastname","Value":["Lynn"]},{"Key":"Email","Value":["loretta@lynn.com"]},{"Key":"PhoneNumber","Value":["38345662135"]},{"Key":"BirthDate","Value":["13/09/2022"]},{"Key":"GenderId","Value":["2"]},{"Key":"CityId","Value":["2"]},{"Key":"CountryId","Value":["2"]},{"Key":"Address","Value":["23rd street"]},{"Key":"PostalCode","Value":["E8854"]},{"Key":"NewUser","Value":["true","false"]},{"Key":"Username","Value":["loretta"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDLY2guOsZlPHhkKWQ7dNLoJugNPrZ2VJ3bt6LfbHcWt3K4UIif22aiLzlda_y0QCTDul7OwOO1zpQnJnZcQ8F7v3c_niFU92HYGqF9ahtDUotH_HJmjfx49JVtVenJFRb0San9JRvmwo0gspBkO9M7AuQWJdr2gCkBNNW1T0WIQg"]}]', 0, NULL, CAST(N'2022-09-20T11:15:42.247' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5023, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', NULL, NULL, N'POST', N'https://localhost:5001/Staff/Register', N'[{"Key":"StaffIde","Value":[""]},{"Key":"MethodType","Value":["1"]},{"Key":"PersonalNumber","Value":["1234569789"]},{"Key":"Firstname","Value":["Loretta"]},{"Key":"Lastname","Value":["Lynn"]},{"Key":"Email","Value":["loretta@lynn.com"]},{"Key":"PhoneNumber","Value":["38345662135"]},{"Key":"BirthDate","Value":["13/09/2022"]},{"Key":"GenderId","Value":["2"]},{"Key":"CityId","Value":["2"]},{"Key":"CountryId","Value":["2"]},{"Key":"Address","Value":["23rd street"]},{"Key":"PostalCode","Value":["E8854"]},{"Key":"NewUser","Value":["true","false"]},{"Key":"Username","Value":["loretta"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDLY2guOsZlPHhkKWQ7dNLoJugNPrZ2VJ3bt6LfbHcWt3K4UIif22aiLzlda_y0QCTDul7OwOO1zpQnJnZcQ8F7v3c_niFU92HYGqF9ahtDUotH_HJmjfx49JVtVenJFRb0San9JRvmwo0gspBkO9M7AuQWJdr2gCkBNNW1T0WIQg"]}]', 1, N'{"ClassName":"System.ArgumentNullException","Message":"Value cannot be null.","Data":null,"InnerException":null,"HelpURL":null,"StackTraceString":"   at System.Boolean.Parse(String value)\r\n   at AMS.Controllers.BaseController.FirstTimePassword(IConfiguration configuration, String firstName, String lastName) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Controllers\\BaseController.cs:line 302\r\n   at AMS.Controllers.StaffController.Register(StaffPost staff) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Controllers\\StaffController.cs:line 174\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ActionMethodExecutor.TaskOfIActionResultExecutor.Execute(IActionResultTypeMapper mapper, ObjectMethodExecutor executor, Object controller, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeActionMethodAsync>g__Awaited|12_0(ControllerActionInvoker invoker, ValueTask`1 actionResultValueTask)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeNextActionFilterAsync>g__Awaited|10_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Rethrow(ActionExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 165\r\n--- End of stack trace from previous location ---\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2147467261,"Source":"System.Private.CoreLib","WatsonBuckets":null,"ParamName":"value"}', CAST(N'2022-09-20T11:16:17.857' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5024, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Error', N'Arb Tahiri', N'Error view', N'GET', N'https://localhost:5001/Home/Error', NULL, 0, NULL, CAST(N'2022-09-20T11:16:18.027' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5025, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-09-20T13:10:52.917' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5026, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Action to register staff.', N'POST', N'https://localhost:5001/Staff/Register', N'[{"Key":"StaffIde","Value":[""]},{"Key":"MethodType","Value":["1"]},{"Key":"PersonalNumber","Value":["1445788695"]},{"Key":"Firstname","Value":["Major"]},{"Key":"Lastname","Value":["Tom"]},{"Key":"Email","Value":["major@tom.com"]},{"Key":"PhoneNumber","Value":["38345332123"]},{"Key":"BirthDate","Value":["13/09/2022"]},{"Key":"GenderId","Value":["1"]},{"Key":"CityId","Value":["2"]},{"Key":"CountryId","Value":["2"]},{"Key":"Address","Value":["23rd street"]},{"Key":"PostalCode","Value":["E88753"]},{"Key":"NewUser","Value":["true","false"]},{"Key":"Username","Value":["majortom"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB4Wp_kjjevtE1Ux-gIwSqlTZwu1IgBTVjLwj1pxhHdnjLJ8FIJZmJSNxFgsohTIezuFSGnJMg3XMtRSK1uY7JoKBSlzNGwZCU5CgrOCWvvMfxx9KIbOt61YyLARgVzyGlVDjFTEEFJ3AhROMm1Jk3M79Oxd-YIGr6te1EcwYL3CQ"]}]', 0, NULL, CAST(N'2022-09-20T13:24:31.477' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5027, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:25:17.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5028, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'_AddDocument', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Staff/_AddDocument?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:25:24.820' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5029, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'AddDocument', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Staff/AddDocument', N'[{"Key":"StaffIde","Value":["TgzqG(MlCJSzDGGaMhpeUw=="]},{"Key":"DocumentTypeId","Value":["2"]},{"Key":"Title","Value":["Certifikata e lindjes"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAL9eDdfViF6OgBopLOz2-ISDr2Bzejm6DNzOJoIynZQ6QT6NX9naXf-PHkD90fCHR3ZLFYIzKCO7GauQXzbgDQiaEu_jIXDBIxkSqML3l-46G3dZKWVnTxGPGXzIDEEUF5tqcOdKSdt56S8r-_ldiaxT_URNuUAxQZfWRlCXPmhg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T13:25:37.170' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5030, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:25:38.613' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5031, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'_AddDocument', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Staff/_AddDocument?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:25:40.410' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5032, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'AddDocument', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Staff/AddDocument', N'[{"Key":"StaffIde","Value":["TgzqG(MlCJSzDGGaMhpeUw=="]},{"Key":"DocumentTypeId","Value":["5"]},{"Key":"Title","Value":["Deshmia e fondeve"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCOjRAtSzoiAPJfzns5J5aL6-Dc0ZrQzyadPdAFM0bWpbHy9j1PLQdweTdn-40FdwKIaawNB_g7ZdnoWFtti6rVIpi4JgRegp1nLZdlqys9C3CXuL31lx-bJM7EbEi3iuAZJgdU9_y88MShza7u5eLwmX0Z8D-PsVizdGPVj8d27g"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T13:25:52.770' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5033, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:25:53.960' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5034, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'_AddDocument', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Staff/_AddDocument?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:26:14.757' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5035, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'AddDocument', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Staff/AddDocument', N'[{"Key":"StaffIde","Value":["TgzqG(MlCJSzDGGaMhpeUw=="]},{"Key":"DocumentTypeId","Value":["1"]},{"Key":"Title","Value":["CV"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDiCiAk3Ge-4MDt1RF0JGfhCniR02bVQecypPJLlq1qkJTnI7G0SQ7_EN1vHA6iRtj_2RrecmQMhF8aD-XXpCWwyvgAZ3c28qTK7rCqA1D8I6QtZjryxdvDp0Uk-ElBu0nJGUiZvJfr04gdyAzOTLNiasH51U63vCfmbV5Hxs5XIQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T13:26:24.597' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5036, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:26:26.657' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5037, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:35:21.177' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5038, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Download', N'Arb Tahiri', N'Action to download document.', N'GET', N'https://localhost:5001/Staff/Download?ide=eBQw1qWZXQ1r1j70fg)lwA==', NULL, 0, NULL, CAST(N'2022-09-20T13:39:05.610' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5039, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:43:32.903' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5040, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:52:03.450' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5041, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:52:37.017' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5042, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Download', N'Arb Tahiri', N'Action to download document.', N'GET', N'https://localhost:5001/Staff/Download?ide=eBQw1qWZXQ1r1j70fg)lwA==', NULL, 0, NULL, CAST(N'2022-09-20T13:52:43.477' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5043, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T13:58:44.397' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5044, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Download', N'Arb Tahiri', N'Action to download document.', N'GET', N'https://localhost:5001/Staff/Download?ide=eBQw1qWZXQ1r1j70fg)lwA==', NULL, 0, NULL, CAST(N'2022-09-20T14:00:45.803' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5045, NULL, N'192.168.1.89', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://192.168.1.89:2022/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-09-20T14:09:46.817' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5046, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T14:19:51.917' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5047, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Download', N'Arb Tahiri', N'Action to download document.', N'GET', N'https://localhost:5001/Staff/Download?ide=eBQw1qWZXQ1r1j70fg)lwA==', NULL, 0, NULL, CAST(N'2022-09-20T14:20:04.993' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5048, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T14:31:46.083' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5049, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T14:53:15.867' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5050, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T14:53:29.750' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5051, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FStaff%2FDocuments%2FTgzqG(MlCJSzDGGaMhpeUw%3D%3D', NULL, 0, NULL, CAST(N'2022-09-20T14:53:47.540' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5052, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T14:54:19.233' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5053, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Documents', N'Arb Tahiri', N'Entry form for documents. Third step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Documents/TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T14:54:28.800' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5054, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Departments', N'Arb Tahiri', N'Entry form for department. Fourth step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Departments?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T14:55:54.660' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5055, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'_AddDepartment', N'Arb Tahiri', N'Form to add department.', N'GET', N'https://localhost:5001/Staff/_AddDepartment?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:10:52.120' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5056, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-20T16:10:53.683' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5057, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T16:10:53.893' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5058, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Departments', N'Arb Tahiri', N'Entry form for department. Fourth step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Departments?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:10:55.487' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5059, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Departments', N'Arb Tahiri', N'Entry form for department. Fourth step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Departments?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:15:39.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5060, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'_AddDepartment', N'Arb Tahiri', N'Form to add department.', N'GET', N'https://localhost:5001/Staff/_AddDepartment?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:15:45.640' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5061, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Departments', N'Arb Tahiri', N'Entry form for department. Fourth step of registration/editation of staff.', N'GET', N'https://localhost:5001/Staff/Departments?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:16:53.863' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5062, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'_AddDepartment', N'Arb Tahiri', N'Form to add department.', N'GET', N'https://localhost:5001/Staff/_AddDepartment?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:19:40.800' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5063, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'CheckDates', N'Arb Tahiri', N'Method to check end date and start date.', N'GET', N'https://localhost:5001/Staff/CheckDates?EndDate=20%2F09%2F2026&StartDate=20%2F09%2F2022', NULL, 0, NULL, CAST(N'2022-09-20T16:19:58.303' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5064, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'AddDepartment', N'Arb Tahiri', N'Action to add new department.', N'POST', N'https://localhost:5001/Staff/AddDepartment', N'[{"Key":"StaffIde","Value":["TgzqG(MlCJSzDGGaMhpeUw=="]},{"Key":"DepartmentId","Value":["1"]},{"Key":"StaffTypeId","Value":["1"]},{"Key":"StartDate","Value":["20/09/2022"]},{"Key":"EndDate","Value":["20/09/2026"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAbk_kist6HmZntZHC4o6ilutRmXTDFaamtH9Czba-tSfUGYZMcur56GOGp_AUS5nNdIjXgR1qa1YvMZ9Arrkto642mXs2kU5EM1jUxF1RJjSF2G3f235tyo2wej_tmUFBUkc65JedK2YIZ2DE72U5GDn5XjjRIZkq0wR2thgKObg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T16:19:58.413' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5065, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-20T16:26:00.213' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5066, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-20T16:26:01.280' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5067, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-09-20T16:49:50.907' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5068, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB7irPu388lEQtUggqMSNMWQCn0Np1pPip91qzv065Fbm0SHVynqVheJIct-kMsWpyQuhppmdOmFszTW3bQIi3tLs97Pr1WWCHxqTLZBJfXnyrp1RCDkWwcHLsUZakJIFpVA-JgHznoeH4y6AxZ1iKOywdbQWWrwHKyDc5BGQCdaA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-20T16:49:52.507' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5069, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'InProcess', N'Arb Tahiri', N'Form to display list of staff that are in process of registration.', N'GET', N'https://localhost:5001/Staff/InProcess', NULL, 0, NULL, CAST(N'2022-09-20T16:49:55.813' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5070, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:49:58.173' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5071, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FStaff%2FRegister%3Fide%3DTgzqG(MlCJSzDGGaMhpeUw%3D%3D', NULL, 0, NULL, CAST(N'2022-09-20T16:50:17.993' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5072, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-20T16:52:55.207' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5073, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register?ide=TgzqG(MlCJSzDGGaMhpeUw==', NULL, 0, NULL, CAST(N'2022-09-21T09:35:55.230' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5074, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-21T09:41:01.720' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5075, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCHdo_hP6Q5peH4NRWQJ7su9NdZth5lMXOXpff1d3Hjs1-ho8rj6VXs7ZB5bdf3TaWaEVa3j3vBHRhUbwY6YPjQYAtGtf_acWecMT3WAac26TKLKUr_n77BuJCRJ2173wJ3ZabuOtJUPIeQlFQ6f73y9YYbqOW1wz3TxpIAEy4aqw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T09:41:03.440' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5076, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T09:41:05.797' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5077, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T09:41:06.680' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5078, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TARo7lSQRQzMxXhXNEvW03am5jCF5TEtaTlCIoBjtbGDLca1NiiQFLg66fWqIrKhW32_veLP6lJApKABePZwoAB0kqPpE6Pi1UAIQn32cY3CIpqmbrHcunFregzb0Ou2jult00EBkJTwILv1nGX8G9WwzF6eXzGOlvWqEETQNiMCQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T09:41:08.050' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5079, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:23.967' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5080, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["ABEnyAsEjdj)nibo9nHnfA=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:25.057' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5081, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":[")wS2xUQDnb4y0k5CIbjF(A=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:26.210' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5082, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["BFjB3x06UIwNlWnpgxBdKg=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:27.247' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5083, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["eBQw1qWZXQ1r1j70fg)lwA=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:28.333' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5084, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["6ntuzFsZY7Ut5lvRnyTcZQ=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:29.317' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5085, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["o7DumLm2KssJna5VG7BQLA=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:30.570' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5086, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["PPUVOL4y)QNukdPIfAbXiA=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:31.633' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5087, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["L8ldmrlyb8rhU3Cb3Wfd2g=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:32.570' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5088, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["KeIJ5mB)LZ4SfJ8ctcIjIg=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:33.690' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5089, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["YL3EEHsD983)kev8KUB5qA=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:34.597' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5090, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["KOdWayAvLxjucAJgFTnGLQ=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:35.450' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5091, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["J76OUfvOk2189gdHsCiz)Q=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXJIqMbgH6LvHNUmy0asb-t8oUvImjva1W5b90gTi-lWaarnmZ_Xqe3R8a3zxVashFVkuua1B9k3l6xDs0PpkYzugg_wrUJ2VUuDc-m-cXlk5reA4R6ycIRh-sJLv5R6YP-40AcUAh_MfI8XxRw3exII84JscDmVG3zTS5P65dYQ"]}]', 0, NULL, CAST(N'2022-09-21T09:41:36.423' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5092, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:00:55.310' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5093, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:01:06.037' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5094, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TApQL0mfkkL3In9-dWVtR2htdzeNetMiAIM2Fz218AJ-l1pUjblGSL3NlQuanNKX1pQUmyvqdlTX79kUtb54LhIpf1HvXBcvAA8VA03IVnQvLsu93t3r_k5YTBTSIAmjVNNycvHfkEObMyeOhT729bNhN0oUfBiHM47yFn5n_w8aA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T10:01:10.750' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5095, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["o7DumLm2KssJna5VG7BQLA=="]},{"Key":"attended","Value":["false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDU9e56RwgwRRMi29AY-DTszPjbZlPdn-_GehTxHgv0HVWqMFuPojjfZabB1GTc2M3gcSaZot4dK4yiOOCD1kO4Xp_NwsImuQPI_EEGuQCciZBBVrk79_qzpiqQUkP-M4Rw75Nf2HnfGVwuNAdPNlPVwekbD8DvNA9cH43mHTMEzg"]}]', 0, NULL, CAST(N'2022-09-21T10:01:13.897' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5096, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:01:20.233' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5097, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:01:21.963' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5098, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCygNcSdebuCCD0AfxfXbhN87yfdf5bYvsYl_jlbt-44Xb3FUkOsBRBoUWakzOVusU2P-YpTej0xInQpS_VSs4IZQ_JM0yVvsdQoncOjWneocfCadrP_G6Nsfcxm1fdlMoF82Vg9aRCOq1q2Eabj6F7XpH9zD-gx1HXPnEOPeVx-Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T10:01:24.583' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5099, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:33:47.617' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5100, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:34:58.970' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5101, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:40:25.540' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5102, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:40:26.990' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5103, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TA18OPcnul-SUAE-1D32k8Khla4sQ-N6FIvv5CYmL7t0qJ3HbYrmqQBOgjW7h24suAI6qHvi9gt8sXhIINoPVdpJW8cHd-z8RWJjv4alR8Sge_Lv-XjqTye6EN6ZpobYBilaufdfu-Qqtg6CXx67_7n2D0xShvPEpoW3LQuvyG1Bg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T10:40:29.103' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5104, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["o7DumLm2KssJna5VG7BQLA=="]},{"Key":"attended","Value":["false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TA508edwU1r9viJ5lOEHPRdSnJVX3Q8PuLXs0OTjzPQdAITSS1jTKHfGHoA3zmmUz-U5vfkydUwyKvDk3U_fg3KgN98A9ZzzeFsvCynF5K5MsVDDj_DHvn5_xWw6s94UjmaCGGlVpJVYfuv_N1uTpwZA9z1QwXbFSAlVfgP76om7g"]}]', 0, NULL, CAST(N'2022-09-21T10:40:34.713' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5105, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:40:43.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5106, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:40:45.530' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5107, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TC9Fmquit23-pdzUECwijgRxzL9huWNcfTwq7PKhP1wvSbiuwGlMC3ZhF1r-r59n12Dv19RhxUxmiPH3e36_GRsygKYp13v6EidCWxI2fPz7izG1l-VPu58cJM-XR3J5-bevEnrN4B_IVKb1ih3Acs3ybTZsMFKoTamaVKjRx_uLQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T10:40:46.830' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5108, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:43:27.510' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5109, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:43:29.197' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5110, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:57:02.293' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5111, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:57:03.797' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5112, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCoR_TDQ4dHlxEUofQ3lI-skzVaq-e1DQRq2m3TmkyB35Ivv6ys0V14MzOYWNQw7Yf-4WU-CVR6sk1TNp5MMecG4dei37DqTrT8zxUq8Y2j1btx-8jEXiugU5cPxPUNrwClsAwy_nX-WkeLTuabjrPpWUu4ACbp_-pvHW-FqgxhiQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T10:57:05.030' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5113, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T10:57:40.610' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5114, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T10:57:41.697' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5115, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB2X_P47eT_nnm70j62W-ZW8EQjFkoDtS65rIOWgbdrNmUInifkEkR3Oxgb54wcXQpTq4SVZVQGxR1gwbjzAN-QH217wixRNNp8L2orAK5L15PYr9lrAxfySoQ7qiAxS_TLfBSpx3G4Mi7mMXoOV-Eu1-fhRj-akts4igrWcKCmtQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T10:57:43.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5116, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FAttendance', NULL, 0, NULL, CAST(N'2022-09-21T10:57:48.500' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5117, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAg3iM6TbJNLk0OZ6bZ5Gx0gcZrTEhmDRMZ27UecAMx4cIYRa2Bje-NdOsZfIF6F5JymnF6a3_bxkPljIfryWPJa0wKRa6COz0IZM0RThScxU_i1lxOT2L5IK_UPcYvzHm4xQxyYmGcEVjytY4X8qeE2Glgrrkyf9Xv8o2abrtzxA"]}]', 0, NULL, CAST(N'2022-09-21T10:57:51.917' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5118, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAg3iM6TbJNLk0OZ6bZ5Gx0gcZrTEhmDRMZ27UecAMx4cIYRa2Bje-NdOsZfIF6F5JymnF6a3_bxkPljIfryWPJa0wKRa6COz0IZM0RThScxU_i1lxOT2L5IK_UPcYvzHm4xQxyYmGcEVjytY4X8qeE2Glgrrkyf9Xv8o2abrtzxA"]}]', 0, NULL, CAST(N'2022-09-21T10:57:55.683' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5119, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB2X_P47eT_nnm70j62W-ZW8EQjFkoDtS65rIOWgbdrNmUInifkEkR3Oxgb54wcXQpTq4SVZVQGxR1gwbjzAN-QH217wixRNNp8L2orAK5L15PYr9lrAxfySoQ7qiAxS_TLfBSpx3G4Mi7mMXoOV-Eu1-fhRj-akts4igrWcKCmtQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T10:58:10.717' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5120, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAg3iM6TbJNLk0OZ6bZ5Gx0gcZrTEhmDRMZ27UecAMx4cIYRa2Bje-NdOsZfIF6F5JymnF6a3_bxkPljIfryWPJa0wKRa6COz0IZM0RThScxU_i1lxOT2L5IK_UPcYvzHm4xQxyYmGcEVjytY4X8qeE2Glgrrkyf9Xv8o2abrtzxA"]}]', 0, NULL, CAST(N'2022-09-21T10:59:28.043' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5121, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:00:21.370' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5122, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:00:23.113' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5123, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBbL_-JqWOGV_-U4u8z3Ce3-PZWjg7SYx7Pa-7Yv5g5kbiq4lTJCUYH8i4MRb_9bXSe9LWlSQQcyr0yETxo3SkMs_HNQa3kXI4zyDXFGaQ_rXyGfrTy65Mh0myffO9VgAKdm4lKuC5QR3U5gg9Hoyo019_5mDeoR2V1Lgwk9sj6IA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:00:27.057' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5124, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCwExc0ZM0D4jUp2-G0wnQ70sE5HCMovYGEV-Yyu6bD9RJqWKMquo3YlA9t2sdW0W88xmvu-i3DB6kz98uqQIF7mY1UxMlmujYbtSOxZJC7RDqEKKgUbNvYpT0STWGysXF5Ns17evbjTbKpL7zpi22CAPSTjoX7CDx-qk7hpP_1lA"]}]', 0, NULL, CAST(N'2022-09-21T11:00:29.070' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5125, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCwExc0ZM0D4jUp2-G0wnQ70sE5HCMovYGEV-Yyu6bD9RJqWKMquo3YlA9t2sdW0W88xmvu-i3DB6kz98uqQIF7mY1UxMlmujYbtSOxZJC7RDqEKKgUbNvYpT0STWGysXF5Ns17evbjTbKpL7zpi22CAPSTjoX7CDx-qk7hpP_1lA"]}]', 0, NULL, CAST(N'2022-09-21T11:00:32.080' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5126, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCwExc0ZM0D4jUp2-G0wnQ70sE5HCMovYGEV-Yyu6bD9RJqWKMquo3YlA9t2sdW0W88xmvu-i3DB6kz98uqQIF7mY1UxMlmujYbtSOxZJC7RDqEKKgUbNvYpT0STWGysXF5Ns17evbjTbKpL7zpi22CAPSTjoX7CDx-qk7hpP_1lA"]}]', 0, NULL, CAST(N'2022-09-21T11:00:35.007' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5127, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:03:22.807' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5128, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:03:24.230' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5129, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBAJE1FJhgGa7qX9SSVlC94fsWQJ3OF_PqtNR4rU7cGyGCpZ4ZcX34XpZAtqv2VcI7vcoUHGVzS2ON-9DMnmUrx4Ws0tD1LthWLsFqhKDS1otkgAZ-iAwH1eXJTa3q6C2nqp9aXvxoAUNlY9pLK40ky_Eq7X1W7uedzGPTEHBQOJA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:03:25.350' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5130, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAkcTnr_0bakEFJSzIcHyMN5-y5XF7vPf0BRJauISCWL7OtPIFWPNSyuu1teszUKgVI5d9n82w5Xk3KDvgD0CxPXUnNxb9LHEw0lp_RgvKv1QP312aM1DKzeXhhzB29YEtgsfn1k3hTx4xSZ-BXR6hAInxku6sOjjIfR6-ZKNhuzg"]}]', 0, NULL, CAST(N'2022-09-21T11:03:26.867' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5131, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ChangeAttendance', N'Arb Tahiri', N'Action to change attendance of staff.', N'POST', N'https://localhost:5001/Attendance/ChangeAttendance', N'[{"Key":"ide","Value":["Tm9PCOMclx4Po9wuWiQ5Bg=="]},{"Key":"attended","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAkcTnr_0bakEFJSzIcHyMN5-y5XF7vPf0BRJauISCWL7OtPIFWPNSyuu1teszUKgVI5d9n82w5Xk3KDvgD0CxPXUnNxb9LHEw0lp_RgvKv1QP312aM1DKzeXhhzB29YEtgsfn1k3hTx4xSZ-BXR6hAInxku6sOjjIfR6-ZKNhuzg"]}]', 0, NULL, CAST(N'2022-09-21T11:03:29.563' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5132, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:04:57.687' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5133, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:04:59.203' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5134, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCgju_gVVfiAeYlP_K1tGY9FpfvX3sEPWryJJFePPpGz72gEcefsA6QF0KTFgc1goFzjtjdBDi8GjEWfGHNEz0RWh8jqTwDxxXC6O6urL-MP19KIvRd8AVIIwjPBAMr88k8VROKgEbUuErrdgkB4WJyD56QVtP-WwqhJf2buWftBw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:05:01.027' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5135, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:05:06.633' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5136, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:05:07.697' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5137, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:05:20.170' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5138, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:05:21.283' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5139, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDRG33HF3STpBFML4eGmDaqQWReSsPuGb7WfNgZbSasRHrai6L0aehG9mtzY2HxhRg8ydmR7xbZhrPB_GCLtu54Pm5Z1GNq-6HFYT0BbTD-jqzEvaL5sXVMs385gTQFEYmutYMyx-VK3CLZ-PXgHBX7T045aBApAd1L8SXFmwJNhA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:05:22.520' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5140, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:07:50.877' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5141, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:07:52.540' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5142, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBK-3H1op-SbOJjYaR27dbz00bmu0vlqIjZKlFle7Xt440ERdrfoLVRU_dIxIrHOXINGODJwWjev4S2EWmS7CrSB-k92lmR4ISqunxOzBmj0S4XwGHJ-dl_lR2vE5jQKRziLSU_859-buOzdwa73eQrYtagFkcJXXVNipUDQrgHfg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:07:54.440' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5143, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:07:59.547' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5144, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:08:00.720' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5145, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCp6R_frQflQM1Z6abmYrynkwaWwLPl6I0D5Nnnc32XJ_YlecaqELj1xFpbBJeykrwBHZTDnfedv0UclZOjTMMcm2D8gxg04O7wQjVZ__n0LhHqwC5jb_ObGR_ybbiKWok3WqTxY35IUxMLTjkmmX-IE26yJCrpgOsjGGb2ewy3uA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:08:01.647' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5146, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:12:51.657' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5147, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:12:52.910' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5148, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBcWaGi8Zfg4t4vt6TFDWUOetCbRLURNmR8Kl3vHzdPJJ8Xv_NFEbNzFnxj-liNeuX_3EP8py4ClAYDSFOCJo5jqwKpBzVFwJ_DG2-5fI0dUaIWP6K_QTC7ehbhMDt4gE3UemcstC7TbBYukOmKh6mGwZSeHjvCBkmPiUrpEOHtTg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:12:54.080' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5149, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:13:25.707' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5150, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:13:27.827' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5151, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TC87Hrqvk2KN8mYjWKAptQE_IVvwzWD_COJ2txdNKGRar8MFFhWUI6bXUO2_vQdWeYARoa1Xl4x4L0XhsqYh82TMl-IoYa7ts2dYKQKqKvD7HcjQc3wKzaR-oJ1yRTv1xb0j58QSiOCIaoZXHNIrXOImzrpWK3vMrXBt-Y5WUylgQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:13:29.720' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5152, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:14:56.563' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5153, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:14:57.860' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5154, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDomK_T4ORnZ8JChBDoIvLCCF4VkXlYJxQ-BpJKKXTmrSylVSesiLuKiFQltnDYRiOLgrj4uHFZ26MuJdFqDbNW9wXi7A18HzcghqAkmEyj3whibSmaNY3dXkaYCNtsU6nsLQBaYxUGhcwS4hk-5Y8U4wroOyN-cMOH0UHy9RvcQw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:14:58.983' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5155, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:15:37.707' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5156, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:15:39.810' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5157, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDcJjreXWnULUZJSCATRjit0orhL9bC1wltMZ8yNSt3d7NBi0mmAfv59kiamR8hC7Xkv58Q7RhEgVqV09zDaBTvxcoyIN9YRLPFV5AGCX1vJavgzKjlDXxHNoS6DLMYbNIpaFgCagBkgNsC-fC253tYxY5mxaU4kPieo1agBX8b7w"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:15:40.983' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5158, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:16:16.470' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5159, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:16:17.713' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5160, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:16:36.777' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5161, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:16:38.630' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5162, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCnRVoVB1xgT7bzG9x8R2vl-KFB44ME3KDn5ome2cDOTfFY5xyT6URn2ZVEjnKMLbscpkdqd5XhuWQ8wH3OUyvgQm4cC8aC7bDorxPdpzXZV6Qp4zDBJI-TtUwz3_wZn5Oopg7o6xg4EpyL0ZAjj6oueoUNCBt-3D5fxL5K83Qm_Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:16:39.690' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5163, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:16:59.260' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5164, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:17:00.483' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5165, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBRJ4f6e__MBsk3GOGSpwwjo_cdaHJ5uMF90kj5LTFb_yT0j8zriLRx_bVIaYGRcd3k4dJoC0zjT0FUV2-970xDmauQL4CKzqpOCooJeir81GpKPGAFAN0BosL9wnwnzZbDAHdn6XL8KcVL-rkLyNh3WzP2jvPGo6ViwNDOKLukGA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:17:01.750' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5166, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-21T11:17:09.030' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5167, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBo53ZrzPu2f-dOPnzjTAwmGwzawOOacT-wgKSuQlhd1xGn3_k0u-sctWsFcQfTpsiS5hQLT8fs9aAaBUF-439nN_4IGWxuT4MMF4jSqUge6RvclDM_6_rvhvhGGMfXSmlm0zfdRnVHoW-dpnSlIKf87p6tZEhmYLZ112IoOee4Wg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:17:10.593' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5168, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:18:00.463' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5169, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:18:02.873' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5170, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-21T11:18:04.430' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5171, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBaknVzCIZSkw_3QMyCe5NlMjbMsWo73nHIhqAt5qus0lQGfkBbHYViVd3ytzA4KpHr2r17NCyqZ9RnjdWrGNGZLR5fMHvMjLF1cAX6retFh-CgELB5XcfnBGiCs8_M6bgFTptfz55ZXoZfaCgo-x9Awm8RTHD5sN8fYfx7zTlk-w"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:18:05.817' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5172, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:18:28.700' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5173, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:18:30.293' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5174, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-21T11:18:30.650' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5175, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBQaJYuqiHdJ0twcrxY-ZR70nkcYCUY2T0y3Jsm7_bzUU8G2KH4UDhRJ-SL7D47BiGQNikcgBCScDMF3FMzEVQPbxjrSoSByWuOl2zl4E2lsDe4Fm-TPEA6htB4C8fVSfLTe_K8m_epMvQASaU90xe1JTCb-SafBv8qADQuUT0djg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:18:31.963' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5176, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T11:19:36.847' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5177, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T11:19:38.200' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5178, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-21T11:19:39.480' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5179, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCRZWHLN88nlX2I56UKxi6x1OkA37nJ6U6j2jThxS5tl9KqG2-eKYsoRohdQzvwT8YrjhTxPLJsKzApitqPGCmRuooCzxaZJQeT3Nwv_kgyglPJEUOvFNKeeGRZJpBUboCNkTlD2tIT-UHJgvbQM2Lynwe9IbU2Mbk2-PUYVuoIgA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T11:19:40.643' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5180, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T13:57:44.473' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5181, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T13:58:07.060' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5182, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB1pLHyd79a8wXh5UAXv7LkNAC-8xsWC4rqaYk2On0CYu9S51aWzRrjAGxzTWBcc_gWElOjv50eeeqxfDI52g4nPlczeVsc3qYVWB2r6GwecIZ09JcxjD-cHCqBldrjuOeeyROx_HKF2RFGiNB9GAEPz5G_XHdndEbDrC3AK7qrwQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T13:58:30.457' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5183, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-21T13:58:33.713' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5184, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCxmgLrqSUDEtweJaSI4wtp5mOFmw2TjlO5uOB_omqtiog1keznb9QUCW0KcuVTRcm84J3aBPUl0IDGhUe6jtSxCxxR87zu0n_0aspXElKrWS-2ekFT0jwseW8KmUpsnWn-qqZTYPyYp-m9DmX_CChn2fCtULF5g15Z6xeNhDVIEQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T13:58:34.923' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5185, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=Tm9PCOMclx4Po9wuWiQ5Bg==&startDate=2022-09-21T11:03:29.58&endDate=2022-09-21T11:03:29.58', NULL, 0, NULL, CAST(N'2022-09-21T13:58:37.643' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5186, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=Tm9PCOMclx4Po9wuWiQ5Bg==&startDate=2022-09-21T11:03:29.58&endDate=2022-09-21T11:03:29.58', NULL, 0, NULL, CAST(N'2022-09-21T13:58:58.410' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5187, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-21T14:05:26.963' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5188, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-21T14:05:29.600' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5189, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FHome%2FIndex', NULL, 0, NULL, CAST(N'2022-09-21T14:07:20.607' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5190, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T14:17:56.890' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5191, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T14:17:57.923' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5192, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchAttendance', NULL, 0, NULL, CAST(N'2022-09-21T14:17:58.570' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5193, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCiAd6R6YOQ7Z_usXLsiJnUInfrT5r54p8nZvHvYDSHshBCA2-JMr2fPkvJYLQ4FePopk7Sj7aj9jqUxTLqWXqS5fTgEhDileBTQRIRYHB2Ru5GE2kniUzeek-MN8LqdplQNXXot-gWEUE4mdILLbo2suPptEaNWSf5VFo7HdOi_A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T14:17:59.813' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5194, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=Tm9PCOMclx4Po9wuWiQ5Bg==&startDate=2022-09-21T11:03:29.58&endDate=2022-09-21T11:03:29.58', NULL, 0, NULL, CAST(N'2022-09-21T14:18:01.753' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5195, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAttendance', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAttendance?ide=PtxT78M7iD8prWx0AoOKlg==', NULL, 0, NULL, CAST(N'2022-09-21T14:18:04.893' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5196, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'StaffAbsence', N'Arb Tahiri', N'Form to add absent type and add description for staff.', N'GET', N'https://localhost:5001/Attendance/StaffAbsence?ide=LAHsU3XfI0apXcPWsoMrww==', NULL, 0, NULL, CAST(N'2022-09-21T14:18:13.047' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5197, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=Tm9PCOMclx4Po9wuWiQ5Bg==&startDate=2022-09-21T11:03:29.58&endDate=2022-09-21T11:03:29.58', NULL, 0, NULL, CAST(N'2022-09-21T14:18:18.217' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5198, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCiAd6R6YOQ7Z_usXLsiJnUInfrT5r54p8nZvHvYDSHshBCA2-JMr2fPkvJYLQ4FePopk7Sj7aj9jqUxTLqWXqS5fTgEhDileBTQRIRYHB2Ru5GE2kniUzeek-MN8LqdplQNXXot-gWEUE4mdILLbo2suPptEaNWSf5VFo7HdOi_A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T14:18:20.823' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5199, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'History', N'Arb Tahiri', N'Form to display staff attendance details.', N'GET', N'https://localhost:5001/Attendance/History?ide=Tm9PCOMclx4Po9wuWiQ5Bg==&startDate=2022-09-21T11:03:29.58&endDate=2022-09-21T11:03:29.58', NULL, 0, NULL, CAST(N'2022-09-21T14:22:22.523' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5200, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FAttendance', NULL, 0, NULL, CAST(N'2022-09-21T14:22:37.220' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5201, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchAttendance', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchAttendance', N'[{"Key":"atype","Value":[""]},{"Key":"AStaffId","Value":[""]},{"Key":"ADepartmentId","Value":[""]},{"Key":"AStaffTypeId","Value":[""]},{"Key":"AStartDate","Value":[""]},{"Key":"AEndDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCiAd6R6YOQ7Z_usXLsiJnUInfrT5r54p8nZvHvYDSHshBCA2-JMr2fPkvJYLQ4FePopk7Sj7aj9jqUxTLqWXqS5fTgEhDileBTQRIRYHB2Ru5GE2kniUzeek-MN8LqdplQNXXot-gWEUE4mdILLbo2suPptEaNWSf5VFo7HdOi_A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T14:22:48.077' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5202, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T15:58:41.860' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5203, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T15:59:09.160' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5204, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDZBP1TuF6bYT2zWOGNPFmKFMsjbIrSwwx-NycOX815p4pav0K8a95O8LA__5TVi1uOqlw8JHldsYZOFXtKXe55pEQUKvKstVsYGrd0onWEFnre_uwIGUSePYKcf2EV-QYoWpcF2d-zdc3b9ma20D1tPCcGARz0LlLT_V6NkXQjiA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:00:44.223' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5205, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FAttendance', NULL, 0, NULL, CAST(N'2022-09-21T16:00:54.910' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5206, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:01:36.537' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5207, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:01:39.280' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5208, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDXcglTp1daEaUZ43Gl_Njl_keGt45UBDgypqjH1MqeEWpLaFwXY0bDzQCUhkeZ8ngAghjHKXpwCGbpanBpA2S7zI4Mm1FCdrs8ZDp-3k4354wpZN_erQPPCkGIPQi5ntUJSiHcKdV8CnlXE6gWUIqs0ESX9TAT6_DnVG84S8L0uw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:01:40.473' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5209, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:01:55.000' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5210, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:01:58.130' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5211, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDXbH4YHE0YH6Xecyt-AHQ2qZiy8FCKKt91rFgA5YqtP4dnoxPcB_VfbXcbwpXLYmhwczavivUJaK-yw7HZ0RRGwaH6EKFq9VJZBnHxUoBRzt2QSxahBOrTtDsIoMMPwc5Y5cOZfOjCmgT9H258ojBXTyPIooQhkM672GcqffFJ8g"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:01:59.643' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5212, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:02:06.540' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5213, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:02:09.687' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5214, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCfByLANCdiiQAqrEH6oUNU6YeJBK0PIV_XadUxkkexOLYUxdUiCY1qVPG-KlnEH0wdXZH8ZTi4uI32MslCQQh-4B2n1oeorolKW7VyfdnV39Ow_jFUgFDqh5wFpKKsGlap5t1m7T3MuQEMjbmcZT3L0DMBm5Uu_IeqZkwln7s8bw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:02:11.113' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5215, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:05:07.673' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5216, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:05:10.937' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5217, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCzygvJtOZ2dSZhuMHrIRt7ZGfqyKs2pzwjC_JvsQtIV6FD9rakxSvDD3-6qT36_DsEbeaCy3ba_t9kpCbQ4OPCPZ_mcqTGsi3XX4k6Ck5FElNyseCvIs3r9L5D-nAKafgolK5PWypAiYbpHD0kJPJXzgMbErvdejzNBuWHu789PA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:05:12.157' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5218, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:06:01.383' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5219, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:06:03.207' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5220, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBQcw88MzN73e1FkCYKMwnhZQkDjicKR3LFwHbE4-DUnER9PvOYQ0V34pf8XftjmjnO0IYL5ONrHhZQdRbOCyHXStuPmf5iMrDzhXpRgBqAOyRlh2g2cO2ZPPNcnx0H9UULlinqv_HuNoPqmxYvFIahdd8zCI1d9CMEqM4iHBFSBQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:06:04.900' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5221, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:07:49.550' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5222, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:07:59.607' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5223, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDjdmUZ2OdVqvg4OWXrA7aJU8N-92_Gy0EtAfBk9YQaNwgIC4Lx_ipXkNwrV045ZMX4PA0tiYCvEhcu5OjObFe9a4whFRemuSd_xdNko55E25Uk9jtEbNU_dS5UAokynqdsWngMho7d81sAMyLVqPV7BKz1gRDD0EZDA5jlcBq74A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:08:01.917' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5224, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:09:46.200' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5225, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:09:58.103' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5226, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDIYcVcCeKFKi6UkzEE58_w6_G13eIc88JsJTje9rXkvjcu2xOcRa2JYjU_usU5zoJe7wNq8X8EcXeYlybezHtiSGibZjRRxqkcMhO6IHzP9fQeLad3rg4ckTZNoQIRcHCoE9LNtZOJHPYibfwmVhbkDZd2whn_yPLLHmDbEUMeFA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:10:41.873' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5227, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:14:02.180' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5228, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:14:14.997' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5229, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCAKfst3sebDx8YzH6r2SmaQIfgSvMCLKQOOlazWK2_X-rD5aRjRGVZRzCJVMi8hiAVnVmrHkVoUNnNLsLIERuffHe2i4GmsXMSNElpiZCckJkucBzEtE1WFaScW51-DX4a0juaf4zh-qZvlVBtXBjCfeJp5SHbCMyXjZ141REKxQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:14:16.313' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5230, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ReportAttendanceDetailed', N'Arb Tahiri', N'Report for list of staff detailed attendance depending of the search.', N'GET', N'https://localhost:5001/Attendance/ReportAttendanceDetailed?ide=Tm9PCOMclx4Po9wuWiQ5Bg==&reportType=1', NULL, 0, NULL, CAST(N'2022-09-21T16:14:19.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5231, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:15:31.677' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5232, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:15:41.997' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5233, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDIJj6HS5OjR92jjdls5VfFS0ebaDykx8YSsEw2-oXsaf82rzDe_9-WB5LQ5tzrlCiowQQjzYWon2TOjPm4hluSuFFVy1SXKMlKijJj-RSuHnn6QVtbEi6l3ALk8h2Sh5oVlLehU-F3GLxJwenFz1MFpQ6SjDh-EKuwvonmfaOLmg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:15:43.727' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5234, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ReportAttendanceDetailed', N'Arb Tahiri', N'Report for list of staff detailed attendance depending of the search.', N'GET', N'https://localhost:5001/Attendance/ReportAttendanceDetailed?ide=Tm9PCOMclx4Po9wuWiQ5Bg==&reportType=1', NULL, 0, NULL, CAST(N'2022-09-21T16:15:46.220' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5235, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ReportAttendanceDetailed', N'Arb Tahiri', N'Report for list of staff detailed attendance depending of the search.', N'GET', N'https://localhost:5001/Attendance/ReportAttendanceDetailed?ide=)wS2xUQDnb4y0k5CIbjF(A==&reportType=1', NULL, 0, NULL, CAST(N'2022-09-21T16:16:14.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5236, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'ReportAttendanceDetailed', N'Arb Tahiri', N'Report for list of staff detailed attendance depending of the search.', N'GET', N'https://localhost:5001/Attendance/ReportAttendanceDetailed?ide=)wS2xUQDnb4y0k5CIbjF(A==&reportType=1', NULL, 0, NULL, CAST(N'2022-09-21T16:19:51.580' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5237, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-09-21T16:21:35.130' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5238, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-21T16:21:35.180' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5239, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-21T16:29:03.763' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5240, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FHome%2FAdministrator', NULL, 0, NULL, CAST(N'2022-09-21T16:30:43.263' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5241, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-21T16:31:02.023' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5242, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-21T16:35:54.187' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5243, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FHome%2FAdministrator', NULL, 0, NULL, CAST(N'2022-09-21T16:39:03.263' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5244, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-21T16:42:27.157' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5245, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-21T16:42:28.100' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5246, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDKnelQEbqoL2seb9ErqAELvE0NS5_i1tz0ywWM5Y4PnJb0YQJOu6WBV_1NkUHLzQsvz0DQB3WW4T6F9jgUMlCCtdvsLX_i1coFmBCgo8aqIlYViIPIkggO329Zr8aBrnqhVMbaFEvxHOmQ_-keyQ_5wcqVqn9eFw8vP_mOJ913IQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-21T16:42:29.307' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5247, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-22T10:04:07.933' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5248, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-22T10:04:29.190' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5249, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:04:33.747' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5250, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TA4zaasJ85AsRDvC3ovFu5Fw54_V9_F_OnONabCn2XQMIR6G3jxWnGXYyUFsHFA5zV9gXu58eS03iOM2wYDHWJ8BsphklU-HQwAtp4Tq011-rIldAj-P2hAzSqNFnwweOx4qp4RnTA5AkPBbfzsAL1ioTgYUiZCjkAf6HIkLaC54Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:04:34.880' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5251, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:04:36.427' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5252, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FDocument', NULL, 0, NULL, CAST(N'2022-09-22T10:05:04.980' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5253, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:05:49.310' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5254, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCRh0yYW-vUJR16yk2mPnrxe3aBFzgEhOHli-O-47o1RmZuDOJibSibKoa-SZ6mqG_4YxpPt6xbItiM3eC59lFxZeo8RLvayQwvDZ6RZ8JB9EXHgN5GOAgLQFlw0U1N-QGXaZhbXvN2PZJF-3xmxStb-vOTYBeoZiDlrQ402F124w"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:05:51.333' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5255, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:05:52.640' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5256, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:06:26.947' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5257, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TC8k9E_B8nOzB1nA6L6iVF2WVKNXVbWKPle57o4edd71sbWkxcw1khT2DHW_pahuPSqPgEhR9nP-r8BKjMDtNoG3H1UaFSd67U7OPSG33uFyiX9Cr_NbxjS4aPR3X7ghJ6J2C_qpttrbYj5QFmxYSUoYrhewFMPUU9iPUzJL5IhUg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:06:29.733' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5258, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:06:31.547' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5259, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:06:44.927' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5260, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBUJ7XtjKAfKN4yWfkphJV7fCriKCR1GIaHutayPMpvB2TP0Dz3SHv-2gRKqENRC0p2JtMT_e0w8nLnceYD4-2JEy-sK-ASfGXDwFI3Rznu5_Aifa6zTbztrMaGLTbxl4AVGXHTsWeOUVZtbVmbMKgJVxpShwlyRyoiAf32rq_ocw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:06:46.760' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5261, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:06:47.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5262, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:07:04.207' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5263, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-09-22T10:07:31.443' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5264, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["developer"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCnK7tylyoWSvhbswK6ku4PMSUZRdybkZffKvBXZzArTFsy-HrHpXvaqjvsB-fyYay5EIaHM_zcUQyO-yM-alGnvO-0ELatUVLn3aUGOMAxlKOOo-jBk72KqAyJPs-B6rA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:07:38.470' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5265, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["developer"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCnK7tylyoWSvhbswK6ku4PMSUZRdybkZffKvBXZzArTFsy-HrHpXvaqjvsB-fyYay5EIaHM_zcUQyO-yM-alGnvO-0ELatUVLn3aUGOMAxlKOOo-jBk72KqAyJPs-B6rA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:07:38.477' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5266, N'3ed2a1de-790d-4d56-87c6-96b269607523', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-22T10:07:38.697' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5267, N'3ed2a1de-790d-4d56-87c6-96b269607523', N'127.0.0.1', N'Home', N'Developer', N'Arb Tahiri', N'Home page for developer.', N'GET', N'https://localhost:5001/Home/Developer', NULL, 0, NULL, CAST(N'2022-09-22T10:07:38.737' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5268, N'3ed2a1de-790d-4d56-87c6-96b269607523', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-09-22T10:07:42.483' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5269, N'3ed2a1de-790d-4d56-87c6-96b269607523', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-09-22T10:07:43.727' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5270, N'3ed2a1de-790d-4d56-87c6-96b269607523', N'127.0.0.1', N'Menu', N'_Create', N'Arb Tahiri', N'Form to create a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Create', NULL, 0, NULL, CAST(N'2022-09-22T10:07:45.147' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5271, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:09:37.540' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5272, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TD1hMVNumt2omNx2CDoG7ETOhwE5g_RZgRwjQJkZUU2eI1bdea9f8BYodvozwWkgUm7Sfy_Ndgog89Du0bTS1FnVrfa35VbkCiMORN66WDfsTWXqTitXj46KalE81FJAuRj1ueP9vY46ZB_8NDvOWK9NHHTeH8nsusUR1rZO9fNbA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:09:40.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5273, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:09:42.087' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5274, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:10:00.400' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5275, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TB1wGzh2lNpl6-ubebIMT678rXeZGBHEkC4fseY11ldKMWPZBlT-I9-0na1Xi4Sj-c-6RolHBzGJt7-QQRI2Zbv4134-EtpiFfyAJBEq44FG7sbZaL0JzuiWCC4ORS8N8hzr2cfkb7Pzx6ZtWKwmGzu3bpu69QFY_bYcbs61TlqFw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:10:01.693' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5276, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:10:03.257' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5277, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:10:57.813' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5278, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDShc1xUZRkJQNkHGD5c7NNgdgEhSawp4nT01ApZ1iubcRPVK15Ssiisa2W08MrubYNicweru1RT05FrlJLZ7XorhtWZi5xvj5V6auY6ctcxtafdx7lB1WiC-LyIv7-y3P6FtJ-NbZy9txoSEm0V8CSHLr3KEm5s_25TiDS5c_MMg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:11:09.393' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5279, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:11:12.197' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5280, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:13:53.843' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5281, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAHNse65lO1bn92kxe94tFK3_dZ2P4X3bBV5J9dTQn6jgWk4y7mQFq1eFmQuWXc2MJn-HMTsi0HYPOLXMQhUcSgb8ML6a7PPtsRyuN1eFIyXWzhrEU07vm_j0GtAVPPXjK7RuYZNNvAgTV-IiAxg7Hoap0ZwplwTh8xBUxnm3Omsg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:13:57.020' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5282, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:14:14.413' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5283, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:14:24.780' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5284, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TD241iM2tDzqmtgzTX-oR9W3NPRUd7UEgtsaa-pN3MYn6CrVFBmOkMYLblNTHgUDsYGYtim02TROvmqzd5GwZ234498CYMU7v_MfYbgNQx0R3YoIQSz3gBEp80lpcPxYD5sPDfP7SNmJkBLfpvUPbcuDRYjs44NsbAHJ2WsQGMO1A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:14:27.303' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5285, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:14:36.340' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5286, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:16:33.203' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5287, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDjdcw58nLV2p0IMcrW29s3Pq_wwe_WmTrO_IwnNswv-oRoIj3QHavxwVqx9syeWtt92Pk2O_6tS2OtWH7sSIWz9eaE0gCoqHxBmbnYTRzH5LI5oh67150tCiisKcX4p7AwWOG8JQVINomhJFutE-IjAHAMFGUkO59H-lmcMww73Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:16:34.353' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5288, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:16:35.810' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5289, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-22T10:17:23.197' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5290, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T10:17:24.077' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5291, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:17:40.443' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5292, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDykH62tzWmxcHMQXhXrTeQf9J3vw9gU6ftJK65ZnUfpaky2v8CP3ovaDCDJCtMQdnx22NeL_wU6HGk9D8pDcwjA3gAN-mUS6S3KAHdnvWUW-JJqHdj-pETS1zI0v4Z697k42zDKAMmWPZ37hi3KiiKdQvWp7MgwCiMDH3lA8H5zA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:17:41.647' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5293, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:17:44.020' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5294, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:18:34.283' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5295, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCKVu9veyKIuyvLPG5ccU1qN2gM1atVD5PM1ECCZEyphYTtDjCwGmw0vlJ7xARTD-YEP_mcjqcuL554rzPFjTfSJwHKc7-jQ1YmiMoWzPsSwC0QaC44UC6IMdFZmLuiasE5kkPMRGb48sLbqDsQjyboX-u72JGn-UGflL0MrYWCzQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:18:44.543' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5296, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:18:46.510' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5297, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCKVu9veyKIuyvLPG5ccU1qN2gM1atVD5PM1ECCZEyphYTtDjCwGmw0vlJ7xARTD-YEP_mcjqcuL554rzPFjTfSJwHKc7-jQ1YmiMoWzPsSwC0QaC44UC6IMdFZmLuiasE5kkPMRGb48sLbqDsQjyboX-u72JGn-UGflL0MrYWCzQ"]}]', 0, NULL, CAST(N'2022-09-22T10:19:25.257' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5298, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:20:04.653' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5299, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCKVu9veyKIuyvLPG5ccU1qN2gM1atVD5PM1ECCZEyphYTtDjCwGmw0vlJ7xARTD-YEP_mcjqcuL554rzPFjTfSJwHKc7-jQ1YmiMoWzPsSwC0QaC44UC6IMdFZmLuiasE5kkPMRGb48sLbqDsQjyboX-u72JGn-UGflL0MrYWCzQ"]}]', 0, NULL, CAST(N'2022-09-22T10:20:05.973' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5300, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:21:14.763' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5301, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBdRsFwBf5pzkrO5J1e703crOVb1uBoqXg4mSZTZ0ZBNqaUIKNE5vQnrrJFDLNv4cxeqbN745NCpbdj7y9v651cTRcYdAVjYdONOqcgLpR-vjBIS4K_8udbZ5Bg9xUz7vpZizu5o0sNMf1BP4AiFELWN_4Rgk3VrN6yozTOegHadQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:21:27.603' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5302, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:22:04.783' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5303, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBdRsFwBf5pzkrO5J1e703crOVb1uBoqXg4mSZTZ0ZBNqaUIKNE5vQnrrJFDLNv4cxeqbN745NCpbdj7y9v651cTRcYdAVjYdONOqcgLpR-vjBIS4K_8udbZ5Bg9xUz7vpZizu5o0sNMf1BP4AiFELWN_4Rgk3VrN6yozTOegHadQ"]}]', 0, NULL, CAST(N'2022-09-22T10:22:15.757' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5304, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Document/Create', N'[{"Key":"AStaffId","Value":["10"]},{"Key":"ADocumentTypeId","Value":["2"]},{"Key":"ATitle","Value":["Birth certificate"]},{"Key":"ExpireDate","Value":[""]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAYTsx2Lasmy-8u-5EvtkXpdH-X2G0KveaA4RG31O53v4VF23E8xa5CNafIY7Wr2lta-E3hB2D0Asl4vBm3sq5LOKaK5ahBv67MFaN8WtXz4GFSOIEDmWMnTrPIG_8rTZm0MNlJuO0Smpnj4qXkK3o2GiS7W7NPKXg3HWYvaHTqyw"]},{"Key":"Expires","Value":["false"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:23:26.773' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5305, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:23:28.337' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5306, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCy2LhANdZSpXFaTdtorrHgH56pKK5m3U-m6bHUiH4bKeu63tUYPFIRSqenuEkTFHKwtqvyAY01AYGw3xQ0ImVGKYf3qF_y0_iXTjHYjVHVgc7i5Bt_WmPGy-bnTSQgYZdaOJXr7Uy_0m4UVXhguDhEqTppoQYvTQ1FEsyKt8bOYg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:23:29.023' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5307, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:23:34.057' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5308, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCy2LhANdZSpXFaTdtorrHgH56pKK5m3U-m6bHUiH4bKeu63tUYPFIRSqenuEkTFHKwtqvyAY01AYGw3xQ0ImVGKYf3qF_y0_iXTjHYjVHVgc7i5Bt_WmPGy-bnTSQgYZdaOJXr7Uy_0m4UVXhguDhEqTppoQYvTQ1FEsyKt8bOYg"]}]', 0, NULL, CAST(N'2022-09-22T10:23:34.997' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5309, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-22T10:27:36.187' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5310, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T10:27:37.063' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5311, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T10:31:26.620' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5312, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T10:39:01.803' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5313, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T10:43:53.980' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5314, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:44:10.300' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5315, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBu7_VQBrN5sOzcQKURtxtEEV_AQhhvAhMEeN95N0JvI5PC34aTws7bDEIRpnWmNwLEGonpsXEtF6mZpIp2zdgd5rvOYM_2r2sVbOdzKwrwE49UlFbphR9HdaM24EhpcTRdRC8l6p8p1illu0Y1vrMiQ6FYwwxFo4fIV5FskL0bMQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:44:13.123' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5316, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:44:43.660' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5317, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBu7_VQBrN5sOzcQKURtxtEEV_AQhhvAhMEeN95N0JvI5PC34aTws7bDEIRpnWmNwLEGonpsXEtF6mZpIp2zdgd5rvOYM_2r2sVbOdzKwrwE49UlFbphR9HdaM24EhpcTRdRC8l6p8p1illu0Y1vrMiQ6FYwwxFo4fIV5FskL0bMQ"]}]', 0, NULL, CAST(N'2022-09-22T10:44:47.733' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5318, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:45:43.560' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5319, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBcTu3G12ASeOiupPicc3xXk1EHoPOiP3y2OdgDEJpoyNzcGBviTCvch_x-rdhorKmTCTh3buJa88fE0UXMu8wbXPIxR6a0LA7FATKlvU0bGu9CMiQ4E0TGM50NgbYnKIGlhbYZsw_Bbw0J_dlk9BXxRITZQHJTP6jMgvYp5ESFfA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:45:45.033' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5320, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:45:46.107' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5321, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBcTu3G12ASeOiupPicc3xXk1EHoPOiP3y2OdgDEJpoyNzcGBviTCvch_x-rdhorKmTCTh3buJa88fE0UXMu8wbXPIxR6a0LA7FATKlvU0bGu9CMiQ4E0TGM50NgbYnKIGlhbYZsw_Bbw0J_dlk9BXxRITZQHJTP6jMgvYp5ESFfA"]}]', 0, NULL, CAST(N'2022-09-22T10:45:47.400' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5322, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:47:12.293' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5323, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDbN6Zub3GEjAdUjbUVIpjJRzBkT6dxaFRrhzybhzW4rDnr5KsvnQRUHICvn7lo0LOf6vu6e2Kr-WxeiU16P-eee2twYzRf_ve_wHW5fSg9SNh9ULv2c7GuWaZDB1KDCrPP4sYOqk66xgWCxcpyWvAQTTZW3hvYHmIzxWEE3sygwg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:47:13.433' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5324, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:47:14.693' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5325, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:47:28.263' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5326, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDfKkK0i0xtf2micoiUahO1gD6z1gbCX9dDuPbKqZFwiUXMMeoc-fFLJOqdRECPSe5hG1djnFOYrDGLbI7WliT-z2NRChwwkpQnLuwQLJlmmuaKzOCAv8u-kuVlWbkpnFHjjAl2achdOk2WkiSWxjWstkCImNUyeKbgOpqHOQhTRQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:47:30.013' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5327, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:47:31.407' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5328, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDfKkK0i0xtf2micoiUahO1gD6z1gbCX9dDuPbKqZFwiUXMMeoc-fFLJOqdRECPSe5hG1djnFOYrDGLbI7WliT-z2NRChwwkpQnLuwQLJlmmuaKzOCAv8u-kuVlWbkpnFHjjAl2achdOk2WkiSWxjWstkCImNUyeKbgOpqHOQhTRQ"]}]', 0, NULL, CAST(N'2022-09-22T10:47:32.737' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5329, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:48:30.407' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5330, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAnO-dmaART_jTW0TIvin5jeJ9-tAHbhPRSNj70sFHMEA6E3JFeqlWXmRoNCWfaxO7i5IIwSsWsVsDe56O4HnRWFbMtYiGr66n7jhrNGD4UbmtTEwaHMVI8F7Sedv1-liH7tD5t23hEs9K0QWYCinFd9jripbwfvHnCPhm6SBMY3g"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:48:32.260' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5331, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:48:34.270' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5332, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAnO-dmaART_jTW0TIvin5jeJ9-tAHbhPRSNj70sFHMEA6E3JFeqlWXmRoNCWfaxO7i5IIwSsWsVsDe56O4HnRWFbMtYiGr66n7jhrNGD4UbmtTEwaHMVI8F7Sedv1-liH7tD5t23hEs9K0QWYCinFd9jripbwfvHnCPhm6SBMY3g"]}]', 0, NULL, CAST(N'2022-09-22T10:48:35.863' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5333, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:49:08.760' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5334, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TASjSHKDdeeY5yDjUL1cBpESWgflj-UstAe5wm-KIl_QYc7yi4asTY-RLilmk14Pk3Qq8zOKT1sJuwqZgQ6hUu84sQ63NbXztOz5Whrn61MZO9CHD1Me5VPC3vW-eZaVJtVVzIk-cpYd9Bj-6Wkjw5ZK5cbbGqamIROeNcAlQE6hA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:49:09.617' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5335, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:49:11.070' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5336, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TASjSHKDdeeY5yDjUL1cBpESWgflj-UstAe5wm-KIl_QYc7yi4asTY-RLilmk14Pk3Qq8zOKT1sJuwqZgQ6hUu84sQ63NbXztOz5Whrn61MZO9CHD1Me5VPC3vW-eZaVJtVVzIk-cpYd9Bj-6Wkjw5ZK5cbbGqamIROeNcAlQE6hA"]}]', 0, NULL, CAST(N'2022-09-22T10:49:12.003' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5337, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:50:15.173' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5338, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAx1PwlFzK1AxtZG8Rf8NzEjvycwEBGuMKaGeYqWzuNDBfZV8ZEHIZfheMRVTaVvvaLRyyBs_TR6C-xuegOtdpSLBJYBXvYS5H_JqXrfL5o9Mh4US0bgmOfxOjkeapl-4fo0eeLsTBBJjPGhvnN1t0gpRxmvymDeFmuIAWbvkZNjQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:50:17.710' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5339, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T10:50:19.130' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5340, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAx1PwlFzK1AxtZG8Rf8NzEjvycwEBGuMKaGeYqWzuNDBfZV8ZEHIZfheMRVTaVvvaLRyyBs_TR6C-xuegOtdpSLBJYBXvYS5H_JqXrfL5o9Mh4US0bgmOfxOjkeapl-4fo0eeLsTBBJjPGhvnN1t0gpRxmvymDeFmuIAWbvkZNjQ"]}]', 0, NULL, CAST(N'2022-09-22T10:50:20.303' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5341, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:53:54.157' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5342, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBd0fnLaRHsFcoVtaWsKtsmoIEWehTUWjxE0X_234GNUEy51Uk2bItwVoZqv10wSRCsRUqMlNDuLmVlS43BCtxY1zaQSBKssid1yb_l47wRYEOyRZCV_yGU_neN_ftakH8kSLqTZ-M3tm8mEO-nqL4xp0I-EV1t2u9hqpeL53j04Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:54:06.067' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5343, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:55:41.967' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5344, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCbdxJDoEguXB8vYNfCqRUgQ2X4cBEMQbaRoQdiUs4FASdYSaMLUUfj7NvpTfxCahJQBIvzOG_t-x1vW8xwSBZKzwh7mJGJZq7lxaeBc3aTpobUMqwm8vRnHWael-Iy9DFrWFcSMed9qXvSFbQwDnAsdW73GioJ3HuKrotpgMUn1w"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:55:43.590' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5345, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T10:56:28.837' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5346, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBEjdpV1XfvyjYv3VascxzDVUvpBleUMARZwYHsI0nDrkCKbOATyYxvd9FOd6POt4XdScsC3XkM6VipkYWYOzYH4fi9H5ThDlK81Q7Gj6xpx7B6wmYb5sOpCeryRl8ON05SOXOcXK4qI2HlUYy9jB64UJdPaKLaVfdV-Leh2SO_QQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T10:56:29.890' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5347, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-22T10:56:29.940' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5348, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T10:56:30.007' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5349, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T11:10:30.257' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5350, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'Index', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance', NULL, 0, NULL, CAST(N'2022-09-22T11:10:44.100' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5351, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'GET', N'https://localhost:5001/Attendance/SearchStaff', NULL, 0, NULL, CAST(N'2022-09-22T11:10:45.130' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5352, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Attendance', N'SearchStaff', N'Arb Tahiri', N'Form to display list of staff attendance.', N'POST', N'https://localhost:5001/Attendance/SearchStaff', N'[{"Key":"stype","Value":[""]},{"Key":"SStaffId","Value":[""]},{"Key":"SDepartmentId","Value":[""]},{"Key":"SStaffTypeId","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TD45mny9OKncnrZXEczi-7xIW5hlp2PaKNb8OBVtQUXbRVP48qxTmFTpy_NPC-xK39G5JAW1DcZdIddmqITnTD71iR-LEqnDOWMUkJ2Wqg1uXZyCF0ABGAc-8I1ImDnnm_eeSYpuotksdtxXzt1eplymo8OEUVmgZJ7vAmdVNDs4Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:11:35.157' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5353, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:11:42.843' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5354, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCX0jAj3c1lPMg_2bMLhHIL0cixraxoMUDnSzBGkaDy-7_CKwqS6Yyi_8XdT49Iyuxm-o9L8PDGxWUyUW-QRUHwiP1PptpgDeQLxFM7SMhF93bWDD2qj_MpvK6uKaEerLvz6_oi2XuggGkW7NAP3Mv6pTFDko0G2vMvYowG_QTXtA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:11:43.947' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5355, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:12:04.607' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5356, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBVRn17AQWu1QL_8R4wD9Kc2to3EtKf4biwlx5wmJ8tpYoDzkWxJFo3KeV2X7H1rPK5p2Lr8bbIwKqgVpudr4SGkaeqiW1T593fz0Ej7jScHsw-3MAN9uzeaSU6VXlyXxFFsoJTajSQb5CbZr6yW5-TNXb50SJM08YzafyKlQKilg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:12:06.700' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5357, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:13:55.573' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5358, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBDxuG_hjFSrAybUjYsI-f6GrBAF6QOQsr_oacu5-vinRsbPX4aglp4M52F40dW8X5e4T2E1eiPsHIbviRJVQsBSl5y884pmEdtsAcKwQfIacxXddMQQC29XYIBOT6R77qfiIWYR3dQJaqYXpFmTy6pwHvdqPrQ3gFt9pWlulcrwg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:14:06.953' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5359, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:14:08.133' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5360, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBFewQ0IA1vhQ0dfeOxqd7oqne3LuWH8XxEiR9hC5DsuFVmi_r8kV4Ls554ISKuyQWna7mFvGj9rUW3HekIcLQNdAbQp-WfhexgkegP-cQcuswoACNlQZ2JuZmvrjhxwaSSCpmxo_n0ZgnsJnRmRtDkrjgDupbaxO9WH4U-YoQ6dg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:14:08.983' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5361, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:14:10.333' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5362, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBFewQ0IA1vhQ0dfeOxqd7oqne3LuWH8XxEiR9hC5DsuFVmi_r8kV4Ls554ISKuyQWna7mFvGj9rUW3HekIcLQNdAbQp-WfhexgkegP-cQcuswoACNlQZ2JuZmvrjhxwaSSCpmxo_n0ZgnsJnRmRtDkrjgDupbaxO9WH4U-YoQ6dg"]}]', 0, NULL, CAST(N'2022-09-22T11:14:11.580' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5363, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Document/Create', N'[{"Key":"AStaffId","Value":["10"]},{"Key":"ADocumentTypeId","Value":["2"]},{"Key":"ATitle","Value":["Birth certificate"]},{"Key":"ExpireDate","Value":[""]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDcX0o5EyzyzVDB6FyyVYqHfd5-Fmb8zXd8bqA6ZlEhGLlsElB-M7jo6d-HFWMhrFKob2Ry_AXlaV2D8sEzBtBOXp1n_zABDlow9IgoJy7t5o6tUl4boRRL8wstgeqN_G1_prNJsowcbNtFCkgoOsMMiS7Yvgwo8v1F0TtMr_nleA"]},{"Key":"Expires","Value":["false"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:14:20.483' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5364, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:14:31.203' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5365, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TC4FRUo2slBKNJhyzYYpWYt_Sp7Up_yrgl6MF2W0qhoNcKNL7rA-KUaVtKRPpnjLhOMaYAhFo420Afx_m3cywoW84PZWOTOXNdosbuuUMYVPiuWWr2MdtOavBrWw3go3PR5sMvz1bAaMs9Eav_muWoHM-C0VhtMUHQZNtB90KVgmg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:14:32.017' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5366, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:14:54.060' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5367, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TC4FRUo2slBKNJhyzYYpWYt_Sp7Up_yrgl6MF2W0qhoNcKNL7rA-KUaVtKRPpnjLhOMaYAhFo420Afx_m3cywoW84PZWOTOXNdosbuuUMYVPiuWWr2MdtOavBrWw3go3PR5sMvz1bAaMs9Eav_muWoHM-C0VhtMUHQZNtB90KVgmg"]}]', 0, NULL, CAST(N'2022-09-22T11:14:55.147' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5368, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Document/Create', N'[{"Key":"AStaffId","Value":["10"]},{"Key":"ADocumentTypeId","Value":["5"]},{"Key":"ATitle","Value":["Deshmia e fondeve"]},{"Key":"Expires","Value":["true","false"]},{"Key":"ExpireDate","Value":["23/09/2022"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TA1uVY1j0yuH4tiFR4anMH_jJckwFy32lB0OiFxybLMTWVojUm5YFeb9prclfmFGFpnVykW4g6aADvsMuhM3PSh5Qmjcp6ivUEZ3vZdJCK_LyVkziZKedsz-z0jJOB7eVaTdQjqG5OE5vrkkf9YQtyJ7Hzw7fBbVzElt4_5A4tT_g"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:15:15.170' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5369, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-22T11:19:32.673' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5370, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T11:19:33.563' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5371, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FHome%2FAdministrator', NULL, 0, NULL, CAST(N'2022-09-22T11:19:52.880' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5372, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T11:22:42.303' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5373, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:22:57.720' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5374, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDTYhzKyLN84RDjlBsAKfOVZvGsie0IkaQx8TcQDLaNcM9cqi25G1Da9uZqV4DAXmiRXLTaNwNAkMfh9UhxNEI8SxllSaFpM9CfvApGpPxm505Ygl0JzmtnE6NUxe_dZY98o_HEQyNoKUY5czka7QvFlNkYyqMAdW6qUfelA5aVvw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:22:58.867' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5375, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:23:00.007' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5376, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDTYhzKyLN84RDjlBsAKfOVZvGsie0IkaQx8TcQDLaNcM9cqi25G1Da9uZqV4DAXmiRXLTaNwNAkMfh9UhxNEI8SxllSaFpM9CfvApGpPxm505Ygl0JzmtnE6NUxe_dZY98o_HEQyNoKUY5czka7QvFlNkYyqMAdW6qUfelA5aVvw"]}]', 0, NULL, CAST(N'2022-09-22T11:23:02.090' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5377, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FDocument', NULL, 0, NULL, CAST(N'2022-09-22T11:23:08.733' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5378, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Document/Create', N'[{"Key":"AStaffId","Value":["10"]},{"Key":"ADocumentTypeId","Value":["5"]},{"Key":"ATitle","Value":["Deshmia e fondeve"]},{"Key":"Expires","Value":["true","false"]},{"Key":"ExpireDate","Value":["22/09/2022"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TA8Z83fL2TMlAaNjo2Wm7qDHArbcxb7846J4zxeEqC5N3RadcmZbeL_B7Cx5MccshHXOFXkiOf1IfI1bLsk4-gjriMXi_3yaGaw_dk1cud0hz722zR6a5BIwWrzEfNjmMp8X6zkGr4hH9tsomYG1XIqCHq_bkvntp_QMcb21GAQdQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:24:33.300' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5379, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T11:28:52.330' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5380, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:29:13.580' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5381, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCxVbk8o2pCIlEwB-1gxAScdQDe5NsqfBCm4r8so1NdLbLqPL-kxL6RifJB3vdV1zyY24OoD7flYFZ3ANzNYFqrP2lpFct0m6o8j9Z6CBrfkqOc47tjxiIkmH2O82jgkMm94DbyAFQLrPSkQ_0T-aPNHZtxdZkL17xXxaODpvcLvQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:29:14.603' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5382, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:29:34.683' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5383, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCxVbk8o2pCIlEwB-1gxAScdQDe5NsqfBCm4r8so1NdLbLqPL-kxL6RifJB3vdV1zyY24OoD7flYFZ3ANzNYFqrP2lpFct0m6o8j9Z6CBrfkqOc47tjxiIkmH2O82jgkMm94DbyAFQLrPSkQ_0T-aPNHZtxdZkL17xXxaODpvcLvQ"]}]', 0, NULL, CAST(N'2022-09-22T11:29:36.363' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5384, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Document/Create', N'[{"Key":"AStaffId","Value":["10"]},{"Key":"ADocumentTypeId","Value":["5"]},{"Key":"ATitle","Value":["Deshmia fondeve"]},{"Key":"Expires","Value":["true","false"]},{"Key":"ExpireDate","Value":["22/09/2022"]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBXNjBABwNznMVcQoBTyXErN-jKv_JSMGLMXICRRYRi-m79wWMPxvu1qGsYAedZt36lwMh2bSeg8ie2vYI611uWC-uj9ZaV41Uzj4aFJPbKR-xYHzM9GWWqG3mg3zqH01tdeY_mKIeMm_76Zv5nY3udwzAWnKNjAwWuEfPG0S1HSA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:29:53.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5385, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:30:07.003' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5386, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAIskaUTXRs9ga7OQwiNWejeIsdGw7ADjhVmf7jFWeGV3ElUUnDFAcjV-ULTZbxLilAB3xAWBWWmeAwnGY7rPDjwhdwgBEKoZTNn4FaYGgGgQDBArJ_bRQc5j6BWiEhNj755Q788iFwzpmIJxghNvMZ7gXNqloihZhh0JZAUo7fNg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:30:07.980' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5387, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:30:11.430' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5388, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'GetStaff', N'Arb Tahiri', N'List of staff for select list', N'POST', N'https://localhost:5001/Document/GetStaff', N'[{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TAIskaUTXRs9ga7OQwiNWejeIsdGw7ADjhVmf7jFWeGV3ElUUnDFAcjV-ULTZbxLilAB3xAWBWWmeAwnGY7rPDjwhdwgBEKoZTNn4FaYGgGgQDBArJ_bRQc5j6BWiEhNj755Q788iFwzpmIJxghNvMZ7gXNqloihZhh0JZAUo7fNg"]}]', 0, NULL, CAST(N'2022-09-22T11:30:12.913' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5389, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Action to add documents.', N'POST', N'https://localhost:5001/Document/Create', N'[{"Key":"AStaffId","Value":["10"]},{"Key":"ADocumentTypeId","Value":["5"]},{"Key":"ATitle","Value":["Deshmia e fondeve"]},{"Key":"ExpireDate","Value":[""]},{"Key":"Description","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDcf4uppjL4C2iaTmr75wjDt31BXOx06pXh9sXxvQo-vSkjwRa_ikXKC7D89ePerFt9ehpfcAnJF_df1kiyPf_17pnhC3sLnBi1YiGguX6HIdjl8uCGt79rpm3zW2KrHCmC9dQpuzLbD8DqkC1SJnxNnDUxJJleHPz6XnI2xfWLbA"]},{"Key":"Expires","Value":["false"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:30:27.390' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5390, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:30:35.287' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5391, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TDIbn1G-lNLOKI5w3Cj2lAeR3DwyX6R5w23Tswxatf7rP6QSxaJZiig6S3HoAAo3JUl-MKw7_Sh1JtNny0hXD8uHtf1hCUgtGk23dMXdMW-AVB9Sy0azxyo5wPkZ4yJ2viDm8d_-sZtOuL01gwoIXTyAAdrtOTiTwbEMO2ik3Iprw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:30:36.150' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5392, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-09-22T11:38:00.743' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5393, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T11:38:01.827' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5394, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:38:02.030' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5395, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TCzTdeYiwjFlB1j9sqF8FUCdM8OymA5b_PcPx27IzkhWvICg2aQn3dQkIneiXi3ORdYfOtvorVa-h2JIGbfEbsNnrjDrO7Rm8SdCNbjdyCXyYgS500FJYhRs4SjbeGLs6VxDS8Z9CHRTWfofVR-rlVR991a9nkiUBrmNPH_ZGKJcw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:38:11.570' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5396, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:38:28.220' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5397, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Edit', N'Arb Tahiri', N'Form to edit a document.', N'GET', N'https://localhost:5001/Document/Edit?ide=tgutkThhHU9phNc7I80u9A==', NULL, 0, NULL, CAST(N'2022-09-22T11:38:33.353' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5398, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Edit', N'Arb Tahiri', N'Form to edit a document.', N'GET', N'https://localhost:5001/Document/Edit?ide=KeIJ5mB)LZ4SfJ8ctcIjIg==', NULL, 0, NULL, CAST(N'2022-09-22T11:38:40.453' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5399, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:38:45.933' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5400, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Edit', N'Arb Tahiri', N'Form to edit a document.', N'GET', N'https://localhost:5001/Document/Edit?ide=tgutkThhHU9phNc7I80u9A==', NULL, 0, NULL, CAST(N'2022-09-22T11:38:50.453' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5401, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Create', N'Arb Tahiri', N'Form to add documents.', N'GET', N'https://localhost:5001/Document/Create', NULL, 0, NULL, CAST(N'2022-09-22T11:39:16.073' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5402, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:47:14.357' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5403, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T11:47:14.357' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5404, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBUEbaOkI9vrKF1R7UxgEXAGpFlLkoK_ZYNy-u-SaKjj9XKbN2v0qBJfXo3SGb-ggT3OajcfbNf6Zcf2_N_FRGo543A5qO6DRKA9Mw9suafJ_CLmT5YxtFz9ft4vzmIXm2XhzuR-4gRGVxQ3Tm4tpdlHYcwb4gAAyJoflreYV-lig"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:47:24.060' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5405, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:47:47.137' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5406, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBDmyRVTjLVKXNAU0AtJ-bNzqn_9qOKlHVvbx5AMDK9CJ8zoKbnbdysl2HQpUo8PO6J5jsIPWI0QkLhkfl8ls4VqJ0bCCCY1AK1ynjmGDtisxNye2WTwonax-tmDZOeWtnUpTBYD7TjZZ93xYVA18K9D82azHB2IZn7ue79n7y8zw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:47:48.407' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5407, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Index', N'Arb Tahiri', N'Form to display list of documents.', N'GET', N'https://localhost:5001/Document', NULL, 0, NULL, CAST(N'2022-09-22T11:52:10.923' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5408, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"ExpireId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBvLku7QP1EVdeAFWBo3vatBKlDmihIoH2OkI3vx07xLbKKMyR4fYg3LXCjufITKwqJ1dhjY4OevMeVE9_6eYyQiPWRGwRNB2yRcZeNbOPcEt8Prun62fneT1m4AIyaTyOC28mb7XMC71U3jOEnnKbbO7buSqXppuPrit75lmXtNw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:52:20.747' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5409, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"ExpireId","Value":["1"]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBvLku7QP1EVdeAFWBo3vatBKlDmihIoH2OkI3vx07xLbKKMyR4fYg3LXCjufITKwqJ1dhjY4OevMeVE9_6eYyQiPWRGwRNB2yRcZeNbOPcEt8Prun62fneT1m4AIyaTyOC28mb7XMC71U3jOEnnKbbO7buSqXppuPrit75lmXtNw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:52:25.267' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5410, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"ExpireId","Value":["2"]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBvLku7QP1EVdeAFWBo3vatBKlDmihIoH2OkI3vx07xLbKKMyR4fYg3LXCjufITKwqJ1dhjY4OevMeVE9_6eYyQiPWRGwRNB2yRcZeNbOPcEt8Prun62fneT1m4AIyaTyOC28mb7XMC71U3jOEnnKbbO7buSqXppuPrit75lmXtNw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:52:27.577' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5411, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Document', N'Search', N'Arb Tahiri', N'Action to search for the list of documents.', N'POST', N'https://localhost:5001/Document/Search', N'[{"Key":"atype","Value":[""]},{"Key":"Title","Value":[""]},{"Key":"StaffId","Value":[""]},{"Key":"DocumentTypeId","Value":[""]},{"Key":"ExpireId","Value":[""]},{"Key":"InsertDate","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8JhfzRbWdZJJuQTPD7R-7TBvLku7QP1EVdeAFWBo3vatBKlDmihIoH2OkI3vx07xLbKKMyR4fYg3LXCjufITKwqJ1dhjY4OevMeVE9_6eYyQiPWRGwRNB2yRcZeNbOPcEt8Prun62fneT1m4AIyaTyOC28mb7XMC71U3jOEnnKbbO7buSqXppuPrit75lmXtNw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-09-22T11:52:30.633' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5412, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-09-22T14:42:40.673' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5413, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Email', N'Index', N'Arb Tahiri', N'Form to display email.', N'GET', N'https://localhost:5001/Administration/Email/Index', NULL, 0, NULL, CAST(N'2022-09-22T14:43:31.637' AS DateTime))
SET IDENTITY_INSERT [Core].[Log] OFF
GO
SET IDENTITY_INSERT [Core].[Menu] ON 

INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Ballina', N'Home', 0, N'fas fa-home', N'1:m', N'1', NULL, N'Home', N'Index', 1, N'Administrator, IT, ', N'Index, Administrator', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:51:58.333' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, N'Administrimi', N'Administration', 1, N'fas fa-users-cog', N'3:m', N'3', N'Administration', N'Administration', N'Index', 4, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, N'Autorizimet', N'Authorizations', 1, N'fas fa-key', N'5:m', N'5', N'Authorization', N'Authorization', N'Index', 3, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:56:01.463' AS DateTime), 2)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, N'Gjurmët', N'Traces', 1, N'fas fa-fingerprint', N'6:m', N'6', N'Application', N'Application', N'Index', 5, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (8, N'Stafi', N'Staff', 1, N'fas fa-user-alt', N'7:m', N'7', NULL, N'Staff', N'Index', 6, NULL, N'Index,Search,Register,Documents,Departments', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:27:14.760' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:27:35.440' AS DateTime), 1)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (9, N'Konfigurimet', N'Configurations', 1, N'fas fa-cog', N'2:m', N'2', NULL, N'Configuration', N'Index', 3, NULL, N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:47:11.850' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1008, N'Pjesëmarrja', N'Attendance', 0, N'fab fa-atlassian', N'8:m', N'8', NULL, N'Attendance', N'Index', 7, N'Administrator, ', N'Index,SearchStaff,SearchAttendance', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T14:41:41.463' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1009, N'Profili', N'Profile', 0, N'far fa-address-card', N'9:m', N'9', NULL, N'Profile', N'Index', 5, N'Administrator, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-09T09:13:39.070' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1010, N'Dokumentet', N'Documents', 0, N'fas fa-folder-open', N'25:m', N'25', NULL, N'Document', N'Index', 5, N'Administrator, ', N'Index', 1, N'3ed2a1de-790d-4d56-87c6-96b269607523', CAST(N'2022-09-19T13:46:09.090' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[Menu] OFF
GO
SET IDENTITY_INSERT [Core].[RealRole] ON 

INSERT [Core].[RealRole] ([RealRoleID], [UserID], [RoleID], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:37:51.103' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[RealRole] OFF
GO
SET IDENTITY_INSERT [Core].[StatusType] ON 

INSERT [Core].[StatusType] ([StatusTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Aprovuar', N'Approved', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:45:59.110' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[StatusType] ([StatusTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, N'Refuzuar', N'Refused', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:46:12.003' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[StatusType] ([StatusTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, N'Në pritje', N'Pending', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:46:22.210' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[StatusType] ([StatusTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, N'Në procesim', N'Processing', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:46:48.203' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[StatusType] ([StatusTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, N'Përfunduar', N'Finished', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:46:59.857' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[StatusType] ([StatusTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, N'Fshirë', N'Deleted', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:47:08.243' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[StatusType] ([StatusTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, N'I regjistruar/i paprocesuar', N'Registered/unprocessed', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:47:33.667' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[StatusType] OFF
GO
SET IDENTITY_INSERT [Core].[SubMenu] ON 

INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 6, N'Autorizimet', N'Authorizations', N'fas fa-shield-alt', N'51:m', N'51', N'Authorization', N'Authorizations', N'Index', 1, N'IT, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-10T08:18:03.277' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 6, N'Menytë', N'Menus', N'fas fa-bars', N'52:m', N'52', N'Authorization', N'Menu', N'Index', 2, N'IT, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-10T08:18:03.277' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, 8, N'Regjistro', N'Register', N'fas fa-plus', N'71:m', N'71', NULL, N'Staff', N'Register', 1, N'Administrator, ', N'Register,Documents,Departments', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:28:48.243' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, 8, N'Lista', N'List', N'fas fa-list', N'7:m', N'7', NULL, N'Staff', N'Index', 1, N'Administrator, ', N'Index,Search', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:29:37.920' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, 9, N'Parametrat e aplikacionit', N'Application parameters', N'fas fa-sliders-h', N'21:m', N'21', N'Configuration', N'AppSettings', N'Index', 1, N', IT, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:48:14.597' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:43:25.260' AS DateTime), 2)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, 9, N'Tabelat ndihmëse', N'Look up tables', N'fas fa-table', N'22:m', N'22', N'Configuration', N'Tables', N'Index', 2, N', IT, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:49:06.780' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:43:34.463' AS DateTime), 1)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1004, 4, N'Përdoruesit', N'Users', N'fas fa-user-cog', N'31:m', N'31', N'Administration', N'Users', N'Index', 1, N', IT, ', N'Index,Create,Edit', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T09:41:18.140' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1005, 4, N'Email', N'Email', N'fas fa-at', N'33:m', N'33', N'Administration', N'Email', N'Index', 3, N'Administrator, , ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T09:44:09.333' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1006, 4, N'Grupet', N'Roles', N'fas fa-user-tag', N'32:m', N'32', N'Administration', N'Roles', N'Index', 2, N', IT, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T09:45:18.547' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[SubMenu] OFF
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'00000000000000_CreateIdentitySchema', N'6.0.5')
GO
SET IDENTITY_INSERT [dbo].[AbsentType] ON 

INSERT [dbo].[AbsentType] ([AbsentTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Vizitë mjekësore', N'Medical visit', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T16:06:04.900' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[AbsentType] OFF
GO
SET IDENTITY_INSERT [dbo].[AspNetRoleClaims] ON 

INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (2, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'5', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (20, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (21, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'71', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (22, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7d', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (23, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7d', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (24, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7d', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (25, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7d', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (26, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7dp', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (27, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7dp', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (28, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7dp', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (29, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7dp', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (30, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (31, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'71', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (32, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (35, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'15', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (36, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (37, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (38, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (39, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1013, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'8', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1014, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'8', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1015, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'8', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1016, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'1', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1018, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'33', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1030, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'33', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1031, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'9', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1032, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'1', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1033, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'51', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1034, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'52', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1035, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'21', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1036, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'22', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1037, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'32', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1039, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'31', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1040, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'31', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1041, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'31', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1042, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'31', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1043, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'31sp', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1044, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'31l', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1045, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'31ul', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1046, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'32', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1047, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'32', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1048, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'32', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1049, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'22', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1050, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'22', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1051, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'22', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1052, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'22', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1053, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'15', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1054, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'51', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1055, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'12', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1056, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'52', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1057, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'52', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1058, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'52', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1059, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'52', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1060, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'53', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1061, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'53', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1062, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'53', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1063, N'708c1afc-9ac5-4677-831f-d50966b8411e', N'53', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1065, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'8', N'h')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1066, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'8', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1067, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'25', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1068, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'25', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1069, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'25', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1070, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'7', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1071, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'25', N'm')
SET IDENTITY_INSERT [dbo].[AspNetRoleClaims] OFF
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NameSQ], [NameEN], [Description], [NormalizedName], [ConcurrencyStamp]) VALUES (N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'Administrator', N'Administrator', N'Administrator', N'Administrator', N'ADMINISTRATOR', N'32b18837-d775-4487-9668-d72cc41ebcb8')
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NameSQ], [NameEN], [Description], [NormalizedName], [ConcurrencyStamp]) VALUES (N'708c1afc-9ac5-4677-831f-d50966b8411e', N'IT', N'IT', N'IT', N'Role to manage authorizations, configurations of the system.', N'IT', N'e53c4296-13d7-4141-8e5e-85c91a104719')
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'3ed2a1de-790d-4d56-87c6-96b269607523', N'708c1afc-9ac5-4677-831f-d50966b8411e')
GO
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [PersonalNumber], [FirstName], [LastName], [PhoneNumber], [Email], [NormalizedUserName], [NormalizedEmail], [PhoneNumberConfirmed], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [ProfileImage], [AllowNotification], [Language], [AppMode], [InsertedFrom], [InsertedDate]) VALUES (N'3ed2a1de-790d-4d56-87c6-96b269607523', N'developer', N'1255466873', N'George', N'Harrison', N'38349665221', N'george.beatles@gmail.com', N'DEVELOPER', N'GEORGE.BEATLES@GMAIL.COM', 0, 1, N'AQAAAAEAADqYAAAAEKiFaFyhfTVRgjD22iUYWtMehV2DiIq3qE/FO5qGJKYqD+xgUHGexWuoDNv/LzMNhw==', N'3PMJXNOQ2MX47ELWSRSNAABEDKXJ2O5U', N'2072aec5-1441-4118-aa1a-52679e483375', 0, CAST(N'2022-01-14T14:20:08.8529058+01:00' AS DateTimeOffset), 1, 0, N'/Uploads/Users/096deafc-2539-472a-a510-c275d7e156db.jpg', 0, 1, 2, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-16T16:37:15.210' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [PersonalNumber], [FirstName], [LastName], [PhoneNumber], [Email], [NormalizedUserName], [NormalizedEmail], [PhoneNumberConfirmed], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [ProfileImage], [AllowNotification], [Language], [AppMode], [InsertedFrom], [InsertedDate]) VALUES (N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'admin', N'1230456789', N'May', N'Calamawy', N'38345996688', N'may@yahoo.com', N'ADMIN', N'MAY@YAHOO.COM', 0, 1, N'AQAAAAEAADqYAAAAEKiFaFyhfTVRgjD22iUYWtMehV2DiIq3qE/FO5qGJKYqD+xgUHGexWuoDNv/LzMNhw==', N'3PMJXNOQ2MX47ELWSRSNAABEDKXJ2O5U', N'4bc64dc3-b2c7-494f-b345-f80b6f44e831', 0, CAST(N'2022-01-14T14:20:08.8529058+01:00' AS DateTimeOffset), 1, 0, N'/Uploads/Users/0a753b27-d731-471a-b019-8147231f7925.jpg', 0, 1, 2, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-01-06T16:34:20.557' AS DateTime))
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [PersonalNumber], [FirstName], [LastName], [PhoneNumber], [Email], [NormalizedUserName], [NormalizedEmail], [PhoneNumberConfirmed], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [ProfileImage], [AllowNotification], [Language], [AppMode], [InsertedFrom], [InsertedDate]) VALUES (N'beea93e7-f537-4dae-9a26-bfe1b94bd175', N'majortom', N'1445788695', N'Major', N'Tom', N'38345332123', N'major@tom.com', N'MAJORTOM', N'MAJOR@TOM.COM', 0, 1, N'AQAAAAEAADqYAAAAEIJjXMAGwkkMd8pOWALQl5aApL1maIJPxBv9yuZ97a1AACNpNPbSFut1fDlHMuDfXw==', N'HAJVHCTEK66HPUYPAPEOUL2WZ4R3JPAF', N'0f0f8b50-796e-4e16-84d7-c05000127a9b', 0, NULL, 1, 0, NULL, 0, 1, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T13:24:31.800' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Department] ON 

INSERT [dbo].[Department] ([DepartmentID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Administrata', N'Administration', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:47:51.960' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Department] ([DepartmentID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, N'Burimet njerëzore', N'Human resource', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:58:10.030' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Department] ([DepartmentID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, N'Inxhinieri', N'Engineer', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:59:01.957' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Department] OFF
GO
SET IDENTITY_INSERT [dbo].[DocumentType] ON 

INSERT [dbo].[DocumentType] ([DocumentTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Resume', N'Resume', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:45:26.830' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[DocumentType] ([DocumentTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, N'Certifikata lindjes', N'Birth certificate', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:45:26.830' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[DocumentType] ([DocumentTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, N'Gjendja llogarisë', N'Evidence of funds', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-09T11:25:52.800' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[DocumentType] OFF
GO
SET IDENTITY_INSERT [dbo].[Staff] ON 

INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, NULL, N'1205354756', N'Jack', N'Shephard', CAST(N'1998-03-12' AS Date), 1, 2, 1, N'225 street', N'12235', N'jack.sh@gmail.com', N'38345123321', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:01:21.810' AS DateTime), 1)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, NULL, N'1203214051', N'Josh', N'Holloway', CAST(N'1970-03-12' AS Date), 2, 1, 2, N'225 street', N'70000', N'joshh@hotmail.com', N'38345556447', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, NULL, N'1204125172', N'Harry', N'Potter', CAST(N'1990-03-12' AS Date), 1, 2, 1, N'225 street', N'10000', N'potter_harry@hotmail.com', N'38345223556', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, NULL, N'1205130283', N'Terry', N'O''Quinn', CAST(N'1995-03-12' AS Date), 2, 1, 2, N'225 street', N'2245', N'terry_oquinn@gmail.com', N'38345669885', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, NULL, N'1206141394', N'Charlie', N'Cox', CAST(N'1985-03-12' AS Date), 1, 2, 1, N'225 street', N'4425', N'cox.charlie@gmail.com', N'38345558774', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (8, NULL, N'1207252405', N'Tony', N'Stark', CAST(N'1992-03-12' AS Date), 2, 1, 2, N'225 street', N'646', N'iron.man@yahoo.com', N'38345336552', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (9, NULL, N'1208363516', N'Shang', N'Chi', CAST(N'1996-03-12' AS Date), 1, 2, 1, N'225 street', N'3436', N'shang@hotmail.com', N'38345225441', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (10, NULL, N'1205574627', N'Al', N'Pacino', CAST(N'2003-03-12' AS Date), 2, 1, 2, N'225 street', N'34636', N'alpacino@yahoo.com', N'38345398541', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (11, NULL, N'1200589738', N'Roberto', N'De Niro', CAST(N'1978-03-12' AS Date), 1, 2, 1, N'225 street', N'36436', N'deniro72@gmail.com', N'38345256874', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (12, NULL, N'1201898879', N'Michael', N'Jackson', CAST(N'2001-03-12' AS Date), 2, 1, 2, N'225 street', N'436463', N'billy.jean@yahoo.com', N'38345147852', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (13, NULL, N'1202907960', N'LeBron', N'James', CAST(N'2000-03-12' AS Date), 1, 2, 1, N'225 street', N'3643643', N'lebron623@yahoo.com', N'38345258963', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (14, NULL, N'1203725051', N'Kobe', N'Bryant', CAST(N'1989-03-12' AS Date), 2, 1, 2, N'225 street', N'364434', N'kobe824@hotmail.com', N'38345369852', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (15, NULL, N'1204244242', N'Ethan', N'Hawke', CAST(N'1999-03-12' AS Date), 1, 2, 1, N'225 street', N'52420', N'ethan2000@gmail.com', N'38345258741', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (16, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'1205253433', N'May', N'Calamawy', CAST(N'1978-03-12' AS Date), 2, 1, 2, N'225 street', N'5524', N'may@yahoo.com', N'38345123698', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (17, NULL, N'1206371324', N'Oscar', N'Isaac', CAST(N'1988-03-12' AS Date), 1, 2, 1, N'225 street', N'3346', N'oscar.moon@hotmail.com', N'38345951753', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (20, NULL, N'1242823636', N'Amigo', N'AAAA', CAST(N'2022-04-09' AS Date), 2, 1, 2, N'dikun', N'70000', N'231321@32132asxc.com', N'38345354354', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-09T16:08:27.450' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T08:43:10.853' AS DateTime), 1)
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (21, N'beea93e7-f537-4dae-9a26-bfe1b94bd175', N'1445788695', N'Major', N'Tom', CAST(N'2022-09-13' AS Date), 1, 2, 2, N'23rd street', N'E88753', N'major@tom.com', N'38345332123', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T13:25:11.543' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Staff] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffAttendance] ON 

INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 3, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-15T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, 3, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-16T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 3, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-17T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, 3, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, 4, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-14T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, 4, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-15T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, 4, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-16T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (8, 5, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-14T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (9, 5, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-15T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (10, 5, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-16T16:20:37.247' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (11, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-08T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (12, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-09T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (13, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-10T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (14, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-11T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (15, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-12T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (16, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-13T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (17, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-14T14:26:48.187' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (18, 10, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-17T16:20:37.247' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (19, 5, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-17T16:22:32.473' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (20, 4, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-17T16:22:34.130' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (21, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-17T16:22:45.680' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (22, 10, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:48.163' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (23, 15, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:50.287' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (24, 5, 1, 1, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:51.580' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (25, 4, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:52.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (26, 13, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:53.997' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (27, 12, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:55.297' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (28, 17, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:56.613' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (29, 3, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:59:51.480' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (30, 4, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:59:53.553' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (31, 5, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:59:55.937' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (32, 6, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:59:57.223' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (33, 7, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:59:58.643' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (34, 8, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:59:59.593' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (35, 9, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T15:00:00.640' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (36, 10, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T15:00:01.603' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (37, 11, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T15:00:02.877' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (38, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T15:00:05.553' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (39, 3, 0, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:24.000' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:57:51.930' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (40, 4, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:25.073' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (41, 5, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:26.220' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (42, 6, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:27.257' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (43, 7, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:28.347' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (44, 8, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:29.333' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (45, 9, 0, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:30.630' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:01:13.957' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (46, 10, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:31.657' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (47, 11, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:32.590' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (48, 12, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:33.707' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (49, 13, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:34.607' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (50, 14, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:35.467' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (51, 15, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T09:41:36.437' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (52, 9, 0, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:01:13.957' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:40:34.777' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (53, 9, 1, 1, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:40:34.780' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (54, 3, 1, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:57:51.930' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:57:55.690' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (55, 3, 0, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:57:55.690' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:59:28.067' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (56, 3, 1, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T10:59:28.067' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:00:29.133' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (57, 3, 0, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:00:29.133' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:00:32.087' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (58, 3, 1, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:00:32.087' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:00:35.023' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (59, 3, 0, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:00:35.023' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:03:26.890' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (60, 3, 1, NULL, NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:03:26.890' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:03:29.580' AS DateTime), 1)
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (61, 3, 0, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-21T11:03:29.580' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[StaffAttendance] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffDepartment] ON 

INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 3, 1, 2, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, 4, 1, 3, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 5, 1, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, 6, 2, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, 7, 2, 2, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, 8, 2, 3, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, 9, 3, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (8, 10, 3, 2, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (9, 11, 3, 3, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (10, 12, 1, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (11, 13, 3, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (12, 14, 2, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (13, 15, 1, 3, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (14, 16, 2, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (15, 17, 2, 3, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (16, 20, 2, 1, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDepartment] ([StaffDepartmentID], [StaffID], [DepartmentID], [StaffTypeID], [StartDate], [EndDate], [Description], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (17, 21, 2, 3, CAST(N'2021-08-01T00:00:00.000' AS DateTime), CAST(N'2023-08-01T00:00:00.000' AS DateTime), NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T15:46:01.660' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[StaffDepartment] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffDocument] ON 

INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 3, 1, N'Resumeja', N'/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 0, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T13:59:20.587' AS DateTime), 1)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, 16, 1, N'CV', N'/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 16, 2, N'Çertifikata', N'/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, 16, 5, N'Dëshmia e fondeve', N'/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, 10, 2, N'Certifikata e lindjes', N'/StaffDocuments/0bad5214-0522-4397-95ad-c1464a7cb756.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:49:45.653' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, 20, 2, N'Certifikata lindjes', N'/StaffDocuments/6e590c31-d01a-4fae-93d9-b83714454b2d.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T08:43:49.957' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, 21, 2, N'Certifikata e lindjes', N'/StaffDocuments/aea4c0ab-d1ed-44ca-84b4-8a6ca389eb66.docx', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T13:25:37.210' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (8, 21, 5, N'Deshmia e fondeve', N'/StaffDocuments/7efeb7cd-ea1e-416c-b38b-6c71d4425560.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T13:25:52.800' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (9, 21, 1, N'CV', N'/StaffDocuments/95bd49d6-aded-4afc-99a1-ad84aa6b8d85.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T13:26:24.620' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (10, 10, 2, N'Birth certificate', N'/StaffDocuments/4c54904c-77b7-4e73-ba98-eac1ee880963.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-22T10:23:26.803' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (11, 10, 2, N'Birth certificate', N'/StaffDocuments/ebbaadeb-5523-4cef-828c-0ca93f2da939.pdf', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-22T11:14:27.623' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (12, 10, 5, N'Deshmia fondeve', N'/StaffDocuments/0dcdefeb-7149-4a8b-8228-fdb0fe90dc89.pdf', NULL, 1, CAST(N'2022-09-22T00:00:00.000' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-22T11:30:04.717' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [ExpirationDate], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (13, 10, 5, N'Deshmia e fondeve', N'/StaffDocuments/0cb7b567-58a0-4512-8c86-7d6d77e28a75.docx', NULL, 1, NULL, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-22T11:30:33.050' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[StaffDocument] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffRegistrationStatus] ON 

INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 3, 5, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:47:43.207' AS DateTime), 1)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, 4, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 5, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, 6, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, 7, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, 8, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, 9, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (8, 10, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (9, 11, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (10, 12, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (11, 13, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (12, 14, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (13, 15, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (14, 16, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (15, 17, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-08-15T09:37:38.900' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1002, 3, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:47:43.207' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1005, 20, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-09T16:08:35.057' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1006, 21, 5, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-20T13:25:13.610' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[StaffRegistrationStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffType] ON 

INSERT [dbo].[StaffType] ([StaffTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Administrata', N'Administration', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:45:38.720' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:48:00.147' AS DateTime), 1)
INSERT [dbo].[StaffType] ([StaffTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, N'Inxhinier', N'Engineer', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T16:00:13.543' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffType] ([StaffTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, N'IT', N'IT', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-07-25T16:00:36.233' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[StaffType] OFF
GO
SET IDENTITY_INSERT [His].[AspNetUser] ON 

INSERT [His].[AspNetUser] ([AspNetUserID], [UserID], [UserName], [PersonalNumber], [FirstName], [LastName], [PhoneNumber], [Email], [NormalizedUserName], [NormalizedEmail], [PhoneNumberConfirmed], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [ProfileImage], [AllowNotification], [Language], [AppMode], [InsertedFrom], [InsertedDate]) VALUES (1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'admin', N'1230456789', N'May', N'Calamawy', N'38345996688', N'may@yahoo.com', N'ADMIN', N'MAY@YAHOO.COM', 0, 1, N'AQAAAAEAADqYAAAAEKiFaFyhfTVRgjD22iUYWtMehV2DiIq3qE/FO5qGJKYqD+xgUHGexWuoDNv/LzMNhw==', N'3PMJXNOQ2MX47ELWSRSNAABEDKXJ2O5U', N'5f3cd9b3-a65c-4513-b65d-fd7464859d1e', 0, CAST(N'2022-01-14T14:20:08.8529058+01:00' AS DateTimeOffset), 1, 0, N'/Uploads/Users/096deafc-2539-472a-a510-c275d7e156db.jpg', 0, 1, 2, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-01-06T16:34:20.557' AS DateTime))
SET IDENTITY_INSERT [His].[AspNetUser] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 22-Sep-22 3:31:58 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 22-Sep-22 3:31:58 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 22-Sep-22 3:31:58 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 22-Sep-22 3:31:58 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 22-Sep-22 3:31:58 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 22-Sep-22 3:31:58 PM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 22-Sep-22 3:31:58 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Core].[City]  WITH CHECK ADD  CONSTRAINT [FK_City_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[City] CHECK CONSTRAINT [FK_City_AspNetUsers_Inserted]
GO
ALTER TABLE [Core].[City]  WITH CHECK ADD  CONSTRAINT [FK_City_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[City] CHECK CONSTRAINT [FK_City_AspNetUsers_Updated]
GO
ALTER TABLE [Core].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Country_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[Country] CHECK CONSTRAINT [FK_Country_AspNetUsers_Inserted]
GO
ALTER TABLE [Core].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Country_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[Country] CHECK CONSTRAINT [FK_Country_AspNetUsers_Updated]
GO
ALTER TABLE [Core].[Log]  WITH CHECK ADD  CONSTRAINT [FK_Log_AspNetUsers] FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[Log] CHECK CONSTRAINT [FK_Log_AspNetUsers]
GO
ALTER TABLE [Core].[Menu]  WITH CHECK ADD  CONSTRAINT [FK_Menu_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[Menu] CHECK CONSTRAINT [FK_Menu_AspNetUsers_Inserted]
GO
ALTER TABLE [Core].[Menu]  WITH CHECK ADD  CONSTRAINT [FK_Menu_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[Menu] CHECK CONSTRAINT [FK_Menu_AspNetUsers_Updated]
GO
ALTER TABLE [Core].[Notification]  WITH CHECK ADD  CONSTRAINT [FK_Notification_AspNetUsers] FOREIGN KEY([Receiver])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[Notification] CHECK CONSTRAINT [FK_Notification_AspNetUsers]
GO
ALTER TABLE [Core].[Notification]  WITH CHECK ADD  CONSTRAINT [FK_Notification_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[Notification] CHECK CONSTRAINT [FK_Notification_AspNetUsers_Inserted]
GO
ALTER TABLE [Core].[RealRole]  WITH CHECK ADD  CONSTRAINT [FK_RealRole_AspNetRoles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [Core].[RealRole] CHECK CONSTRAINT [FK_RealRole_AspNetRoles]
GO
ALTER TABLE [Core].[RealRole]  WITH CHECK ADD  CONSTRAINT [FK_RealRole_AspNetUsers] FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[RealRole] CHECK CONSTRAINT [FK_RealRole_AspNetUsers]
GO
ALTER TABLE [Core].[RealRole]  WITH CHECK ADD  CONSTRAINT [FK_RealRole_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[RealRole] CHECK CONSTRAINT [FK_RealRole_AspNetUsers_Inserted]
GO
ALTER TABLE [Core].[RealRole]  WITH CHECK ADD  CONSTRAINT [FK_RealRole_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[RealRole] CHECK CONSTRAINT [FK_RealRole_AspNetUsers_Updated]
GO
ALTER TABLE [Core].[StatusType]  WITH CHECK ADD  CONSTRAINT [FK_StatusType_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[StatusType] CHECK CONSTRAINT [FK_StatusType_AspNetUsers_Inserted]
GO
ALTER TABLE [Core].[StatusType]  WITH CHECK ADD  CONSTRAINT [FK_StatusType_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[StatusType] CHECK CONSTRAINT [FK_StatusType_AspNetUsers_Updated]
GO
ALTER TABLE [Core].[SubMenu]  WITH CHECK ADD  CONSTRAINT [FK_SubMenu_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[SubMenu] CHECK CONSTRAINT [FK_SubMenu_AspNetUsers_Inserted]
GO
ALTER TABLE [Core].[SubMenu]  WITH CHECK ADD  CONSTRAINT [FK_SubMenu_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [Core].[SubMenu] CHECK CONSTRAINT [FK_SubMenu_AspNetUsers_Updated]
GO
ALTER TABLE [Core].[SubMenu]  WITH CHECK ADD  CONSTRAINT [FK_SubMenu_Menu] FOREIGN KEY([MenuID])
REFERENCES [Core].[Menu] ([MenuID])
GO
ALTER TABLE [Core].[SubMenu] CHECK CONSTRAINT [FK_SubMenu_Menu]
GO
ALTER TABLE [dbo].[AbsentType]  WITH CHECK ADD  CONSTRAINT [FK_AbsentType_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AbsentType] CHECK CONSTRAINT [FK_AbsentType_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[AbsentType]  WITH CHECK ADD  CONSTRAINT [FK_AbsentType_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AbsentType] CHECK CONSTRAINT [FK_AbsentType_AspNetUsers_Updated]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUsers]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUsers_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsers] CHECK CONSTRAINT [FK_AspNetUsers_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_Department_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_Department_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_Department_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_Department_AspNetUsers_Updated]
GO
ALTER TABLE [dbo].[DocumentType]  WITH CHECK ADD  CONSTRAINT [FK_DocumentType_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[DocumentType] CHECK CONSTRAINT [FK_DocumentType_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[DocumentType]  WITH CHECK ADD  CONSTRAINT [FK_DocumentType_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[DocumentType] CHECK CONSTRAINT [FK_DocumentType_AspNetUsers_Updated]
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
ALTER TABLE [dbo].[StaffAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffAttendance_Staff] FOREIGN KEY([StaffID])
REFERENCES [dbo].[Staff] ([StaffID])
GO
ALTER TABLE [dbo].[StaffAttendance] CHECK CONSTRAINT [FK_StaffAttendance_Staff]
GO
ALTER TABLE [dbo].[StaffAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartmentAttendance_AbsentType] FOREIGN KEY([AbsentTypeID])
REFERENCES [dbo].[AbsentType] ([AbsentTypeID])
GO
ALTER TABLE [dbo].[StaffAttendance] CHECK CONSTRAINT [FK_StaffDepartmentAttendance_AbsentType]
GO
ALTER TABLE [dbo].[StaffAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffAttendance] CHECK CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[StaffAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffAttendance] CHECK CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Updated]
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
ALTER TABLE [dbo].[StaffDocument]  WITH CHECK ADD  CONSTRAINT [FK_StaffDocument_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffDocument] CHECK CONSTRAINT [FK_StaffDocument_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[StaffDocument]  WITH CHECK ADD  CONSTRAINT [FK_StaffDocument_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffDocument] CHECK CONSTRAINT [FK_StaffDocument_AspNetUsers_Updated]
GO
ALTER TABLE [dbo].[StaffDocument]  WITH CHECK ADD  CONSTRAINT [FK_StaffDocument_DocumentType] FOREIGN KEY([DocumentTypeID])
REFERENCES [dbo].[DocumentType] ([DocumentTypeID])
GO
ALTER TABLE [dbo].[StaffDocument] CHECK CONSTRAINT [FK_StaffDocument_DocumentType]
GO
ALTER TABLE [dbo].[StaffDocument]  WITH CHECK ADD  CONSTRAINT [FK_StaffDocument_Staff] FOREIGN KEY([StaffID])
REFERENCES [dbo].[Staff] ([StaffID])
GO
ALTER TABLE [dbo].[StaffDocument] CHECK CONSTRAINT [FK_StaffDocument_Staff]
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
ALTER TABLE [dbo].[StaffType]  WITH CHECK ADD  CONSTRAINT [FK_StaffType_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffType] CHECK CONSTRAINT [FK_StaffType_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[StaffType]  WITH CHECK ADD  CONSTRAINT [FK_StaffType_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffType] CHECK CONSTRAINT [FK_StaffType_AspNetUsers_Updated]
GO
ALTER TABLE [His].[AppSettings]  WITH CHECK ADD  CONSTRAINT [FK_AppSettings_AspNetUsers] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [His].[AppSettings] CHECK CONSTRAINT [FK_AppSettings_AspNetUsers]
GO
/****** Object:  StoredProcedure [job].[MissingStaffAttendance]    Script Date: 22-Sep-22 3:31:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================
-- Author:			Arb Tahiri
-- Create date:		12/09/2022
-- Description:		Job to insert staff that did not attend work.
-- Execution Time:	Every day on 22.00.
-- ===============================================================
CREATE PROCEDURE [job].[MissingStaffAttendance]
AS
BEGIN
	DECLARE @tbl_Attendance TABLE ( StaffID INT )
	INSERT INTO @tbl_Attendance
	SELECT
		StaffID
	FROM StaffAttendance
	WHERE CAST(InsertedDate AS DATE) = CAST(GETDATE() AS DATE)

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
USE [master]
GO
ALTER DATABASE [AMS] SET  READ_WRITE 
GO
