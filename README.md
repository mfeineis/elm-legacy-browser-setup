# Basic Elm 0.18 setup fit for IE8+

This is a basic Elm 0.18 setup that should at least work in IE8+. It includes
a couple of necessary polyfills for IE<9. With this we might even be able to go all 
the way down to IE6+ - which in turn could enable server-side-rendering using the 
most ancient `JScript` engine versions embedded in Microsoft's Classic ASP since
Windows XP+ with Elm 0.19, we'll have to see.

## Disclaimer
Before you go on taking this into the wild, wild open:

Note that this is **not meant as a traditional starter-kit**. Although I don't intend 
to maintain this as a project for myself, I'm open to pull-requests that improve
upon the basic setup. So code contributions are welcome, I don't plan to process 
issues on Github, though, so please refrain from feature requests or the like. This
is a fun one-day project and maintaining IE related stuff is not covered by my
definition of fun :-P.

## Building

* You'll need Git and Node>=6LTS
* Clone the repo `git clone https://github.com/mfeineis/elm-legacy-browser-setup`
* `cd elm-legacy-browser-setup && npm run setup` will install all dependencies,
  build the example Elm app, spin up a local `http-server` that serves the example
  page [on localhost](http://localhost:8081/)

If you want to fiddle with the Elm code you may use `npm run dev` to start 
[`elm-reactor` on port 8080](http://localhost:8080/src/Reactor.elm). Note that this
won't work in IE<9 since `elm-reactor` uses its own HTML and there is currently
no easy way to hook into that without using a different tool like
[elm-live](https://github.com/architectcodes/elm-live).

## Context
This is a little experiment that sprang from
[a "How do I support IE<11" thread on Elm Discourse](https://discourse.elm-lang.org/t/elm-support-for-older-browsers-ie-9-10/744).

Personally I just wanted to explore how far in the past we can transport Elm with
polyfills alone. A nice side-effect of that endeavor is that people can use this 
as a guideline to support their - arguably ridiculous - business use-cases to 
include
[unmaintained and insecure browsers](https://www.microsoft.com/en-gb/windowsforbusiness/end-of-ie-support)
that have been
[abandoned even by their creators long, long ago](https://support.microsoft.com/en-gb/help/17454/lifecycle-faq-internet-explorer).

## What is included?

* A working Elm 0.18 Hello World Counter app complete with JSON flags and ports
* A [`window.console` polyfill](https://github.com/paulmillr/console-polyfill), since IE only has that available when the devtools are open
* An [MDN polyfill for `Array.prototype.indexOf`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf) which is IE9+
* An [MDN polyfill for `String.prototype.trim`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/trim) which is IE9+
* A polyfill for `addEventListener` so we don't need to temper with the Elm generated JS 
  after all - thanks to [Eiric Backer](https://qiita.com/sounisi5011/items/a8fc80e075e4f767b79a#11).
  This brings us down to maybe even IE6+
* The [original `JSON` polyfill](https://www.json.org/), since this has been introduced in ES5
* A useful basic `eslint` setup with `eslint-plugin-compat` enabled that checks
  the JS you're using against the target browsers configured in `.browserslistrc`. 
  The detection is far from perfect but it prevents you from using something
  obviously not cross-browser like `navigator.serviceWorker` without you noticing it
* A reasonable `browserslist` config for a typical Enterprise setup, which sad to say
  may include IE8+ (ES5), Safari 7 (for flexbox) and Firefox ESR
* a pre-commit hook - using husky - that builds the app and runs `eslint` on all 
  JS files within your project, including the Elm generated JS. This setup tries
  to auto-magically prevent you from committing code that isn't up to your
  `browserslist` configuration. You are encouraged to include stricter `eslint` 
  configuration, of course ;-)
* A **very** basic `index.html` entry point that includes all the stuff necessary
  in the easiest way possible via `<script>` tags for demo purposes. You are free 
  to use whatever bundler you want in your real-world app
  
## TODO

* [x] Check that it's actually working on Windows in a real IE xD - it does on my Win10 aka "Works On My Machine" (tm) - you might want to check this with a *real* browser in a VM via [modern.ie](https://modern.ie), though. I don't want and need to :-)
* [x] Find a way to polyfill the W3C event model which right now is preventing us from
    going down to IE8+ or even lower - yeah, thanks Eiric Backer
* [x] Add a working example that includes basic user interaction - counter is working
* [x] Expand the example to demonstrate support for JSON decoding of flags and ports

Works on these machines (tm):

* Ubuntu 17.10 64bit, Intel i3
* Windows 10 64bit, Intel i7
