iBook App
E-commerce for books with online payments,
Chat & Chatbot system for user support,
User Profiles for personalization,
Blog section to share articles and updates.

Features
-Chat System: Real-time messaging between users or support team.
-Chatbot: Automated responses to common questions.
-User Profile: Manage personal info and order history.
-Blog Section: Read articles, updates, and book recommendations.
-Browse books with detailed info (title, price, author, cover image).
-Add books to a shopping cart.
-Shipping Information Page to enter delivery details.
-Integrated Paymob payment gateway for card payments.
-Firestore order creation after successful payment.
-Order status lifecycle: pending → paid → shipped → delivered.

Tech Stack

-Frontend: Flutter + GetX
-Backend: Firebase Firestore
-Payments: Paymob Integration
-State Management: GetX Controllers


Order Flow

-User adds items to cart → items are stored inside the GetX state.
-User enters shipping information → stored in the shipping controller.
-User proceeds to checkout with Paymob → payment process starts.
-On payment success → collect:
-items from the cart
-buyerInfo from shipping page
-transactionId from Paymob
-totalPrice and status
-Create order in Firestore → orders collection
-Clear the cart after successful payment.
