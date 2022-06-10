﻿using AMS.Data.General;
using AMS.Models.Notification;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace AMS.Utilities.NotificationUtil;

public class NotificationUtility
{
    private readonly AMSContext db;
    private readonly IHubContext<NotificationHub> hubContext;

    public NotificationUtility(AMSContext db, IHubContext<NotificationHub> hubContext)
    {
        this.db = db;
        this.hubContext = hubContext;
    }

    public async Task SendNotification(string sender, List<string> receivers, NotificationSend notification)
    {
        await hubContext.Clients.Users(receivers).SendAsync("Notification", notification);

        var notifications = new List<Notification>();
        receivers.ForEach(receiver =>
        {
            notifications.Add(new Notification
            {
                Receiver = receiver,
                Title = notification.title,
                Description = notification.description,
                Url = notification.url,
                Icon = notification.icon,
                Read = false,
                Deleted = false,
                Type = (int)notification.NotificationType,
                InsertedDate = DateTime.Now,
                InsertedFrom = sender,
            });
        });

        await db.Notification.AddRangeAsync(notifications);
        await db.SaveChangesAsync();

        var unreadNotifications = await db.Notification
            .Where(a => receivers.Contains(a.Receiver))
            .Select(a => new
            {
                a.Receiver,
                a.Read
            }).ToListAsync();

        unreadNotifications.Select(a => a.Receiver).Distinct().ToList().ForEach(async receiver =>
        {
            await hubContext.Clients.User(receiver).SendAsync("UnreadNotification", unreadNotifications.Count(a => a.Receiver == receiver && !a.Read));
        });
    }
}
