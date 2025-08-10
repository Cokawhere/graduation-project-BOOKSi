interface User {
  uid: string;
  name: string;
  email: string;
  bio: string;
  role: "reader" | "library";
  photoUrl: string;
  averageRating?: number;
  totalRatings?: number;
  verified: boolean;
  isBanned: boolean;
  profileIncomplete: boolean;
  genres: string[];
  address?: string; // Only for library
  website?: string; // Only for library
  bookIds: string[]; // Link to book documents
  transactionIds: string[];
  chatIds: string[];
  blogPostIds: string[];
  notificationIds: string[];
  createdAt: Date;
  updatedAt: Date;
}

interface Book {
  id: string;
  ownerId: string;
  ownerType: "reader" | "library";
  title: string;
  author: string;
  isbn: string;
  genre: string;
  averageRating?: number;
  totalRatings?: number;
  description: string;
  condition: "new" | "used";
  price?: number; // only required for sell
  availableFor: ("sell" | "borrow" | "swap")[];
  approved: boolean;
  isDeleted: boolean; // default: false
  status: "available" | "sold" | "borrowed" | "traded";
  coverImage: string;
  images: string[];
  location?: string; // if needed for borrow books
  createdAt: Date;
  updatedAt: Date;
}

interface Transaction {
  transactionId: string;
  buyerId: string; // or borrowerId or swapperId
  sellerId: string; // or lenderId
  bookId: string;
  swapWithBookId?: string; // Only for swap
  type: "sell" | "borrow" | "swap";
  status: "pending" | "completed" | "cancelled";
  dueDate?: Date; // Only for borrow
  createdAt: Date;
  updatedAt: Date;
}

interface Chat {
  chatId: string;
  bookId: string;
  transactionId?: string;
  participants: string[];
  messages: Message[];
  createdAt: Date;
  updatedAt: Date;
}

interface Message {
  messageId: string;
  senderId: string;
  content: string;
  read: boolean;
  timestamp: Date;
  type?: "text" | "offer" | "system"; // to support more than just text
}

// interface Notification {
//   id: string;
//   userId: string;
//   title: string;
//   type: 'new_message' | 'book_request' | 'book_approved';
//   message: string;
//   timestamp: Date;
//   read: boolean;
// }

interface Blog {
  id: string;
  userId: string;
  title: string;
  content: string;
  createdAt: Date;
  isDeleted: boolean; // default: false
  updatedAt: Date;
}

interface Reviews {
  ratingId: string;
  targetId: string; // userId OR bookId
  targetType: "user" | "book";
  reviewerId: string;
  reviewerName: string;
  rating: number; // 1–5
  isHidden: boolean;
  comment?: string;
  createdAt: Date;
}

import "package:flutter/material.dart";
import "package:get/get.dart";
import "../home_controller.dart";
import "../../common/styles/colors.dart";
