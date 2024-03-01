from collections import Counter
import uuid
from django.conf import settings
from django.shortcuts import render
import jwt
from .models import *
from .serializers import *
from rest_framework.generics import ListAPIView
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status , viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token


class UserListView(ListAPIView):
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer

class MenuListView(ListAPIView):
    queryset = MenuItem.objects.all()
    serializer_class = MenuItemSerializer

class OrderItemViewSet(viewsets.ModelViewSet):
    queryset = OrderItem.objects.all()
    serializer_class = OrderItemSerializer

class OrderListView(ListAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer

    def get(self, request):
        user = request.user
        try:
            if user.is_staff:  # Check if the user is an admin
                orders = Order.objects.all()  # Retrieve all orders for admin
            else:
                orders = Order.objects.filter(user=user)  # Retrieve orders for regular users

            data = []
            order_serializer = OrderSerializer(orders, many=True)
            for order in order_serializer.data:
                order_items = OrderItem.objects.filter(order=order["id"]) 
                order_item_serializer = OrderItemSerializer(order_items, many=True)              
                order['order_items'] = order_item_serializer.data           
                data.append(order)

            response_msg = {"error": False, "data": data}
        except Exception as e:
            response_msg = {"error": True, "data": str(e)}        
        return Response(response_msg)
    

class AddToOrder(APIView):
    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]

    def post(self, request):
        food_id = request.data["id"]
        food_obj = MenuItem.objects.get(id=food_id)
    
        try:
            user_order = Order.objects.filter(user=request.user).first()
            
            if user_order:
                print("EXISTING ORDER")
                order_item = OrderItem.objects.filter(order=user_order, food=food_obj).first()
                if order_item:
                    order_item.quantity += 1
                    order_item.save()
                    user_order.total += food_obj.price
                    user_order.save()
                else:
                    print("NEW ORDER ITEM CREATED")
                    order_item = OrderItem.objects.create(
                        order=user_order,
                        food=food_obj,
                        quantity=1
                    )
                    user_order.total += food_obj.price
                    user_order.save()
            else:
                print("NEW ORDER CREATED")
                new_order = Order.objects.create(
                    user=request.user,
                    total=0
                )
                order_item = OrderItem.objects.create(
                    order=new_order,
                    food=food_obj,
                    quantity=1
                )
                new_order.total += food_obj.price
                new_order.save()

            response_message = {
                'error': False,
                'message': "Food added to cart successfully",
                "food_id": food_id
            }
        except Exception as e:
            print(e)
            response_message = {
                'error': True,
                'message': "Food not added! Something went wrong"
            }
        
        return Response(response_message)

class DeleteOrderItem(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated, ]

    def post(self, request):
        order_item_id = request.data.get('id')
        try:
            order_item = OrderItem.objects.filter(order__user=request.user, id=order_item_id).first()
            order = Order.objects.filter(user=request.user).first()
            if order:
                order.total -= order_item.food.price * order_item.quantity
                order.total = max(order.total, 0)  # Ensure total is non-negative
                order.save()
                order_item.delete()
                response_msg = {'error': False}
            else:
                response_msg = {'error': True, 'message': 'No active order found for the user.'}
        except OrderItem.DoesNotExist:
            response_msg = {'error': True, 'message': 'Order item not found.'}
        except Exception as e:
            print(e)
            response_msg = {'error': True, 'message': 'Something went wrong.'}
        return Response(response_msg)

class DeleteOrder(APIView):
    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]

    def post(self, request):
        cart_id = request.data['id']
        try:
            cart_obj = Order.objects.get(id=cart_id)
            cart_obj.delete()
            response_msg = {'error': False}
        except:
            response_msg = {'error': True}
        return Response(response_msg)

# class Checkout(APIView):

#     def post(self, request):
#         cart_id = request.data.get('orderid')
#         user_id = request.data.get('userid') # Use get method to avoid KeyError
#         try:
#             orders = Order.objects.get(id=cart_id)
#             user = User.objects.get(id=user_id) 
#             order_itemss = OrderItem.objects.filter(order=orders)

#             # Calculate total amount and fetch food items
#             total_amount = sum(order_item.food.price * order_item.quantity for order_item in order_items)

#             # Construct list of food items with their quantities
#             food_items_ordered = []
#             for order_item in order_itemss:
#                 food_name = order_item.food.food_name
#                 quantity = order_item.quantity
#                 food_items_ordered.append({'food_name': food_name, 'quantity': quantity})

#             # Create a new CheckOut instance with the calculated total_amount and associated food_items
#             checkout = History.objects.create(order=orders,user=user,total_amount=total_amount)
#             checkout.order_items.add(*order_itemss)

#             response_msg = {
#                 'error': False,
#                 'message': 'Checkout completed successfully.',
#                 'food_items_ordered': food_items_ordered,
#                 'total_amount': total_amount
#             }
#         except Order.DoesNotExist:
#             response_msg = {'error': True, 'message': 'Order not found.'}
#         except Exception as e:
#             print(e)
#             response_msg = {'error': True, 'message': 'Something went wrong during checkout.'}       
#         return Response(response_msg)

# class GenerateOrderToken(APIView):
#     def post(self, request):
#         order_id = request.data.get('order_id')
#         try:
#             # Retrieve the order object based on the provided order_id
#             order = Order.objects.get(pk=order_id)

#             # Generate a unique token-like identifier for the order
#             order.token = str(uuid.uuid4())  # Example: using UUID4 for generating a unique identifier
#             order.save
#             # Return the token-like identifier in the response
#             return Response({'token': order}, status=status.HTTP_200_OK)
#         except Order.DoesNotExist:
#             return Response({'error': 'Order not found'}, status=status.HTTP_404_NOT_FOUND)
#         except Exception as e:
#             return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class GenerateOrderToken(APIView):
    def post(self, request):
        user_id = request.data.get('user_id')
        try:
            # Generate a JWT containing the order ID
            token = jwt.encode({'user_id': user_id}, settings.SECRET_KEY, algorithm='HS256')
            
            # Return the token to the client
            return Response({'token': token}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class Checkout(APIView):
    def post(self, request):
        token = request.data.get('token')
        
        try:
            # Verify user token
            # user = Token.objects.get(key=token).user
            decoded_token = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
            user = decoded_token.get('user_id')

            # Fetch the order associated with the user
            order = Order.objects.get(user=user)
            order_items = OrderItem.objects.filter(order=order)

            # Calculate total amount
            total_amount = order.total

            # Create a new History entry
            history = History.objects.create(order=order, user=user, total_amount=total_amount)

            # Create snapshots of order items
            for order_item in order_items:
                HistoryOrderItem.objects.create(
                    history=history,
                    food_name=order_item.food.food_name,
                    quantity=order_item.quantity,
                )

            response_msg = {
                'error': False,
                'message': 'Checkout completed successfully.',
                'total_amount': total_amount
            }
        except Token.DoesNotExist:
            response_msg = {'error': True, 'message': 'Invalid user token.'}
        except Order.DoesNotExist:
            response_msg = {'error': True, 'message': 'Order not found.'}
        except Exception as e:
            print(e)
            response_msg = {'error': True, 'message': 'Something went wrong during checkout.'}

        return Response(response_msg)


class AllOrdersView(ListAPIView):
    queryset = History.objects.all().order_by('-date')
    serializer_class = HistorySerializer
    
class HistoryView(ListAPIView):
    serializer_class = HistorySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return History.objects.filter(user=user).order_by('-date')
    
def sales_view(request):
    total_orders = OrderItem.objects.count()
    total_users = User.objects.count()
    history_order = HistoryOrderItem.objects.count()
    total_income = sum(history.total_amount for history in History.objects.all())

    history_order_items = HistoryOrderItem.objects.all()
    most_ordered_items = Counter(item.food_name for item in history_order_items).most_common(5)
    

    context = {
        'total_orders': history_order,
        'total_users': total_users,
        'total_income': total_income,
        'most_ordered_items': most_ordered_items,
    }
    return render(request, 'sales.html', context)


