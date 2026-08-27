import 'package:flutter/material.dart';
import '../models/insurance_models.dart';

class InsuranceState extends ChangeNotifier {
  // User Profile
  final String userName = 'Willie Schulist';
  final String userGreeting = 'Welcome Back';
  final String userAvatarUrl = '';
  final String memberTier = 'Premium Member';

  // Selected bottom navigation index
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // Active Policies
  List<Policy> _policies = [];
  List<Policy> get policies => _policies;
  PolicyCategory? _selectedPolicyCategoryFilter;
  PolicyCategory? get selectedPolicyCategoryFilter => _selectedPolicyCategoryFilter;

  List<Policy> get filteredPolicies {
    if (_selectedPolicyCategoryFilter == null) return _policies;
    return _policies.where((p) => p.category == _selectedPolicyCategoryFilter).toList();
  }

  void filterPoliciesByCategory(PolicyCategory? category) {
    _selectedPolicyCategoryFilter = category;
    notifyListeners();
  }

  // Active Claims
  List<Claim> _claims = [];
  List<Claim> get claims => _claims;
  List<Claim> get activeClaims =>
      _claims.where((c) => c.status != ClaimStatus.completed && c.status != ClaimStatus.rejected).toList();

  // Selected claim for detail view
  Claim? _selectedClaim;
  Claim? get selectedClaim => _selectedClaim ?? (_claims.isNotEmpty ? _claims.first : null);

  void selectClaim(Claim claim) {
    _selectedClaim = claim;
    notifyListeners();
  }

  // Hospitals Directory
  List<Hospital> _hospitals = [];
  List<Hospital> get hospitals => _hospitals;
  String _selectedHospitalCategory = 'All';
  String get selectedHospitalCategory => _selectedHospitalCategory;
  Hospital? _selectedHospital;
  Hospital? get selectedHospital => _selectedHospital ?? (_hospitals.isNotEmpty ? _hospitals.first : null);
  bool _isHospitalMapView = true; // true = Map + Carousel, false = List
  bool get isHospitalMapView => _isHospitalMapView;

  void toggleHospitalView() {
    _isHospitalMapView = !_isHospitalMapView;
    notifyListeners();
  }

  void setHospitalView(bool isMap) {
    _isHospitalMapView = isMap;
    notifyListeners();
  }

  void selectHospital(Hospital hospital) {
    _selectedHospital = hospital;
    notifyListeners();
  }

  void filterHospitalsByCategory(String category) {
    _selectedHospitalCategory = category;
    notifyListeners();
  }

  List<Hospital> get filteredHospitals {
    if (_selectedHospitalCategory == 'All') return _hospitals;
    return _hospitals.where((h) => h.categoryLabel.toLowerCase().contains(_selectedHospitalCategory.toLowerCase())).toList();
  }

  // Teleconsultation
  TeleconsultAppointment? _latestTeleconsult;
  TeleconsultAppointment? get latestTeleconsult => _latestTeleconsult;

  // Payments & Upcoming Premiums
  List<PaymentItem> _upcomingPayments = [];
  List<PaymentItem> get upcomingPayments => _upcomingPayments;

  List<PaymentItem> _paymentHistory = [];
  List<PaymentItem> get paymentHistory => _paymentHistory;

  double get totalUpcomingPremiums =>
      _upcomingPayments.where((p) => !p.isPaid).fold(0.0, (sum, item) => sum + item.amount);

  // Digital e-Card
  final DigitalCard digitalCard = const DigitalCard(
    cardId: 'HI1418872904-BB',
    holderName: 'Willie Schulist',
    tier: 'Premium',
    validThru: '09/28',
    policyRef: 'INS-28491',
    avatarImagePath: 'assets/images/user_avatar.jpg',
  );

  // Insurance Events / Insights
  List<InsuranceEvent> _events = [];
  List<InsuranceEvent> get events => _events;

  // Notifications
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;
  int get unreadNotificationCount => _notifications.where((n) => n.isUnread).length;

  InsuranceState() {
    _initMockData();
  }

  void _initMockData() {
    // 1. Policies
    _policies = [
      const Policy(
        id: 'pol-1',
        name: 'Toyota Camry',
        category: PolicyCategory.auto,
        policyNumber: 'INS-28491',
        status: 'Active',
        coverageAmount: 50000,
        premiumMonthly: 89.00,
        renewalDate: '12 Sep 2026',
        deductible: 500,
        coverages: [
          CoverageItem(title: 'Collision Coverage', amount: 25000),
          CoverageItem(title: 'Property Damage Liability', amount: 15000),
          CoverageItem(title: 'Medical Payments', amount: 10000),
        ],
        documents: [
          PolicyDocument(title: 'Certificate of Insurance', format: 'PDF', size: '1.2 MB', date: '12 Sep 2025'),
          PolicyDocument(title: 'Policy Schedule & Declarations', format: 'PDF', size: '2.4 MB', date: '12 Sep 2025'),
          PolicyDocument(title: 'Terms & Conditions (Endorsement)', format: 'PDF', size: '850 KB', date: '12 Sep 2025'),
          PolicyDocument(title: 'Latest Payment Receipt', format: 'PDF', size: '320 KB', date: '12 Aug 2026'),
        ],
      ),
      const Policy(
        id: 'pol-2',
        name: 'Platinum Comprehensive Health',
        category: PolicyCategory.health,
        policyNumber: 'HLT-99201',
        status: 'Active',
        coverageAmount: 150000,
        premiumMonthly: 145.00,
        renewalDate: '04 Jan 2027',
        deductible: 200,
        coverages: [
          CoverageItem(title: 'Inpatient Hospitalization', amount: 100000),
          CoverageItem(title: 'Prescription Drugs & Pharmacy', amount: 25000),
          CoverageItem(title: 'Dental & Vision Care', amount: 15000),
          CoverageItem(title: 'Mental Health & Teleconsult', amount: 10000),
        ],
        documents: [
          PolicyDocument(title: 'Health Benefits Summary', format: 'PDF', size: '1.8 MB', date: '04 Jan 2026'),
          PolicyDocument(title: 'Cashless Network Hospital Guide', format: 'PDF', size: '3.1 MB', date: '04 Jan 2026'),
          PolicyDocument(title: 'Digital Health Pass', format: 'PDF', size: '450 KB', date: '04 Jan 2026'),
        ],
      ),
      const Policy(
        id: 'pol-3',
        name: 'Urban Residence Home',
        category: PolicyCategory.home,
        policyNumber: 'HOM-48192',
        status: 'Active',
        coverageAmount: 50000,
        premiumMonthly: 65.00,
        renewalDate: '22 Nov 2026',
        deductible: 1000,
        coverages: [
          CoverageItem(title: 'Dwelling & Structure', amount: 35000),
          CoverageItem(title: 'Personal Property', amount: 10000),
          CoverageItem(title: 'Personal Liability', amount: 5000),
        ],
        documents: [
          PolicyDocument(title: 'Homeowners Policy Document', format: 'PDF', size: '2.1 MB', date: '22 Nov 2025'),
          PolicyDocument(title: 'Inventory & Appraisal List', format: 'PDF', size: '920 KB', date: '22 Nov 2025'),
        ],
      ),
    ];

    // 2. Claims
    _claims = [
      Claim(
        id: 'CL-02841',
        policyId: 'pol-1',
        policyName: 'Auto Insurance (Toyota Camry)',
        category: PolicyCategory.auto,
        incidentType: 'Vehicle accident',
        status: ClaimStatus.underReview,
        submittedDate: '10 Aug 2026',
        estimatedResponse: '2–3 days',
        description: 'Rear-ended at traffic signal on Fenimore St. Minor bumper and sensor damage.',
        amountRequested: 2450.00,
        documents: ['Crash_Report_Front.jpg', 'Bumper_Damage.png', 'Repair_Estimate.pdf', 'Police_Report.pdf'],
        timeline: const [
          ClaimStep(
            title: 'Submitted',
            date: '10 Aug 2026, 14:30',
            description: 'Claim submitted online with 4 documents attached.',
            isCompleted: true,
            isCurrent: false,
          ),
          ClaimStep(
            title: 'Documents received',
            date: '11 Aug 2026, 09:15',
            description: 'All inspection receipts verified by claims handler.',
            isCompleted: true,
            isCurrent: false,
          ),
          ClaimStep(
            title: 'Under review',
            date: '12 Aug 2026, 11:00',
            description: 'Assessor reviewing damage report. Decision expected shortly.',
            isCompleted: true,
            isCurrent: true,
          ),
          ClaimStep(
            title: 'Approved',
            date: 'Est. 14 Aug 2026',
            description: 'Direct repair cashless payout authorization.',
            isCompleted: false,
            isCurrent: false,
          ),
          ClaimStep(
            title: 'Completed',
            date: 'Est. 16 Aug 2026',
            description: 'Settlement disbursed to authorized repair center.',
            isCompleted: false,
            isCurrent: false,
          ),
        ],
      ),
      Claim(
        id: 'CL-01994',
        policyId: 'pol-2',
        policyName: 'Health Insurance (Comprehensive)',
        category: PolicyCategory.health,
        incidentType: 'Outpatient Clinic & Diagnostics',
        status: ClaimStatus.approved,
        submittedDate: '28 Jul 2026',
        estimatedResponse: 'Completed',
        description: 'Routine cardiology screening and specialized blood work panel.',
        amountRequested: 480.00,
        documents: ['Clinic_Invoice.pdf', 'Doctor_Prescription.pdf'],
        timeline: const [
          ClaimStep(
            title: 'Submitted',
            date: '28 Jul 2026',
            isCompleted: true,
            isCurrent: false,
          ),
          ClaimStep(
            title: 'Documents received',
            date: '29 Jul 2026',
            isCompleted: true,
            isCurrent: false,
          ),
          ClaimStep(
            title: 'Under review',
            date: '30 Jul 2026',
            isCompleted: true,
            isCurrent: false,
          ),
          ClaimStep(
            title: 'Approved',
            date: '02 Aug 2026',
            description: 'Reimbursement of \$480 approved to your account.',
            isCompleted: true,
            isCurrent: true,
          ),
          ClaimStep(
            title: 'Completed',
            date: '03 Aug 2026',
            description: 'Transferred via direct deposit.',
            isCompleted: true,
            isCurrent: false,
          ),
        ],
      ),
    ];

    // 3. Hospitals Directory (Matching design reference 2 & 3)
    _hospitals = [
      const Hospital(
        id: 'hosp-1',
        name: 'Harmony General Hospital',
        categoryLabel: 'General & Primary Care',
        address: 'Fenimore St 22A (2.3km)',
        distance: '2.3km',
        openStatus: 'Open • Close at 23:30',
        isOpen: true,
        phone: '+1 (555) 234-8900',
        rating: 4.9,
        latOffsetRatio: 0.52,
        lngOffsetRatio: 0.68,
        imageType: 'modern_facade',
        isCashlessNetwork: true,
      ),
      const Hospital(
        id: 'hosp-2',
        name: 'VitalSpring Medical',
        categoryLabel: 'Dental & Oral Health',
        address: 'Fenimore St 22A (2.3km)',
        distance: '2.3km',
        openStatus: 'Open • Close at 20:00',
        isOpen: true,
        phone: '+1 (555) 345-1289',
        rating: 4.8,
        latOffsetRatio: 0.38,
        lngOffsetRatio: 0.45,
        imageType: 'brick_clinic',
        isCashlessNetwork: true,
      ),
      const Hospital(
        id: 'hosp-3',
        name: 'Parkside Behavioral Health',
        categoryLabel: 'Mental & Behavioral Health',
        address: 'Sterling St 14B (3.1km)',
        distance: '3.1km',
        openStatus: 'Open • Close at 18:00',
        isOpen: true,
        phone: '+1 (555) 908-1122',
        rating: 4.9,
        latOffsetRatio: 0.28,
        lngOffsetRatio: 0.58,
        imageType: 'glass_tower',
        isCashlessNetwork: true,
      ),
      const Hospital(
        id: 'hosp-4',
        name: 'St. Jude Specialty Center',
        categoryLabel: 'General & Primary Care',
        address: 'Empire Blvd 88 (1.8km)',
        distance: '1.8km',
        openStatus: 'Open 24/7 Emergency',
        isOpen: true,
        phone: '+1 (555) 441-2090',
        rating: 4.95,
        latOffsetRatio: 0.65,
        lngOffsetRatio: 0.35,
        imageType: 'pavilion',
        isCashlessNetwork: true,
      ),
    ];

    // 4. Teleconsultation
    _latestTeleconsult = const TeleconsultAppointment(
      id: 'tel-1',
      doctorName: 'Dr. Emily Carter',
      specialty: 'Senior Physician & Internist',
      type: 'Video',
      dateTime: 'June 10, 2025 | 10:00 AM',
      hasLabOption: true,
      isPrescriptionCovered: true,
      avatarInitials: 'EC',
      avatarImagePath: 'assets/images/doctor_avatar.jpg',
    );

    // 5. Payments & Premiums
    _upcomingPayments = [
      const PaymentItem(
        id: 'pay-1',
        title: 'Toyota Camry Insurance',
        policyNumber: 'INS-28491',
        amount: 89.00,
        dueDate: '12 Sep 2026',
        isPaid: false,
        category: PolicyCategory.auto,
      ),
      const PaymentItem(
        id: 'pay-2',
        title: 'Comprehensive Health Plan',
        policyNumber: 'HLT-99201',
        amount: 145.00,
        dueDate: '15 Sep 2026',
        isPaid: false,
        category: PolicyCategory.health,
      ),
      const PaymentItem(
        id: 'pay-3',
        title: 'Annual Premium Bundle & Residence',
        policyNumber: 'HOM-48192',
        amount: 2088.98,
        dueDate: '27 Sep 2026',
        isPaid: false,
        category: PolicyCategory.home,
      ),
    ];

    _paymentHistory = [
      const PaymentItem(
        id: 'hist-1',
        title: 'Toyota Camry Premium',
        policyNumber: 'INS-28491',
        amount: 89.00,
        dueDate: '12 Aug 2026',
        paidDate: '12 Aug 2026',
        isPaid: true,
        category: PolicyCategory.auto,
      ),
      const PaymentItem(
        id: 'hist-2',
        title: 'Comprehensive Health Plan',
        policyNumber: 'HLT-99201',
        amount: 145.00,
        dueDate: '15 Jul 2026',
        paidDate: '14 Jul 2026',
        isPaid: true,
        category: PolicyCategory.health,
      ),
      const PaymentItem(
        id: 'hist-3',
        title: 'Toyota Camry Premium',
        policyNumber: 'INS-28491',
        amount: 89.00,
        dueDate: '12 Jun 2026',
        paidDate: '12 Jun 2026',
        isPaid: true,
        category: PolicyCategory.auto,
      ),
    ];

    // 6. Events & Insights
    _events = const [
      InsuranceEvent(
        id: 'ev-1',
        tag: 'News',
        title: 'How Gamification is Reshaping the Insurance Industry',
        readTime: '4 min read',
        badgeBg: Color(0xFFF1E3DC),
        badgeText: Color(0xFF634946),
        heroTheme: 'gamification',
      ),
      InsuranceEvent(
        id: 'ev-2',
        tag: 'Event Recap',
        title: 'A Glimpse Into Exclusive Insurance Summit',
        readTime: '5 min read',
        badgeBg: Color(0xFFE8EEF5),
        badgeText: Color(0xFF2C4A6F),
        heroTheme: 'summit',
      ),
      InsuranceEvent(
        id: 'ev-3',
        tag: 'Wellness',
        title: 'Maximizing Your Preventive Health & Wellness Benefits',
        readTime: '3 min read',
        badgeBg: Color(0xFFEAF5EB),
        badgeText: Color(0xFF2E6333),
        heroTheme: 'wellness',
      ),
    ];

    // 7. Notifications
    _notifications = [
      const AppNotification(
        id: 'notif-1',
        title: 'Claim update',
        description: 'Your claim #CL-02841 is now under review.',
        timeAgo: '2 hours ago',
        type: 'claim',
        isUnread: true,
      ),
      const AppNotification(
        id: 'notif-2',
        title: 'Payment reminder',
        description: 'Your insurance payment is due in 3 days.',
        timeAgo: '1 day ago',
        type: 'payment',
        isUnread: true,
      ),
      const AppNotification(
        id: 'notif-3',
        title: 'Policy renewal',
        description: 'Your auto insurance renews next month.',
        timeAgo: '3 days ago',
        type: 'renewal',
        isUnread: false,
      ),
    ];
  }

  // Action: Submit Claim
  void submitNewClaim({
    required String policyId,
    required String incidentType,
    required String incidentDate,
    required String location,
    required String description,
    required List<String> fileNames,
  }) {
    final policy = _policies.firstWhere(
      (p) => p.id == policyId,
      orElse: () => _policies.first,
    );

    final newClaimId = 'CL-${10000 + _claims.length + 1}';

    final newClaim = Claim(
      id: newClaimId,
      policyId: policy.id,
      policyName: '${policy.category.displayName} Insurance (${policy.name})',
      category: policy.category,
      incidentType: incidentType,
      status: ClaimStatus.submitted,
      submittedDate: incidentDate,
      estimatedResponse: '2–3 business days',
      description: description.isNotEmpty ? description : 'Claim for $incidentType at $location',
      amountRequested: 1200.0,
      documents: fileNames.isNotEmpty ? fileNames : ['Damage_Photo_1.jpg', 'Receipt.pdf'],
      timeline: [
        ClaimStep(
          title: 'Submitted',
          date: 'Just now',
          description: 'Claim submitted successfully.',
          isCompleted: true,
          isCurrent: true,
        ),
        const ClaimStep(
          title: 'Documents received',
          date: 'Pending intake',
          description: 'A claims adjuster will verify submitted documentation.',
          isCompleted: false,
          isCurrent: false,
        ),
        const ClaimStep(
          title: 'Under review',
          date: 'Pending',
          description: 'Damage evaluation and coverage match.',
          isCompleted: false,
          isCurrent: false,
        ),
        const ClaimStep(
          title: 'Approved',
          date: 'Pending',
          description: 'Direct repair authorization or payout.',
          isCompleted: false,
          isCurrent: false,
        ),
        const ClaimStep(
          title: 'Completed',
          date: 'Pending',
          description: 'Settlement completed.',
          isCompleted: false,
          isCurrent: false,
        ),
      ],
    );

    _claims.insert(0, newClaim);
    _selectedClaim = newClaim;

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Claim Created',
        description: 'Your claim $newClaimId has been received and is being processed.',
        timeAgo: 'Just now',
        type: 'claim',
        isUnread: true,
      ),
    );

    notifyListeners();
  }

  // Action: Pay Premium
  void payUpcomingPremium(String paymentId) {
    final index = _upcomingPayments.indexWhere((p) => p.id == paymentId);
    if (index != -1) {
      final payment = _upcomingPayments[index];
      _upcomingPayments.removeAt(index);

      final historyItem = PaymentItem(
        id: 'hist-${DateTime.now().millisecondsSinceEpoch}',
        title: payment.title,
        policyNumber: payment.policyNumber,
        amount: payment.amount,
        dueDate: payment.dueDate,
        paidDate: 'Today',
        isPaid: true,
        category: payment.category,
      );
      _paymentHistory.insert(0, historyItem);

      _notifications.insert(
        0,
        AppNotification(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Payment Successful',
          description: 'Payment of \$${payment.amount.toStringAsFixed(2)} for ${payment.title} was completed.',
          timeAgo: 'Just now',
          type: 'payment',
          isUnread: true,
        ),
      );

      notifyListeners();
    }
  }

  void markNotificationRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notif = _notifications[index];
      _notifications[index] = AppNotification(
        id: notif.id,
        title: notif.title,
        description: notif.description,
        timeAgo: notif.timeAgo,
        type: notif.type,
        isUnread: false,
      );
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    _notifications = _notifications
        .map((n) => AppNotification(
              id: n.id,
              title: n.title,
              description: n.description,
              timeAgo: n.timeAgo,
              type: n.type,
              isUnread: false,
            ))
        .toList();
    notifyListeners();
  }
}
