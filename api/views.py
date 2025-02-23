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
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt



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
            order = Order.objects.get(id=cart_id)
            order.total = 0
            order.save()
            order.orderitem_set.all().delete()
            response_msg = {'error': False}
        except:
            response_msg = {'error': True}
        return Response(response_msg)


class GenerateOrderToken(APIView):
    def post(self, request):
        order_id = request.data.get('order_id')
        try:
            # Retrieve the order object based on the provided order_id
            order = Order.objects.get(id=order_id)

            # Generate a unique token-like identifier for the order
            order.token = str(uuid.uuid4())  # Example: using UUID4 for generating a unique identifier
            order.save()
            # Return the token-like identifier in the response
            return Response({'token': order.token}, status=status.HTTP_200_OK)
        except Order.DoesNotExist:
            return Response({'error': 'Order not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class VerifyOrderToken(APIView):
    def post(self, request):
        token = request.data.get('token')
        
        if not token:
            return Response({'error': 'Token not provided'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Query the order based on the token
            order = Order.objects.get(token=token)
            user = order.user
            return Response({'order_id': order.id}, status=status.HTTP_200_OK)
        except Order.DoesNotExist:
            return Response({'error': 'Order not found for the provided token'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class UpdateOrderToken(APIView):
    def post(self, request):
        order_id = request.data.get('order_id')
        try:
            # Retrieve the order object based on the provided order_id
            order = Order.objects.get(id=order_id)

            # Generate a unique token-like identifier for the order
            order.token = str(uuid.uuid4())  # Example: using UUID4 for generating a unique identifier
            order.save()
            
        except Order.DoesNotExist:
            return Response({'error': 'Order not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
class CheckOrderItem(APIView):
    def post(self, request):
        token = request.data.get('token')
        try:
            order = Order.objects.get(token=token)
            order_items = OrderItem.objects.filter(order=order)
            
            order_items_data = [{item.food.food_name:item.quantity} for item in order_items]
            
            response_msg = {               
                'order_items': order_items_data
            }
        except Order.DoesNotExist:
            response_msg = {'error': True, 'message': 'Order not found.'}
        except Exception as e:
            response_msg = {'error': True, 'message': e}
        return Response(response_msg)

class Checkout(APIView):
    def post(self, request):
        token = request.data.get('token')
               
        try:          
            # Fetch the order associated with the user
            order = Order.objects.get(token=token)
            order_items = OrderItem.objects.filter(order=order)
            user = order.user.username         

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
    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]
    serializer_class = HistorySerializer

    def get_queryset(self):
        user = self.request.user
        return History.objects.filter(user=user.username).order_by('-date')
    
def sales_view(request):
    total_users = User.objects.filter(is_staff=False).count()
    history_order = HistoryOrderItem.objects.count()
    total_revenue = sum(history.total_amount for history in History.objects.all())
    history_order_items = HistoryOrderItem.objects.all()

    SalesReport.objects.create(revenue=total_revenue, totalusers=total_users, totalorders=history_order)

    
    context = {
        'total_orders': history_order,
        'total_users': total_users,
        'total_revenue': total_revenue,
    }
    return render(request, 'sales.html', context)
    