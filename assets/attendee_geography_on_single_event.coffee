# Generated by CoffeeScript 1.4.0

window.calendar_url = 'http://events.cornell.edu'
window.gmap = null
window.event_id = "532770"

# define slzr/reports/attendee_geography module
modulejs.define 'slzr/reports/attendee_geography', ['jquery', 'underscore'], ($, _) ->

  # initialize events created by day
  attendeesOnSingleEvent = null

  # define method to get attendee geography on single event
  getAttendeesOnSingleEvent: ->
    dateRange = $('#date_range_select').val()
    endDate = new Date
    startDate = new Date

    # set start date and end date for reporting
    if dateRange != 'Custom'
      startDate.setDate startDate.getDate() - parseInt(dateRange) + 1
    else
      startDate = $("#start_date_input").data("date")
      endDate = $("#end_date_input").data("date")

    daysDiff = (endDate.getTime() - startDate.getTime()) / (1000 * 3600 * 24)
    if daysDiff > 366
      $('#message-response-message').html('The date range must be 366 days or less.')
      $('#message-response').show()
      return false

    $.ajax
      url: window.calendar_url + '/api/2/events/' + window.event_id + '/stats/attendees'
      type: 'GET'
      data: 'start=' + startDate.toISOString().slice(0, 10) + '&end=' + endDate.toISOString().slice(0, 10)
      cache: false
      async: false
      dataType: 'json'
      success: (data, textStatus, jqXHR) ->
        attendeesOnSingleEvent = data
    return true

  initMap: ->
    window.gmap = new google.maps.Map(document.getElementById('map'), {
      zoom: 4,
      center: {lat: 38.0, lng: -97.0}
    });

  # method to draw chart
  drawChart: ->
    if window.markers != null
      $(window.markers).each (index, marker) ->
        marker.setMap(null)

    marker_image =
      url: 'images/none.png'

    window.markers = []
    $(attendeesOnSingleEvent.attendance_data).each (index, element) ->
      if element.zip == $("#zipcode").val()
        window.gmap.panTo({lat: element.latitude, lng: element.longitude})
      window.markers.push new MarkerWithLabel({
        position:
          lat: element.latitude
          lng: element.longitude
        labelContent: element.count + ""
        labelClass: "marker_labels"
        labelAnchor: new google.maps.Point(15, 25)
        labelInBackground: true
        icon: marker_image
        map: window.gmap
      })


Slzr.jQuery ($) ->

  return unless $(document.body).is('.admin-analytics-attendee-geography')

  AttendeeGeographyModule = modulejs.require('slzr/reports/attendee_geography')
  AttendeeGeographyModule.initMap()

  AttendeeGeographyModule.getAttendeesOnSingleEvent()
  AttendeeGeographyModule.drawChart()

  # action triggered when clicking 'update' button
  $(document).onAction 'update-report', (event) ->
    if $("#date_range_select").val() == "Custom" && ($("#start_date_input").data("date-status") != "ok" && $("#end_date_input").data("date-status") != "ok")
      # show notice
    else
      if AttendeeGeographyModule.getAttendeesOnSingleEvent()
        AttendeeGeographyModule.drawChart()
