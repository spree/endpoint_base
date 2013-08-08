json.message_id @message['message_id']

json.parameters @parameters do |parameter|
  json.name parameter[:name]
  json.value parameter[:value]
end if @parameters.present?

json.messages @messages do |message|
  json.key message[:key]
  json.payload message[:payload]
end if @messages.present?
