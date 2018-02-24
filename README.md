# Basic Elm 0.18 setup fit for IE9+

This is a basic Elm 0.18 setup that should at least work in IE9+. It includes
some polyfills for IE<9 because we might be able to go all the way down to
IE6+, which could enable server-side-rendering using the `JScript` engine
embedded in Microsoft's Classic ASP, we'll see.

## What is included?

* A working Elm 0.18 Hello World
* A `window.console` polyfill, since IE only has that available when the devtools are open
* An MDN polyfill for `Array.prototype.indexOf` which is IE9+
* An MDN polyfill for `String.prototype.trim` which is IE9+
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
* Check that it's actually working on Windows in a real IE xD
* Find a way to polyfill the W3C event model which right now is preventing us from
  going down to IE8+ or even lower.
