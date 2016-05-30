import moment from "moment"

let channel = false

const push_enabled_state = (id, enabled) => {
  if(!channel) {
    return(false)
  }
  channel.push("switch:enabled", {event_id: id, enabled: enabled})
}

$("#monitor-index-page").ready(() => {
  setInterval(() => {
    $('.state-updated-at').each((_, elem) => {
      let text = moment($(elem).data('time')).fromNow()
      if($(elem).text() !== text) {
        $(elem).text(text)
      }
    })
  }, 1000)
  $('input.enabled-switch').on("change", (event) => {
    let target = $(event.target)
    let id = target.data("id")
    let checked = target.is(":checked")
    push_enabled_state(id, checked)
  })
})

const onTestPortUpdate = payload => {
  if($("#monitor-index-page").length == 0) {
    return
  }
  let row = $('tr#' + payload.identity)
  let eventState = row.find('.event-state')
  let eventStateUpdatedAt = row.find('.state-updated-at')
  let lastOkTime = row.find('.last-ok-time')
  if(payload.body == 'success') {
    eventState.html('<span class="label label-success">ACTIVE</span>')
    eventState.removeClass('text-danger')
    eventState.addClass('text-success')
    row.removeClass('danger')
  } else {
    eventState.html('<span class="label label-danger">INACTIVE</span><span class="label label-danger">' + payload.reason + "</span>")
    eventState.removeClass('text-success')
    eventState.addClass('text-danger')
    row.addClass('danger')
    $("#alert-audio")[0].play()
  }
  eventStateUpdatedAt.data('time', payload.timestamp)
  eventStateUpdatedAt.text(moment(payload.timestamp).fromNow())
  lastOkTime.text(moment(payload.last_ok_time).format("YY-MM-DD HH:mm:ss"))
}

const onEnabledStateUpdate = payload => {
  $("#snackbar")[0].MaterialSnackbar.showSnackbar({
    message: 'Event state updated',
    timeout: 1000
  })
  let checkbox = $("input[data-id=" + payload.event_id + "]")
  let enabled = payload.enabled
  checkbox.prop("checked", enabled)
  checkbox.closest("label").toggleClass("is-checked", enabled)
}

const setChannel = c => {
  channel = c
}

export const callbacks = {onTestPortUpdate, onEnabledStateUpdate, setChannel}
