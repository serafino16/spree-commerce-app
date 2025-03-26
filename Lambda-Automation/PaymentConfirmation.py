import json
import requests

def lambda_handler(event, context):
    
    payment_status = event['payment_status']  
    order_id = event['order_id']
    transaction_id = event['transaction_id']
    
    
    if payment_status == 'success':
        order_status = 'paid'
    else:
        order_status = 'failed'

    
    spree_api_url = "https://your-spree-api-url.com/orders/{}".format(order_id)
    headers = {'Authorization': 'Bearer your_api_token'}
    payload = {
        'status': order_status,
        'payment_transaction_id': transaction_id
    }
    
    response = requests.put(spree_api_url, json=payload, headers=headers)
    
    if response.status_code == 200:
        return {
            'statusCode': 200,
            'body': json.dumps(f"Order {order_id} updated with status: {order_status}")
        }
    else:
        return {
            'statusCode': 500,
            'body': json.dumps("Failed to update the order status in Spree")
        }
