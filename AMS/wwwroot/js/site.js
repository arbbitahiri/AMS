var resources = null;

const ErrorStatus = {
    SUCCESS: 1,
    ERROR: 2,
    WARNING: 3,
    INFO: 4
}

const ReportType = {
    PDF: 1,
    EXCEL: 2,
    WORD: 3
}

const MethodType = {
    POST: 1,
    PUT: 2
}

const LookUpTable = {
    DOCUMENT: 1
}

const SubmitPathType = {
    RELOAD: 1,
    NORELOAD: 2,
    PATH: 3
}

const StatusType = {
    APPROVED: 1,
    REJECTED: 2,
    PENDING: 3
}

var arrows = {
    leftArrow: '<i class="la la-angle-left"></i>',
    rightArrow: '<i class="la la-angle-right"></i>'
}

$(document).ready(function () {
    resources = $.getJSON('/culture/general/' + culture + '.json');

    $('.fade-in').hide().fadeIn(2000);

    if (culture == 'sq-AL') {
        $("input[type='text']").prop('spellcheck', false);
        $('textarea').prop('spellcheck', false);
    } else {
        $("input[type='text']").prop('spellcheck', true);
        $('textarea').prop('spellcheck', true);
    }

    $.fn.datepicker.dates.sq = {
        days: ["E dielë", "E hënë", "E martë", "E mërkurë", "E enjte", "E premte", "E shtunë"],
        daysShort: ["Die", "Hën", "Mar", "Mër", "Enj", "Pre", "Sht"],
        daysMin: ["D", "H", "Ma", "Më", "E", "P", "Sh"],
        months: ["Janar", "Shkurt", "Mars", "Prill", "Maj", "Qershor", "Korrik", "Gusht", "Shtator", "Tetor", "Nentor", "Dhjetor"],
        monthsShort: ["Jan", "Shk", "Mar", "Pri", "Maj", "Qer", "Kor", "Gus", "Sht", "Tet", "Nen", "Dhj"],
        today: "Sot",
        clear: "Fshije",
        format: "dd/mm/yyyy",
        titleFormat: "MM yyyy",
        weekStart: 1
    };

    $.fn.datepicker.dates.en = {
        days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        daysMin: ["Su", "M", "Tu", "W", "Th", "F", "Sa"],
        months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        today: "Today",
        clear: "Clear",
        format: "dd/mm/yyyy",
        titleFormat: "MM yyyy",
        weekStart: 1
    };

    $.fn.datepicker.dates.sr = {
        days: ["Nedelja", "Ponedeljak", "Utorak", "Sreda", "Četvrtak", "Petak", "Subota"],
        daysShort: ["Ned", "Pon", "Uto", "Sre", "Čet", "Pet", "Sub"],
        daysMin: ["N", "Po", "U", "Sr", "Č", "Pe", "Su"],
        months: ["Januara", "Februara", "Marta", "April", "Može", "Juna", "Jul", "Avgusta", "Septembar", "Oktobar", "Novembar", "Decembar"],
        monthsShort: ["Jan", "Feb", "Mar", "Apr", "Maž", "Jun", "Jul", "Avg", "Sep", "Okt", "Nov", "Dec"],
        today: "Danas",
        clear: "Jasno",
        format: "dd/mm/yyyy",
        titleFormat: "MM yyyy",
        weekStart: 1
    };
});

function show_loading() {
    $('#mdl_load').modal('show');
}

function hide_loading(timeout = 0) {
    setTimeout(function () {
        $('#mdl_load').modal('hide');
    }, timeout);
}

function handle_success(data, path_type, path) {
    if (data.status == ErrorStatus.SUCCESS) {
        Swal.fire({
            icon: 'success',
            title: data.title,
            text: data.description,
            timer: 2000,
            timerProgressBar: true,
            showConfirmButton: false
        }).then((result) => {
            if (path_type == SubmitPathType.RELOAD) {
                window.location.reload();
            } else if (path_type == SubmitPathType.PATH) {
                window.location.href = path;
            } else { }
        });
    } else if (data.status == ErrorStatus.WARNING) {
        Swal.fire({
            icon: 'warning',
            title: data.title,
            text: data.description,
            confirmButtonText: resources.responseJSON.Okay
        });
    } else if (data.status == ErrorStatus.ERROR) {
        Swal.fire({
            icon: 'error',
            title: data.title,
            text: data.description,
            confirmButtonText: resources.responseJSON.Okay
        });
    } else if (data.status == ErrorStatus.INFO) {
        Swal.fire({
            icon: 'info',
            title: data.title,
            text: data.description,
            confirmButtonText: resources.responseJSON.Okay
        });
    }
}

$(document).on('submit', 'form:not(.no-loading)', function () {
    show_loading();
    $(this).find('button[type="submit"]').attr('disabled', 'disabled');
});

$(document).ajaxComplete(function () {
    hide_loading(500);
    $(this).find('button[type="submit"]').removeAttr('disabled', 'disabled');
});

$(document).ajaxError(function (error) {
    if (error.handleObj.handler.arguments[1].status == 403) {
        Swal.fire({
            icon: 'error',
            title: resources.responseJSON.AccessDenied,
            text: resources.responseJSON.AccessDeniedLong,
            confirmButtonText: resources.responseJSON.Okay
        });
    } else if (error.handleObj.handler.arguments[1].status == 0) {
        // ajax from ajax
    } else if (error.handleObj.handler.arguments[1].status == 307) {
        window.location.href = '/Home/Index';
    } else {
        Swal.fire({
            icon: 'error',
            title: resources.responseJSON.Error,
            text: resources.responseJSON.ErrorProcessingData,
            confirmButtonText: resources.responseJSON.Okay
        });
    }
});

$(document).on('invalid-form.validate', 'form', function () {
    hide_loading();
});

function change_role(ide) {
    show_loading();
    $.post('/Home/ChangeRole', {
        ide: ide
    }, function (data) {
        hide_loading();
        handle_success(data, SubmitPathType.RELOAD, "");
        setTimeout(function () {
            window.location.href = '/Home/Index';
        }, 2000);
    });
}

function change_mode(e) {
    show_loading();
    $.post('/Home/ChangeMode', {
        mode: $(e).is(':checked')
    }, function (data) {
        hide_loading();
        handle_success(data, SubmitPathType.RELOAD, "");
        $('[aria-labelledby="swal2-title"]').css('width', '12em');
    });
}

function format_currency(data) {
    return parseFloat(data, 10).toFixed(2);
}

function get_notifications() {
    connection.invoke('Notifications');
}

function mark_as_read(ide, e) {
    $('#notifications_list').on("click", function (event) {
        event.stopPropagation();
    });

    $.post('/Home/MarkAsReadNotification', {
        ide: ide
    }, function (data) {
        $(e).find("i").removeClass("far");
        $(e).find("i").addClass("fas");

        connection.invoke('Notifications');
    });
}

function delete_notification(ide) {
    $('#notifications_list').on("click", function (event) {
        event.stopPropagation();
    });

    $.post('/Home/DeleteNotification', {
        ide: ide
    }, function (data) {
        connection.invoke('Notifications');
    });
}

function mark_all_as_read() {
    $('#notifications_list').addClass("show");

    $.post('/Home/MarkAsReadAllNotification', function (data) {
        connection.invoke('Notifications');
    });
}

function delete_all_notification() {
    $('#notifications_list').addClass("show");

    $.post('/Home/DeleteAllNotification', function (data) {
        connection.invoke('Notifications');
    });
}

function change_notification_mode(e) {
    if ($(e).is(':checked')) {
        Notification.requestPermission().then(function (permission) {
            if (permission == "granted") {
                subscribeUser();
            }
        });
    } else {
        unsubscribeUser();
    }
}

function display_notification(description, title, url, target, notification_type, background) {
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 2000,
        timerProgressBar: true,
        customClass: {
            title: 'swal2-title'
        },
        background: background,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
            toast.addEventListener('click', function () {
                window.open(url, target);
            });
        }
    })

    Toast.fire({
        icon: notification_type,
        title: title,
        text: description,
    });

    $('.swal2-backdrop-show').css("cursor", "pointer");
}

function format_repo(repo) {
    if (repo.loading) {
        return repo.text;
    }

    var $container = $(
        '<span class="d-flex align-items-center">' + repo.text + '</span>'
    );
    return $container;
}

function format_repo_selection(repo) {
    return repo.text;
}

function quick_search() {
    $('#kt_quick_search_result').load('/Home/Search');
}
