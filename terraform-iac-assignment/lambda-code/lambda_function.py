"""
Simple Lambda function for Infrastructure as Code assignment.
This function demonstrates basic AWS Lambda functionality.
"""

import json
import os
from datetime import datetime

def lambda_handler(event, context):
    """
    AWS Lambda handler function.

    Args:
        event: The event dict that contains the request data
        context: The context object provides methods and properties with
                 information about the invocation, function, and runtime environment

    Returns:
        dict: Response with statusCode and body
    """

    # Get environment variables
    environment = os.environ.get('ENVIRONMENT', 'unknown')

    # Create response message
    response_message = {
        'message': 'Hello from Infrastructure as Code Lambda!',
        'timestamp': datetime.now().isoformat(),
        'environment': environment,
        'function_name': context.function_name if context else 'local-test',
        'request_id': context.aws_request_id if context else 'local-request-id',
        'event_data': event
    }

    print(f"Processing request in {environment} environment")
    print(f"Event received: {json.dumps(event)}")

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(response_message, indent=2)
    }

# For local testing
if __name__ == "__main__":
    # Mock event and context for local testing
    test_event = {
        'test': True,
        'message': 'Local test execution'
    }

    class MockContext:
        def __init__(self):
            self.function_name = 'test-function'
            self.aws_request_id = 'test-request-123'

    result = lambda_handler(test_event, MockContext())
    print("Test result:", json.dumps(result, indent=2))
