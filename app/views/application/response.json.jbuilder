json.message_id @message['message_id']

@attrs.each do |name, value|
  json.set! name, value
end if @attrs.present?

json.parameters @parameters do |parameter|
  json.name  parameter[:name]
  json.value parameter[:value]
end if @parameters.present?

json.messages @messages do |message|
  json.message message[:message]
  json.payload message[:payload]
end if @messages.present?

json.notifications @notifications do |notification|
  json.level         notification[:level]
  json.subject       notification[:subject]
  json.description   notification[:description]
end if @notifications.present?
