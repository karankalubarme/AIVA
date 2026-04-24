import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appwrite/models.dart' as models;
import '../services/appwrite_data_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  final AppwriteDataService _dataService = AppwriteDataService();
  late TabController _tabController;
  
  List<models.Document> _ocrHistory = [];
  List<models.Document> _chatHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _loadAllHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllHistory() async {
    setState(() => _isLoading = true);
    final ocr = await _dataService.getOCRHistory();
    final chat = await _dataService.getChatHistory();
    setState(() {
      _ocrHistory = ocr;
      _chatHistory = chat;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAllHistory),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00ACC1),
          labelColor: const Color(0xFF00ACC1),
          unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
          tabs: const [
            Tab(icon: Icon(Icons.document_scanner), text: "OCR"),
            Tab(icon: Icon(Icons.chat_bubble_outline), text: "Chat"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOCRList(isDark),
                _buildChatList(isDark),
              ],
            ),
    );
  }

  Widget _buildOCRList(bool isDark) {
    if (_ocrHistory.isEmpty) return _buildEmptyState("No OCR history found", Icons.document_scanner);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _ocrHistory.length,
      itemBuilder: (context, index) => _buildHistoryItem(_ocrHistory[index], isDark, "OCR"),
    );
  }

  Widget _buildChatList(bool isDark) {
    if (_chatHistory.isEmpty) return _buildEmptyState("No Chat history found", Icons.chat_bubble_outline);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _chatHistory.length,
      itemBuilder: (context, index) => _buildHistoryItem(_chatHistory[index], isDark, "Chat"),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(models.Document item, bool isDark, String type) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    
    String title = "";
    String subtitleText = "";
    
    if (type == "OCR") {
      title = item.data['text'] ?? "No text";
    } else {
      title = item.data['message'] ?? "No message";
      subtitleText = item.data['response'] ?? "No response";
    }

    final String timestampStr = item.data['timestamp'] ?? "";
    DateTime? timestamp = timestampStr.isNotEmpty ? DateTime.tryParse(timestampStr) : null;
    final formattedDate = timestamp != null 
      ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp)
      : "Unknown date";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitleText.isNotEmpty)
              Text(
                subtitleText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF00ACC1)),
        onTap: () {
          if (type == "OCR") {
            _showOCRDetails(title, formattedDate);
          } else {
            _showChatDetails(title, subtitleText, formattedDate);
          }
        },
      ),
    );
  }

  void _showOCRDetails(String text, String date) {
    _showDetailsSheet("OCR Details", date, text);
  }

  void _showChatDetails(String msg, String resp, String date) {
    _showDetailsSheet("Chat Details", date, "User: $msg\n\nAIVA: $resp");
  }

  void _showDetailsSheet(String title, String date, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(),
              Text("Date: $date", style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Content copied to clipboard"),
                        backgroundColor: Color(0xFF00ACC1),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.copy),
                label: const Text("Copy Content"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ACC1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
