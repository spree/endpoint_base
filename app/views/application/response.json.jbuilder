json.request_id @payload['request_id']

@attrs.each do |name, value|
  json.set! name, value
end if @attrs.present?

json.set! :parameters do
  @parameters.each do |key, value|
    json.set! key.to_sym, value
  end
end if @parameters.present?

@objects.each do |klass, objects|
  json.set! klass, objects
end if @objects.present?
