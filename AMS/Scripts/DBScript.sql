USE [master]
GO
/****** Object:  Database [AMS]    Script Date: 28-Jun-22 3:48:36 PM ******/
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
/****** Object:  Schema [Core]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE SCHEMA [Core]
GO
/****** Object:  Schema [His]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE SCHEMA [His]
GO
/****** Object:  UserDefinedFunction [dbo].[Logs]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[MenuList]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[MenuListAccess]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[City]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[Country]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[Gender]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[Log]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[Menu]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[Notification]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[RealRole]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[StatusType]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [Core].[SubMenu]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AbsentType]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[Department]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[DocumentType]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[Staff]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[StaffDepartment]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[StaffDepartmentAttendance]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[StaffDocument]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[StaffRegistrationStatus]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [dbo].[StaffType]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [His].[AppSettings]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
/****** Object:  Table [His].[AspNetUser]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (44, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-21T13:33:20.943' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (45, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LVicTjoGKWC0pB_eGv0ZvQTV7DvS76wNJsxx2AUEEFP3xtc3MNUX7ZkUR7HKj-HCdLgAF4giaaZwyAJ_jlMGN1abzZf87U-9vqHGkWBG9-nZYs8ZaimaSWzHda6Z8cHpk"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-21T13:33:39.097' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (46, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:33:40.943' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (47, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorizations?area=Authorization', NULL, 0, NULL, CAST(N'2022-06-21T13:33:52.083' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (48, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', NULL, NULL, N'GET', N'https://localhost:5001/Authorizations?area=Authorization', NULL, 1, N'{"ClassName":"System.InvalidOperationException","Message":"The view ''Index'' was not found. The following locations were searched:\r\n/Views/Authorizations/Index.cshtml\r\n/Views/Shared/Index.cshtml\r\n/Pages/Shared/Index.cshtml","Data":null,"InnerException":null,"HelpURL":null,"StackTraceString":"   at Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult.EnsureSuccessful(IEnumerable`1 originalLocations)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewResultExecutor.ExecuteAsync(ActionContext context, ViewResult result)\r\n   at Microsoft.AspNetCore.Mvc.ViewResult.ExecuteResultAsync(ActionContext context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResultFilterAsync>g__Awaited|30_0[TFilter,TFilterAsync](ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResultExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.ResultNext[TFilter,TFilterAsync](State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.InvokeResultFilters()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 172\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.ResponseCompression.ResponseCompressionMiddleware.InvokeCore(HttpContext context)\r\n   at Microsoft.AspNetCore.ResponseCaching.ResponseCachingMiddleware.Invoke(HttpContext httpContext)\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146233079,"Source":"Microsoft.AspNetCore.Mvc.ViewFeatures","WatsonBuckets":null}', CAST(N'2022-06-21T13:33:52.550' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (49, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Error', N'Arb Tahiri', N'Error view', N'GET', N'https://localhost:5001/Home/Error', NULL, 0, NULL, CAST(N'2022-06-21T13:33:52.593' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (50, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:33:55.210' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (51, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:38:18.923' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (52, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:38:55.857' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (53, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:39:10.853' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (54, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:39:14.340' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (55, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:40:05.293' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (56, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:40:07.353' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (57, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:40:59.513' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (58, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:41:13.150' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (59, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Search', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/Search', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I3iMg5I0SzKB8J7-tQyDyJvNe3ZR3KTOBTGtOug-wgfrG9qKJN_w2hRoayE_1D_50UHwsRSPCw0J8Jon462iVgjitIoymSjqggMjm-JBi4nVLleJp7E-GnUCEwFg-QpYiYJ7LWwZYURjBPDsukDVWJxYXq8k2lnUCgSSV-4r1lsg"]}]', 0, NULL, CAST(N'2022-06-21T13:41:17.060' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (60, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:41:29.273' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (61, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:44:21.137' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (62, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:44:24.157' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (63, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:45:00.777' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (64, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:45:02.740' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (65, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Search', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/Search', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KbGkQGTKsg40WIDcnxLA3GqDWR7KMSki-wfEd-peGUmgAaYMy0R7DgUigVHEHF_pL-Fn_Dpz3MmJKnmI_uSKq1PdDIcouUFfwzVkgO4YDjOZjdfSgX2AxI8r6UhNB5_V5N_WVuauewW6uVwNJTNHDpZ0_QKX_HOUHFUhfEKnCTqA"]}]', 0, NULL, CAST(N'2022-06-21T13:45:03.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (66, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-21T13:45:05.637' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (67, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Search', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/Search', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KbGkQGTKsg40WIDcnxLA3GqDWR7KMSki-wfEd-peGUmgAaYMy0R7DgUigVHEHF_pL-Fn_Dpz3MmJKnmI_uSKq1PdDIcouUFfwzVkgO4YDjOZjdfSgX2AxI8r6UhNB5_V5N_WVuauewW6uVwNJTNHDpZ0_QKX_HOUHFUhfEKnCTqA"]}]', 0, NULL, CAST(N'2022-06-21T13:45:06.470' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (68, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-21T13:45:53.927' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (69, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Search', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/Search', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02Ks6hz8SwUBHTkd6an17nfDYCzGrkIt-Tkpm4ouFjbfB9jmI0AAWRJKrtCOp-ctteJI2urmhXZQGNxQu8-XFBgVwhTAlxp0Fz9fPysz19LBUdNkKAbHvoe6MOro4TrRt9nRw_Iz0QHfbj4sYwVQzu9ZF_SpVzaBjm_hfFmPGuSSBA"]}]', 0, NULL, CAST(N'2022-06-21T13:45:56.123' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (70, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2F', NULL, 0, NULL, CAST(N'2022-06-28T09:36:07.593' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (71, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KQIdFwOdyUak6XPr75E4PJaLdexC1ywKWHaUJVzLSBNxFGOKqhCXSHKMb58F8ULCxukoY7QBlKbBgUvkhiVPhLcSJXkrLcXtZjKWzekiL1DezP4rqY10lLKjRaKlVv4xM"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T09:39:18.250' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (72, NULL, N'127.0.0.1', N'Identity', N'/Account/Message', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Message?handler=Filter', N'[{"Key":"Title","Value":["Kujdes"]},{"Key":"Status","Value":["3"]},{"Key":"Description","Value":["Email/emri përdoruesit ose fjalëaklimi janë të pasakta!"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KQIdFwOdyUak6XPr75E4PJaLdexC1ywKWHaUJVzLSBNxFGOKqhCXSHKMb58F8ULCxukoY7QBlKbBgUvkhiVPhLcSJXkrLcXtZjKWzekiL1DezP4rqY10lLKjRaKlVv4xM"]}]', 0, NULL, CAST(N'2022-06-28T09:39:20.030' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (73, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'POST', N'https://localhost:5001/Identity/Account/Login?returnUrl=%2F', N'[{"Key":"Input.returnUrl","Value":["/"]},{"Key":"Input.Email","Value":["darthvader"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KQIdFwOdyUak6XPr75E4PJaLdexC1ywKWHaUJVzLSBNxFGOKqhCXSHKMb58F8ULCxukoY7QBlKbBgUvkhiVPhLcSJXkrLcXtZjKWzekiL1DezP4rqY10lLKjRaKlVv4xM"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T09:39:39.483' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (74, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-28T09:39:40.817' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (75, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T09:39:55.437' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (76, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T09:40:00.190' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (77, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Search', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/Search', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:02.167' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (78, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-28T09:40:06.993' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (79, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["52:r"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:13.997' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (80, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["52:c"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:16.823' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (81, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["52:e"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:19.433' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (82, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["52:d"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:21.880' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (83, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["53:c"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:24.367' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (84, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["53:e"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:26.897' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (85, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["53:d"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KzZtlUaqKsD01GX_hDiXPm98f0vcYwL1FtO4tABi-B12wfL7rfU3lUBiGOOtP7l38zaM-ZTytRVI7SFswh3hbKrx0Mli_fjyJfuuMbOVSg8H9EiZ4HhgEcQ_WYHLE2jbZk4XmT9NsbLx0lJuSAAm5vxza2CSswDqUUbJuAdCImlQ"]}]', 0, NULL, CAST(N'2022-06-28T09:40:29.367' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (86, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T09:40:32.577' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (87, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-28T09:40:34.270' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (88, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T09:40:38.697' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (89, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T09:40:40.583' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (90, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T09:40:41.040' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (91, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FAuthorization%2FMenu%2FIndex', NULL, 0, NULL, CAST(N'2022-06-28T09:40:48.637' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (92, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T09:43:18.567' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (93, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T09:43:28.090' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (94, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Create', N'Arb Tahiri', N'Form to create a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Create', NULL, 0, NULL, CAST(N'2022-06-28T09:43:30.903' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (95, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:18:00.177' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (96, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:18:09.933' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (97, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Create', N'Arb Tahiri', N'Form to create a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Create', NULL, 0, NULL, CAST(N'2022-06-28T10:18:35.147' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (98, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Create', NULL, NULL, N'GET', N'https://localhost:5001/Authorization/Menu/_Create', NULL, 1, N'{"ClassName":"System.InvalidOperationException","Message":"Cannot retrieve property ''Name'' because localization failed.  Type ''AMS.Resources.Resource'' is not public or does not contain a public static string property with the name ''NameSq''.","Data":null,"InnerException":null,"HelpURL":null,"StackTraceString":"   at System.ComponentModel.DataAnnotations.LocalizableString.<>c__DisplayClass12_1.<GetLocalizableValue>b__2()\r\n   at System.ComponentModel.DataAnnotations.LocalizableString.GetLocalizableValue()\r\n   at System.ComponentModel.DataAnnotations.DisplayAttribute.GetName()\r\n   at Microsoft.AspNetCore.Mvc.DataAnnotations.DataAnnotationsMetadataProvider.CreateDisplayMetadata(DisplayMetadataProviderContext context)\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultCompositeMetadataDetailsProvider.CreateDisplayMetadata(DisplayMetadataProviderContext context)\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadata.get_DisplayMetadata()\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadata.get_Order()\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadata.<>c.<get_Properties>b__79_0(ModelMetadata p)\r\n   at System.Linq.EnumerableSorter`2.ComputeKeys(TElement[] elements, Int32 count)\r\n   at System.Linq.EnumerableSorter`1.ComputeMap(TElement[] elements, Int32 count)\r\n   at System.Linq.EnumerableSorter`1.Sort(TElement[] elements, Int32 count)\r\n   at System.Linq.OrderedEnumerable`1.ToList()\r\n   at System.Linq.Enumerable.ToList[TSource](IEnumerable`1 source)\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.ModelPropertyCollection..ctor(IEnumerable`1 properties)\r\n   at Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadata.get_Properties()\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ExpressionMetadataProvider.FromLambdaExpression[TModel,TResult](Expression`1 expression, ViewDataDictionary`1 viewData, IModelMetadataProvider metadataProvider)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpressionProvider.CreateModelExpression[TModel,TValue](ViewDataDictionary`1 viewData, Expression`1 expression)\r\n   at AspNetCore._Areas_Authorization_Views_Menu__Create.<ExecuteAsync>b__29_0() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Areas\\Authorization\\Views\\Menu\\_Create.cshtml:line 17\r\n   at Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext.GetChildContentAsync(Boolean useCachedResult, HtmlEncoder encoder)\r\n   at Microsoft.AspNetCore.Mvc.TagHelpers.RenderAtEndOfFormTagHelper.ProcessAsync(TagHelperContext context, TagHelperOutput output)\r\n   at Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner.<RunAsync>g__Awaited|0_0(Task task, TagHelperExecutionContext executionContext, Int32 i, Int32 count)\r\n   at AspNetCore._Areas_Authorization_Views_Menu__Create.ExecuteAsync() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Areas\\Authorization\\Views\\Menu\\_Create.cshtml:line 5\r\n   at Microsoft.AspNetCore.Mvc.Razor.RazorView.RenderPageCoreAsync(IRazorPage page, ViewContext context)\r\n   at Microsoft.AspNetCore.Mvc.Razor.RazorView.RenderPageAsync(IRazorPage page, ViewContext context, Boolean invokeViewStarts)\r\n   at Microsoft.AspNetCore.Mvc.Razor.RazorView.RenderAsync(ViewContext context)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor.ExecuteAsync(ViewContext viewContext, String contentType, Nullable`1 statusCode)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor.ExecuteAsync(ViewContext viewContext, String contentType, Nullable`1 statusCode)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor.ExecuteAsync(ActionContext actionContext, IView view, ViewDataDictionary viewData, ITempDataDictionary tempData, String contentType, Nullable`1 statusCode)\r\n   at Microsoft.AspNetCore.Mvc.ViewFeatures.PartialViewResultExecutor.ExecuteAsync(ActionContext context, PartialViewResult result)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResultFilterAsync>g__Awaited|30_0[TFilter,TFilterAsync](ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResultExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.ResultNext[TFilter,TFilterAsync](State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.InvokeResultFilters()\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 172\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.ResponseCompression.ResponseCompressionMiddleware.InvokeCore(HttpContext context)\r\n   at Microsoft.AspNetCore.ResponseCaching.ResponseCachingMiddleware.Invoke(HttpContext httpContext)\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146233079,"Source":"System.ComponentModel.Annotations","WatsonBuckets":null}', CAST(N'2022-06-28T10:18:36.167' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (99, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:25:52.463' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (100, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:26:03.383' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (101, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Create', N'Arb Tahiri', N'Form to create a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Create', NULL, 0, NULL, CAST(N'2022-06-28T10:26:07.323' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (102, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Create', N'Arb Tahiri', N'Action to create a new menu.', N'POST', N'https://localhost:5001/Authorization/Menu/Create', N'[{"Key":"NameSq","Value":["Stafi"]},{"Key":"NameEn","Value":["Staff"]},{"Key":"Controller","Value":["Staff"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["3"]},{"Key":"ClaimPolicy","Value":["7:m"]},{"Key":"Icon","Value":["fad fa-user-alt"]},{"Key":"OpenFor","Value":["Index,Search,Register,Documents,Departments"]},{"Key":"HasSubMenu","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JmeKvl4KSFTzU-HCOSsACNtWNzeuc6RwEJ1AiNN48aFw2bed2y0B3WVJEF7VUYy1hqIBuHpmIaMbQWyDaeWDXTIcWIXFmsgCU3zsRW5FzmYL2UU9Tp1v_ik-wIPPDmF56B3BdIQNsVDM-W0ixw6efeR8JXTsC_asuSn_HeIMs-4A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:27:14.540' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (103, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:27:17.023' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (104, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:27:17.503' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (105, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Edit', N'Arb Tahiri', N'Form to edit a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Edit?ide=6ntuzFsZY7Ut5lvRnyTcZQ==', NULL, 0, NULL, CAST(N'2022-06-28T10:27:22.373' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (106, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Edit', N'Arb Tahiri', N'Action to edit a new menu.', N'POST', N'https://localhost:5001/Authorization/Menu/Edit', N'[{"Key":"MenuIde","Value":["6ntuzFsZY7Ut5lvRnyTcZQ=="]},{"Key":"NameSq","Value":["Stafi"]},{"Key":"NameEn","Value":["Staff"]},{"Key":"Controller","Value":["Staff"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["3"]},{"Key":"ClaimPolicy","Value":["7:m"]},{"Key":"Icon","Value":["fas fa-user-alt"]},{"Key":"OpenFor","Value":["Index,Search,Register,Documents,Departments"]},{"Key":"HasSubMenu","Value":["true","false"]},{"Key":"Active","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02IIL7-VqOEq90el-IwsBjZpSzR9CKInXqkQaZBcRKnXMqvivAZnYMQrrFN7aHJ6pZ9tH3sMVd8AVstkBctZx1EThjkCOMCPsCTbdlra-8bGeM_LO5EBRnjOz5OYEzHX4A2vhmjo3j6wwl3ewktJN8_I48yKF3rBP1NFsPjDoyZwUw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:27:35.423' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (107, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:27:37.593' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (108, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:27:38.083' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (109, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Create', N'Arb Tahiri', N'Form to create a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Create?ide=6ntuzFsZY7Ut5lvRnyTcZQ==', NULL, 0, NULL, CAST(N'2022-06-28T10:27:39.830' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (110, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Create', N'Arb Tahiri', N'Action to create a new submenu.', N'POST', N'https://localhost:5001/Authorization/SubMenu/Create', N'[{"Key":"MenuIde","Value":["6ntuzFsZY7Ut5lvRnyTcZQ=="]},{"Key":"NameSq","Value":["Regjistro"]},{"Key":"NameEn","Value":["Register"]},{"Key":"Controller","Value":["Staff"]},{"Key":"Action","Value":["Register"]},{"Key":"OrdinalNumber","Value":["1"]},{"Key":"ClaimPolicy","Value":["71:m"]},{"Key":"Icon","Value":["fas fa-plus"]},{"Key":"OpenFor","Value":["Register,Documents,Departments"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02J05u6pPMKwjkF6QwBnRE263ms3RpJZhT0W_VZCoIAKAwxFl1KyiMPiGrFpKG7CchGgw4H2uPZha1udbhAmf5Db27UvZUaWlhZ79gGej3-We3RKRJ4NTttWhceBCknwf-lV6hwnRk2fOhkdQ12ZS6fgOvfOIzVgaiL2j4vwH4hcSg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:28:48.227' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (111, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:28:50.423' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (112, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:28:51.083' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (113, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Create', N'Arb Tahiri', N'Form to create a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Create?ide=6ntuzFsZY7Ut5lvRnyTcZQ==', NULL, 0, NULL, CAST(N'2022-06-28T10:28:52.917' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (114, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Create', N'Arb Tahiri', N'Action to create a new submenu.', N'POST', N'https://localhost:5001/Authorization/SubMenu/Create', N'[{"Key":"MenuIde","Value":["6ntuzFsZY7Ut5lvRnyTcZQ=="]},{"Key":"NameSq","Value":["Lista"]},{"Key":"NameEn","Value":["List"]},{"Key":"Controller","Value":["Staff"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["1"]},{"Key":"ClaimPolicy","Value":["7:m"]},{"Key":"Icon","Value":["fas fa-list"]},{"Key":"OpenFor","Value":["Index,Search"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KaQkrXR9W0mVyNP_r4-CliwHkdcOM94nTGfRHQVxPDg1IpDKltEPPSmzoTMjqrcHC1qXz4e_eXf7utjnxcry5c4Q_iCoawSB9FG_ZE-eL3BZESOCxe3-0Dt0c18W9zTGlWj4ANgEJgZkIAEzRCoHXfIPeWsQenw77uGbvzqRS-2A"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:29:37.903' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (115, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:29:39.373' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (116, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:29:39.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (117, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:29:41.487' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (118, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-28T10:29:43.657' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (119, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7:r"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:29:47.420' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (120, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["71:c"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:29:50.177' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (121, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7d:r"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:29:52.940' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (122, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7d:c"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:29:55.437' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (123, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7d:e"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:29:57.910' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (124, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7d:d"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:00.457' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (125, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7dp:r"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:02.963' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (126, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7dp:c"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:05.510' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (127, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7dp:e"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:08.023' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (128, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7dp:d"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:10.707' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (129, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["7:c"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:19.450' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (130, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Search', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/Search', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:22.710' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (131, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeAccess', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"MenuIde","Value":["6ntuzFsZY7Ut5lvRnyTcZQ=="]},{"Key":"SubMenuIde","Value":["ABEnyAsEjdj)nibo9nHnfA=="]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:24.510' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (132, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeAccess', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"MenuIde","Value":["6ntuzFsZY7Ut5lvRnyTcZQ=="]},{"Key":"SubMenuIde","Value":[")wS2xUQDnb4y0k5CIbjF(A=="]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KFwHMDzYgzdzudTL-aiHGSPsWBVkkCuYE0EyLYh7nWZF6iKwrqAxLW5ULSuAlexU1WgK_HgQxOLAQJtjGzc1SoIJhWjQjJJcIwVpTCgkPXDWcVbTHAbALBakiYCCTpPyA8Gu1T4gD7wnffB0NAkPMgPE16V5xtuFPpuIbF2Eq8CA"]}]', 0, NULL, CAST(N'2022-06-28T10:30:27.157' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (133, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:30:30.533' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (134, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-06-28T10:30:33.690' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (135, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LycLCOTWKbBKfRKRjRchhJemPdwnge282ubHBPaIaEK9SBpQG3UvT0Fco7AAiiK7zhjk-25GGBwvGCxVnZG8Yhk1t1tf2OQMjquEC5Lfi1OTKVUkDPUjHHJTr-nGVhqSkegfvh_vI84JD9f3CA0lF7YzofUOMlm3wI9145V2AIiQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:30:34.707' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (137, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'InProcess', NULL, NULL, N'GET', N'https://localhost:5001/Staff/InProcess', NULL, 1, N'{"ClassName":"Microsoft.EntityFrameworkCore.DbUpdateException","Message":"An error occurred while saving the entity changes. See the inner exception for details.","Data":null,"InnerException":{"ClassName":"Microsoft.Data.SqlClient.SqlException","Message":"String or binary data would be truncated in table ''AMS.Core.Log'', column ''Description''. Truncated value: ''Form to display list of staff that are in process of registratio''.\r\nThe statement has been terminated.","Data":{"HelpLink.ProdName":"Microsoft SQL Server","HelpLink.ProdVer":"15.00.2095","HelpLink.EvtSrc":"MSSQLServer","HelpLink.EvtID":"2628","HelpLink.BaseHelpUrl":"https://go.microsoft.com/fwlink","HelpLink.LinkId":"20476","SqlError 1":"Microsoft.Data.SqlClient.SqlError: String or binary data would be truncated in table ''AMS.Core.Log'', column ''Description''. Truncated value: ''Form to display list of staff that are in process of registratio''.","SqlError 2":"Microsoft.Data.SqlClient.SqlError: The statement has been terminated."},"InnerException":null,"HelpURL":null,"StackTraceString":"   at Microsoft.Data.SqlClient.SqlCommand.<>c.<ExecuteDbDataReaderAsync>b__188_0(Task`1 result)\r\n   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()\r\n   at System.Threading.Tasks.Task.<>c.<.cctor>b__272_0(Object obj)\r\n   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)\r\n--- End of stack trace from previous location ---\r\n   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)\r\n   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Storage.RelationalCommand.ExecuteReaderAsync(RelationalCommandParameterObject parameterObject, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146232060,"Source":"Core Microsoft SqlClient Data Provider","WatsonBuckets":null,"Errors":null,"ClientConnectionId":"3cca2e53-0c3e-430e-8776-a949799dffd3"},"HelpURL":null,"StackTraceString":"   at Microsoft.EntityFrameworkCore.Update.ReaderModificationCommandBatch.ExecuteAsync(IRelationalConnection connection, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.Update.Internal.BatchExecutor.ExecuteAsync(IEnumerable`1 commandBatches, IRelationalConnection connection, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(IList`1 entriesToSave, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.ChangeTracking.Internal.StateManager.SaveChangesAsync(StateManager stateManager, Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.SqlServer.Storage.Internal.SqlServerExecutionStrategy.ExecuteAsync[TState,TResult](TState state, Func`4 operation, Func`4 verifySucceeded, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)\r\n   at Microsoft.EntityFrameworkCore.DbContext.SaveChangesAsync(Boolean acceptAllChangesOnSuccess, CancellationToken cancellationToken)\r\n   at AMS.Controllers.BaseController.OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Controllers\\BaseController.cs:line 85\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionInvoker.<InvokeInnerFilterAsync>g__Awaited|13_0(ControllerActionInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeNextResourceFilter>g__Awaited|25_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Rethrow(ResourceExecutedContextSealed context)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.Next(State& next, Scope& scope, Object& state, Boolean& isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeFilterPipelineAsync>g__Awaited|20_0(ResourceInvoker invoker, Task lastTask, State next, Scope scope, Object state, Boolean isCompleted)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Mvc.Infrastructure.ResourceInvoker.<InvokeAsync>g__Awaited|17_0(ResourceInvoker invoker, Task task, IDisposable scope)\r\n   at Microsoft.AspNetCore.Routing.EndpointMiddleware.<Invoke>g__AwaitRequestTask|6_0(Endpoint endpoint, Task requestTask, ILogger logger)\r\n   at Microsoft.AspNetCore.Authorization.Policy.AuthorizationMiddlewareResultHandler.HandleAsync(RequestDelegate next, HttpContext context, AuthorizationPolicy policy, PolicyAuthorizationResult authorizeResult)\r\n   at Microsoft.AspNetCore.Authorization.AuthorizationMiddleware.Invoke(HttpContext context)\r\n   at Microsoft.AspNetCore.Authentication.AuthenticationMiddleware.Invoke(HttpContext context)\r\n   at Program.<>c.<<<Main>$>b__0_11>d.MoveNext() in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Program.cs:line 172\r\n--- End of stack trace from previous location ---\r\n   at Microsoft.AspNetCore.ResponseCompression.ResponseCompressionMiddleware.InvokeCore(HttpContext context)\r\n   at Microsoft.AspNetCore.ResponseCaching.ResponseCachingMiddleware.Invoke(HttpContext httpContext)\r\n   at AMS.Utilities.General.ExceptionHandlerMiddleware.Invoke(HttpContext context, AMSContext db) in C:\\Users\\arb.tahiri\\source\\repos\\not for you\\AMS\\AMS\\Utilities\\General\\ExceptionHandlerMiddleware.cs:line 21","RemoteStackTraceString":null,"RemoteStackIndex":0,"ExceptionMethod":null,"HResult":-2146233088,"Source":"Microsoft.EntityFrameworkCore.Relational","WatsonBuckets":null}', CAST(N'2022-06-28T10:30:37.970' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (138, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FStaff', NULL, 0, NULL, CAST(N'2022-06-28T10:33:06.460' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (139, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-06-28T10:33:28.653' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (140, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JOvd_tkikPFOfYRTp_dpb2ZOF-iD6qLtP0OIHwQIodGZmQa1n8FoGV0uzBgs2VTh4mSfnw_7H_u7gzbuOlnsmBqSCqpSjxLvGInU6_E2zV-bySw3d4rUSWz6E0OsFFSjuX61pAhA8sHlL67BX_ItlEB4jv0Bubn8QK53tc0WHdjA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:33:32.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (141, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'InProcess', N'Arb Tahiri', N'Form to display list of staff that are in process of registration.', N'GET', N'https://localhost:5001/Staff/InProcess', NULL, 0, NULL, CAST(N'2022-06-28T10:33:35.040' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (142, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-06-28T10:33:43.453' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (143, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-06-28T10:34:45.000' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (144, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I1KinZPR1IDGd70tl3qqsiiHMmyVCdEt1sTr4JKhMCzF_BnaKtw_h-1qsBPkvKbvX9jSHvzQH4ZHwNZDJHZJaICL_FZV99ISM0z9fHmSUs0RIbhauEay-e1Rxphyz6maajV7_cs6QITRQSf4ADkrDA0-cLuP9S80Ynt48YPJYWuA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:34:45.917' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (145, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-06-28T10:37:08.457' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (146, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LQExJF2oqjAoyj0kA1KnJ5VQmePmMOKe9p0nK7Gy5-SZrDKFCavfQ_tVJEdczzKlDzKv3omzggldmDiA9AMKdZDXk6jyakI1Z6vvVqEzIgv0gKvgKYmfq5Nmw5Wgp_HJyMVWz6SYbnZQ3HEm3hxi13YJ5RiUGzODGXspYuk_N3xw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:37:10.140' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (147, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-06-28T10:45:15.297' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (148, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:45:31.590' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (149, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:45:34.600' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (150, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:45:35.053' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (151, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Edit', N'Arb Tahiri', N'Form to edit a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Edit?ide=BFjB3x06UIwNlWnpgxBdKg==', NULL, 0, NULL, CAST(N'2022-06-28T10:45:46.187' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (152, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Edit', N'Arb Tahiri', N'Action to edit a new menu.', N'POST', N'https://localhost:5001/Authorization/Menu/Edit', N'[{"Key":"MenuIde","Value":["BFjB3x06UIwNlWnpgxBdKg=="]},{"Key":"NameSq","Value":["Autorizimet"]},{"Key":"NameEn","Value":["Authorizations"]},{"Key":"Controller","Value":["Authorization"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["3"]},{"Key":"ClaimPolicy","Value":["5:m"]},{"Key":"Icon","Value":["fas fa-key"]},{"Key":"OpenFor","Value":["Menu,SubMenu,Authorizations"]},{"Key":"HasSubMenu","Value":["true","false"]},{"Key":"Active","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02L7A-VffexKx_fIvn2hZ3Mn8c2RuwM7YMznn6mwjMUdQwuDr6prJuQs0_vQIhrt28utkJc2YaAgFvVnXhu1Jhljd0t2mxkN6yBzvzlHQstAWEjJ7p-dTK4u-8rsHLs3tGmaF9stmPDgaqcAiPm4T7duGr4JWZVCOkh-ew7oezYZ8Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:45:55.380' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (153, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:45:57.503' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (154, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:45:57.880' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (155, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:46:00.120' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (156, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:46:02.687' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (157, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:46:03.023' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (158, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:46:09.893' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (159, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:46:12.153' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (160, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Create', N'Arb Tahiri', N'Form to create a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Create', NULL, 0, NULL, CAST(N'2022-06-28T10:46:13.320' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (161, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Create', N'Arb Tahiri', N'Action to create a new menu.', N'POST', N'https://localhost:5001/Authorization/Menu/Create', N'[{"Key":"NameSq","Value":["Konfigurimet"]},{"Key":"NameEn","Value":["Configurations"]},{"Key":"Controller","Value":["Configuration"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["3"]},{"Key":"ClaimPolicy","Value":["2:m"]},{"Key":"Icon","Value":["fas fa-cog"]},{"Key":"OpenFor","Value":["Index"]},{"Key":"HasSubMenu","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JcUwt0pvVA6Fs2c0mhfXJcCnEgrR53JmqkZ_PAwRCquCyaPRmhHnPi6JL3L_qXX48M3t5TOMsMpywwn6hzzpd6c9KxrSK1VTvQzbH8kMBm7cpGHL1iggU2wqFnuuRBUGmGDzh3PARbBkSEW4HqFE_O_X7GiyWxBNIANH02dZBj5w"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:47:11.813' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (162, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:47:13.563' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (163, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:47:14.097' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (164, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Create', N'Arb Tahiri', N'Form to create a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Create?ide=o7DumLm2KssJna5VG7BQLA==', NULL, 0, NULL, CAST(N'2022-06-28T10:47:21.227' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (165, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Create', N'Arb Tahiri', N'Action to create a new submenu.', N'POST', N'https://localhost:5001/Authorization/SubMenu/Create', N'[{"Key":"MenuIde","Value":["o7DumLm2KssJna5VG7BQLA=="]},{"Key":"NameSq","Value":["Parametrat e aplikacionit"]},{"Key":"NameEn","Value":["Application parameters"]},{"Key":"Controller","Value":["AppSettings"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["1"]},{"Key":"ClaimPolicy","Value":["21:m"]},{"Key":"Icon","Value":["fas fa-sliders-h"]},{"Key":"OpenFor","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LGSEOGgYl_H9Q0KWXeJ4aPidG8mmwAQCedmVszZh5C05D1KRPEK0tvGhz15mtvRiEWOQcl2gD2_41Eane-3LQ7wvkaB2q0_ecXLhhDWrUuEh4uoJ9Gbj1a6q8lIF3SJw6gEP70gvpso9QlO69FZC4wqG03mk-cLxODUSb_Mgljpg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:48:14.580' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (166, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:48:16.763' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (167, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:48:17.250' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (168, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Create', N'Arb Tahiri', N'Form to create a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Create?ide=o7DumLm2KssJna5VG7BQLA==', NULL, 0, NULL, CAST(N'2022-06-28T10:48:19.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (169, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Create', N'Arb Tahiri', N'Action to create a new submenu.', N'POST', N'https://localhost:5001/Authorization/SubMenu/Create', N'[{"Key":"MenuIde","Value":["o7DumLm2KssJna5VG7BQLA=="]},{"Key":"NameSq","Value":["Tabelat ndihmëse"]},{"Key":"NameEn","Value":["Look up tables"]},{"Key":"Controller","Value":["Tables"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["2"]},{"Key":"ClaimPolicy","Value":["22:m"]},{"Key":"Icon","Value":["fas fa-table"]},{"Key":"OpenFor","Value":["Index"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02K4w-Uts-fPP98TQS8PNdcZEuIKqvnjk00Pp-UQ9jb3eUBoe3tZgyC1-1mFHxBB_bCMqP5pCW4k-uFqfqSY-fN02QVxZ1KA0xRMTj-8haDRUdbHL3J85-uHg04wSx25DVuTfucppFITmRM2T82O8pnH50hGuhodeFJ_oM316q9X0Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:49:06.767' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (170, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:49:07.697' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (171, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:49:08.070' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (172, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:49:10.347' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (173, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Edit', N'Arb Tahiri', N'Form to edit a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Edit?ide=BFjB3x06UIwNlWnpgxBdKg==', NULL, 0, NULL, CAST(N'2022-06-28T10:49:12.577' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (174, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/Home/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:54:40.363' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (175, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:55:43.167' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (176, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:55:49.310' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (177, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:55:49.740' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (178, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Edit', N'Arb Tahiri', N'Form to edit a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Edit?ide=BFjB3x06UIwNlWnpgxBdKg==', NULL, 0, NULL, CAST(N'2022-06-28T10:55:54.793' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (179, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Edit', N'Arb Tahiri', N'Action to edit a new menu.', N'POST', N'https://localhost:5001/Authorization/Menu/Edit', N'[{"Key":"MenuIde","Value":["BFjB3x06UIwNlWnpgxBdKg=="]},{"Key":"NameSq","Value":["Autorizimet"]},{"Key":"NameEn","Value":["Authorizations"]},{"Key":"Controller","Value":["Authorization"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["3"]},{"Key":"ClaimPolicy","Value":["5:m"]},{"Key":"Icon","Value":["fas fa-key"]},{"Key":"OpenFor","Value":["Index"]},{"Key":"HasSubMenu","Value":["true","false"]},{"Key":"Active","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JpIs2fUbqPJX1ccHYF-MqJTVv82foLs_XXZdl8og1QVpe2BcJpjwk9MWHi2gkOE8mBwxwjlDsP2Ssw5pax5ydiL-jJsC6vB1t-U1IHzDBG6rNT3V2iIU4AoFEOE_QJGdcRuKhq1BRH-iRT_jvVfTIKaPFlztvtaj8pNpbSTAhvTA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T10:56:01.260' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (180, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:56:02.407' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (181, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T10:56:02.880' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (182, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T10:56:03.903' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (183, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Edit', N'Arb Tahiri', N'Form to edit a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Edit?ide=tgutkThhHU9phNc7I80u9A==', NULL, 0, NULL, CAST(N'2022-06-28T10:56:08.440' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (184, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Home', N'Index', N'Arb Tahiri', N'Entry home.', N'GET', N'https://localhost:5001/', NULL, 0, NULL, CAST(N'2022-06-28T11:22:15.607' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (185, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Index', N'Arb Tahiri', N'Authorization configuration.', N'GET', N'https://localhost:5001/Authorization/Authorizations/Index', NULL, 0, NULL, CAST(N'2022-06-28T11:22:38.933' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (186, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Search', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/Search', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:22:40.947' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (187, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeAccess', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"MenuIde","Value":["o7DumLm2KssJna5VG7BQLA=="]},{"Key":"SubMenuIde","Value":["BFjB3x06UIwNlWnpgxBdKg=="]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:22:43.530' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (188, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeAccess', N'Arb Tahiri', N'Form to search through authorizations.', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"MenuIde","Value":["o7DumLm2KssJna5VG7BQLA=="]},{"Key":"SubMenuIde","Value":["eBQw1qWZXQ1r1j70fg)lwA=="]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:22:46.757' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (189, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'Rules', N'Arb Tahiri', N'Entry form in application rules', N'POST', N'https://localhost:5001/Authorization/Authorizations/Rules', N'[{"Key":"role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]}]', 0, NULL, CAST(N'2022-06-28T11:22:49.297' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (190, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["15:r"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:22:53.687' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (191, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["22:r"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:22:56.320' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (192, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["22:c"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:22:59.270' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (193, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["22:e"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:23:01.750' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (194, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Authorizations', N'ChangeMethodAccess', N'Arb Tahiri', N'Action to change access for methods with policies', N'POST', N'https://localhost:5001/Authorization/Authorizations/ChangeMethodAccess', N'[{"Key":"Role","Value":["6dce687e-0a9c-4bcf-aa79-65c13a8b8db0"]},{"Key":"Policy","Value":["22:d"]},{"Key":"Access","Value":["true"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02I6fTpYoNEUhKAjdGS-E-JlUFzd0FadDbG65ZbKmMks_0arW6N0IjXN-eCPd60xey9s54t2y6zZheFAfQSXMDXT4hJd2B414fSNKFqi3IsyLA9linpUSGeNqrINZ2d97QBF3eoYaLK-_94y2KTS3qZ7_ea4mFJe7IdqQFdbYs1SWA"]}]', 0, NULL, CAST(N'2022-06-28T11:23:04.200' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (195, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T11:23:18.433' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (196, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T11:23:19.037' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (197, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'_Edit', N'Arb Tahiri', N'Form to edit a new menu.', N'GET', N'https://localhost:5001/Authorization/Menu/_Edit?ide=o7DumLm2KssJna5VG7BQLA==', NULL, 0, NULL, CAST(N'2022-06-28T11:23:24.850' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (198, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T11:23:27.150' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (199, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Edit', N'Arb Tahiri', N'Form to edit a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Edit?sIde=BFjB3x06UIwNlWnpgxBdKg==', NULL, 0, NULL, CAST(N'2022-06-28T11:23:29.283' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (200, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Edit', N'Arb Tahiri', N'Action to edit a new submenu.', N'POST', N'https://localhost:5001/Authorization/SubMenu/Edit', N'[{"Key":"SubMenuIde","Value":["BFjB3x06UIwNlWnpgxBdKg=="]},{"Key":"NameSq","Value":["Parametrat e aplikacionit"]},{"Key":"NameEn","Value":["Application parameters"]},{"Key":"Controller","Value":["AppSettings"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["1"]},{"Key":"ClaimPolicy","Value":["21:m"]},{"Key":"Icon","Value":["fas fa-sliders-h"]},{"Key":"OpenFor","Value":["Index"]},{"Key":"Active","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LklHsBfyvDwjqdceyxbda_CSbKC2yBTPLYmoMRrEqMxcGRaSvLrAWOEM5PL5XBMXYUag6LwZY1k_TvhoEoov46rYT0K82CXZq-KQaZvRgP1wO9AR5O87o3Lm6mgwE_8p4BeKBkNEiSrmAz3XhcP5UgDDHOl1ZVYmKrq_SHTNQjKg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T11:23:33.263' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (201, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T11:23:35.370' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (202, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T11:23:35.703' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (203, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T11:23:36.703' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (204, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Edit', N'Arb Tahiri', N'Form to edit a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Edit?sIde=eBQw1qWZXQ1r1j70fg)lwA==', NULL, 0, NULL, CAST(N'2022-06-28T11:23:38.347' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (205, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T11:23:43.613' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (206, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T11:23:43.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (207, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:32:06.737' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (208, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:32:26.723' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (209, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:32:30.443' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (210, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:32:37.403' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (211, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:32:37.877' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (212, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:35:18.373' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (213, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:35:27.383' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (214, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:35:32.423' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (215, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:35:32.960' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (216, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-06-28T13:35:34.547' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (217, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JNGt403_zQFTrHznUjajWxT9gY8RUUsQER_y_FgVxULa9lhFUd9Q0MBWHY-_HQ3MnIAk4GjLs5hIUwjks2DSHkNRmwU45jq50abI4POqWa2AB1ECBXNitqcvvpJ3Sj7PHSYk3gc6LW-ENGZYP3MkxvfT0OowBng8LXG1yWg4-K_w"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:35:35.480' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (218, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-06-28T13:35:39.717' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (219, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LA5N8cbl_abErF4iH3NPwmg32rER2A2D91yICIRn2b3TCbZb24kx4N6UAzNLLrvckWwstEzOnJeY8XrDPErjUGFNlxPnM5zEG2LQu-FGi42u-8_hLPugYop4druDz5j_dF8emvcb0MyuqmdbrhlHl7ll2MWkREBuG7OyYL_nOazA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:35:40.403' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (220, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Staff', N'Index', N'Arb Tahiri', N'Entry home. Search for staff.', N'GET', N'https://localhost:5001/Staff', NULL, 0, NULL, CAST(N'2022-06-28T13:35:53.513' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (221, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Staff', N'Search', N'Arb Tahiri', N'Form to list searched list of staff.', N'POST', N'https://localhost:5001/Staff/Search', N'[{"Key":"reportType","Value":[""]},{"Key":"Department","Value":[""]},{"Key":"StaffType","Value":[""]},{"Key":"PersonalNumber","Value":[""]},{"Key":"Firstname","Value":[""]},{"Key":"Lastname","Value":[""]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02IvB9Tbz0ISqgzNwdySMLUprjt2QAQYF53oky_YcPn24kcNE9XeWbDTh3qH-Tpfnf2YVs3X8YdEzECE5sbxxD2wJU6Ae_M1WDlGe79H4zuLnT7A_P78gpcb_v2ABfIBUOky9fTipiPLUFzfdl0BKDYXFWI-c5VNwpmRurwrKtrq-Q"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:35:53.937' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (222, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:35:56.290' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (223, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:35:56.677' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (224, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:35:58.960' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (225, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'::1', N'SubMenu', N'_Edit', N'Arb Tahiri', N'Form to edit a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Edit?sIde=BFjB3x06UIwNlWnpgxBdKg==', NULL, 0, NULL, CAST(N'2022-06-28T13:36:01.357' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (226, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:42:34.343' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (227, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:42:44.617' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (228, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:43:10.123' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (229, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Edit', N'Arb Tahiri', N'Form to edit a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Edit?sIde=BFjB3x06UIwNlWnpgxBdKg==', NULL, 0, NULL, CAST(N'2022-06-28T13:43:12.243' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (230, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Edit', N'Arb Tahiri', N'Action to edit a new submenu.', N'POST', N'https://localhost:5001/Authorization/SubMenu/Edit', N'[{"Key":"SubMenuIde","Value":["BFjB3x06UIwNlWnpgxBdKg=="]},{"Key":"NameSq","Value":["Parametrat e aplikacionit"]},{"Key":"NameEn","Value":["Application parameters"]},{"Key":"Area","Value":["Configuration"]},{"Key":"Controller","Value":["AppSettings"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["1"]},{"Key":"ClaimPolicy","Value":["21:m"]},{"Key":"Icon","Value":["fas fa-sliders-h"]},{"Key":"OpenFor","Value":["Index"]},{"Key":"Active","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LxNTCs_vajhbqccM4otKSIje8lqv3wTvpzDftF-niGZzidL15ctFiZ8qVRFbkA7HIciskWKsNmU7uMMZ5X43sO5BAZFhFGJQAcuyud_WDLHBfAWqWiPC5aZIOuA0EZ-2zNxuaQI14Zk5ygmp8CQrLbTT15fBho_1YLJKxPCUgKAw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:43:24.980' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (231, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:43:27.443' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (232, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:43:27.910' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (233, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Index', N'Arb Tahiri', N'Form to dipslay list of submenus.', N'GET', N'https://localhost:5001/Authorization/SubMenu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:43:30.247' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (234, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'_Edit', N'Arb Tahiri', N'Form to edit a new submenu.', N'GET', N'https://localhost:5001/Authorization/SubMenu/_Edit?sIde=eBQw1qWZXQ1r1j70fg)lwA==', NULL, 0, NULL, CAST(N'2022-06-28T13:43:32.227' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (235, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'SubMenu', N'Edit', N'Arb Tahiri', N'Action to edit a new submenu.', N'POST', N'https://localhost:5001/Authorization/SubMenu/Edit', N'[{"Key":"SubMenuIde","Value":["eBQw1qWZXQ1r1j70fg)lwA=="]},{"Key":"NameSq","Value":["Tabelat ndihmëse"]},{"Key":"NameEn","Value":["Look up tables"]},{"Key":"Area","Value":["Configuration"]},{"Key":"Controller","Value":["Tables"]},{"Key":"Action","Value":["Index"]},{"Key":"OrdinalNumber","Value":["2"]},{"Key":"ClaimPolicy","Value":["22:m"]},{"Key":"Icon","Value":["fas fa-table"]},{"Key":"OpenFor","Value":["Index"]},{"Key":"Active","Value":["true","false"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KuujB1ryTWG1wBZ9nGm5MACpIhfVxQySI6aiPp3hMWRLk3wnTYcqVCQ1OE31P87osGHMvFshVr4lZKHaLVYoYlDYnF6FwQ0cuWnxdvEAD0otDBTLpejAX8BLg8Y-wTXDojtqA4Td4SOyz3v8CN98T8XaPuck_Yw4F8lwtFuf1Tjw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:43:34.450' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (236, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Index', N'Arb Tahiri', N'Form to display list of menus and submenus.', N'GET', N'https://localhost:5001/Authorization/Menu/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:43:36.563' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (237, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Menu', N'Search', N'Arb Tahiri', N'Form to display list of menus.', N'GET', N'https://localhost:5001/Authorization/Menu/Search', NULL, 0, NULL, CAST(N'2022-06-28T13:43:36.950' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (238, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:43:39.423' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (239, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:43:39.970' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (240, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Lloji dokumentit"]}]', 0, NULL, CAST(N'2022-06-28T13:43:40.020' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (241, NULL, N'127.0.0.1', N'Identity', N'/Account/Login', NULL, NULL, N'GET', N'https://localhost:5001/Identity/Account/Login?ReturnUrl=%2FConfiguration%2FTables%2FIndex', NULL, 0, NULL, CAST(N'2022-06-28T13:43:46.763' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (242, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:44:18.803' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (243, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:44:19.923' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (244, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Lloji dokumentit"]}]', 0, NULL, CAST(N'2022-06-28T13:44:19.943' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (245, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:44:42.507' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (246, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:44:43.413' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (247, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Lloji dokumentit"]}]', 0, NULL, CAST(N'2022-06-28T13:44:43.423' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (248, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["6"]},{"Key":"title","Value":["Lloji dokumentit"]}]', 0, NULL, CAST(N'2022-06-28T13:44:48.407' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (249, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["6"]},{"Key":"title","Value":["Lloji dokumentit"]}]', 0, NULL, CAST(N'2022-06-28T13:44:50.993' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (250, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["6"]},{"Key":"title","Value":["Lloji dokumentit"]}]', 0, NULL, CAST(N'2022-06-28T13:45:16.243' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (251, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["6"]},{"Key":"Title","Value":["Lloji dokumentit"]},{"Key":"NameSQ","Value":["Resume"]},{"Key":"NameEN","Value":["Resume"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JabXjsPjMHV-BligrurpwEMSYjGtKl292tjy1J5fN1Y4kApkxYTL-pIaXZHyGOjmKHct-fk271MAbIZhs4w1Kqrs7aqTMU7Cb6GET0HnE9SDr8CxmfxZIOCMfDs1Hc6y8rjfu2JJoRcSIzoXAKiURlptxA6QwnbX-1qPWSkSY7nQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:45:26.807' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (252, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:45:28.990' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (253, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["6"]},{"Key":"title","Value":["Lloji dokumentit"]}]', 0, NULL, CAST(N'2022-06-28T13:45:29.470' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (254, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:45:29.470' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (255, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["7"]},{"Key":"title","Value":["Lloji stafit"]}]', 0, NULL, CAST(N'2022-06-28T13:45:31.647' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (256, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["7"]},{"Key":"title","Value":["Lloji stafit"]}]', 0, NULL, CAST(N'2022-06-28T13:45:32.630' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (257, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["7"]},{"Key":"Title","Value":["Lloji stafit"]},{"Key":"NameSQ","Value":["Administrata"]},{"Key":"NameEN","Value":["Administrata"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02J94ytgMT9x_rN8BbUGya75ojvATdjOvJxtPK1zSCnpGGn2Rf63GQ3wg1gcTdLxwDN7RFzB5wQ4w3iypl2YXm41p2Iv7md3jrnvhpSHUjRoR5Ydr1odUe_xfpnnOG24de6v6rr6qmOBQa-bbO_dnse9KmuWPhJg1AKHa2M_SauAwA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:45:38.707' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (258, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:45:40.847' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (259, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:45:41.313' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (260, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["7"]},{"Key":"title","Value":["Lloji stafit"]}]', 0, NULL, CAST(N'2022-06-28T13:45:41.320' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (261, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:45:42.980' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (262, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:45:44.097' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (263, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["3"]},{"Key":"Title","Value":["Lloji statusit"]},{"Key":"NameSQ","Value":["Aprovuar"]},{"Key":"NameEN","Value":["Approved"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KOVdgsC4t9OWROfODLeB1xXdsEcN6p4u774yRKYtPz8eZ-lK9jq791s8fw_XMNtLOQ_3ZqS24s1Pp63I7BD3SHhJogzkFaTaMkWXXhT5WzBHGGcgFZ1P8fP0gZP9yu2OD_D-ETlPf2386jOVIuoEqGl5JJu0GIDvgnpdTo_r7JoA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:45:59.100' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (264, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:46:01.310' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (265, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:46:01.843' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (266, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:02.010' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (267, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:03.193' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (268, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["3"]},{"Key":"Title","Value":["Lloji statusit"]},{"Key":"NameSQ","Value":["Refuzuar"]},{"Key":"NameEN","Value":["Refused"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JYZ8ZCHnLb8oGJPoXBBvpashZv5X3exrEBXjetH50SMCQFbU7ttd2BEkCGPcOkbBd9cmGz6fU6Xr44XP8c2b_XsDsldUVAB6emUUXJa6XV25G6g_LOhznG_0-UnQOBTXP1qTXx9n5aTl3XO2keEwLpGYmr1DoXa_GXxLUBdtXNCQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:46:11.993' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (269, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:46:14.110' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (270, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:14.683' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (271, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:46:14.687' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (272, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:15.260' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (273, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["3"]},{"Key":"Title","Value":["Lloji statusit"]},{"Key":"NameSQ","Value":["Në pritje"]},{"Key":"NameEN","Value":["Pending"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JUo0OU-M3bAsTDefPUmSUlamyuFLMZPEZJ1Iw6X4LSJGZH0m8sFRq0bw8FAa784r6SlgOYL8TWRVx2ZXD7d89Jd_ajBXq-0KGpFhJo_itCObmNFoHm8HIpUYF5HF-lfSTa7wIGAw8G1RVg4_RHLgCQyQv5Qp4RqeYZ3jcBGnFKnw"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:46:22.203' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (274, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:46:24.743' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (275, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:25.133' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (276, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:46:25.130' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (277, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:26.103' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (278, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["3"]},{"Key":"Title","Value":["Lloji statusit"]},{"Key":"NameSQ","Value":["Në procesim"]},{"Key":"NameEN","Value":["Processing"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02L7yXrPcjenaH7sC8SpEbkoZf6nku2e5Y9TX8vmdnFhDL9g4kpUnIs1-Cfs_s7NXJofJSRHKWmx-Vt_EbL7bih0b1qowv5barRUc7xJF4URwnwukyBF36aWZZov03khcLZQn8OSR5i_AtSjt-POZl7kWYIZQn9zN-tDwZEGI80Fwg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:46:48.167' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (279, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:46:50.590' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (280, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:46:51.137' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (281, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:51.140' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (282, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:46:51.770' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (283, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["3"]},{"Key":"Title","Value":["Lloji statusit"]},{"Key":"NameSQ","Value":["Përfunduar"]},{"Key":"NameEN","Value":["Finished"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LIvcFrqYQUpZzNHexvmTTlXC-GBDuhsyLV-2_BKDqJyPDwvNf6k44e-3uNwxx-vbA-IUVqpFQbD6HMAAJxSbORlqTVUha3ONgh-sBKS5WNaSf6jW6lk8SQpEdEgyRR2kdnBzpRlHQT3cNu3sh05KjYadW1_X8rqTQ9pZWchmF3gQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:46:59.840' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (284, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:47:02.043' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (285, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:02.790' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (286, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:47:02.800' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (287, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:03.437' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (288, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["3"]},{"Key":"Title","Value":["Lloji statusit"]},{"Key":"NameSQ","Value":["Fshirë"]},{"Key":"NameEN","Value":["Deleted"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02LQMSHT1qre87tidVInP4d2L_gLaxRGJn0jDCec8HUaKmAo-1vFkdSUQT6MpMN3b0Wsm2mEWHO-UyhQvBULlasVfm_dHo8-KsDkuK3RlVviWy0QvGJ69xujFxuAtOWGv72CE-sfL0QAtzyraUA8j-8Q7tjz5F70wY9V8IPH1Pomug"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:47:08.233' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (289, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:47:10.473' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (290, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:47:11.257' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (291, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:11.260' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (292, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:11.907' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (293, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:25.700' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (294, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["3"]},{"Key":"Title","Value":["Lloji statusit"]},{"Key":"NameSQ","Value":["I regjistruar/i paprocesuar"]},{"Key":"NameEN","Value":["Registered/unprocessed"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02ItiZlKVz74O_2LTRNFfXYVAWhXYws-OCgfDKudoeGloJ5w1_Emj04N0DAqmYM-lcimBZI9qt6FnKwKKNguqYRTGLIReF9Aw497qO9zIY8sSdfU4o8wZZzigkMjuLY7o5RSteaVSyWCUD_Bnj6jq480lQ-xt1Ly6mciAPEfGgtQlQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:47:33.653' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (295, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:47:36.457' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (296, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:37.073' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (297, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:47:37.077' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (298, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["3"]},{"Key":"title","Value":["Lloji statusit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:37.843' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (299, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["5"]},{"Key":"title","Value":["Departamenti"]}]', 0, NULL, CAST(N'2022-06-28T13:47:42.443' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (300, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["5"]},{"Key":"title","Value":["Departamenti"]}]', 0, NULL, CAST(N'2022-06-28T13:47:43.790' AS DateTime))
GO
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (301, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["5"]},{"Key":"Title","Value":["Departamenti"]},{"Key":"NameSQ","Value":["Administrata"]},{"Key":"NameEN","Value":["Administration"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KXiiZQFprEF9fc6yM2E9r_gAf4n036-R0Yhuoq5taxKX2a92hnLmnva8TbphxOsdBM92YhDKCY2GQrNiA3swhVWMOWfmZlQuJcysYLucuLNx2nActcG0RgmgOLsUNKHNFNxPua0_d4MTg30rF2Me-wYCmmyTVPgYzkZAnN0jSWTQ"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:47:51.927' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (302, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:47:53.470' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (303, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["5"]},{"Key":"title","Value":["Departamenti"]}]', 0, NULL, CAST(N'2022-06-28T13:47:54.073' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (304, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:47:54.073' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (305, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["7"]},{"Key":"title","Value":["Lloji stafit"]}]', 0, NULL, CAST(N'2022-06-28T13:47:54.650' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (306, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Edit', N'Arb Tahiri', N'Form to edit data from look up tables.', N'POST', N'https://localhost:5001/Configuration/Tables/_Edit', N'[{"Key":"table","Value":["7"]},{"Key":"title","Value":["Lloji stafit"]},{"Key":"ide","Value":["tgutkThhHU9phNc7I80u9A=="]}]', 0, NULL, CAST(N'2022-06-28T13:47:56.103' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (307, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Edit', N'Arb Tahiri', N'Action to edit data from a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Edit', N'[{"Key":"Ide","Value":["tgutkThhHU9phNc7I80u9A=="]},{"Key":"Table","Value":["7"]},{"Key":"Title","Value":["Lloji stafit"]},{"Key":"NameSQ","Value":["Administrata"]},{"Key":"NameEN","Value":["Administration"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KbFj7zwCLgoAHQLOyTq951jo2iEjaseDqVNq9YkK6GENaqmYcFiU3lDOisFpKi39N3kd76PcjtgiPpfGKMPly12JtNcHPkBXiMMOArFlDhgfAhhAkRX_9qjZwSLa14avKNTsMt9xiJY8rXGFYIdXuA6Urh5TcYK3ZryF5lYzzJKA"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:48:00.120' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (308, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:48:02.243' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (309, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:48:02.700' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (310, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["7"]},{"Key":"title","Value":["Lloji stafit"]}]', 0, NULL, CAST(N'2022-06-28T13:48:02.703' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (311, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["2"]},{"Key":"title","Value":["Shteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:25.617' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (312, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["2"]},{"Key":"title","Value":["Shteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:26.937' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (313, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["2"]},{"Key":"Title","Value":["Shteti"]},{"Key":"NameSQ","Value":["Kosovë"]},{"Key":"NameEN","Value":["Kosova"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02KDJQjtCes09l0sR2Xm_5R6GXdTOWjxOhJOB5JvAfu6f17dLl17rB1fiVCTh_5AT9jxNXsa1GcQVk4YoyZrOh4fv93UR5mVOwAckAGoGytmXK5aSAjn12ur0sQJRAffqHCpoqRaE8AfenzgBge8S4o8wAxl5MMm5fHxQmcoZhTgMg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:48:33.337' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (314, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:48:34.570' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (315, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:48:35.233' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (316, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["2"]},{"Key":"title","Value":["Shteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:35.237' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (317, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["2"]},{"Key":"title","Value":["Shteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:36.517' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (318, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["2"]},{"Key":"Title","Value":["Shteti"]},{"Key":"NameSQ","Value":["Angli"]},{"Key":"NameEN","Value":["England"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02JbC6uZ89USlMwgyjruBWXtwSkWW6Vz65s0yb6K3iQNokR5xUQdJy_Yq1zOxyanvOlCL8FcNpQpjSEcmh8zNIAnsLsrgrZ7nUzv5-qzqZ0Qx1Y6t1pup5Qqix1U2MSW418BCPMvGiY2Z8X5hW0l3RF4-YPMtUIK4MD11bR5mQUb8w"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:48:41.083' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (319, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:48:43.267' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (320, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:48:43.707' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (321, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["2"]},{"Key":"title","Value":["Shteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:43.713' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (322, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Qyteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:44.740' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (323, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Qyteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:45.583' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (324, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["1"]},{"Key":"Title","Value":["Qyteti"]},{"Key":"NameSQ","Value":["Ferizaj"]},{"Key":"NameEN","Value":["Ferizaj"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02J_MQF1AeiVoaXHzr6NyJBZCfNubd1U_t8KHjAq4gG_AbgKAVyAALcqIYbPbGhQDS8DC8uyElGaISfa2ID3Etv3FO0lykPOXoH5qwJnabUP79d1J7-IlxSrzwt2gcoPJwSsw-icrJ1IzN_RrlvYUu7C39FxSS1MmqN88Z4-yrl9ng"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:48:49.370' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (325, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:48:52.003' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (326, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:48:52.433' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (327, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Qyteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:52.437' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (328, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_Create', N'Arb Tahiri', N'Form to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/_Create', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Qyteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:52.923' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (329, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Create', N'Arb Tahiri', N'Action to create data for a look up table.', N'POST', N'https://localhost:5001/Configuration/Tables/Create', N'[{"Key":"Table","Value":["1"]},{"Key":"Title","Value":["Qyteti"]},{"Key":"NameSQ","Value":["Londër"]},{"Key":"NameEN","Value":["London"]},{"Key":"__RequestVerificationToken","Value":["CfDJ8MPGkjXDyyJJh-i3xneI02ITXur-o0fSb3BDfXfB-f_QvNpLs7gHS3KFDUYXYWcDQlgoitq507Vnc9YNFT92zdIvZD4HMmrJwxjJiTZOZNiLX5JS2gESxqqg9HDAo2lkyVViXurY1XPZlySRcgLMjkAHZSRVTLDURQ838Qnmyg1ae61EEKBzhjkfyk0yExUkIg"]},{"Key":"X-Requested-With","Value":["XMLHttpRequest"]}]', 0, NULL, CAST(N'2022-06-28T13:48:57.533' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (330, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'Index', N'Arb Tahiri', N'Entry form.', N'GET', N'https://localhost:5001/Configuration/Tables/Index', NULL, 0, NULL, CAST(N'2022-06-28T13:48:59.090' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (331, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpTables', N'Arb Tahiri', N'List of lookup tables.', N'GET', N'https://localhost:5001/Configuration/Tables/_LookUpTables', NULL, 0, NULL, CAST(N'2022-06-28T13:48:59.450' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (332, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Tables', N'_LookUpData', N'Arb Tahiri', N'List of data of look up tables', N'POST', N'https://localhost:5001/Configuration/Tables/_LookUpData', N'[{"Key":"table","Value":["1"]},{"Key":"title","Value":["Qyteti"]}]', 0, NULL, CAST(N'2022-06-28T13:48:59.453' AS DateTime))
INSERT [Core].[Log] ([LogID], [UserID], [IP], [Controller], [Action], [Developer], [Description], [HttpMethod], [Url], [FormContent], [Error], [Exception], [InsertedDate]) VALUES (333, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'127.0.0.1', N'Staff', N'Register', N'Arb Tahiri', N'Form to register or update staff. First step of registration/edition of staff.', N'GET', N'https://localhost:5001/Staff/Register', NULL, 0, NULL, CAST(N'2022-06-28T13:49:04.883' AS DateTime))
SET IDENTITY_INSERT [Core].[Log] OFF
GO
SET IDENTITY_INSERT [Core].[Menu] ON 

INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Ballina', N'Home', 0, N'fas fa-home', N'1:m', N'1', NULL, N'Home', N'Index', 1, N'Administrator', N'Index, Administrator', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:51:58.333' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, N'Konfigurimet', N'Configurations', 1, N'fas fa-cog', N'2:m', N'2', N'Configuration', N'Configuration', N'Index', 4, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, N'Administrimi', N'Administration', 1, N'fas fa-users-cog', N'3:m', N'3', N'Administration', N'Administration', N'Index', 5, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, N'Profili', N'Profile', 0, N'fas fa-address-card', N'4:m', N'4', NULL, N'StaffProfile', N'Index', 2, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, N'Autorizimet', N'Authorizations', 1, N'fas fa-key', N'5:m', N'5', N'Authorization', N'Authorization', N'Index', 3, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:56:01.463' AS DateTime), 2)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, N'Gjurmët', N'Traces', 1, N'fas fa-fingerprint', N'6:m', N'6', N'Application', N'Application', N'Index', 6, N'Administrator', NULL, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-09T13:56:11.900' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (8, N'Stafi', N'Staff', 1, N'fas fa-user-alt', N'7:m', N'7', NULL, N'Staff', N'Index', 3, NULL, N'Index,Search,Register,Documents,Departments', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:27:14.760' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:27:35.440' AS DateTime), 1)
INSERT [Core].[Menu] ([MenuID], [NameSQ], [NameEN], [HasSubMenu], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (9, N'Konfigurimet', N'Configurations', 1, N'fas fa-cog', N'2:m', N'2', NULL, N'Configuration', N'Index', 3, NULL, N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:47:11.850' AS DateTime), NULL, NULL, NULL)
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

INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, 6, N'Autorizimet', N'Authorizations', N'fas fa-shield-alt', N'51:m', N'51', N'Authorization', N'Authorizations', N'Index', 1, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-10T08:18:03.277' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (3, 6, N'Menytë', N'Menus', N'fas fa-bars', N'52:m', N'52', N'Authorization', N'Menu', N'Index', 2, N'Administrator', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-10T08:18:03.277' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (4, 8, N'Regjistro', N'Register', N'fas fa-plus', N'71:m', N'71', NULL, N'Staff', N'Register', 1, N'Administrator, ', N'Register,Documents,Departments', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:28:48.243' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (5, 8, N'Lista', N'List', N'fas fa-list', N'7:m', N'7', NULL, N'Staff', N'Index', 1, N'Administrator, ', N'Index,Search', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:29:37.920' AS DateTime), NULL, NULL, NULL)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (6, 9, N'Parametrat e aplikacionit', N'Application parameters', N'fas fa-sliders-h', N'21:m', N'21', N'Configuration', N'AppSettings', N'Index', 1, N'Administrator, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:48:14.597' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:43:25.260' AS DateTime), 2)
INSERT [Core].[SubMenu] ([SubMenuID], [MenuID], [NameSQ], [NameEN], [Icon], [Claim], [ClaimType], [Area], [Controller], [Action], [OrdinalNumber], [Roles], [OpenFor], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (7, 9, N'Tabelat ndihmëse', N'Look up tables', N'fas fa-table', N'22:m', N'22', N'Configuration', N'Tables', N'Index', 2, N'Administrator, ', N'Index', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T10:49:06.780' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:43:34.463' AS DateTime), 1)
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
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (6, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'51', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (12, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'12', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (13, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'52', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (14, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'52', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (15, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'52', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (16, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'52', N'd')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (17, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'53', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (18, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'53', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (19, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'53', N'd')
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
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (33, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'21', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (34, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'm')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (35, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'15', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (36, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'r')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (37, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'c')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (38, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'e')
INSERT [dbo].[AspNetRoleClaims] ([Id], [RoleId], [ClaimType], [ClaimValue]) VALUES (39, N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'22', N'd')
SET IDENTITY_INSERT [dbo].[AspNetRoleClaims] OFF
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name], [NameSQ], [NameEN], [Description], [NormalizedName], [ConcurrencyStamp]) VALUES (N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0', N'Administrator', N'Administrator', N'Administrator', N'Administrator', N'ADMINISTRATOR', N'ce58aeea-b561-4172-bbe1-48e100dab361')
GO
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'6dce687e-0a9c-4bcf-aa79-65c13a8b8db0')
GO
INSERT [dbo].[AspNetUsers] ([Id], [UserName], [PersonalNumber], [FirstName], [LastName], [PhoneNumber], [Email], [NormalizedUserName], [NormalizedEmail], [PhoneNumberConfirmed], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount], [ProfileImage], [AllowNotification], [Language], [AppMode], [InsertedFrom], [InsertedDate]) VALUES (N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', N'darthvader', N'0123456789', N'Darth', N'Vader', N'38345996688', N'darth@vader.com', N'DARTHVADER', N'DARTH@VADER.COM', 0, 1, N'AQAAAAEAADqYAAAAEKiFaFyhfTVRgjD22iUYWtMehV2DiIq3qE/FO5qGJKYqD+xgUHGexWuoDNv/LzMNhw==', N'3PMJXNOQ2MX47ELWSRSNAABEDKXJ2O5U', N'e653befa-b18b-449b-820d-a8695801a996', 0, CAST(N'2022-01-14T14:20:08.8529058+01:00' AS DateTimeOffset), 1, 0, N'/Uploads/Users/096deafc-2539-472a-a510-c275d7e156db.jpg', 0, 1, 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-01-06T16:34:20.557' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Department] ON 

INSERT [dbo].[Department] ([DepartmentID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Administrata', N'Administration', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:47:51.960' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Department] OFF
GO
SET IDENTITY_INSERT [dbo].[DocumentType] ON 

INSERT [dbo].[DocumentType] ([DocumentTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Resume', N'Resume', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:45:26.830' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[DocumentType] OFF
GO
SET IDENTITY_INSERT [dbo].[StaffType] ON 

INSERT [dbo].[StaffType] ([StaffTypeID], [NameSQ], [NameEN], [Active], [InsertedFrom], [InsertedDate], [UpdatedFrom], [UpdatedDate], [UpdatedNo]) VALUES (1, N'Administrata', N'Administration', 1, N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:45:38.720' AS DateTime), N'99b703d2-9e2c-4e3a-b0e9-520f2c13cb3b', CAST(N'2022-06-28T13:48:00.147' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[StaffType] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [EmailIndex]    Script Date: 28-Jun-22 3:48:37 PM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 28-Jun-22 3:48:37 PM ******/
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
ALTER TABLE [dbo].[StaffDepartment]  WITH CHECK ADD  CONSTRAINT [FK_StaffDepartment_StaffType] FOREIGN KEY([StaffTypeID])
REFERENCES [dbo].[StaffType] ([StaffTypeID])
GO
ALTER TABLE [dbo].[StaffDepartment] CHECK CONSTRAINT [FK_StaffDepartment_StaffType]
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
USE [master]
GO
ALTER DATABASE [AMS] SET  READ_WRITE 
GO
