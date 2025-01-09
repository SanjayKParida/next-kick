import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_kick/models/drill_model.dart';
import '../../../provider/user_provider.dart';
import '../../../services/drill_service.dart';

class DrillDetailScreen extends ConsumerStatefulWidget {
  final DrillModel drill;

  const DrillDetailScreen({
    super.key,
    required this.drill,
  });

  @override
  ConsumerState<DrillDetailScreen> createState() => _DrillDetailScreenState();
}

class _DrillDetailScreenState extends ConsumerState<DrillDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _completedCount;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.drill.name,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4527A0),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4527A0)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.drill.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: Icon(
                            Icons.sports_soccer,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Description',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4527A0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.drill.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enter your count',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4527A0),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          labelText: 'Completed Count',
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF4527A0),
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.red[400]!,
                              width: 1,
                            ),
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a count';
                          }
                          final count = int.tryParse(value);
                          if (count == null) {
                            return 'Please enter a valid number';
                          }
                          if (count <= 0) {
                            return 'Count must be greater than 0';
                          }
                          if (count > widget.drill.totalCount) {
                            return 'Count cannot exceed ${widget.drill.totalCount}';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _completedCount = int.tryParse(value);
                          });
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _completedCount = int.tryParse(value);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitCount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4527A0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Submit',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitCount() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_completedCount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a valid count',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red[400],
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        final userId = ref.read(userProvider)?.id;
        if (userId == null) {
          throw Exception('User not logged in');
        }

        final drillService = DrillService();
        await drillService.saveUserDrill(
          userId: userId,
          drillId: widget.drill.id,
          completedCount: _completedCount!,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Progress saved successfully! 🎯',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green[400],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to save progress: ${e.toString()}',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red[400],
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }
}
