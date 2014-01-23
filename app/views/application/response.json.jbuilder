json.message_id @message['message_id']

@attrs.each do |name, value|
  json.set! name, value
end if @attrs.present?

json.parameters @parameters do |parameter|
  json.name  parameter[:name]
  json.value parameter[:value]
end if @parameters.present?

json.messages @messages do |message|
  json.(message, *message.keys)
end if @messages.present?

json.notifications @notifications
