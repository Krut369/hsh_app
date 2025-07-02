import 'package:flutter/material.dart';

class PaymentProofUploadSection extends StatefulWidget {
  final String title;
  final String description;

  const PaymentProofUploadSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<PaymentProofUploadSection> createState() => _PaymentProofUploadSectionState();
}

class _PaymentProofUploadSectionState extends State<PaymentProofUploadSection> {
  bool _isUploading = false;
  String _uploadMessage = '';

  Future<void> _uploadScreenshot() async {
    setState(() {
      _isUploading = true;
      _uploadMessage = 'Uploading...';
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isUploading = false;
      _uploadMessage = '${widget.title} uploaded successfully!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.cloud_upload, size: 80, color: Theme.of(context).primaryColor),
        Text(widget.description, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        _isUploading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          onPressed: _uploadScreenshot,
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload Screenshot'),
        ),
        if (_uploadMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_uploadMessage, textAlign: TextAlign.center),
          ),
      ],
    );
  }
}
