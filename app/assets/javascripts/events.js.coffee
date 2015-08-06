$(document).ready ->

  $('#new_event').click (event) ->
    event.preventDefault()
    url = $(this).attr('href')
    $.ajax
      url: url
      success: (data) ->
        $('#create_event').replaceWith data
        $('#create_event_dialog').dialog
          title: 'New Event'
          modal: true
          width: 500
          close: (event, ui) ->
            $('#create_event_dialog').dialog 'destroy'

  $('#calendar').fullCalendar
    eventSources: [{  
      url: '/events',
    }], 

    editable: true,  
    header:  
      left: 'prev,next today',  
      center: 'title',  
      right: 'month,agendaWeek,agendaDay'

    defaultView: 'month' 
    height: 500 
    eventColor: 'gray'
    eventTextColor: 'black'
    slotMinutes: 30

    timeFormat: 'h:mm t{ - h:mm t} ' 
    dragOpacity: "0.5"  

    eventDrop: (event, delta, revertFunc) -> 
      updateEvent event

    eventResize: (event, delta, revertFunc) ->
      updateEvent event

    eventClick: (event, jsEvent, view) ->
      eventId = event.id
      $("#disp_event_dialog").dialog
          title: event.title
      $("#disp_event").html "Title: " + event.title + "<br/>" + "Description: " +  event.description + "<br/>" + "<a href=/events/#{eventId}/edit id=edit_event_link>Edit</a>" + "<br/>" + "<a href=/events/#{eventId} method=destroy id=delete_event>Destroy</a>"

      $("#disp_event").append $('#edit_event_link').click (event) ->
        $('#disp_event_dialog').dialog 'close'
        event.preventDefault()
        url = $(this).attr('href')
        $.ajax
          url: url
          success: (data) ->
            $('#edit_event').replaceWith data
            $('#edit_event_dialog').dialog
              title: 'Edit Event'
              modal: true
              width: 500
              close: (event, ui) ->
                $('#edit_event_dialog').dialog 'destroy'
      close: (event, ui) ->
        $('#disp_event_dialog').dialog 'destroy'

      $("#disp_event").append $('#delete_event').click (event) ->
              event.preventDefault()
              url = $(this).attr('href')
              $.ajax
                url: url
                type: 'POST'
                data: _method: 'DELETE'
                success: (data) ->
                  window.location.reload()
                  $('#disp_event_dialog').dialog 'close'
  
    updateEvent = (event) ->  
      $.update "/events/" + event.id,  
        event:
          starts_at: event.start.format() 
          ends_at: event.end.format()
