using AMS.Data.Core;
using AMS.Data.SqlFunctions;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace AMS.Data;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser, ApplicationRole, string>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    #region SQL Functions

    [NotMapped]
    public DbSet<MenuList> MenuList { get; set; }

    [NotMapped]
    public DbSet<MenuListAccess> MenuListAccess { get; set; }

    [NotMapped]
    public DbSet<Logs> Logs { get; set; }

    [NotMapped]
    public DbSet<AttendanceConsecutiveDays> AttendanceConsecutiveDays { get; set; }

    [NotMapped]
    public DbSet<StaffConsecutiveDays> StaffConsecutiveDays { get; set; }

    [NotMapped]
    public DbSet<SearchApplication> SearchApplication { get; set; }

    #endregion

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.Entity<ApplicationUser>().HasIndex(a => new { a.PersonalNumber }).IsUnique(true);

        builder.Entity<MenuList>().HasNoKey();
        builder.Entity<MenuListAccess>().HasNoKey();
        builder.Entity<Logs>().HasNoKey();
        builder.Entity<AttendanceConsecutiveDays>().HasNoKey();
        builder.Entity<StaffConsecutiveDays>().HasNoKey();
        builder.Entity<SearchApplication>().HasNoKey();

        base.OnModelCreating(builder);
    }
}