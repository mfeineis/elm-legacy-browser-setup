// W3C XMLHttpRequest polyfill proof-of-concept stub by Martin Feineis, 2018, MIT License
// With a little help of https://code.jquery.com/jquery-1.6.3.js
(function (window) {
    "use strict";

    var CapturedXhr = window.XMLHttpRequest;

    if (typeof window.ActiveXObject === "undefined" ||
        (CapturedXhr && ("withCredentials" in new CapturedXhr()))
    ) {
        // Nothing to polyfill here...
        return;
    }

    function createStandardXHR() {
        try {
            return new CapturedXhr();
        } catch (e) { }
    }

    function createActiveXHR() {
        try {
            return new window.ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) { }
    }

    function createXhr() {
        return createStandardXHR() || createActiveXHR();
    }

    function addEventListener(which, next) {
        this["on" + which] = function () {
            // xhr.response property isn't there in old IE
            this.response = this.responseText;
            next.apply(this, arguments);
        };
    }

    function decorate(addEventListener) {
        return function (which, next) {
            return addEventListener.call(this, which, function () {
                // xhr.response property isn't there in old IE
                this.response = this.responseText;
                next.apply(this, arguments);
            });
        };
    }

    window.XMLHttpRequest = function () {
        var xhr = createXhr();

        if (typeof xhr.addEventListener === "undefined") {
            xhr.addEventListener = addEventListener;
        } else {
            xhr.addEventListener = decorate(xhr.addEventListener);
        }

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                xhr.onload && xhr.onload();
            }
        };

        return xhr;
    };

}(typeof window === 'undefined' ? this : window))