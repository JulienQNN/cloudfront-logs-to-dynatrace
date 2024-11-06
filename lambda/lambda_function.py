import base64
import json
import os

print('Loading function')

def lambda_handler(event, context):
    output = []

    # Get the DT_CUSTOM_PROP environment variable (throws error if not set)
    dt_custom_prop = os.environ['DT_CUSTOM_PROP']

    # Based on the fields chosen during the creation of the
    # Real-time log configuration.
    # The order is important and please adjust the function if you have removed
    # certain default fields from the configuration.
    realtimelog_fields_dict = {
        "timestamp": "float",
        "c-ip": "str",
        "sc-status": "int",
        "cs-method": "str",
        "cs-protocol": "str",
        "cs-host": "str",
        "cs-uri-stem": "str",
        "x-host-header": "str",
        "time-taken": "float",
        "cs-user-agent": "str",
        "cs-cookie": "str"
    }

    for record in event['records']:

        # Extracting the record data in bytes and base64 decoding it
        payload_in_bytes = base64.b64decode(record['data'])

        # Converting the bytes payload to string
        payload = "".join(map(chr, payload_in_bytes))

        # Dictionary where all the field and record value pairing will end up
        payload_dict = {}

        # Counter to iterate over the record fields
        counter = 0

        # Generate list from the tab-delimited log entry
        payload_list = payload.strip().split('\t')

        # Perform the field, value pairing and any necessary type casting.
        # Possible types are: int, float and str (default)
        for field, field_type in realtimelog_fields_dict.items():
            # Overwrite field_type if absent or '-'
            if payload_list[counter].strip() == '-':
                field_type = "str"
            else:
                payload_dict[field] = payload_list[counter].strip()
                counter += 1

        # Add the DT_CUSTOM_PROP environment variable to the payload dictionary
        payload_dict['DT_CUSTOM_PROP'] = dt_custom_prop

        # JSON version of the dictionary type
        payload_json = json.dumps(payload_dict)

        # Preparing JSON payload to push back to Firehose
        payload_json_ascii = payload_json.encode('ascii')
        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': base64.b64encode(payload_json_ascii).decode("utf-8")
        }

        output.append(output_record)

    print('Successfully processed {} records.'.format(len(event['records'])))

    return {'records': output}
