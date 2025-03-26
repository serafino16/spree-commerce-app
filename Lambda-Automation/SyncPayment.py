import json
import requests

def lambda_handler(event, context):
    
    payment_gateway = event['payment_gateway']  
    order_id = event['order_id']
    payment_status = event['payment_status']  
    transaction_id = event['transaction_id']

    
    spree_api_url = f"https://your-spree-api-url.com/orders/{order_id}"
    headers = {'Authorization': 'Bearer your_api_token'}
    
    
    order_payload = {
        'status': payment_status,
        'payment_transaction_id': transaction_id
    }

    
    spree_response = requests.put(spree_api_url, json=order_payload, headers=headers)

    if spree_response.status_code == 200:
        return {
            'statusCode': 200,
            'body': json.dumps(f"Payment status for order {order_id} synced successfully")
        }
    else:
        return {
            'statusCode': 500,
            'body': json.dumps(f"Failed to sync payment status for order {order_id}")
        }
