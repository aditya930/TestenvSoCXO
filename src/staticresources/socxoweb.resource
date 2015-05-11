function AlertMessage(n) {
    $(".ShowAlert").empty();
    $(".ShowAlert").html(n);
    $(".ShowAlert").show();
    setTimeout(function() {
        $(".ShowAlert").fadeOut()
    }, 5e3)
}

function SuccessMessage(n) {
    $(".ShowSuccessinfo").empty();
    $(".ShowSuccessinfo").html(n);
    $(".ShowSuccessinfo").show();
    setTimeout(function() {
        $(".ShowSuccessinfo").fadeOut()
    }, 5e3)
}

function InfoMessage(n) {
    $(".ShowInfo").empty();
    $(".ShowInfo").html(n);
    $(".ShowInfo").show();
    setTimeout(function() {
        $(".ShowInfo").fadeOut()
    }, 5e3)
}

function IsValidForm(n) {
    var t = !0;
    return $("#" + n).find('[data-val="true"]').each(function() {
        $(this).valid() || (t = !1)
    }), $(".dynamic-div-validation-error").remove(), $("textarea").each(function() {
        $(this).css("display") != "none" && ($(this).val().match(/<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/) ? ($(this).parent().append("<div class='dynamic-div-validation-error'>Remove characters ('<' ,'>') <\/div>"), t = !1) : $(this).val().match(/[\<+]/g) && ($(this).parent().append("<div class='dynamic-div-validation-error'>Remove characters ('<' ,'>')<\/div>"), t = !1))
    }), $("input:text").each(function() {
        $(this).val().match(/<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/) ? ($(this).parent().append("<div class='dynamic-div-validation-error'>Remove characters ('<' ,'>')<\/div>"), t = !1) : $(this).val().match(/[\<+]/g) && ($(this).parent().append("<div class='dynamic-div-validation-error'>Remove characters ('<' ,'>')<\/div>"), t = !1)
    }), t
}

function TrimText(n, t) {
    (t == undefined || t == null) && (t = 20);
    var i = n;
    return n.length > t && (i = n.substring(0, t - 3) + "..."), i
}

function specialCharCheck(n, t) {
    n.value = n.value.replace(regxchars[t], "")
}

function pageScrollTop() {
    $(document).scrollTop(0)
}
var regxchars;
$("#pageLoader").hide();
var menuLeft = document.getElementById("cbp-spmenu-s1"),
    menuTop = document.getElementById("cbp-spmenu-s3"),
    showTop = document.getElementById("showTop"),
    showLeftPush = document.getElementById("showLeftPush"),
    body = document.body;
regxchars = {
    special: /[\W]/g,
    quotes: /['\''&'\"']/g,
    notnumbers: /[^\d]/g,
    numbers: /[\d+]/g,
    alphanumeric: /[^a-zA-Z0-9- ]/g,
    numbersAndDot: /[^'\d'&^'\.']/g,
    htmlTags: /([\<])([^\>]{1,})*([\>])/g,
    numbersAndSingleDot: /[\d+]/g,
    tilda: /['~']/g
}