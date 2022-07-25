using Microsoft.EntityFrameworkCore;

namespace AMS.Data.General;

public partial class AMSContext : DbContext
{
    public AMSContext()
    {
    }

    public AMSContext(DbContextOptions<AMSContext> options)
        : base(options)
    {
    }

    public virtual DbSet<AbsentType> AbsentType { get; set; }
    public virtual DbSet<AppSettings> AppSettings { get; set; }
    public virtual DbSet<AspNetRoleClaims> AspNetRoleClaims { get; set; }
    public virtual DbSet<AspNetRoles> AspNetRoles { get; set; }
    public virtual DbSet<AspNetUser> AspNetUser { get; set; }
    public virtual DbSet<AspNetUserClaims> AspNetUserClaims { get; set; }
    public virtual DbSet<AspNetUserLogins> AspNetUserLogins { get; set; }
    public virtual DbSet<AspNetUserTokens> AspNetUserTokens { get; set; }
    public virtual DbSet<AspNetUsers> AspNetUsers { get; set; }
    public virtual DbSet<City> City { get; set; }
    public virtual DbSet<Country> Country { get; set; }
    public virtual DbSet<Department> Department { get; set; }
    public virtual DbSet<DocumentType> DocumentType { get; set; }
    public virtual DbSet<Gender> Gender { get; set; }
    public virtual DbSet<Log> Log { get; set; }
    public virtual DbSet<Menu> Menu { get; set; }
    public virtual DbSet<Notification> Notification { get; set; }
    public virtual DbSet<RealRole> RealRole { get; set; }
    public virtual DbSet<Staff> Staff { get; set; }
    public virtual DbSet<StaffDepartment> StaffDepartment { get; set; }
    public virtual DbSet<StaffDepartmentAttendance> StaffDepartmentAttendance { get; set; }
    public virtual DbSet<StaffDocument> StaffDocument { get; set; }
    public virtual DbSet<StaffRegistrationStatus> StaffRegistrationStatus { get; set; }
    public virtual DbSet<StaffType> StaffType { get; set; }
    public virtual DbSet<StatusType> StatusType { get; set; }
    public virtual DbSet<SubMenu> SubMenu { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
            optionsBuilder.UseSqlServer("Server=ARBTAHIRI;Database=AMS;Trusted_Connection=True;MultipleActiveResultSets=true");
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AbsentType>(entity =>
        {
            entity.Property(e => e.AbsentTypeId).HasColumnName("AbsentTypeID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.AbsentTypeInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AbsentType_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.AbsentTypeUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_AbsentType_AspNetUsers_Updated");
        });

        modelBuilder.Entity<AppSettings>(entity =>
        {
            entity.ToTable("AppSettings", "His");

            entity.Property(e => e.AppSettingsId).HasColumnName("AppSettingsID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NewVersion).IsRequired();

            entity.Property(e => e.OldVersion).IsRequired();

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.AppSettings)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AppSettings_AspNetUsers");
        });

        modelBuilder.Entity<AspNetRoleClaims>(entity =>
        {
            entity.HasIndex(e => e.RoleId, "IX_AspNetRoleClaims_RoleId");

            entity.Property(e => e.RoleId).IsRequired();

            entity.HasOne(d => d.Role)
                .WithMany(p => p.AspNetRoleClaims)
                .HasForeignKey(d => d.RoleId);
        });

        modelBuilder.Entity<AspNetRoles>(entity =>
        {
            entity.HasIndex(e => e.NormalizedName, "RoleNameIndex")
                .IsUnique()
                .HasFilter("([NormalizedName] IS NOT NULL)");

            entity.Property(e => e.Description).HasMaxLength(512);

            entity.Property(e => e.Name).HasMaxLength(256);

            entity.Property(e => e.NameEn)
                .HasMaxLength(256)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .HasMaxLength(256)
                .HasColumnName("NameSQ");

            entity.Property(e => e.NormalizedName).HasMaxLength(256);
        });

        modelBuilder.Entity<AspNetUser>(entity =>
        {
            entity.ToTable("AspNetUser", "His");

            entity.Property(e => e.AspNetUserId).HasColumnName("AspNetUserID");

            entity.Property(e => e.Email).HasMaxLength(256);

            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.LastName)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.NormalizedEmail).HasMaxLength(256);

            entity.Property(e => e.NormalizedUserName).HasMaxLength(256);

            entity.Property(e => e.PersonalNumber)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.ProfileImage).HasMaxLength(512);

            entity.Property(e => e.UserId)
                .IsRequired()
                .HasMaxLength(450)
                .HasColumnName("UserID");

            entity.Property(e => e.UserName).HasMaxLength(256);
        });

        modelBuilder.Entity<AspNetUserClaims>(entity =>
        {
            entity.HasIndex(e => e.UserId, "IX_AspNetUserClaims_UserId");

            entity.Property(e => e.UserId).IsRequired();

            entity.HasOne(d => d.User)
                .WithMany(p => p.AspNetUserClaims)
                .HasForeignKey(d => d.UserId);
        });

        modelBuilder.Entity<AspNetUserLogins>(entity =>
        {
            entity.HasKey(e => new { e.LoginProvider, e.ProviderKey });

            entity.HasIndex(e => e.UserId, "IX_AspNetUserLogins_UserId");

            entity.Property(e => e.LoginProvider).HasMaxLength(128);

            entity.Property(e => e.ProviderKey).HasMaxLength(128);

            entity.Property(e => e.UserId).IsRequired();

            entity.HasOne(d => d.User)
                .WithMany(p => p.AspNetUserLogins)
                .HasForeignKey(d => d.UserId);
        });

        modelBuilder.Entity<AspNetUserTokens>(entity =>
        {
            entity.HasKey(e => new { e.UserId, e.LoginProvider, e.Name });

            entity.Property(e => e.LoginProvider).HasMaxLength(128);

            entity.Property(e => e.Name).HasMaxLength(128);

            entity.HasOne(d => d.User)
                .WithMany(p => p.AspNetUserTokens)
                .HasForeignKey(d => d.UserId);
        });

        modelBuilder.Entity<AspNetUsers>(entity =>
        {
            entity.HasIndex(e => e.NormalizedEmail, "EmailIndex");

            entity.HasIndex(e => e.NormalizedUserName, "UserNameIndex")
                .IsUnique()
                .HasFilter("([NormalizedUserName] IS NOT NULL)");

            entity.Property(e => e.Email).HasMaxLength(256);

            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.LastName)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.NormalizedEmail).HasMaxLength(256);

            entity.Property(e => e.NormalizedUserName).HasMaxLength(256);

            entity.Property(e => e.PersonalNumber)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.ProfileImage).HasMaxLength(512);

            entity.Property(e => e.UserName).HasMaxLength(256);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.InverseInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AspNetUsers_AspNetUsers_Inserted");

            entity.HasMany(d => d.Role)
                .WithMany(p => p.User)
                .UsingEntity<Dictionary<string, object>>(
                    "AspNetUserRoles",
                    l => l.HasOne<AspNetRoles>().WithMany().HasForeignKey("RoleId"),
                    r => r.HasOne<AspNetUsers>().WithMany().HasForeignKey("UserId"),
                    j =>
                    {
                        j.HasKey("UserId", "RoleId");

                        j.ToTable("AspNetUserRoles");

                        j.HasIndex(new[] { "RoleId" }, "IX_AspNetUserRoles_RoleId");
                    });
        });

        modelBuilder.Entity<City>(entity =>
        {
            entity.ToTable("City", "Core");

            entity.Property(e => e.CityId).HasColumnName("CityID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.CityInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_City_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.CityUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_City_AspNetUsers_Updated");
        });

        modelBuilder.Entity<Country>(entity =>
        {
            entity.ToTable("Country", "Core");

            entity.Property(e => e.CountryId).HasColumnName("CountryID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.CountryInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Country_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.CountryUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_Country_AspNetUsers_Updated");
        });

        modelBuilder.Entity<Department>(entity =>
        {
            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.DepartmentInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Department_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.DepartmentUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_Department_AspNetUsers_Updated");
        });

        modelBuilder.Entity<DocumentType>(entity =>
        {
            entity.Property(e => e.DocumentTypeId).HasColumnName("DocumentTypeID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.DocumentTypeInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DocumentType_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.DocumentTypeUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_DocumentType_AspNetUsers_Updated");
        });

        modelBuilder.Entity<Gender>(entity =>
        {
            entity.ToTable("Gender", "Core");

            entity.Property(e => e.GenderId).HasColumnName("GenderID");

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(50)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(50)
                .HasColumnName("NameSQ");
        });

        modelBuilder.Entity<Log>(entity =>
        {
            entity.ToTable("Log", "Core");

            entity.Property(e => e.LogId).HasColumnName("LogID");

            entity.Property(e => e.Action)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.Controller)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.Description).HasMaxLength(128);

            entity.Property(e => e.Developer).HasMaxLength(32);

            entity.Property(e => e.FormContent).HasMaxLength(2048);

            entity.Property(e => e.HttpMethod)
                .IsRequired()
                .HasMaxLength(24);

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.Ip)
                .IsRequired()
                .HasMaxLength(64)
                .HasColumnName("IP");

            entity.Property(e => e.Url)
                .IsRequired()
                .HasMaxLength(1024);

            entity.Property(e => e.UserId)
                .HasMaxLength(450)
                .HasColumnName("UserID");

            entity.HasOne(d => d.User)
                .WithMany(p => p.Log)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_Log_AspNetUsers");
        });

        modelBuilder.Entity<Menu>(entity =>
        {
            entity.ToTable("Menu", "Core");

            entity.Property(e => e.MenuId).HasColumnName("MenuID");

            entity.Property(e => e.Action).HasMaxLength(128);

            entity.Property(e => e.Area).HasMaxLength(128);

            entity.Property(e => e.Claim).HasMaxLength(128);

            entity.Property(e => e.ClaimType).HasMaxLength(128);

            entity.Property(e => e.Controller).HasMaxLength(128);

            entity.Property(e => e.Icon).HasMaxLength(128);

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.Roles).HasMaxLength(2048);

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.MenuInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Menu_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.MenuUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_Menu_AspNetUsers_Updated");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.ToTable("Notification", "Core");

            entity.Property(e => e.NotificationId).HasColumnName("NotificationID");

            entity.Property(e => e.Description).HasMaxLength(1024);

            entity.Property(e => e.Icon)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.Receiver)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.Title)
                .IsRequired()
                .HasMaxLength(512);

            entity.Property(e => e.Url).HasMaxLength(1024);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.NotificationInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Notification_AspNetUsers_Inserted");

            entity.HasOne(d => d.ReceiverNavigation)
                .WithMany(p => p.NotificationReceiverNavigation)
                .HasForeignKey(d => d.Receiver)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Notification_AspNetUsers");
        });

        modelBuilder.Entity<RealRole>(entity =>
        {
            entity.ToTable("RealRole", "Core");

            entity.Property(e => e.RealRoleId).HasColumnName("RealRoleID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.RoleId)
                .IsRequired()
                .HasMaxLength(450)
                .HasColumnName("RoleID");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.Property(e => e.UserId)
                .IsRequired()
                .HasMaxLength(450)
                .HasColumnName("UserID");

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.RealRoleInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RealRole_AspNetUsers_Inserted");

            entity.HasOne(d => d.Role)
                .WithMany(p => p.RealRole)
                .HasForeignKey(d => d.RoleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RealRole_AspNetRoles");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.RealRoleUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_RealRole_AspNetUsers_Updated");

            entity.HasOne(d => d.User)
                .WithMany(p => p.RealRoleUser)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_RealRole_AspNetUsers");
        });

        modelBuilder.Entity<Staff>(entity =>
        {
            entity.Property(e => e.StaffId).HasColumnName("StaffID");

            entity.Property(e => e.Address).HasMaxLength(256);

            entity.Property(e => e.BirthDate).HasColumnType("date");

            entity.Property(e => e.CityId).HasColumnName("CityID");

            entity.Property(e => e.CountryId).HasColumnName("CountryID");

            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.GenderId).HasColumnName("GenderID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.LastName)
                .IsRequired()
                .HasMaxLength(128);

            entity.Property(e => e.PersonalNumber)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(e => e.PostalCode).HasMaxLength(12);

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.Property(e => e.UserId)
                .HasMaxLength(450)
                .HasColumnName("UserID");

            entity.HasOne(d => d.City)
                .WithMany(p => p.Staff)
                .HasForeignKey(d => d.CityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Staff_City");

            entity.HasOne(d => d.Country)
                .WithMany(p => p.Staff)
                .HasForeignKey(d => d.CountryId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Staff_Country");

            entity.HasOne(d => d.Gender)
                .WithMany(p => p.Staff)
                .HasForeignKey(d => d.GenderId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Staff_Gender");

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.StaffInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Staff_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.StaffUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_Staff_AspNetUsers_Updated");

            entity.HasOne(d => d.User)
                .WithMany(p => p.StaffUser)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_Staff_AspNetUsers");
        });

        modelBuilder.Entity<StaffDepartment>(entity =>
        {
            entity.Property(e => e.StaffDepartmentId).HasColumnName("StaffDepartmentID");

            entity.Property(e => e.DepartmentId).HasColumnName("DepartmentID");

            entity.Property(e => e.Description).HasMaxLength(2048);

            entity.Property(e => e.EndDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.StaffId).HasColumnName("StaffID");

            entity.Property(e => e.StaffTypeId).HasColumnName("StaffTypeID");

            entity.Property(e => e.StartDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.Department)
                .WithMany(p => p.StaffDepartment)
                .HasForeignKey(d => d.DepartmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDepartment_Department");

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.StaffDepartmentInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDepartment_AspNetUsers_Inserted");

            entity.HasOne(d => d.Staff)
                .WithMany(p => p.StaffDepartment)
                .HasForeignKey(d => d.StaffId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDepartment_Staff");

            entity.HasOne(d => d.StaffType)
                .WithMany(p => p.StaffDepartment)
                .HasForeignKey(d => d.StaffTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDepartment_StaffType");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.StaffDepartmentUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_StaffDepartment_AspNetUsers_Updated");
        });

        modelBuilder.Entity<StaffDepartmentAttendance>(entity =>
        {
            entity.Property(e => e.StaffDepartmentAttendanceId).HasColumnName("StaffDepartmentAttendanceID");

            entity.Property(e => e.Description).HasMaxLength(2048);

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.StaffDepartmentId).HasColumnName("StaffDepartmentID");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.StaffDepartmentAttendanceInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDepartmentAttendance_AspNetUsers_Inserted");

            entity.HasOne(d => d.StaffDepartment)
                .WithMany(p => p.StaffDepartmentAttendance)
                .HasForeignKey(d => d.StaffDepartmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDepartmentAttendance_StaffDepartment");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.StaffDepartmentAttendanceUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_StaffDepartmentAttendance_AspNetUsers_Updated");
        });

        modelBuilder.Entity<StaffDocument>(entity =>
        {
            entity.Property(e => e.StaffDocumentId).HasColumnName("StaffDocumentID");

            entity.Property(e => e.Description).HasMaxLength(2048);

            entity.Property(e => e.DocumentTypeId).HasColumnName("DocumentTypeID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.Path)
                .IsRequired()
                .HasMaxLength(2048);

            entity.Property(e => e.StaffId).HasColumnName("StaffID");

            entity.Property(e => e.Title)
                .IsRequired()
                .HasMaxLength(256);

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.DocumentType)
                .WithMany(p => p.StaffDocument)
                .HasForeignKey(d => d.DocumentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDocument_DocumentType");

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.StaffDocumentInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDocument_AspNetUsers_Inserted");

            entity.HasOne(d => d.Staff)
                .WithMany(p => p.StaffDocument)
                .HasForeignKey(d => d.StaffId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffDocument_Staff");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.StaffDocumentUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_StaffDocument_AspNetUsers_Updated");
        });

        modelBuilder.Entity<StaffRegistrationStatus>(entity =>
        {
            entity.Property(e => e.StaffRegistrationStatusId).HasColumnName("StaffRegistrationStatusID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.StaffId).HasColumnName("StaffID");

            entity.Property(e => e.StatusTypeId).HasColumnName("StatusTypeID");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.StaffRegistrationStatusInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffRegistrationStatus_AspNetUsers_Inserted");

            entity.HasOne(d => d.Staff)
                .WithMany(p => p.StaffRegistrationStatus)
                .HasForeignKey(d => d.StaffId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffRegistrationStatus_Staff");

            entity.HasOne(d => d.StatusType)
                .WithMany(p => p.StaffRegistrationStatus)
                .HasForeignKey(d => d.StatusTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffRegistrationStatus_StatusType");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.StaffRegistrationStatusUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_StaffRegistrationStatus_AspNetUsers_Updated");
        });

        modelBuilder.Entity<StaffType>(entity =>
        {
            entity.Property(e => e.StaffTypeId).HasColumnName("StaffTypeID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.StaffTypeInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StaffType_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.StaffTypeUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_StaffType_AspNetUsers_Updated");
        });

        modelBuilder.Entity<StatusType>(entity =>
        {
            entity.ToTable("StatusType", "Core");

            entity.Property(e => e.StatusTypeId).HasColumnName("StatusTypeID");

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.StatusTypeInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_StatusType_AspNetUsers_Inserted");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.StatusTypeUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_StatusType_AspNetUsers_Updated");
        });

        modelBuilder.Entity<SubMenu>(entity =>
        {
            entity.ToTable("SubMenu", "Core");

            entity.Property(e => e.SubMenuId).HasColumnName("SubMenuID");

            entity.Property(e => e.Action).HasMaxLength(128);

            entity.Property(e => e.Area).HasMaxLength(128);

            entity.Property(e => e.Claim).HasMaxLength(128);

            entity.Property(e => e.ClaimType).HasMaxLength(128);

            entity.Property(e => e.Controller).HasMaxLength(128);

            entity.Property(e => e.Icon).HasMaxLength(128);

            entity.Property(e => e.InsertedDate).HasColumnType("datetime");

            entity.Property(e => e.InsertedFrom)
                .IsRequired()
                .HasMaxLength(450);

            entity.Property(e => e.MenuId).HasColumnName("MenuID");

            entity.Property(e => e.NameEn)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameEN");

            entity.Property(e => e.NameSq)
                .IsRequired()
                .HasMaxLength(128)
                .HasColumnName("NameSQ");

            entity.Property(e => e.Roles).HasMaxLength(2048);

            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.Property(e => e.UpdatedFrom).HasMaxLength(450);

            entity.HasOne(d => d.InsertedFromNavigation)
                .WithMany(p => p.SubMenuInsertedFromNavigation)
                .HasForeignKey(d => d.InsertedFrom)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SubMenu_AspNetUsers_Inserted");

            entity.HasOne(d => d.Menu)
                .WithMany(p => p.SubMenu)
                .HasForeignKey(d => d.MenuId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_SubMenu_Menu");

            entity.HasOne(d => d.UpdatedFromNavigation)
                .WithMany(p => p.SubMenuUpdatedFromNavigation)
                .HasForeignKey(d => d.UpdatedFrom)
                .HasConstraintName("FK_SubMenu_AspNetUsers_Updated");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
