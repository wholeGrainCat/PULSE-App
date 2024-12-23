import 'package:flutter/material.dart';

class CounsellorInfoScreen extends StatelessWidget {
  const CounsellorInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psycon Counsellor'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUnitInfo(),
              const SizedBox(height: 32.0),
              ..._buildCounsellorCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitInfo() {
    return Row(
      // Change Card to Row
      children: [
        Expanded(
          // Wrap content in Expanded
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color(0xFFD9F65C),
            ),
            padding: const EdgeInsets.all(24.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Psychology & Counseling Unit',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  'Operating Hours:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '''
Monday to Thursday:
8.30 am - 12.30 pm | 2.00 pm - 4.30 pm

Friday:
8.30 am - 11.30 pm | 2.30 pm - 4.30 pm
            ''',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCounsellorCards() {
    return [
      const _CounsellorCard(
        imageUrl: 'assets/images/mdm_fauziah.jpg',
        name: 'Mdm Fauziah Bee Bt Mohd Salleh',
        phone: '082-581861',
        email: 'msfauziah@unimas.my',
      ),
      const _CounsellorCard(
        imageUrl: 'assets/images/puan_saptuyah.jpg',
        name: 'Puan Saptuyah Bt Barahim',
        phone: '082-581835',
        email: 'bsaptuyah@unimas.my',
      ),
      const _CounsellorCard(
        imageUrl: 'assets/images/puan_debra.jpg',
        name: 'Puan Debra Adrian',
        phone: '082-581804',
        email: 'adebra@unimas.my',
      ),
      const _CounsellorCard(
        imageUrl: 'assets/images/en_lawrence.jpg',
        name: 'En. Lawrence Sengkuai Anak Henry',
        phone: '082-581904',
        email: 'shlawrence@unimas.my',
      ),
      const _CounsellorCard(
        imageUrl: 'assets/images/cik_ummikhairah.jpg',
        name: 'Cik Ummikhairah Sofea Bt Ja\'afar',
        phone: '082-581869',
        email: 'jusofea@unimas.my',
      ),
    ];
  }
}

class _CounsellorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String phone;
  final String email;

  const _CounsellorCard({
    required this.imageUrl,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
              radius: 36.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16.0, color: Colors.green),
                      const SizedBox(width: 8.0),
                      Text(
                        phone,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16.0, color: Colors.blue),
                      const SizedBox(width: 8.0),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
