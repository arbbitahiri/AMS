$(function ($) {
    $.validator.addMethod('fileextension', function (value, element, params) {
        if (value == "")
            return true;
        var allowedExtensions = params.expectedvalue.split(',');
        var extension = value.substr(value.lastIndexOf('.')).toLowerCase();
        return allowedExtensions.includes(extension);
    });

    $.validator.unobtrusive.adapters.add('fileextension', ['formats'],
        function (options) {
            options.rules['fileextension'] = {
                expectedvalue: options.params['formats']
            };
            options.messages['fileextension'] = options.message;
        });

    $.validator.addMethod('arrayval', function (value, element, params) {
        if (value == "")
            return false;
        var attachedElem = value.split(',');
        var requiredItems = parseInt(params.nr);
        return requiredItems <= attachedElem.length;
    });

    $.validator.unobtrusive.adapters.add('arrayval', ['nr'],
        function (options) {
            options.rules['arrayval'] = {
                nr: options.params['nr']
            };
            options.messages['arrayval'] = options.message;
        });

    //$.validator.addMethod('dategreaterthantoday', function (value, element, params) {
    //    if (value == "")
    //        return false;
    //    var currentDate = new Date();
    //    var datestr = (value.split(' ')[0]).split('/');
    //    var timestr = value.split(' ')[1].split(':');
    //    var selectedDate = new Date(datestr[2], parseInt(datestr[1]) - 1, datestr[0], timestr[0], timestr[1]);
    //    return currentDate.getTime() <= selectedDate.getTime();
    //});

    //$.validator.unobtrusive.adapters.add('dategreaterthantoday',
    //    function (options) {
    //        options.rules['dategreaterthantoday'] = {
    //        };
    //        options.messages['dategreaterthantoday'] = options.message;
    //    });

    $.validator.addMethod('maxfilesize', function (value, element, params) {
        if (element.files.length > 0) {
            var fileSize = element.files[0].size;
            var maxAllowedSize = parseFloat(params.dependsOn) * 1024;
            return !(fileSize > maxAllowedSize);
        } else {
            return true;
        }
    });

    $.validator.unobtrusive.adapters.add('maxfilesize', ['size'],
        function (options) {
            options.rules['maxfilesize'] = {
                dependsOn: options.params['size']
            };
            options.messages['maxfilesize'] = options.message;
        });

    $.validator.addMethod('requiredif', function (value, element, params) {
        if ($('#' + params['requiredif']).val() == params['requiredIfValue']) {
            return $(element).val() != "";
        }
        return true;
    });

    $.validator.unobtrusive.adapters.add('requiredif',
        function (options) {
            options.rules['requiredif'] = {
                requiredif: options.element.dataset['valRequiredifValue'],
                requiredIfValue: options.element.dataset['valRequiredifValueon']
            };
            options.messages['requiredif'] = options.message;
        });

    $.validator.addMethod('requiredifnot', function (value, element, params) {
        if ($('#' + params['requiredifnot']).val() != params['requiredIfNotValue']) {
            return $(element).val() != "";
        }
        return true;
    });

    $.validator.unobtrusive.adapters.add('requiredifnot',
        function (options) {
            options.rules['requiredifnot'] = {
                requiredifnot: options.element.dataset['valRequiredifnotValue'],
                requiredIfNotValue: options.element.dataset['valRequiredifnotValueon']
            };
            options.messages['requiredifnot'] = options.message;
        });

    $.validator.addMethod('datecompare', function (value, element, params) {
        if (value == "")
            return true;
        var currentStr = $('#' + params["datecompare"]).val().split(' ')[0].split('/');
        var currentDate = new Date(currentStr[2], parseInt(currentStr[1]) - 1, parseInt(currentStr[0]) + 1);
        var datestr = (value.split(' ')[0]).split('/');
        var selectedDate = new Date(datestr[2], parseInt(datestr[1]) - 1, parseInt(datestr[0]) + 1);

        if (currentDate.getTime() > selectedDate.getTime()) {
            return false;
        }
        return true;
    });

    $.validator.unobtrusive.adapters.add('datecompare',
        function (options) {
            options.rules['datecompare'] = {
                datecompare: options.element.dataset['valDatecompareValue'],
                datecompareValue: options.element.dataset['valDatecompareValueon']
            };
            options.messages['datecompare'] = options.message;
        });

    $.validator.unobtrusive.adapters.add("requiredifchecked", ["depend", "value"], function (options) {
        options.rules["requiredifchecked"] = options.params;
        options.messages["requiredifchecked"] = options.message;
    });

    $.validator.addMethod("requiredifchecked", function (value, elements, params) {
        debugger
        if (elements.hasAttribute('[data-switch="true"]')) {
            if ((params.value == 'True' ? true : false) == $('#' + params.depend).bootstrapSwitch('state')) {
                if (value == "" || value == null || value == undefined) {
                    return false;
                } else {
                    return true
                }
            } else {
                return true;

            }
        } else {
            if ((params.value == 'True' ? true : false) == $('#' + params.depend).is(":checked")) {
                if (value == "" || value == null || value == undefined) {
                    return false;
                } else {
                    return true
                }
            } else {
                return true;

            }
        }
    });

    $.validator.addMethod('requirediftrue', function (value, element, params) {
        if ($('#' + params.requirediftrue).is(':checked') == (params.requiredIfTrueValue == "True" ? true : false)) {
            return $(element).val() != "";
        }
        return true;
    });

    $.validator.unobtrusive.adapters.add('requirediftrue',
        function (options) {
            options.rules['requirediftrue'] = {
                requirediftrue: options.element.dataset['valRequirediftrueValue'],
                requiredIfTrueValue: options.element.dataset['valRequirediftrueValueon']
            };
            options.messages['requirediftrue'] = options.message;
        });

    $.validator.unobtrusive.adapters.add("rangeif", ["min", "max", "depend", 'dependvalue'], function (options) {
        options.rules["rangeif"] = options.params;
        options.messages["rangeif"] = options.message;
    });

    $.validator.addMethod("rangeif", function (value, elements, params) {
        if (value) {
            var newvalue = parseFloat(value);
            if (newvalue > parseFloat(params.max) && $('#' + params.depend).val() == params.dependvalue) {
                return false;
            }
        }
        return true;
    });

    $.validator.addMethod('dategreaterthantoday', function (value, element, params) {
        if (value == "")
            return false;
        var currentDate = new Date();
        var datestr = (value.split(' ')[0]).split('/');
        var selectedDate = new Date(datestr[2], parseInt(datestr[1]) - 1, parseInt(datestr[0]) + 1);

        return selectedDate.getTime() - 1000 * 60 > currentDate.getTime();
    });

    $.validator.unobtrusive.adapters.add('dategreaterthantoday',
        function (options) {
            options.rules['dategreaterthantoday'] = {
            };
            options.messages['dategreaterthantoday'] = options.message;
        });

    $.validator.setDefaults({
        ignore: [],
    });

    $.validator.addMethod('overeightteen', function (value, element, params) {

        if (value == "")
            return false;
        var currentDate = new Date();
        var datestr = (value.split(' ')[0]).split('/');
        var selectedDate = new Date(datestr[2], parseInt(datestr[1]) - 1, parseInt(datestr[0]) + 1);
        var diffTime = currentDate.getTime() - selectedDate.getTime();
        var days = diffTime / (1000 * 3600 * 24);
        return days > 18 * 364;

    });

    $.validator.unobtrusive.adapters.add('overeightteen',
        function (options) {

            options.rules['overeightteen'] = {
            };
            options.messages['overeightteen'] = options.message;
        });

    $.validator.setDefaults({
        ignore: [],
    });

}(jQuery));