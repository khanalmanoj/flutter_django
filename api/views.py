from .models import Food
from .serializers import FoodSerializer, OrderSerializer
from rest_framework.generics import ListAPIView
from .models import Order, OrderItem, History
from .serializers import OrderItemSerializer,HistorySerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status , viewsets
from rest_framework.generics import CreateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
# Create your views here.

class FoodListView(ListAPIView):
    queryset = Food.objects.all()
    serializer_class = FoodSerializer

class OrderItemViewSet(viewsets.ModelViewSet):
    queryset = OrderItem.objects.all()
    serializer_class = OrderItemSerializer

class OrderListView(ListAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer

    def get(self, request):
        user = request.user
        try:
            orders = Order.objects.filter(user=user)
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
        food_obj = Food.objects.get(id=food_id)
    
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
    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticated, ]

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

class Checkout(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        cart_id = request.data.get('id')  # Use get method to avoid KeyError
        try:
            order = Order.objects.get(id=cart_id)
            order_items = OrderItem.objects.filter(order=order)

            # Calculate total amount and fetch food items
            total_amount = sum(order_item.food.price * order_item.quantity for order_item in order_items)

            # Construct list of food items with their quantities
            food_items_ordered = []
            for order_item in order_items:
                food_name = order_item.food.food_name
                quantity = order_item.quantity
                food_items_ordered.append({'food_name': food_name, 'quantity': quantity})

            # Create a new CheckOut instance with the calculated total_amount and associated food_items
            checkout = History.objects.create(orders=order, total_amount=total_amount)
            checkout.food_items.add(*order_items)

            response_msg = {
                'error': False,
                'message': 'Checkout completed successfully.',
                'food_items_ordered': food_items_ordered,
                'total_amount': total_amount
            }
        except Order.DoesNotExist:
            response_msg = {'error': True, 'message': 'Order not found.'}
        except Exception as e:
            print(e)
            response_msg = {'error': True, 'message': 'Something went wrong during checkout.'}
        
        return Response(response_msg)


    
class HistoryView(ListAPIView):
    queryset = History.objects.all()
    serializer_class = HistorySerializer

class OrderItemCreateView(CreateAPIView):
   serializer_class = OrderItemSerializer

   def post(self, request, *args, **kwargs):
        serializer = OrderItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class OrderCreateView(CreateAPIView):
   serializer_class = OrderSerializer

   def post(self, request, *args, **kwargs):
        serializer = OrderSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
