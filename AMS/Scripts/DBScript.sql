USE [master]
GO
/****** Object:  Database [AMS]    Script Date: 10-Jun-22 3:52:58 PM ******/
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
/****** Object:  Schema [Core]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE SCHEMA [Core]
GO
/****** Object:  Schema [His]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE SCHEMA [His]
GO
/****** Object:  UserDefinedFunction [dbo].[Logs]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[MenuList]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[MenuListAccess]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[City]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[Country]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[Gender]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[Log]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
	[Description] [nvarchar](64) NULL,
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
/****** Object:  Table [Core].[Menu]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[Notification]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[RealRole]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[StatusType]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [Core].[SubMenu]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AbsentType]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[Department]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[DocumentType]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[Staff]    Script Date: 10-Jun-22 3:52:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[StaffID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](450) NOT NULL,
	[PersonalNumber] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](128) NOT NULL,
	[LastName] [nvarchar](128) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[GenderID] [int] NOT NULL,
	[CityID] [int] NOT NULL,
	[CountryID] [int] NOT NULL,
	[Address] [nvarchar](256) NULL,
	[PostalCode] [nvarchar](12) NULL,
	[InsertedFrom] [nvarchar](450) NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[UpdatedFrom] [nvarchar](450) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedNo] [int] NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[StaffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StaffDepartment]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[StaffDepartmentAttendance]    Script Date: 10-Jun-22 3:52:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StaffDepartmentAttendance](
	[StaffDepartmentAttendanceID] [int] IDENTITY(1,1) NOT NULL,
	[StaffDepartmentID] [int] NOT NULL,
	[Date] [date] NOT NULL,
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
	[StaffDepartmentAttendanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StaffDocument]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [dbo].[StaffType]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [His].[AppSettings]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
/****** Object:  Table [His].[AspNetUser]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
SET IDENTITY_INSERT [Core].[Log] ON 

INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (1, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T08:51:17.533' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (2, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T08:51:17.533' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (3, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T08:52:09.480' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (4, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T08:53:35.260' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (5, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JRavAX-JQwkmeJjRcgSI0RpapIM83UpucfDe52w11J__9l0Xmqav7pwm-_UxYfjH13lZ5xsH2SrjdJzaMWqy7qbhgsic23CDvmZtdi1oihgqcUCqBFyyZg5hiAPZP0ipI"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 1, N'{"ClassName":"Microsoft.Data.SqlClient.SqlException","Message":"Invalid column name ''UpdateDate''.\r\nInvalid column name ''UpdateFrom''.\r\nInvalid column name ''UpdateNo''.","Data":{"HelpLink.ProdName":"Microsoft SQL Server","HelpLink.ProdVer":"15.00.2080","HelpLink.EvtSrc":"MSSQLServer","HelpLink.EvtID":"207","HelpLink.BaseHelpUrl":"https://go.microsoft.com/fwlink","HelpLink.LinkId":"20476","SqlError 1":"Microsoft.Data.SqlClient.SqlError: Invalid column name ''UpdateDate''.","SqlError 2":"Microsoft.Data.SqlClient.SqlError: Invalid column name ''UpdateFrom''.","SqlError 3":"Microsoft.Data.SqlClient.SqlError: Invalid column name ''UpdateNo''."},"InnerException":null,"HelpURL":null,"StackTraceString":"   at Microsoft.Data.SqlClient.SqlCommand.<>c.<ExecuteDbDataReaderAsync>b__188_0(Task`1 result)\r\n   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()\r\n   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)\r\n--- End of stack trace from previous location ---\r\n   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Query.Internal.SingleQueryingEnumerable`1.AsyncEnumerator.InitializeReaderAsync(AsyncEnumerator enumerator, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.SqlServer.Storage.Internal.SqlServerExecutionStrategy.ExecuteAsync[TState,TResult](TState state, Func`4 operation, Func`4 verifySucceeded, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Query.Internal.SingleQueryingEnumerable`1.AsyncEnumerator.MoveNextAsync()\r\n   at Microsoft.EntityFrameworkCore.Query.ShapedQueryCompilingExpressionVisitor.SingleOrDefaultAsync[TSource](IAsyncEnumerable`1 asyncEnumerable, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Query.ShapedQueryCompilingExpressionVisitor.SingleOrDefaultAsync[TSource](IAsyncEnumerable`1 asyncEnumerable, CancellationToken cancellationToken)\r\n   at Microsoft.AspNetCore.Identity.UserManager`1.FindByNameAsync(String userName)\r\n   at Microsoft.AspNetCore.Identity.SignInManager`1.PasswordSignInAsync(String userName, String password, Boolean isPersistent, Boolean lockoutOnFailure)\r\n   at AMS.Areas.Identity.Pages.Account.LoginModel.OnPostAsync() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Areas\\Identity\\Pages\\Account\\Login.cshtml.cs:line 92\r\n   at Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.ExecutorFactory.GenericTaskHandlerMethod.Convert[T](Object taskAsObject)\r\n   at Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.ExecutorFactory.GenericTaskHandlerMethod.Execute(Object receiver, Object[] arguments)\r\n   at Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageActionInvoker.InvokeHandlerMethodAsync()\r\n   at Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageActionInvoker.InvokeNextPageFilterAsync()","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146232060,"Source":"Core Microsoft SqlClient Data Provider","WatsonBuckets":null,"Errors":null,"ClientConnectionId":"f17b0840-baad-4842-8758-be6ecfc98c31"}', CAST(N'2022-06-10T08:54:36.857' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (6, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T09:15:32.437' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (7, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02Kan1_VA16jtDCjeY1CecAYzapT6NcJA_fXsURjoC5M4weZCg9-BPGFEclWG9qQ8EH8TJY7x7fsoboa5lH2f5GnwIqZR0kfw7430pfb9T1tSWnKqBHgEBmiLMhoRmMwxpw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-10T09:15:48.010' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (8, NULL, N'127.0.0.1', N'Identity', N'/Account/AccessDenied', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/AccessDenied?ReturnUrl=%2FHome%2FIndex', NULL, 0, NULL, CAST(N'2022-06-10T09:15:49.353' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (9, NULL, N'127.0.0.1', N'Identity', N'/Account/AccessDenied', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/AccessDenied?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T09:15:58.870' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (10, NULL, N'127.0.0.1', N'Identity', N'/Account/AccessDenied', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/AccessDenied?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T09:22:37.650' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (11, NULL, N'127.0.0.1', N'Identity', N'/Account/AccessDenied', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/AccessDenied?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T09:23:28.920' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (12, NULL, N'127.0.0.1', N'Identity', N'/Account/AccessDenied', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/AccessDenied?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T09:23:32.737' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (13, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-06-10T09:23:32.813' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (14, NULL, N'127.0.0.1', N'Identity', N'/Account/AccessDenied', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/AccessDenied?ReturnUrl=%2FHome%2FIndex', NULL, 0, NULL, CAST(N'2022-06-10T09:23:41.480' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (15, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-10T09:23:41.493' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (16, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T09:26:28.383' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (17, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KdEsUqTPETdVL2_L-a3HmOg1v03sQs4KxXhMBd2a-vmHJO5PKL3xASiGILM78Kow1Q4q-gD6pt-W5h9JhSIDVxifAuQyuAhXrK9yQqHnSeyecuw_wliy4bP0z2cbgDACOdgfs3wlTfttorKxxyIuqludJ9z0OXgeU-AyuGzSGqzw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-10T09:28:21.127' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (18, NULL, N'127.0.0.1', N'Identity', N'/Account/Message', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Message?handler=Filter', N'[{"Key":"Title","Value":["Kujdes"]},{"Key":"Status","Value":["3"]},{"Key":"Description","Value":["Email/emri përdoruesit ose fjalëaklimi janë të pasakta!"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KdEsUqTPETdVL2_L-a3HmOg1v03sQs4KxXhMBd2a-vmHJO5PKL3xASiGILM78Kow1Q4q-gD6pt-W5h9JhSIDVxifAuQyuAhXrK9yQqHnSeyecuw_wliy4bP0z2cbgDACOdgfs3wlTfttorKxxyIuqludJ9z0OXgeU-AyuGzSGqzw"]}]', 0, NULL, CAST(N'2022-06-10T09:28:21.627' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (19, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KdEsUqTPETdVL2_L-a3HmOg1v03sQs4KxXhMBd2a-vmHJO5PKL3xASiGILM78Kow1Q4q-gD6pt-W5h9JhSIDVxifAuQyuAhXrK9yQqHnSeyecuw_wliy4bP0z2cbgDACOdgfs3wlTfttorKxxyIuqludJ9z0OXgeU-AyuGzSGqzw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-10T09:31:42.057' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (20, NULL, N'127.0.0.1', N'Identity', N'/Account/Message', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Message?handler=Filter', N'[{"Key":"Title","Value":["Kujdes"]},{"Key":"Status","Value":["3"]},{"Key":"Description","Value":["Email/emri përdoruesit ose fjalëaklimi janë të pasakta!"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KdEsUqTPETdVL2_L-a3HmOg1v03sQs4KxXhMBd2a-vmHJO5PKL3xASiGILM78Kow1Q4q-gD6pt-W5h9JhSIDVxifAuQyuAhXrK9yQqHnSeyecuw_wliy4bP0z2cbgDACOdgfs3wlTfttorKxxyIuqludJ9z0OXgeU-AyuGzSGqzw"]}]', 0, NULL, CAST(N'2022-06-10T09:31:42.130' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (21, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-10T09:31:43.870' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (22, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KoRp-UbT9JbTSAHTft-1j5pr-kpfO07y_OWpzIAghI5nFL1rT2XJI9vl3Gg1Uge-5mvmOnSFsdrOTklryfLd-dRuC9EW_nqzGW0mrtiSDihZ5xr0iJ0m2h0mJhAajWOA9gvboQcm6IRsLRapIH9JFswREzk78nZJkg8Zs5QWRgTA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-10T09:31:52.690' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (23, NULL, N'127.0.0.1', N'Identity', N'/Account/Message', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Message?handler=Filter', N'[{"Key":"Title","Value":["Kujdes"]},{"Key":"Status","Value":["3"]},{"Key":"Description","Value":["Email/emri përdoruesit ose fjalëaklimi janë të pasakta!"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KoRp-UbT9JbTSAHTft-1j5pr-kpfO07y_OWpzIAghI5nFL1rT2XJI9vl3Gg1Uge-5mvmOnSFsdrOTklryfLd-dRuC9EW_nqzGW0mrtiSDihZ5xr0iJ0m2h0mJhAajWOA9gvboQcm6IRsLRapIH9JFswREzk78nZJkg8Zs5QWRgTA"]}]', 0, NULL, CAST(N'2022-06-10T09:31:52.740' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (24, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KoRp-UbT9JbTSAHTft-1j5pr-kpfO07y_OWpzIAghI5nFL1rT2XJI9vl3Gg1Uge-5mvmOnSFsdrOTklryfLd-dRuC9EW_nqzGW0mrtiSDihZ5xr0iJ0m2h0mJhAajWOA9gvboQcm6IRsLRapIH9JFswREzk78nZJkg8Zs5QWRgTA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-10T09:31:54.697' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (25, NULL, N'127.0.0.1', N'Identity', N'/Account/Message', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Message?handler=Filter', N'[{"Key":"Title","Value":["Kujdes"]},{"Key":"Status","Value":["3"]},{"Key":"Description","Value":["Email/emri përdoruesit ose fjalëaklimi janë të pasakta!"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KoRp-UbT9JbTSAHTft-1j5pr-kpfO07y_OWpzIAghI5nFL1rT2XJI9vl3Gg1Uge-5mvmOnSFsdrOTklryfLd-dRuC9EW_nqzGW0mrtiSDihZ5xr0iJ0m2h0mJhAajWOA9gvboQcm6IRsLRapIH9JFswREzk78nZJkg8Zs5QWRgTA"]}]', 0, NULL, CAST(N'2022-06-10T09:31:54.770' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (26, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KoRp-UbT9JbTSAHTft-1j5pr-kpfO07y_OWpzIAghI5nFL1rT2XJI9vl3Gg1Uge-5mvmOnSFsdrOTklryfLd-dRuC9EW_nqzGW0mrtiSDihZ5xr0iJ0m2h0mJhAajWOA9gvboQcm6IRsLRapIH9JFswREzk78nZJkg8Zs5QWRgTA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-10T09:32:05.110' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (27, NULL, N'127.0.0.1', N'Identity', N'/Account/AccessDenied', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/AccessDenied?ReturnUrl=%2FHome%2FIndex', NULL, 0, NULL, CAST(N'2022-06-10T09:32:05.313' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (28, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-10T09:32:05.327' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (29, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-06-10T09:33:40.130' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (30, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', N'Arb Tahiri', N'Home page for administrator.', N'GET', N'https://localhost:5001/Home/Administrator', NULL, 0, NULL, CAST(N'2022-06-10T09:33:40.877' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (31, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Administrator', NULL, NULL, N'GET', N'https://localhost:5001/Home/Administrator', NULL, 1, N'{"ClassName":"System.InvalidOperationException","Message":"The view ''Administrator'' was not found. The following locations were searched:\r\n/Views/Home/Administrator.cshtml\r\n/Views/Shared/Administrator.cshtml\r\n/Pages/Shared/Administrator.cshtml","Data":null,"InnerException":null,"HelpURL":null,"StackTraceString":"   at Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult.EnsureSuccessful(IEnumerable`1 originalLocations)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewResultExecutor.ExecuteAsync(ActionContext context, ViewResult result)\r\n   at Microsoft.AspNetCore.Mvc.ViewResult.ExecuteResultAsync(ActionContext context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResultFilterAsync>g__Awaited|30_0[TFilter,TFilterAsync](ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResultExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.ResultNext[TFilter,TFilterAsync](State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.InvokeResultFilters()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 172\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.ResponseCompression.ResponseCompressionMiddleware.InvokeCore(HttpContext context)\r\n   at Microsoft.AspNetCore.ResponseCaching.ResponseCachingMiddleware.Invoke(HttpContext httpContext)\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146233079,"Source":"Microsoft.AspNetCore.Mvc.ViewFeatures","WatsonBuckets":null}', CAST(N'2022-06-10T09:33:41.350' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (32, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Error', N'Arb Tahiri', N'Error view', N'GET', N'https://localhost:5001/Home/Error', NULL, 0, NULL, CAST(N'2022-06-10T09:33:41.427' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (33, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Error', N'Arb Tahiri', N'Error view', N'GET', N'https://localhost:5001/Home/Error', NULL, 0, NULL, CAST(N'2022-06-10T09:34:29.697' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (34, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-06-10T09:34:36.657' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (35, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', NULL, NULL, N'GET', N'https://localhost:5001/', NULL, 1, N'{"ClassName":"System.InvalidOperationException","Message":"Cannot create a DbSet for ''MenuList'' because this type is not included in the model for the context.","Data":null,"InnerException":null,"HelpURL":null,"StackTraceString":"   at Microsoft.EntityFrameworkCore.Internal.InternalDbSet`1.get_EntityType()\r\n   at Microsoft.EntityFrameworkCore.Internal.InternalDbSet`1.CheckState()\r\n   at Microsoft.EntityFrameworkCore.Internal.InternalDbSet`1.get_EntityQueryable()\r\n   at Microsoft.EntityFrameworkCore.Internal.InternalDbSet`1.System.Linq.IQueryable.get_Provider()\r\n   at Microsoft.EntityFrameworkCore.RelationalQueryableExtensions.FromSqlInterpolated[TEntity](DbSet`1 source, FormattableString sql)\r\n   at AMS.Repositories.FunctionRepository.MenuList(String role, LanguageEnum lang) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Repositories\\FunctionRepository.cs:line 18\r\n   at AMS.ViewComponents.MenuViewComponent.InvokeAsync() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\ViewComponents\\MenuViewComponent.cs:line 29\r\n   at Microsoft.AspNetCore.Mvc.ViewComponents.DefaultViewComponentInvoker.InvokeAsyncCore(ObjectMethodExecutor executor, Object component, ViewComponentContext context)\r\n   at Microsoft.AspNetCore.Mvc.ViewComponents.DefaultViewComponentInvoker.InvokeAsync(ViewComponentContext context)\r\n   at Microsoft.AspNetCore.Mvc.ViewComponents.DefaultViewComponentInvoker.InvokeAsync(ViewComponentContext context)\r\n   at Microsoft.AspNetCore.Mvc.ViewComponents.DefaultViewComponentHelper.InvokeCoreAsync(ViewComponentDescriptor descriptor, Object arguments)\r\n   at AspNetCore._Views_Shared__Layout.<>c__DisplayClass74_0.<<ExecuteAsync>b__1>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Views\\Shared\\_Layout.cshtml:line 97\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext.SetOutputContentAsync()\r\n   at AspNetCore._Views_Shared__Layout.ExecuteAsync() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Views\\Shared\\_Layout.cshtml:line 51\r\n   at Microsoft.AspNetCore.Mvc.Razor.RazorView.RenderPageCoreAsync(IRazorPage page, ViewContext context)\r\n   at Microsoft.AspNetCore.Mvc.Razor.RazorView.RenderPageAsync(IRazorPage page, ViewContext context, Boolean invokeViewStarts)\r\n   at Microsoft.AspNetCore.Mvc.Razor.RazorView.RenderLayoutAsync(ViewContext context, ViewBufferTextWriter bodyWriter)\r\n   at Microsoft.AspNetCore.Mvc.Razor.RazorView.RenderAsync(ViewContext context)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor.ExecuteAsync(ViewContext viewContext, String contentType, Nullable`1 statusCode)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor.ExecuteAsync(ViewContext viewContext, String contentType, Nullable`1 statusCode)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor.ExecuteAsync(ActionContext actionContext, IView view, ViewDataDictionary viewData, ITempDataDictionary tempData, String contentType, Nullable`1 statusCode)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewResultExecutor.ExecuteAsync(ActionContext context, ViewResult result)\r\n   at Microsoft.AspNetCore.Mvc.ViewResult.ExecuteResultAsync(ActionContext context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResultFilterAsync>g__Awaited|30_0[TFilter,TFilterAsync](ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResultExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.ResultNext[TFilter,TFilterAsync](State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeResultFilters>g__Awaited|28_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 172\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.ResponseCompression.ResponseCompressionMiddleware.InvokeCore(HttpContext context)\r\n   at Microsoft.AspNetCore.ResponseCaching.ResponseCachingMiddleware.Invoke(HttpContext httpContext)\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146233079,"Source":"Microsoft.EntityFrameworkCore","WatsonBuckets":null}', CAST(N'2022-06-10T09:34:39.413' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (36, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Error', N'Arb Tahiri', N'Error view', N'GET', N'https://localhost:5001/Home/Error', NULL, 0, NULL, CAST(N'2022-06-10T09:34:39.463' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (37, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-06-10T09:36:52.013' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (38, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-06-10T09:37:53.623' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (39, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'ChangeMode', N'Arb Tahiri', N'Action to change actual role.', N'POST', N'https://localhost:5001/Home/ChangeMode', N'[{"Key":"mode","Value":["false"]}]', 0, NULL, CAST(N'2022-06-10T09:37:57.190' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (40, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-06-10T09:37:59.607' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (41, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorizations?area=Authorization', NULL, 0, NULL, CAST(N'2022-06-10T09:38:35.503' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (42, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', NULL, NULL, N'GET', N'https://localhost:5001/Authorizations?area=Authorization', NULL, 1, N'{"ClassName":"System.InvalidOperationException","Message":"The view ''Index'' was not found. The following locations were searched:\r\n/Views/Authorizations/Index.cshtml\r\n/Views/Shared/Index.cshtml\r\n/Pages/Shared/Index.cshtml","Data":null,"InnerException":null,"HelpURL":null,"StackTraceString":"   at Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult.EnsureSuccessful(IEnumerable`1 originalLocations)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewResultExecutor.ExecuteAsync(ActionContext context, ViewResult result)\r\n   at Microsoft.AspNetCore.Mvc.ViewResult.ExecuteResultAsync(ActionContext context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResultFilterAsync>g__Awaited|30_0[TFilter,TFilterAsync](ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResultExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.ResultNext[TFilter,TFilterAsync](State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.InvokeResultFilters()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 172\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.ResponseCompression.ResponseCompressionMiddleware.InvokeCore(HttpContext context)\r\n   at Microsoft.AspNetCore.ResponseCaching.ResponseCachingMiddleware.Invoke(HttpContext httpContext)\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146233079,"Source":"Microsoft.AspNetCore.Mvc.ViewFeatures","WatsonBuckets":null}', CAST(N'2022-06-10T09:38:35.813' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (43, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Error', N'Arb Tahiri', N'Error view', N'GET', N'https://localhost:5001/Home/Error', NULL, 0, NULL, CAST(N'2022-06-10T09:38:35.843' AS DateTime))
SET IDENTITY_INSERT [Core].[Log] OFF
GO
SET IDENTITY_INSERT [Core].[Menu] ON 

INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Ballina', N'Home', 0, N'fas fa-home', N'1:m', N'1', NULL, N'Home', N'Index', 1, N'Administrator', N'Index, Administrator', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:51:58.333' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, N'Konfigurimet', N'Configurations', 1, N'fas fa-cog', N'2:m', N'2', N'Configuration', N'Configuration', N'Index', 4, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, N'Administrimi', N'Administration', 1, N'fas fa-users-cog', N'3:m', N'3', N'Administration', N'Administration', N'Index', 5, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, N'Profili', N'Profile', 0, N'fas fa-address-card', N'4:m', N'4', NULL, N'StaffProfile', N'Index', 2, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, N'Autorizimet', N'Authorizations', 1, N'fas fa-key', N'5:m', N'5', N'Authorization', N'Authorization', N'Index', 3, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, N'Gjurmët', N'Traces', 1, N'fas fa-fingerprint', N'6:m', N'6', N'Application', N'Application', N'Index', 6, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[Menu] OFF
GO
SET IDENTITY_INSERT [Core].[RealRole] ON 

INSERT [Core].[RealRole] ([RealRoleID], [UserID], [RoleID], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:37:51.103' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[RealRole] OFF
GO
SET IDENTITY_INSERT [Core].[SubMenu] ON 

INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 6, N'Autorizimet', N'Authorizations', N'fas fa-shield-alt', N'51:m', N'51', N'Authorization', N'Authorizations', N'Index', 1, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-10T08:18:03.277' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 6, N'Menytë', N'Menus', N'fas fa-bars', N'52:m', N'52', N'Authorization', N'Menu', N'Index', 2, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-10T08:18:03.277' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [Core].[SubMenu] OFF
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'00000000000000_CreateIdentitySchema', N'6.0.5')
GO
SET IDENTITY_INSERT [dbo].[AspNetRoleClaims] ON 

INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (1, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'1', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (2, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'5', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (3, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'51', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (4, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'52', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (5, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'53', N'r')
SET IDENTITY_INSERT [dbo].[AspNetRoleClaims] OFF
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NameSQ], [NameEN], [Description], [NormalizedName], [ConcurrencyStamp]) VALUES (N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'Administrator', N'Administrator', N'Administrator', N'Administrator', N'ADMINISTRATOR', N'2e7f6db8-d1aa-4621-bffe-8799b87af361')
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0')
GO
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [PersonalNumber], [FirstName], [LastName], [PhoneNumber], [Email], [NormalizedUserName], [NormalizedEmail], [PhoneNumberConfirmed], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [ProfileImage], [AllowNotification], [Language], [AppMode], [InsertedFrom], [InsertedDate]) VALUES (N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'darthvader', N'0123456789', N'Darth', N'Vader', N'38345996688', N'darth@vader.com', N'DARTHVADER', N'DARTH@VADER.COM', 0, 1, N'AQAAAAEAADqYAAAAEKiFaFyhfTVRgjD22iUYWtMehV2DiIq3qE/FO5qGJKYqD+xgUHGexWuoDNv/LzMNhw==', N'3PMJXNOQ2MX47ELWSRSNAABEDKXJ2O5U', N'fb8b33f7-e053-4139-8f3a-847ee2e32cc8', 0, CAST(N'2022-01-14T14:20:08.8529058+01:00' AS DateTimeOffset), 1, 0, N'/Uploads/Users/096deafc-2539-472a-a510-c275d7e156db.jpg', 0, 1, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-01-06T16:34:20.557' AS DateTime))
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 10-Jun-22 3:52:59 PM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 10-Jun-22 3:52:59 PM ******/
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
ALTER TABLE [dbo].[StaffDepartmentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartmentAttendance_AbsentType] FOREIGN KEY([AbsentTypeID])
REFERENCES [dbo].[AbsentType] ([AbsentTypeID])
GO
ALTER TABLE [dbo].[StaffDepartmentAttendance] CHECK CONSTRAINT [FK_StaffDepartmentAttendance_AbsentType]
GO
ALTER TABLE [dbo].[StaffDepartmentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Inserted] FOREIGN KEY([InsertedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffDepartmentAttendance] CHECK CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Inserted]
GO
ALTER TABLE [dbo].[StaffDepartmentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Updated] FOREIGN KEY([UpdatedFrom])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[StaffDepartmentAttendance] CHECK CONSTRAINT [FK_StaffDepartmentAttendance_AspNetUsers_Updated]
GO
ALTER TABLE [dbo].[StaffDepartmentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartmentAttendance_StaffDepartment] FOREIGN KEY([StaffDepartmentID])
REFERENCES [dbo].[StaffDepartment] ([StaffDepartmentID])
GO
ALTER TABLE [dbo].[StaffDepartmentAttendance] CHECK CONSTRAINT [FK_StaffDepartmentAttendance_StaffDepartment]
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
USE [master]
GO
ALTER DATABASE [AMS] SET  READ_WRITE 
GO
