# Example CoffeeScript module for Localist

#####################
## Define a Module ##
#####################

# Defines the module slzr/module and its dependencies (jQuery and underscore)
#
# See https://larsjung.de/modulejs/ for full modulejs documentation
modulejs.define 'slzr/module', ['jquery', 'underscore'], ($, _) ->
  # In this function, you can access jQuery as $ and underscore as _
  #
  # Anything returned from this function is what's exported in slzr/module and
  # is what will be imported when you define a dependency on it.
  #
  # In this case, we're exporting an object with one key.

  # Exported function
  displayGreeting: -> alert 'Hello, World!'


##########################################
## Attach an event handler on DOM Ready ##
##########################################

# ALWAYS reference jQuery as Slzr.jQuery in the global scope. The global jQuery
# and $ variables may refer to other objects than the Localist-provided jQuery.

# This is a typical jQuery DOM Ready handler.
#
# Note that the function parameter is "$", which allows the common jQuery
# shorthand to be used inside the function.
Slzr.jQuery ($) ->
  # Check if BODY has the defined class, and return unless it's the right page
  # for the code below.
  return unless $(document.body).is('.admin-analytics')

  # You should only attach necessary event handlers in here, or bootstrap into
  # the module defined elsewhere.

  # Attach to links with data-action="alert-hello" to display a greeting.
  #
  # This uses delegation, to automatically find any links even when updated
  # after the page is loaded.
  #
  # onAction automatically stops default event handlers, so there is no need
  # to call event.preventDefault or event.stopPropogation or return false.
  #
  # Like jQuery event handlers, "this" is the element that triggered the event.
  $(document).onAction 'alert-hello', (event) ->
    # Require the module defined above...
    GreetingModule = modulejs.require 'slzr/module'

    # ...and call the exported function
    GreetingModule.displayGreeting()
