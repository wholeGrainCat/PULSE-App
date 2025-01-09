// Code to insert data into firebase

import 'package:cloud_firestore/cloud_firestore.dart';


void addMultipleCollectionsWithTransaction() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Example data
Map<String, Map<String, dynamic>> collectionsData = {
  'appointment': {
    'doc1': {'name': 'Henry', 'date': '23.12.2024', 'Status': 'Upcoming'},
    'doc2': {'name': 'Amos', 'date': '21.12.2024', 'Status': 'Completed'},
    'doc3': {'name': 'Madeline', 'date': '13.12.2024', 'Status': 'Completed'},
    'doc4': {'name': 'Lily', 'date': '20.12.2024', 'Status': 'Cancelled'},
    'doc5': {'name': 'Charlotte', 'date': '02.12.2024', 'Status': 'Completed'},
    'doc6': {'name': 'Grace', 'date': '09.12.2024', 'Status': 'Upcoming'},
    'doc7': {'name': 'Lily', 'date': '24.12.2024', 'Status': 'Completed'},
    'doc8': {'name': 'Amelia', 'date': '17.12.2024', 'Status': 'Cancelled'},
    'doc9': {'name': 'Sophie', 'date': '01.12.2024', 'Status': 'Upcoming'},
    'doc10': {'name': 'Grace', 'date': '26.12.2024', 'Status': 'Completed'},
    'doc11': {'name': 'David', 'date': '18.12.2024', 'Status': 'Completed'},
    'doc12': {'name': 'Oliver', 'date': '17.12.2024', 'Status': 'Completed'},
    'doc13': {'name': 'Amelia', 'date': '07.12.2024', 'Status': 'Completed'},
    'doc14': {'name': 'Amelia', 'date': '04.12.2024', 'Status': 'Upcoming'},
    'doc15': {'name': 'Luna', 'date': '05.12.2024', 'Status': 'Completed'},
    'doc16': {'name': 'Jackson', 'date': '30.12.2024', 'Status': 'Cancelled'},
    'doc17': {'name': 'Mason', 'date': '08.12.2024', 'Status': 'Completed'},
    'doc18': {'name': 'Sebastian', 'date': '20.12.2024', 'Status': 'Completed'},
    'doc19': {'name': 'Nathan', 'date': '16.12.2024', 'Status': 'Upcoming'},
    'doc20': {'name': 'Tom', 'date': '17.12.2024', 'Status': 'Completed'},
    'doc21': {'name': 'Oliver', 'date': '15.12.2024', 'Status': 'Completed'},
    'doc22': {'name': 'Samuel', 'date': '12.12.2024', 'Status': 'Upcoming'},
    'doc23': {'name': 'Jack', 'date': '10.12.2024', 'Status': 'Completed'},
    'doc24': {'name': 'Ella', 'date': '09.12.2024', 'Status': 'Completed'},
    'doc25': {'name': 'Anna', 'date': '04.12.2024', 'Status': 'Completed'},
    'doc26': {'name': 'Ella', 'date': '20.12.2024', 'Status': 'Cancelled'},
    'doc27': {'name': 'Zoe', 'date': '27.12.2024', 'Status': 'Completed'},
    'doc28': {'name': 'Johnathan', 'date': '19.12.2024', 'Status': 'Cancelled'},
    'doc29': {'name': 'David', 'date': '01.12.2024', 'Status': 'Upcoming'},
    'doc30': {'name': 'John', 'date': '24.12.2024', 'Status': 'Completed'},
    'doc31': {'name': 'Sebastian', 'date': '11.12.2024', 'Status': 'Cancelled'},
    'doc32': {'name': 'Benjamin', 'date': '12.12.2024', 'Status': 'Cancelled'},
    'doc33': {'name': 'David', 'date': '30.12.2024', 'Status': 'Upcoming'},
    'doc34': {'name': 'Benjamin', 'date': '05.12.2024', 'Status': 'Completed'},
    'doc35': {'name': 'Peter', 'date': '04.12.2024', 'Status': 'Cancelled'},
    'doc36': {'name': 'Ella', 'date': '16.12.2024', 'Status': 'Completed'},
    'doc37': {'name': 'Amelia', 'date': '27.12.2024', 'Status': 'Completed'},
    'doc38': {'name': 'Sophie', 'date': '11.12.2024', 'Status': 'Cancelled'},
    'doc39': {'name': 'Chloe', 'date': '31.12.2024', 'Status': 'Completed'},
    'doc40': {'name': 'Benjamin', 'date': '09.12.2024', 'Status': 'Upcoming'},
  }
};


  try {
    await firestore.runTransaction((transaction) async {
      collectionsData.forEach((collectionName, documents) {
        documents.forEach((docId, data) {
          DocumentReference docRef =
              firestore.collection(collectionName).doc(docId);
          transaction.set(docRef, data); // Add document in transaction
        });
      });
    });
    print('All collections and documents added successfully!');
  } catch (e) {
    print('Error adding collections: $e');
  }
}
