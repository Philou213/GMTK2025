class_name WebhookCreator
extends HTTPRequest

## Modified and better version of ASecondGuy's Addon https://github.com/ASecondGuy/BugReporter

## Defining signals for different outcomes
signal SendingMessageFinished
signal SendingMessageFailed
signal SendingMessageSuccess

var requestBody := []           ## List to store entire message/embed body
var jsonPayload := {}           ## Dictionary to store JSON data
var isEmbedding := false        ## Flag to check if an embed is currently being created
var lastEmbed := {}             ## Dictionary to store the current embed data
var lastEmbedFields := []       ## List to store fields for the current embed

## Starts constructing a new message
func StartMessage():
	## Checking if the HTTP client is currently connected
	if get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return ERR_BUSY          ## Returns error if the client is busy

	## Clearing previous (if any) request data
	requestBody.clear()
	jsonPayload.clear()
	requestBody.push_back(jsonPayload)
	lastEmbed.clear()
	lastEmbedFields.clear()
	return OK                    ## Returns OK to indicate success

## Setting the player's username to indicate who made the report
func SetUsername(username:String):
	jsonPayload["username"] = username

## Function to start creating an embed
func StartEmbed():
	if isEmbedding:
		FinishEmbed()
	isEmbedding = true            ## Setting the flag to indicate that embedding has started

## Function to finish and add the current embed to the message
func FinishEmbed():
	if isEmbedding:
		lastEmbed["fields"] = lastEmbedFields  ## Adding fields to the current embed
		if jsonPayload.get("embeds") is Array:
			jsonPayload["embeds"].push_back(lastEmbed)  ## Adding the embed to the list of embeds
		else:
			jsonPayload["embeds"] = [lastEmbed]  ## Creating a new list with the embed
		isEmbedding = false          ## Reset the embedding flag

## Function to add a field to the current embed
func AddField(field_name:String, field_value:String, field_inline:=false):
	lastEmbedFields.push_back({"name": field_name, "value": field_value, "inline": field_inline})

## Function to set the color of the current embed
func SetEmbedColor(color:int):
	lastEmbed["color"] = color

## Function to set the title of the current embed (Report Types)
func SetEmbedTitle(title:String):
	lastEmbed["title"] = title

## Function to set the footer of the current embed with game version
func SetEmbedFooter(footer_text:String, version:String):
	lastEmbed["footer"] = {"text": "%s: v%s" % [footer_text, version]}

## Function to convert an array of variants into multipart form data
func ArrayToFormData(array: Array, boundary := "boundary") -> PackedByteArray:
	var file_counter := 0
	var output := PackedByteArray()

	for element in array:
		output += ("\r\n--%s\r\n" % boundary).to_utf8_buffer()

		if element is Dictionary:
			output += 'Content-Disposition: form-data; name="payload_json"\r\n'.to_utf8_buffer()
			output += 'Content-Type: application/json\r\n\r\n'.to_utf8_buffer()
			output += JSON.stringify(element).to_utf8_buffer()

		elif element is String:
			if element.is_absolute_path() and FileAccess.file_exists(element):
				var file := FileAccess.open(element, FileAccess.READ)
				if file:
					var file_content := file.get_buffer(file.get_length())
					file.close()

					output += ('Content-Disposition: form-data; name="files[%d]"; filename="%s"\r\n' %
						[file_counter, element.get_file()]).to_utf8_buffer()
					output += "Content-Type: application/octet-stream\r\n\r\n".to_utf8_buffer()
					output += file_content  # 🔥 binary data — no utf8!
				else:
					printerr("Could not open file: %s" % element)
			else:
				printerr("File does not exist: %s" % element)
			file_counter += 1

	output += ("\r\n--%s--\r\n" % boundary).to_utf8_buffer()
	return output


## Function to send the constructed message
func SendMessage(url:String):
	FinishEmbed()  ## Ensure any current embed is finished
	var boundary := "b%s" % hash(str(Time.get_unix_time_from_system(), jsonPayload))
	var payload := ArrayToFormData(requestBody, boundary)  # Convert request body to multipart form data

	## Requesting HTTPClient
	request_raw(url,
			PackedStringArray(["connection: keep-alive", "Content-type: multipart/form-data; boundary=%s" % boundary]),
			HTTPClient.METHOD_POST,
			payload
	)

## Function called when the request is completed
func OnRequestCompleted(result, _response_code, _headers, _body):
	if result == RESULT_SUCCESS:
		SendingMessageSuccess.emit()
	else:
		SendingMessageFailed.emit()
	SendingMessageFinished.emit()

func AddFile(filePath: String):
	if filePath.is_absolute_path() and FileAccess.file_exists(filePath):
		requestBody.push_back(filePath)
	else:
		printerr("Reporter could not attach File %s to Message, Reason: File does not exist" % filePath)

func AddScreenshot(screenshotUrl: String):
	if not screenshotUrl.begins_with("https://") and not screenshotUrl.begins_with("http://"):
		screenshotUrl = "https://" + screenshotUrl
		var http_request = HTTPRequest.new()
		add_child(http_request)
		var error = http_request.request(screenshotUrl)

		if not error:
			lastEmbed["image"] = {
				"url": screenshotUrl
			}
		http_request.queue_free()
	else:
		lastEmbed["image"] = {
			"url": screenshotUrl
		}
