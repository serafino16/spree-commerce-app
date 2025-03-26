import json
import requests

def lambda_handler(event, context):
    order_id = event['order_id']
    refund_amount = event['refund_amount']  # The amount to refund to the customer
    transaction_id = event['transaction_id']

    # Call the external payment gateway API to process the refund
    payment_gateway_url = "https://payment-gateway.com/api/refund"
    payload = {
        'order_id': order_id,
        'transaction_id': transaction_id,
        'amount': refund_amount
    }
    
    response = requests.post(payment_gateway_url, json=payload)
    refund_data = response.json()
    
    if refund_data['status'] == 'success':
        refund_status = 'refunded'
    else:
        refund_status = 'failed'

    
    spree_api_url = f"https://your-spree-api-url.com/orders/{order_id}"
    headers = {'Authorization': 'Bearer your_api_token'}
    order_payload = {
        'status': refund_status
    }
    
    
    spree_response = requests.put(spree_api_url, json=order_payload, headers=headers)
    
    if spree_response.status_code == 200:
        return {
            'statusCode': 200,
            'body': json.dumps(f"Refund for order {order_id} processed successfully")
        }
    else:
        return {
            'statusCode': 500,
            'body': json.dumps(f"Failed to process refund for order {order_id}")
        }
