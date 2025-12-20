import 'package:flutter/material.dart';
import '../utils/employee_id_fixer.dart';

/// Debug screen to fix duplicate employee IDs
class FixEmployeeIdsScreen extends StatefulWidget {
  const FixEmployeeIdsScreen({super.key});

  @override
  State<FixEmployeeIdsScreen> createState() => _FixEmployeeIdsScreenState();
}

class _FixEmployeeIdsScreenState extends State<FixEmployeeIdsScreen> {
  bool _isLoading = false;
  String _output = 'Ready to scan for duplicates';
  final _fixer = EmployeeIdFixer();

  Future<void> _findDuplicates() async {
    setState(() {
      _isLoading = true;
      _output = 'Searching for duplicates...';
    });

    try {
      final duplicates = await _fixer.findDuplicates();

      if (duplicates.isEmpty) {
        setState(() {
          _output = '✅ No duplicates found!';
        });
      } else {
        final buffer = StringBuffer();
        buffer.writeln(
          '⚠️  Found ${duplicates.length} duplicate employee IDs:\n',
        );

        duplicates.forEach((employeeId, userIds) {
          buffer.writeln('$employeeId → ${userIds.length} users');
          for (final userId in userIds) {
            buffer.writeln('  - $userId');
          }
          buffer.writeln();
        });

        setState(() {
          _output = buffer.toString();
        });
      }
    } catch (e) {
      setState(() {
        _output = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fixDuplicates() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fix Duplicates?'),
        content: const Text(
          'This will regenerate employee IDs for duplicate entries.\n\n'
          'The first user will keep their ID, others will get new IDs.\n\n'
          'Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Fix'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _output = 'Fixing duplicates...';
    });

    try {
      await _fixer.fixDuplicates();
      setState(() {
        _output =
            '✅ All duplicates fixed!\n\nRun "Find Duplicates" again to verify.';
      });
    } catch (e) {
      setState(() {
        _output = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fix Employee IDs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Employee ID Duplicate Fixer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find and fix duplicate employee IDs in the database.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _findDuplicates,
              child: const Text('Find Duplicates'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _fixDuplicates,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Fix All Duplicates'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Text(
                          _output,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
