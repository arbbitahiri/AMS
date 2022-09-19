USE [master]
GO
/****** Object:  Database [AMS]    Script Date: 19-Sep-22 4:42:36 PM ******/
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
USE [AMS]
GO
/****** Object:  User [ams]    Script Date: 19-Sep-22 4:42:36 PM ******/
CREATE USER [ams] FOR LOGIN [ams] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [ams]
GO
/****** Object:  Schema [Core]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE SCHEMA [Core]
GO
/****** Object:  Schema [His]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE SCHEMA [His]
GO
/****** Object:  Schema [job]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE SCHEMA [job]
GO
/****** Object:  UserDefinedFunction [dbo].[AttendanceConsecutiveDays]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
			StaffID,
			InsertedDate,
			GroupingSet = CAST(DATEADD(DAY, -ROW_NUMBER() OVER(PARTITION BY StaffID ORDER BY InsertedDate), InsertedDate) AS DATE)
		FROM StaffAttendance
	)

	INSERT INTO @tbl_StaffDays
	SELECT
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
	GROUP BY A.StaffID, GroupingSet
	ORDER BY A.StaffID, StartDate;

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[Logs]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[MenuList]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[MenuListAccess]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[StaffConsecutiveDays]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
			GroupingSet = CAST(DATEADD(DAY, -ROW_NUMBER() OVER(PARTITION BY StaffID ORDER BY InsertedDate), InsertedDate) AS DATE)
		FROM StaffAttendance
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
		WorkingSince = COUNT(NULLIF(A.StaffID, 0)),
		MAX((CASE WHEN SA.StaffAttendanceID IS NOT NULL THEN 1 ELSE 0 END))
	FROM Staff S
		LEFT JOIN AttendanceCTE A		ON A.StaffID = S.StaffID AND CAST(A.InsertedDate AS DATE) BETWEEN CAST(DATEADD(DAY, -1, GETDATE()) AS DATE) AND CAST(GETDATE() AS DATE)
		INNER JOIN StaffDepartment SD	ON S.StaffID = SD.StaffDepartmentID
		INNER JOIN Department D			ON SD.DepartmentID = D.DepartmentID
		INNER JOIN StaffType ST			ON SD.StaffTypeID = ST.StaffTypeID
		LEFT JOIN StaffAttendance SA	ON SA.StaffID = A.StaffID AND CAST(SA.InsertedDate AS DATE) = CAST(GETDATE() AS DATE)
	WHERE S.StaffID				= ISNULL(@StaffId, S.StaffID)
		AND SD.DepartmentID		= ISNULL(@DepartmentId, SD.DepartmentID)
		AND SD.StaffTypeID		= ISNULL(@StaffTypeId, SD.StaffTypeID)
		AND CAST(SD.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
	GROUP BY S.StaffID, A.GroupingSet
	ORDER BY S.StaffID;
	
	RETURN
END
GO
/****** Object:  Table [Core].[City]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[Country]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[Gender]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[Log]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[Menu]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[Notification]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[RealRole]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[StatusType]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [Core].[SubMenu]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AbsentType]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[Department]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[DocumentType]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[Staff]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[StaffAttendance]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[StaffDepartment]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[StaffDocument]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[StaffRegistrationStatus]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [dbo].[StaffType]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [His].[AppSettings]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  Table [His].[AspNetUser]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [PersonalNumber], [FirstName], [LastName], [PhoneNumber], [Email], [NormalizedUserName], [NormalizedEmail], [PhoneNumberConfirmed], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [ProfileImage], [AllowNotification], [Language], [AppMode], [InsertedFrom], [InsertedDate]) VALUES (N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'admin', N'1230456789', N'May', N'Calamawy', N'38345996688', N'may@yahoo.com', N'ADMIN', N'MAY@YAHOO.COM', 0, 1, N'AQAAAAEAADqYAAAAEKiFaFyhfTVRgjD22iUYWtMehV2DiIq3qE/FO5qGJKYqD+xgUHGexWuoDNv/LzMNhw==', N'3PMJXNOQ2MX47ELWSRSNAABEDKXJ2O5U', N'9dbc1251-3548-43cb-8bd6-046771fcc67a', 0, CAST(N'2022-01-14T14:20:08.8529058+01:00' AS DateTimeOffset), 1, 0, N'/Uploads/Users/0a753b27-d731-471a-b019-8147231f7925.jpg', 0, 2, 2, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-01-06T16:34:20.557' AS DateTime))
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
INSERT [dbo].[Staff] ([StaffID], [UserID], [PersonalNumber], [FirstName], [LastName], [BirthDate], [GenderID], [CityID], [CountryID], [Address], [PostalCode], [Email], [PhoneNumber], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (20, NULL, N'1242823636', N'Amigo', N'AAAA', CAST(N'2022-04-09' AS Date), 2, 1, 2, N'dikun', N'70000', N'231321@32132asxc.com', N'38345354354', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-09T16:08:27.450' AS DateTime), NULL, NULL, NULL)
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
INSERT [dbo].[StaffAttendance] ([StaffAttendanceID], [StaffID], [Absent], [AbsentTypeID], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (24, 5, 1, NULL, NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-18T10:33:51.580' AS DateTime), NULL, NULL, NULL)
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
SET IDENTITY_INSERT [dbo].[StaffDepartment] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffDocument] ON 

INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 3, 1, N'Resumeja', N'/Uploads/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 0, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T13:59:20.587' AS DateTime), 1)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (2, 16, 1, N'CV', N'/Uploads/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 16, 2, N'Çertifikata', N'/Uploads/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, 16, 5, N'Dëshmia e fondeve', N'/Uploads/StaffDocuments/20fc821d-aacd-44cc-aeb1-6d8d96237fe1.pdf', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-07T15:46:41.327' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[StaffDocument] ([StaffDocumentID], [StaffID], [DocumentTypeID], [Title], [Path], [Description], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, 10, 2, N'Certifikata e lindjes', N'/Uploads/StaffDocuments/0bad5214-0522-4397-95ad-c1464a7cb756.pdf', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-19T14:49:45.653' AS DateTime), NULL, NULL, NULL)
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
INSERT [dbo].[StaffRegistrationStatus] ([StaffRegistrationStatusID], [StaffID], [StatusTypeID], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1005, 20, 4, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-09-09T16:08:35.057' AS DateTime), NULL, NULL, NULL)
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
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 19-Sep-22 4:42:37 PM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
/****** Object:  StoredProcedure [job].[MissingStaffAttendance]    Script Date: 19-Sep-22 4:42:37 PM ******/
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
		0,
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
