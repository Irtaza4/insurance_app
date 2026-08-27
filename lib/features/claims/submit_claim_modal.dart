import 'package:flutter/material.dart';
import '../../core/state/insurance_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/buttons_and_inputs.dart';

class SubmitClaimModal extends StatefulWidget {
  final InsuranceState state;

  const SubmitClaimModal({
    super.key,
    required this.state,
  });

  @override
  State<SubmitClaimModal> createState() => _SubmitClaimModalState();
}

class _SubmitClaimModalState extends State<SubmitClaimModal> {
  int _currentStep = 1;

  // Form State
  String? _selectedPolicyId;
  String _incidentType = 'Vehicle collision';
  String _incidentDate = '10 Aug 2026';
  String _location = 'Fenimore St & Flatbush Ave';
  final TextEditingController _descController = TextEditingController();
  final List<String> _attachedFiles = ['Crash_Scene_Photo_1.jpg', 'Repair_Estimate.pdf'];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.state.policies.isNotEmpty) {
      _selectedPolicyId = widget.state.policies.first.id;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitClaim();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _submitClaim() async {
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    widget.state.submitNewClaim(
      policyId: _selectedPolicyId ?? widget.state.policies.first.id,
      incidentType: _incidentType,
      incidentDate: _incidentDate,
      location: _location,
      description: _descController.text,
      fileNames: _attachedFiles,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryDark,
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Claim submitted successfully! Status: Under Review',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header with step progress
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCD7D2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Submit a Claim',
                      style: AppTypography.h1.copyWith(fontSize: 22),
                    ),
                    Text(
                      'Step $_currentStep of 4',
                      style: AppTypography.captionBold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Step Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _currentStep / 4.0,
                    backgroundColor: AppColors.neutralLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Step Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: _buildCurrentStepContent(),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.neutralBorder)),
            ),
            child: Row(
              children: [
                if (_currentStep > 1) ...[
                  Expanded(
                    flex: 1,
                    child: SecondaryButton(
                      label: 'Back',
                      onPressed: _previousStep,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: _currentStep == 4 ? 'Submit claim' : 'Continue',
                    isLoading: _isSubmitting,
                    onPressed: _nextStep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1SelectPolicy();
      case 2:
        return _buildStep2IncidentDetails();
      case 3:
        return _buildStep3UploadDocuments();
      case 4:
        return _buildStep4Review();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Step 1 — Select Policy
  Widget _buildStep1SelectPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Which policy is this claim for?',
          style: AppTypography.h2.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 6),
        Text(
          'Select the active policy to associate with your reimbursement or direct repair request.',
          style: AppTypography.bodySecondary,
        ),
        const SizedBox(height: 20),
        ...widget.state.policies.map((policy) {
          final isSelected = _selectedPolicyId == policy.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.neutralBorder,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.softPeach.withValues(alpha: 0.4) : AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  policy.category.icon,
                  color: isSelected ? AppColors.primary : AppColors.primaryDark,
                ),
              ),
              title: Text(
                '${policy.category.displayName} Insurance',
                style: AppTypography.h3.copyWith(fontSize: 15),
              ),
              subtitle: Text(
                '${policy.name} • #${policy.policyNumber}',
                style: AppTypography.caption,
              ),
              trailing: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textGray,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              onTap: () {
                setState(() {
                  _selectedPolicyId = policy.id;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  /// Step 2 — Claim Details
  Widget _buildStep2IncidentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Claim Details', style: AppTypography.h2.copyWith(fontSize: 18)),
        const SizedBox(height: 6),
        Text('Provide concise details regarding what occurred.', style: AppTypography.bodySecondary),
        const SizedBox(height: 20),

        // Incident Date
        AppInputField(
          label: 'Incident Date',
          hint: 'e.g. 10 Aug 2026',
          controller: TextEditingController(text: _incidentDate),
          prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textGray),
          onChanged: (v) => _incidentDate = v,
        ),
        const SizedBox(height: 16),

        // Incident Type
        AppInputField(
          label: 'Incident Type',
          hint: 'e.g. Vehicle accident, Water damage, Clinic visit',
          controller: TextEditingController(text: _incidentType),
          prefixIcon: const Icon(Icons.category_outlined, size: 18, color: AppColors.textGray),
          onChanged: (v) => _incidentType = v,
        ),
        const SizedBox(height: 16),

        // Incident Location
        AppInputField(
          label: 'Location',
          hint: 'Street address or clinic name',
          controller: TextEditingController(text: _location),
          prefixIcon: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textGray),
          onChanged: (v) => _location = v,
        ),
        const SizedBox(height: 16),

        // Plain Language Description
        AppInputField(
          label: 'Description',
          hint: 'Briefly explain what happened in plain language...',
          controller: _descController,
          maxLines: 4,
        ),
      ],
    );
  }

  /// Step 3 — Upload Documents
  Widget _buildStep3UploadDocuments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload Documents', style: AppTypography.h2.copyWith(fontSize: 18)),
        const SizedBox(height: 6),
        Text(
          'Attach inspection photos, police reports, doctor notes, or repair estimates.',
          style: AppTypography.bodySecondary,
        ),
        const SizedBox(height: 20),

        // Large Upload Drop Area
        InkWell(
          onTap: () {
            setState(() {
              _attachedFiles.add('Medical_Bill_Receipt_${_attachedFiles.length + 1}.pdf');
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document attached successfully!')),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warmBeige, width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7EBE5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 28),
                ),
                const SizedBox(height: 12),
                Text('Tap to browse photos or PDF files', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Supports JPG, PNG, PDF up to 25MB', style: AppTypography.caption),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        Text('Attached Documents (${_attachedFiles.length})', style: AppTypography.captionBold),
        const SizedBox(height: 10),

        ..._attachedFiles.map((file) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.neutralBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    file,
                    style: AppTypography.bodyMedium.copyWith(fontSize: 13.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textGray),
                  onPressed: () {
                    setState(() {
                      _attachedFiles.remove(file);
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// Step 4 — Review Summary
  Widget _buildStep4Review() {
    final selectedPolicy = widget.state.policies.firstWhere(
      (p) => p.id == _selectedPolicyId,
      orElse: () => widget.state.policies.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Claim', style: AppTypography.h2.copyWith(fontSize: 18)),
        const SizedBox(height: 6),
        Text('Verify your details before final submission to claims review.', style: AppTypography.bodySecondary),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.neutralBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _reviewRow('Policy', '${selectedPolicy.category.displayName} (${selectedPolicy.name})'),
              const Divider(height: 20),
              _reviewRow('Policy Number', selectedPolicy.policyNumber),
              const Divider(height: 20),
              _reviewRow('Incident Type', _incidentType),
              const Divider(height: 20),
              _reviewRow('Incident Date', _incidentDate),
              const Divider(height: 20),
              _reviewRow('Location', _location),
              const Divider(height: 20),
              _reviewRow('Attached Files', '${_attachedFiles.length} files attached'),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8EFEA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Our claims adjuster usually responds within 2–3 business days.',
                  style: AppTypography.caption.copyWith(color: AppColors.secondaryBrown),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySecondary.copyWith(fontSize: 13.5)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
