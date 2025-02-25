// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class CheckoutPage extends StatelessWidget {
//   const CheckoutPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         foregroundColor:
//         Colors.white,
//
//
//         title: const Text('Checkout',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Summary Section
//             _buildSectionHeader('Order Summary', Icons.shopping_bag),
//             _buildOrderSummaryCard(),
//
//             const SizedBox(height: 24),
//
//             // Delivery Information
//             _buildSectionHeader('Delivery Info', Icons.location_pin),
//             _buildDeliveryInfoCard(),
//
//             const SizedBox(height: 24),
//
//             // Payment Method
//             _buildSectionHeader('Payment Method', Icons.credit_card),
//             _buildPaymentMethods(),
//
//             const SizedBox(height: 32),
//
//             // Checkout Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2E7D32),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   'Confirm Order',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: const Color(0xFF2E7D32), size: 24),
//           const SizedBox(width: 8),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOrderSummaryCard() {
//     return Card(
//       color: Colors.grey.shade300,
//       elevation: 8.0,
//       shadowColor: Colors.black.withOpacity(0.3), // Subtle shadow
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: 3, // Replace with actual item count from WooCommerce
//               separatorBuilder: (context, index) => const Divider(height: 24),
//               itemBuilder: (context, index) => const Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Item Name', // Replace with actual item name
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   Text(
//                     '2x', // Replace with actual quantity
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                   SizedBox(width: 16),
//                   Text(
//                     '\$15.99', // Replace with actual price
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(height: 32),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Total:', style: TextStyle(fontSize: 18)),
//                 Text('\$47.97',
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2E7D32))),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDeliveryInfoCard() {
//     return Card(
//       color: Colors.grey.shade300,
//
//       elevation: 8.0,
//       shadowColor: Colors.black.withOpacity(0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Full Name *',
//                 labelStyle: TextStyle(
//                   color: Colors.black54, // Subtle label color
//                   fontSize: 14,
//                 ),
//                 prefixIcon: const Icon(Icons.person,color :Color(0xFF2E7D32)),
//                 filled: true, // Add background color
//                 fillColor: Colors.white, // Light background
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Color(0xFF2E7D32), // Focused border color matching your theme
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Border color for errors
//                     width: 2,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Focused error border color
//                     width: 2,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             // Street Address Field
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Street Address *',
//                 labelStyle: TextStyle(
//                   color: Colors.black54, // Subtle label color
//                   fontSize: 14,
//                 ),
//                 prefixIcon: const Icon(Icons.location_on,color :Color(0xFF2E7D32)),
//                 filled: true, // Add background color
//                 fillColor: Colors.white, // Light background
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Color(0xFF2E7D32), // Focused border color matching your theme
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Border color for errors
//                     width: 2,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Focused error border color
//                     width: 2,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             // Apartment/Unit Field
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Apartment, Suite, Unit, etc. (optional)',
//                 labelStyle: TextStyle(
//                   color: Colors.black54, // Subtle label color
//                   fontSize: 14,
//                 ),
//                 prefixIcon: const Icon(Icons.home,color :Color(0xFF2E7D32)),
//                 filled: true, // Add background color
//                 fillColor: Colors.white, // Light background
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Color(0xFF2E7D32), // Focused border color matching your theme
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Border color for errors
//                     width: 2,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Focused error border color
//                     width: 2,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             // Type Location Field
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Type Location *',
//                 labelStyle: TextStyle(
//                   color: Colors.black54, // Subtle label color
//                   fontSize: 14,
//                 ),
//                 prefixIcon: const Icon(Icons.location_searching,color :Color(0xFF2E7D32)),
//                 filled: true, // Add background color
//                 fillColor: Colors.white, // Light background
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Color(0xFF2E7D32), // Focused border color matching your theme
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Border color for errors
//                     width: 2,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Focused error border color
//                     width: 2,
//                   ),
//                 ),
//             ),),
//             const SizedBox(height: 12),
//
//             // Whatsapp Number Field
//             TextField(
//
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Whatsapp Number *',
//                 labelStyle: TextStyle(
//                   color: Colors.black, // Subtle label color
//                   fontSize: 14,
//                 ),
//                 prefixIcon: const Icon(Icons.phone,color :Color(0xFF2E7D32)),
//                 filled: true, // Add background color
//                 fillColor: Colors.white, // Light background
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Color(0xFF2E7D32), // Focused border color matching your theme
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Border color for errors
//                     width: 2,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Focused error border color
//                     width: 2,
//                   ),
//                 ),),
//             ),
//             const SizedBox(height: 12),
//
//             // Email Address Field
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Email Address *',
//                 labelStyle: TextStyle(
//                   color: Colors.black, // Subtle label color
//                   fontSize: 14,
//                 ),
//                 prefixIcon: const Icon(
//                   Icons.email,
//                   color: Color(0xFF2E7D32), // Color matching your theme
//                 ),
//                 filled: true, // Add background color
//                 fillColor: Colors.white, // Light background
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Color(0xFF2E7D32), // Focused border color matching your theme
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Border color for errors
//                     width: 2,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Focused error border color
//                     width: 2,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // Order Notes Field
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Order Notes (optional)',
//                 labelStyle: TextStyle(
//                   color: Colors.black54, // Subtle label color
//                   fontSize: 14,
//                 ),
//                 prefixIcon: const Icon(Icons.note_add,color :Color(0xFF2E7D32)
//                 ),
//                 filled: true, // Add background color
//                 fillColor: Colors.white, // Light background
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Color(0xFF2E7D32), // Focused border color matching your theme
//                     width: 2,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300, // Subtle default border color
//                     width: 1,
//                   ),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Border color for errors
//                     width: 2,
//                   ),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                     color: Colors.red, // Focused error border color
//                     width: 2,
//                   ),
//                 ),
//               ),
//               maxLines: 2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentMethods() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildPaymentMethodButton('assets/credit_card.svg', 'Card'),
//         _buildPaymentMethodButton('assets/google_pay.svg', 'Google Pay'),
//         _buildPaymentMethodButton('assets/cash.svg', 'Cash'),
//       ],
//     );
//   }
//
//   Widget _buildPaymentMethodButton(String assetPath, String label) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: SvgPicture.asset(
//             assetPath,
//             width: 40,
//             height: 40,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }
// }
//-------------------------x--------------------x----------------------x---------------------------
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodsspot/Screens/Cart.dart';


class CheckoutPage extends StatelessWidget {
  final List<CartItem> cartItems; // Receive cart items

  const CheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Checkout',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Section
            _buildSectionHeader('Order Summary', Icons.shopping_bag),
            _buildOrderSummaryCard(),

            const SizedBox(height: 24),

            // Delivery Information
            _buildSectionHeader('Delivery Info', Icons.location_pin),
            _buildDeliveryInfoCard(),

            const SizedBox(height: 24),

            // Payment Method
            _buildSectionHeader('Payment Method', Icons.credit_card),
            _buildPaymentMethods(),

            const SizedBox(height: 32),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Implement order confirmation logic here
                  _confirmOrder(context);
                },
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmOrder(BuildContext context) {
    // Here you would typically send the order data to your backend
    // and handle any necessary logic (e.g., payment processing).

    // For this example, we'll just show a confirmation dialog.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Order Confirmed"),
          content: const Text("Thank you for your order!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen (e.g., product list)
                // Optionally: Clear the cart
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }


  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      color: Colors.grey.shade300,
      elevation: 8.0,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.length, // Use cartItems.length
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.product['name'], // Dynamic item name
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      '${cartItem.quantity}x', // Dynamic quantity
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\Rs ${(cartItem.product['price'] ).toStringAsFixed(2)}', // Dynamic price
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 18)),
                Text(
                  '\Rs ${_calculateTotalPrice().toStringAsFixed(2)}', // Dynamic total
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item.product['price'] * item.quantity;
    }
    return total;
  }

  Widget _buildDeliveryInfoCard() {
    return Card(
      color: Colors.grey.shade300,
      elevation: 8.0,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name ',

                labelStyle: TextStyle(
                  color: Colors.black54, // Subtle label color
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.person, color: Color(0xFF2E7D32)),
                filled: true,
                // Add background color
                fillColor: Colors.white,
                // Light background
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                // Padding inside
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2E7D32),
                    // Focused border color matching your theme
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Border color for errors
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Focused error border color
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Street Address Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Street Address *',
                labelStyle: TextStyle(
                  color: Colors.black54, // Subtle label color
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                    Icons.location_on, color: Color(0xFF2E7D32)),
                filled: true,
                // Add background color
                fillColor: Colors.white,
                // Light background
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                // Padding inside
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2E7D32),
                    // Focused border color matching your theme
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Border color for errors
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Focused error border color
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Apartment/Unit Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Apartment, Suite, Unit, etc. (optional)',
                labelStyle: TextStyle(
                  color: Colors.black54, // Subtle label color
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.home, color: Color(0xFF2E7D32)),
                filled: true,
                // Add background color
                fillColor: Colors.white,
                // Light background
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                // Padding inside
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2E7D32),
                    // Focused border color matching your theme
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Border color for errors
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Focused error border color
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Type Location Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Type Location *',
                labelStyle: TextStyle(
                  color: Colors.black54, // Subtle label color
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                    Icons.location_searching, color: Color(0xFF2E7D32)),
                filled: true,
                // Add background color
                fillColor: Colors.white,
                // Light background
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                // Padding inside
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2E7D32),
                    // Focused border color matching your theme
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Border color for errors
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Focused error border color
                    width: 2,
                  ),
                ),
              ),),
            const SizedBox(height: 12),

            // Whatsapp Number Field
            TextField(

              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Whatsapp Number *',
                labelStyle: TextStyle(
                  color: Colors.black, // Subtle label color
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF2E7D32)),
                filled: true,
                // Add background color
                fillColor: Colors.white,
                // Light background
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                // Padding inside
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2E7D32),
                    // Focused border color matching your theme
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Border color for errors
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Focused error border color
                    width: 2,
                  ),
                ),),
            ),
            const SizedBox(height: 12),

            // Email Address Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email Address *',
                labelStyle: TextStyle(
                  color: Colors.black, // Subtle label color
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Color(0xFF2E7D32), // Color matching your theme
                ),
                filled: true,
                // Add background color
                fillColor: Colors.white,
                // Light background
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                // Padding inside
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2E7D32),
                    // Focused border color matching your theme
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Border color for errors
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Focused error border color
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Order Notes Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Order Notes (optional)',
                labelStyle: TextStyle(
                  color: Colors.black54, // Subtle label color
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.note_add, color: Color(0xFF2E7D32)
                ),
                filled: true,
                // Add background color
                fillColor: Colors.white,
                // Light background
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                // Padding inside
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2E7D32),
                    // Focused border color matching your theme
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Subtle default border color
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Border color for errors
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red, // Focused error border color
                    width: 2,
                  ),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPaymentMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPaymentMethodButton('assets/credit_card.svg', 'Card'),
        _buildPaymentMethodButton('assets/google_pay.svg', 'Google Pay'),
        _buildPaymentMethodButton('assets/cash.svg', 'Cash'),
      ],
    );
  }

  Widget _buildPaymentMethodButton(String assetPath, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: SvgPicture.asset(
            assetPath,
            width: 40,
            height: 40,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}