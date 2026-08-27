import 'package:flutter/material.dart';

enum PolicyCategory {
  auto,
  health,
  home,
  life;

  String get displayName {
    switch (this) {
      case PolicyCategory.auto:
        return 'Auto';
      case PolicyCategory.health:
        return 'Health';
      case PolicyCategory.home:
        return 'Home';
      case PolicyCategory.life:
        return 'Life';
    }
  }

  IconData get icon {
    switch (this) {
      case PolicyCategory.auto:
        return Icons.directions_car_rounded;
      case PolicyCategory.health:
        return Icons.favorite_rounded;
      case PolicyCategory.home:
        return Icons.home_rounded;
      case PolicyCategory.life:
        return Icons.shield_rounded;
    }
  }
}

class CoverageItem {
  final String title;
  final double amount;

  const CoverageItem({required this.title, required this.amount});
}

class PolicyDocument {
  final String title;
  final String format;
  final String size;
  final String date;

  const PolicyDocument({
    required this.title,
    required this.format,
    required this.size,
    required this.date,
  });
}

class Policy {
  final String id;
  final String name;
  final PolicyCategory category;
  final String policyNumber;
  final String status;
  final double coverageAmount;
  final double premiumMonthly;
  final String renewalDate;
  final double deductible;
  final List<CoverageItem> coverages;
  final List<PolicyDocument> documents;

  const Policy({
    required this.id,
    required this.name,
    required this.category,
    required this.policyNumber,
    required this.status,
    required this.coverageAmount,
    required this.premiumMonthly,
    required this.renewalDate,
    required this.deductible,
    required this.coverages,
    required this.documents,
  });
}

enum ClaimStatus {
  submitted,
  documentsReceived,
  underReview,
  approved,
  completed,
  rejected;

  String get label {
    switch (this) {
      case ClaimStatus.submitted:
        return 'Submitted';
      case ClaimStatus.documentsReceived:
        return 'Documents received';
      case ClaimStatus.underReview:
        return 'Under review';
      case ClaimStatus.approved:
        return 'Approved';
      case ClaimStatus.completed:
        return 'Completed';
      case ClaimStatus.rejected:
        return 'Rejected';
    }
  }
}

class ClaimStep {
  final String title;
  final String date;
  final String? description;
  final bool isCompleted;
  final bool isCurrent;

  const ClaimStep({
    required this.title,
    required this.date,
    this.description,
    required this.isCompleted,
    required this.isCurrent,
  });
}

class Claim {
  final String id;
  final String policyId;
  final String policyName;
  final PolicyCategory category;
  final String incidentType;
  final ClaimStatus status;
  final String submittedDate;
  final String estimatedResponse;
  final String description;
  final double amountRequested;
  final List<String> documents;
  final List<ClaimStep> timeline;

  const Claim({
    required this.id,
    required this.policyId,
    required this.policyName,
    required this.category,
    required this.incidentType,
    required this.status,
    required this.submittedDate,
    required this.estimatedResponse,
    required this.description,
    required this.amountRequested,
    required this.documents,
    required this.timeline,
  });

  Claim copyWith({
    String? id,
    String? policyId,
    String? policyName,
    PolicyCategory? category,
    String? incidentType,
    ClaimStatus? status,
    String? submittedDate,
    String? estimatedResponse,
    String? description,
    double? amountRequested,
    List<String>? documents,
    List<ClaimStep>? timeline,
  }) {
    return Claim(
      id: id ?? this.id,
      policyId: policyId ?? this.policyId,
      policyName: policyName ?? this.policyName,
      category: category ?? this.category,
      incidentType: incidentType ?? this.incidentType,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
      estimatedResponse: estimatedResponse ?? this.estimatedResponse,
      description: description ?? this.description,
      amountRequested: amountRequested ?? this.amountRequested,
      documents: documents ?? this.documents,
      timeline: timeline ?? this.timeline,
    );
  }
}

class Hospital {
  final String id;
  final String name;
  final String categoryLabel;
  final String address;
  final String distance;
  final String openStatus;
  final bool isOpen;
  final String phone;
  final double rating;
  final double latOffsetRatio; // Offset for relative canvas map
  final double lngOffsetRatio;
  final String imageType; // Building visual preset for custom painter
  final bool isCashlessNetwork;

  const Hospital({
    required this.id,
    required this.name,
    required this.categoryLabel,
    required this.address,
    required this.distance,
    required this.openStatus,
    required this.isOpen,
    required this.phone,
    required this.rating,
    required this.latOffsetRatio,
    required this.lngOffsetRatio,
    required this.imageType,
    this.isCashlessNetwork = true,
  });
}

class TeleconsultAppointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String type;
  final String dateTime;
  final bool hasLabOption;
  final bool isPrescriptionCovered;
  final String avatarInitials;
  final String? avatarImagePath;

  const TeleconsultAppointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.type,
    required this.dateTime,
    required this.hasLabOption,
    required this.isPrescriptionCovered,
    required this.avatarInitials,
    this.avatarImagePath,
  });
}

class PaymentItem {
  final String id;
  final String title;
  final String policyNumber;
  final double amount;
  final String dueDate;
  final String? paidDate;
  final bool isPaid;
  final PolicyCategory category;

  const PaymentItem({
    required this.id,
    required this.title,
    required this.policyNumber,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.isPaid,
    required this.category,
  });
}

class InsuranceEvent {
  final String id;
  final String tag;
  final String title;
  final String readTime;
  final Color badgeBg;
  final Color badgeText;
  final String heroTheme;

  const InsuranceEvent({
    required this.id,
    required this.tag,
    required this.title,
    required this.readTime,
    required this.badgeBg,
    required this.badgeText,
    required this.heroTheme,
  });
}

class DigitalCard {
  final String cardId;
  final String holderName;
  final String tier;
  final String validThru;
  final String policyRef;
  final String? avatarImagePath;

  const DigitalCard({
    required this.cardId,
    required this.holderName,
    required this.tier,
    required this.validThru,
    required this.policyRef,
    this.avatarImagePath,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final String type; // claim, payment, renewal
  final bool isUnread;

  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.type,
    this.isUnread = true,
  });
}
