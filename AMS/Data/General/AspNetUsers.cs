using System;
using System.Collections.Generic;

namespace AMS.Data.General
{
    public partial class AspNetUsers
    {
        public AspNetUsers()
        {
            AbsentTypeInsertedFromNavigation = new HashSet<AbsentType>();
            AbsentTypeUpdatedFromNavigation = new HashSet<AbsentType>();
            AppSettings = new HashSet<AppSettings>();
            AspNetUserClaims = new HashSet<AspNetUserClaims>();
            AspNetUserLogins = new HashSet<AspNetUserLogins>();
            AspNetUserTokens = new HashSet<AspNetUserTokens>();
            CityInsertedFromNavigation = new HashSet<City>();
            CityUpdatedFromNavigation = new HashSet<City>();
            CountryInsertedFromNavigation = new HashSet<Country>();
            CountryUpdatedFromNavigation = new HashSet<Country>();
            DepartmentInsertedFromNavigation = new HashSet<Department>();
            DepartmentUpdatedFromNavigation = new HashSet<Department>();
            DocumentTypeInsertedFromNavigation = new HashSet<DocumentType>();
            DocumentTypeUpdatedFromNavigation = new HashSet<DocumentType>();
            InverseInsertedFromNavigation = new HashSet<AspNetUsers>();
            Log = new HashSet<Log>();
            MenuInsertedFromNavigation = new HashSet<Menu>();
            MenuUpdatedFromNavigation = new HashSet<Menu>();
            NotificationInsertedFromNavigation = new HashSet<Notification>();
            NotificationReceiverNavigation = new HashSet<Notification>();
            RealRoleInsertedFromNavigation = new HashSet<RealRole>();
            RealRoleUpdatedFromNavigation = new HashSet<RealRole>();
            RealRoleUser = new HashSet<RealRole>();
            StaffAttendanceInsertedFromNavigation = new HashSet<StaffAttendance>();
            StaffAttendanceUpdatedFromNavigation = new HashSet<StaffAttendance>();
            StaffDepartmentInsertedFromNavigation = new HashSet<StaffDepartment>();
            StaffDepartmentUpdatedFromNavigation = new HashSet<StaffDepartment>();
            StaffDocumentInsertedFromNavigation = new HashSet<StaffDocument>();
            StaffDocumentUpdatedFromNavigation = new HashSet<StaffDocument>();
            StaffInsertedFromNavigation = new HashSet<Staff>();
            StaffRegistrationStatusInsertedFromNavigation = new HashSet<StaffRegistrationStatus>();
            StaffRegistrationStatusUpdatedFromNavigation = new HashSet<StaffRegistrationStatus>();
            StaffTypeInsertedFromNavigation = new HashSet<StaffType>();
            StaffTypeUpdatedFromNavigation = new HashSet<StaffType>();
            StaffUpdatedFromNavigation = new HashSet<Staff>();
            StaffUser = new HashSet<Staff>();
            StatusTypeInsertedFromNavigation = new HashSet<StatusType>();
            StatusTypeUpdatedFromNavigation = new HashSet<StatusType>();
            SubMenuInsertedFromNavigation = new HashSet<SubMenu>();
            SubMenuUpdatedFromNavigation = new HashSet<SubMenu>();
            Role = new HashSet<AspNetRoles>();
        }

        public string Id { get; set; }
        public string UserName { get; set; }
        public string PersonalNumber { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string NormalizedUserName { get; set; }
        public string NormalizedEmail { get; set; }
        public bool PhoneNumberConfirmed { get; set; }
        public bool EmailConfirmed { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public string ConcurrencyStamp { get; set; }
        public bool TwoFactorEnabled { get; set; }
        public DateTimeOffset? LockoutEnd { get; set; }
        public bool LockoutEnabled { get; set; }
        public int AccessFailedCount { get; set; }
        public string ProfileImage { get; set; }
        public bool AllowNotification { get; set; }
        public int Language { get; set; }
        public int AppMode { get; set; }
        public string InsertedFrom { get; set; }
        public DateTime InsertedDate { get; set; }

        public virtual AspNetUsers InsertedFromNavigation { get; set; }
        public virtual ICollection<AbsentType> AbsentTypeInsertedFromNavigation { get; set; }
        public virtual ICollection<AbsentType> AbsentTypeUpdatedFromNavigation { get; set; }
        public virtual ICollection<AppSettings> AppSettings { get; set; }
        public virtual ICollection<AspNetUserClaims> AspNetUserClaims { get; set; }
        public virtual ICollection<AspNetUserLogins> AspNetUserLogins { get; set; }
        public virtual ICollection<AspNetUserTokens> AspNetUserTokens { get; set; }
        public virtual ICollection<City> CityInsertedFromNavigation { get; set; }
        public virtual ICollection<City> CityUpdatedFromNavigation { get; set; }
        public virtual ICollection<Country> CountryInsertedFromNavigation { get; set; }
        public virtual ICollection<Country> CountryUpdatedFromNavigation { get; set; }
        public virtual ICollection<Department> DepartmentInsertedFromNavigation { get; set; }
        public virtual ICollection<Department> DepartmentUpdatedFromNavigation { get; set; }
        public virtual ICollection<DocumentType> DocumentTypeInsertedFromNavigation { get; set; }
        public virtual ICollection<DocumentType> DocumentTypeUpdatedFromNavigation { get; set; }
        public virtual ICollection<AspNetUsers> InverseInsertedFromNavigation { get; set; }
        public virtual ICollection<Log> Log { get; set; }
        public virtual ICollection<Menu> MenuInsertedFromNavigation { get; set; }
        public virtual ICollection<Menu> MenuUpdatedFromNavigation { get; set; }
        public virtual ICollection<Notification> NotificationInsertedFromNavigation { get; set; }
        public virtual ICollection<Notification> NotificationReceiverNavigation { get; set; }
        public virtual ICollection<RealRole> RealRoleInsertedFromNavigation { get; set; }
        public virtual ICollection<RealRole> RealRoleUpdatedFromNavigation { get; set; }
        public virtual ICollection<RealRole> RealRoleUser { get; set; }
        public virtual ICollection<StaffAttendance> StaffAttendanceInsertedFromNavigation { get; set; }
        public virtual ICollection<StaffAttendance> StaffAttendanceUpdatedFromNavigation { get; set; }
        public virtual ICollection<StaffDepartment> StaffDepartmentInsertedFromNavigation { get; set; }
        public virtual ICollection<StaffDepartment> StaffDepartmentUpdatedFromNavigation { get; set; }
        public virtual ICollection<StaffDocument> StaffDocumentInsertedFromNavigation { get; set; }
        public virtual ICollection<StaffDocument> StaffDocumentUpdatedFromNavigation { get; set; }
        public virtual ICollection<Staff> StaffInsertedFromNavigation { get; set; }
        public virtual ICollection<StaffRegistrationStatus> StaffRegistrationStatusInsertedFromNavigation { get; set; }
        public virtual ICollection<StaffRegistrationStatus> StaffRegistrationStatusUpdatedFromNavigation { get; set; }
        public virtual ICollection<StaffType> StaffTypeInsertedFromNavigation { get; set; }
        public virtual ICollection<StaffType> StaffTypeUpdatedFromNavigation { get; set; }
        public virtual ICollection<Staff> StaffUpdatedFromNavigation { get; set; }
        public virtual ICollection<Staff> StaffUser { get; set; }
        public virtual ICollection<StatusType> StatusTypeInsertedFromNavigation { get; set; }
        public virtual ICollection<StatusType> StatusTypeUpdatedFromNavigation { get; set; }
        public virtual ICollection<SubMenu> SubMenuInsertedFromNavigation { get; set; }
        public virtual ICollection<SubMenu> SubMenuUpdatedFromNavigation { get; set; }

        public virtual ICollection<AspNetRoles> Role { get; set; }
    }
}
